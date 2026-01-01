##################################################################
############## demo-02-BuildingOurFirstContainer ##############
##################################################################

------------------------------------------------------
# Let's build our first container using a Linux base layer

# Behind the scenes in docker-demos/ set up the Dockerfile 

# Show the Dockerfile (place it in this folder)

ls -l

# simple-app-v01

# Open the Dockerfile and show

# The CMD instruction in a Dockerfile specifies the default command that will run when a container is started from the built image. It defines the command and its parameters that the container will execute.

# The CMD instruction can be overridden at runtime by specifying a different command in the docker run command.

-------

# Use the official Alpine Linux image
FROM alpine:latest

# Set the command to run when the container starts
CMD ["echo", "Hello and welcome to Docker!"]

-----

----------------------------------------------------

# Show one layer being built

docker build -t hello-greeting .


# The image has been built

docker images

# Run the container (in detached mode)
# When we run in detached mode we do not get the output on screen

docker run --name hello-docker-container \
-d \
hello-greeting


# Go to the Docker Desktop -> Containers

# Click on the hello-docker container and show 

Logs

# Should see "Hello and welcome to Docker!"

--------------------------------------------

# Let's build another container from the same image

docker run hello-greeting

# Note that we get the greeting on screen (we're not in detached mode)

# Note this was a different container
docker ps -a

# Let's override the CMD instructions

docker run hello-greeting echo "Howdy doo"

# "Howdy doo" should be printed on screen

# Note all the different containers from the same image
docker ps -a

-----------------------------------------------

# Run a container that uses a Python image (will allow us to run Python apps on top of the container)

# Go to Docker Hub

# Search for Python and look at the Tags

# Note that the latest image is

3.9.19-slim-bullseye

# This is what we will use in our Dockerfile


### The RUN command allows us to execute commands whose effects are baked
###			into the docker image
###	These are separate from commands which run once the container is brought up we used CMD for that earlier
### Installation of tools can be done via RUN, but starting up services
###		can only happen once the container is brought up

### NOTE: We specify the RUN command in the "shell" form
### i.e. as we would run commands in a shell
### The alternative is the "exec" form which we will explore later with the 
###			ENTRYPOINT command


# simple-app-v02

# Change the contents of the Dockerfile

----

FROM python:3.9.19-slim-bullseye

LABEL maintainer=loonycorn

RUN pip install flask

----

# Build the container (note that there are 2 layers in the container being built)

docker build -f Dockerfile -t simple-app .

# Note it runs in interactive mode and opens up a Python terminal
# As long as this process is running the container will be active

docker run --name simple-app-container \
-it \
simple-app

# Run these commands

>>> import sys
>>> sys.version
>>> print(3+4)
>>> exit()


## Container stopped
docker ps -a


docker stop simple-app-container


### Remove the container and the image
docker rm simple-app-container

docker rmi simple-app

----------------------------------------

# Behind the scenes please remove all existing containers and images so we can start afresh in the next demo












