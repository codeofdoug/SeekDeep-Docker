# Docker Image for SeekDeep
<h4 align = "right">Colby T. Ford, Ph.D.</h4>
This repository contains the Dockerfile for generating an Ubuntu image with SeekDeep pre-installed.

## DockerHub
This container image is available from DockerHub: [hub.docker.com/r/cford38/seekdeep](https://hub.docker.com/r/cford38/seekdeep)

#### Pull Image to Local Machine
```bash
docker pull cford38/seekdeep:latest
```
#### To Run Locally
```bash
docker run --name seekdeep -p 9881:9881 -d cford38/seekdeep
docker exec -it seekdeep /bin/bash
```

#### Copy File to Container
```bash
docker cp myfile.txt seekdeep:./myfile.txt
```

### Copy Files from Container
```bash
docker cp seekdeep:./root/SeekDeep/ ./
```

-------------------------------

## Build Instructions
1. Clone this repository to your local machine

2. Open terminal and navigate to the directory of this repository.

3. Run the following command. This will generate the Docker image.
```bash
docker build -t seekdeep .
```
_Note:_ You may have to increase the resource limits in Docker's settings as this container size (and the resources SeekDeep needs to run) will be quite large.
<p align="center"><img src="DockerSettings.PNG" width="500px"></p>


4. Once the image has been created successfully, run the container using the following command.
```bash
docker run --name seekdeep -it -p 9881:9881 -d seekdeep
```
4. Alternatively, if you want to map access to a specific folder on your computer use the following command.
```bash
docker run --name seekdeep -it -p 9881:9881 -v "/your/local/path/to/Folder":/FolderNameInDocker -d seekdeep
```

5. Once the container is ready, remote into the bash terminal.
```bash
docker exec -it seekdeep /bin/bash
```

6. Run all your settings and finalize your analysis by running `runAnalysis` with whatever number of CPUs you want to use (below is 4)
```bash
./runAnalysis.sh 4
```

Note that from the terminal (and after completing your analysis), you can run the `popClusteringViewer` to browse your results.

```bash
SeekDeep popClusteringViewer --verbose --configDir "$(pwd)/serverConfigs" --bindAddress 0.0.0.0 --port 9881 --name pcv
```

Then, navigate to [localhost](http://localhost:9881/pcv) on your local browser. You should then be able to see the viewer tool.
![](viewer.png)

----------------------

## To Publish on DockerHub

```
docker image tag seekdeep <USERNAME>/seekdeep
docker push <USERNAME>/seekdeep
```

----------------------
## About SeekDeep

SeekDeep, developed by the Bailey Lab at Brown University, is a suite of bioinformatics tools for analyzing targeted amplicon sequencing. Check out their website for more details: [http://seekdeep.brown.edu/](http://seekdeep.brown.edu/)
