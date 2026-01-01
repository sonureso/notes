##################################################################
############## demo-04-PushingAndPullingImages ##############
##################################################################

# Behind the scenes
# Make sure you have deleted all the previous containers and images

# Let's work with the same app that we did previously

# On the terminal under docker-demos/ run

ls -l

# Show the same files

# Head over to DockerHub

### Click on Create Repository

### Give the repo a name of 

loony-data-app

### Set the visibility to Public and hit Create

# Click on your Avatar (or letter) on the top right

# Select "Account Settings" -> Go to "Personal Access Tokens"

# Generate a new token with this name

Name: rw_access_token

Access permissions: Read and Write

# Generate token

# Copy the token over and keep it with you

---------------------
# Back to the terminal

# Build an image with a tagname to push to the repo

docker build -t <username>/loony-data-app:v1.0 .

# Check the images

docker images


### Before pushing to dockerhub, we'll need to sign in from the CLI
### Type in the following command before entering the username and password
###         for your dockerhub account
docker login

# Type in your username and the personal access token

# See login successful

# Push the image to the repo
# <registry>/<namespace>/<repository>:<tag>

docker push <username>/loony-data-app:v1.0

# Go back to where you had the repo open and hit refresh

# Show the image with the v1 tag

# Click through to the image

# Show the image layers

### Towards the top-right of the page is a button to Delete Tag - click on it
### We'll now re-add the image using Docker Desktop

### Switch to Docker desktop
### Go to images

### Click on the three-dots for this image --> Push to Hub
### You may be prompted to enter your dockerhub credentials

# Go to the Docker Hub site

# Refresh the page in the repo and show that we once again have an image with the v1 tag


---------------------------------------------
# Now let's delete this image from our local repo

# On the terminal

# The image should be present here
docker images

# Remove the image from the local repo
docker rmi <username>/loony-data-app:v1.0

# The image should no longer be here
docker images


# IMPORTANT: Go to DockerHub and show that the v1 tagged image is still there

--------------------------------------
# Back on the terminal

# Pull the image from DockerHub
docker pull <username>/loony-data-app:v1.0

# The image is once again available
docker images

# Now let's tag this image with the "latest" tag as well

docker tag <username>/loony-data-app:v1.0 <username>/loony-data-app:latest

# See the tag
docker images


# Push the image with the new tag
docker push <username>/loony-data-app:latest

# IMPORTANT: Go to DockerHub and show that the "latest" tagged image is now present there

-------------------------------
# Back to the terminal

# Remove the image with the "latest" tag and pull that from docker hub

docker rmi <username>/loony-data-app:latest

# The image is no longer present in the local registry

docker images

# Now pull the latest from the repository

docker pull <username>/loony-data-app

# Image is back

docker images















































