##################################################################
############## demo-03-SettingUpAContainerWithAnApp ##############
##################################################################

---------------------------------------------------------
# Here we set up and run a simple app specified in a Python file

############################################
###### NOTES

# The ENTRYPOINT directive in a Dockerfile specifies the command that will be run when a container starts. Unlike the CMD instruction, which provides default parameters that can be overridden at runtime, ENTRYPOINT is designed to always execute the specified command, making it the core purpose of the container.

# Immutable Command: The command specified by ENTRYPOINT is immutable and will always be executed. You can, however, pass additional parameters to it at runtime.

### NOTE: We specify the ENTRYPOINT command in the "exec" form where the 
###			different portions of the commands are specified as a list of
###			commands and arguments
### The Docker docs say that the exec form is preferred

###		- the CMD command is often used to pass arguments to the ENTRYPOINT instruction.
###				The docs say "The main purpose of a CMD is to provide defaults for an 
###				executing container". We use it to pass arguments to the setup script.
###		- we use the exec form for both CMD and ENTRYPOINT. This is needed when using
###				CMD to pass arguments to ENTRYPOINT.

############################################

# Please get the files from the my-python-app/ folder

# In the docker-demo/ folder have the following files

app.py
Dockerfile
requirements.txt

# Drag the folder to sublime text and show each of these files in this order

app.py
second_app.py
third_app.py
requirements.txt
Dockerfile

# This is what the Dockerfile should look like


--------------------

FROM python:3.9.19-slim-bullseye

LABEL maintainer=loonycorn

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000/TCP

ENTRYPOINT ["python"]

CMD ["app.py"]

--------------------

# Build the image (note the 4 layers that are built)
# Switching to the WORKDIR is also a layer

docker build -t my-python-app .

# Inspect 

docker inspect my-python-app


# Head over to Docker Desktop -> click on Images

# Click on the my-python-app image

# Show the image hierarchy

# click on the two FROM instructions right below "Image hierarchy"

# Show the vulnerabilities in the base image

# Scroll on the remaining layers "Layers (22)"

# Show that our layers come right at the bottom

------------------
# Back to the terminal

# Run in detached mode

docker run --name my-first-python-app-container \
-d -p 5000:5000 \
my-python-app

# Go to 

http://localhost:5000/

# Show that we get a page which says

My first app in a container is up and running!

# IMPORTANT: Leave this page open

# Now go to Docker Desktop -> click on Containers

# Click through to 

my-first-python-app-container

# Show

Logs

Terminal

# In the terminal run the following commands

pwd

# We should be in the /app directory

ls -l

# Show the 3 files from our directory copied into the container

------------------------------------

# Back to the terminal (my-first-python-app-container is still running)


# On the terminal show the files

ls -l




# Pass in second_app.py as a command line argument

docker run --name my-second-python-app-container \
-d -p 7000:5000 \
my-python-app \
second_app.py

# Go to 

http://localhost:7000/

# Should see the app

My second app in a container is up and running!

---------------------

# Can run a 3rd container

docker run --name my-third-python-app-container \
-d -p 9000:5000 \
my-python-app \
third_app.py


# Go to 

http://localhost:9000/

# Should see the app

My third app in a container is up and running!


# Go to Docker Desktop and show all 3 containers running

# Delete all three containers from here

# Go to Images

# Delete all the images so we can start afresh


------------------------------------
#####################################################################################
# Let's set up an app to display data and a statistical summary

# From the folder my-data-app/

# Behind the scenes set up these files in the docker-demos/ folder

app.py
Dockerfile
requirements.txt
setup_script.sh

setup_script_with_file_details.sh
Store.csv
Ecommerce.csv
insurance.csv


# Drag the folder to Sublimetext and show the first 4 files in this order

app.py
requirements.txt
setup_script.sh
Dockerfile

# Dockerfile should look like this

----
FROM python:3.9.19-slim-bullseye

LABEL maintainer=loonycorn

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000

RUN chmod +x setup_script.sh setup_script_with_file_details.sh

ENTRYPOINT ["./setup_script.sh"]

CMD ["insurance.csv"]
----

------------------------------------------------------

# Now let's create the image

docker build -t my-data-app .

# Create a container with the default insurance.csv file
docker run --name my-data-app-insurance-container \
-d -p 5000:5000 \
my-data-app 

# Show the logs - should have logs from the set up script

docker logs my-data-app-insurance-container

# Go to

http://localhost:5000/

# Show the insurance data

------------------------------------------
# Back to the terminal

# Stop the container
docker stop my-data-app-insurance-container

# Check stopped

docker ps -a

# Remove the container
docker rm my-data-app-insurance-container

# Check removed

docker ps -a


# IMPORTANT: In Sublimetext show the contents of this file

setup_script_with_file_details.sh

# Now back to the terminal

# Let's create another container with a different file and overriding entrypoint

docker run --name my-data-app-store-container \
-d -p 5000:5000 \
--entrypoint "./setup_script_with_file_details.sh" \
my-data-app \
"Store.csv"


# Show the logs

docker logs my-data-app-store-container


# Go to

http://localhost:5000/

# Show the insurance data



















