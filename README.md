# GDAL extensions
The purpose of this project is trying to build up the portable GDAL and its supportive tools

Currently, add FileGDB integration.
This docker image will setup FileGDB and its dependencies first, then install GDAL from source code.

## Prerequisite

Please install [docker](https://docs.docker.com/install/) on your machine. 

## Version

The software environment is as following

* Ubuntu 18.04
* PROJ 6.1
* FileGDB 1.5.1
* GDAL 3.0.1

## Build docker image

* Go under this directory
```

$ docker build -t <IMAGE_NAME> .
```

## Run

* mount your host directory

* run with command 
