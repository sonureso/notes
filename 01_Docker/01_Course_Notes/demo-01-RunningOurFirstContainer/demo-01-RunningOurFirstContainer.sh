##################################################################
############## demo-01-RunningOurFirstContainer ##############
##################################################################

# Explore Docker Desktop

# Click on 

Containers
Images
Volumes


# BEHIND the scenes create an account on https://hub.docker.com/ and log in (no need to show this step)
# Make sure the username is loonydocker or loonyuser (needed for pushing images later).


# Go to the Docker Hub - we should be logged in

https://hub.docker.com/


# Scroll on this page -> Click on the "Postgres" container (this is an official container)

# Show both these pages

Overview
Tags

# On the Tags page for the first tag

12.19-bullseye

# Expand the +5 more

# Show all the architectures that this image supports

# Go back to the main dockerhub page

# Search for this container

hello-world

# Click on the following and show

Overview
Tags (scroll and show the "latest" tag, expand that and show architectures)


-------------------------------------------------
# Back to the terminal

# Keep the terminal open on one full screen

# Keep Docker Desktop open on another full screen

# Navigate between the two during recording

### Get images (this should empty)
docker images

### Get containers
docker ps -a

### First, let's run their built-in container from the CLI

### Not explaining this command as fully covered in the explanation below
### But note the output stating how docker got this
### This will pull the image with the "latest" tag by default
docker run hello-world

### Get images
docker images

### Get containers
docker ps -a

------------------------------------------------
# Head over to Docker Desktop

# Click on Images and show the hello-world image

# Click on Containers on the left

# Show the one exited container

# Click on the container and click on the following tabs

Logs
Inspect
Terminal
Files (here double-click on hello)
Stats


------------------------------------------------
# Back to the terminal

# Let's pull an image from the repository and then run the container
# Note that the latest tag is pulled
docker pull docker/getting-started

# New image available in our local repository
docker images

# No container from this image yet
docker ps -a


### Run one more container
### The image is not pulled here since we already have it available
### "docker run" : run this image as a container
### "-d" : run it in detached mode, in the background
### "-p 7080:80" : map port 7080 on localhost to port 80 in the container
### The implementation of the app exposes port 80 of the container,
### so we listen to that and display it in the localhost:80 port
### "docker/" : the repository in docker hub from which to pull the image
### "getting-started" : the actual image to pull from docker hub
docker run -d -p 7080:80 docker/getting-started

docker images

## This points to the port mapping under the PORTS column
## Observe that the getting-started container STATUS will be "Up x minutes"
##		while the hello-world container will have Exited
docker ps -a

### Open up your web browser
### Navigate to "localhost:7080"
### Scroll through the page (no need to show any of the other pages)

### Now switch over to Docker desktop

### Then click on Containers

# Click through to the running container and show

Logs

# IMPORTANT: Go to the browser where the app is running and hit refresh 2-3 times

# Come back to the logs and see that new logs are generated

# Click on 

Inspect

Terminal

# Here on terminal run 

ls -l

# Click on 

Files

Stats

-------------------------------------------

### Head back to the shell where we'll now stop the running container

docker ps -a

### Note the CONTAINER ID of the docker/getting-started container
### Use the ID to stop the container - this will free up port 80 on the localhost
docker stop <container_id>

### View the container state
docker ps -a

### Removing the container
docker rm <container_id>

### View the container state
docker ps -a

### The images for docker/getting-started and hello-world are still around
### Note the IMAGE ID values for both 
docker images

### Remove the images (the command is docker rmi)
docker rmi <getting-started_image_id>

docker rmi <hello-world_image_id>

docker ps -a

### The images are gone
docker images





