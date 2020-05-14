# Docker Image for SeekDeep
<h4 align = "right">Colby T. Ford, Ph.D.</h4>
This repository contains the Dockerfile for generating an Ubuntu image with SeekDeep pre-installed.

## Instructions
1. Clone this repository to your local machine

2. Open terminal and navigate to the directory of this repository.

3. Run the following command. This will generate the Docker image.
_Note:_ You may have to increase the resource limits in Docker's settings as this container size will be quite large.
```
docker build -t seekdeep .
```

4. Once the image has been created successfully, run the container using the following command.
```
docker run seekdeep
```

----------------------
SeekDeep is a suite of bioinformatic tools for analyzing targeted amplicon sequencing developed by the UMass Medicine Bailey Lab. Checkout their website bellow for more details:  
[http://seekdeep.brown.edu/](http://seekdeep.brown.edu/)