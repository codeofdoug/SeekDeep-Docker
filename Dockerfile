# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.

FROM phusion/baseimage:0.9.16

MAINTAINER Colby T. Ford <colby.ford@uncc.edu>

# global env
ENV HOME=/root TERM=xterm

# set proper timezone
RUN echo America/New_York > /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata

# Install essential for building
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get -y autoremove && \
  apt-get install -y build-essential software-properties-common && \
  apt-get install -y git make

# install generic stuff for downloading other libraries 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake wget

# install clang and g++-7 
RUN echo "deb http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)"-3.8 main" | sudo tee /etc/apt/sources.list.d/llvm.list && \ 
	echo "deb-src http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)"-3.8 main" | sudo tee -a /etc/apt/sources.list.d/llvm.list && \
	echo "deb http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/llvm.list && \
	echo "deb-src http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/llvm.list

RUN sudo add-apt-repository ppa:ubuntu-toolchain-r/test && \
	wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key |sudo apt-key add - && \
    sudo apt-get autoclean && \
    sudo apt-get autoremove && \
	sudo apt-get update && \
    sudo apt-get install -y clang-3.8 libc++-dev g++-7
# sudo apt-get install -y clang-3.8 libc++-dev g++-7


RUN ln -s /usr/bin/clang-3.8 /usr/bin/clang && ln -s /usr/bin/clang++-3.8 /usr/bin/clang++

# install some generic stuff needed by other libraries 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zlib1g-dev libcairo2-dev libpango1.0-dev libcurl4-openssl-dev doxygen graphviz libbz2-dev libjpeg-dev libatlas-base-dev gfortran fort77 libreadline6-dev emacs23-nox

#install apache2
RUN apt-get update && \
  apt-get install -y apache2 apache2-utils && \
  a2enmod proxy && a2enmod proxy_http
  

# install SeekDeep from git repo
RUN cd ~ && \
  git clone https://github.com/bailey-lab/SeekDeep && \
  cd SeekDeep && \
  ./setup.py --libs cmake:3.7.2 --symlinkBin && \
  echo "" >> ~/.profile && echo "#Add SeekDeep bin to your path" >> ~/.profile && echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.profile && \
  . ~/.profile && \
  ./setup.py --addBashCompletion && \
  ./install.sh 7 && \
  ./setup.py --libs muscle:3.8.31 --symlinkBin --overWrite && \
  ./configure.py && \
  ./setup.py --compfile compfile.mk --outMakefile makefile-common.mk --overWrite && \
  make && \
  export PATH=/root/SeekDeep/bin/:$PATH && \
  ln -s /root/SeekDeep/bin/SeekDeep /usr/bin/
# export PATH=/home/user/SeekDeep/bin/:$PATH

# install conda and dependencies
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda install --yes -c bioconda \
		bowtie2 \
		samtools \
		nomkl

# Export Ports to Public
EXPOSE 8000 9881 22