FROM python:3.9-bullseye

## Install sudo
RUN apt-get update && \
    apt-get install -y sudo

## Set timezone
RUN echo America/New_York | sudo tee  /etc/timezone && \
    sudo dpkg-reconfigure --frontend noninteractive tzdata
ENV DEBIAN_FRONTEND noninteractive

## Install base dependencies
RUN sudo apt-get update && \
    sudo apt-get dist-upgrade -y && \
    sudo apt-get -y autoremove && \
    sudo apt-get install -y \
         build-essential \
         software-properties-common \
         libcurl4-openssl-dev \
         git \
         make \
         cmake \
         gcc-9 \
         g++-9

## Clone GitHub repo
RUN mkdir -p /app
WORKDIR /app
RUN git clone https://github.com/bailey-lab/SeekDeep
WORKDIR /app/SeekDeep

## Run SeekDeep Setup
RUN ./setup.py --libs cmake:3.7.2 --symlinkBin
RUN echo "" >> ~/.profile && echo "#Add SeekDeep bin to your path" >> ~/.profile && echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.profile
RUN . ~/.profile
RUN ./setup.py --addBashCompletion
RUN ./install.sh 7
RUN export PATH=/app/SeekDeep/bin/:$PATH && \
    ln -s /app/SeekDeep/bin/SeekDeep /usr/bin/

## Add other tools 
RUN ./setup.py --symlinkBin --overWrite

RUN sudo apt install -y \
    bowtie2 \
    muscle \
    samtools

## Expose Ports
EXPOSE 8000 9881 22 3389