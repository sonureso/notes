> # 1. Using ML and Docker

Code reference: 
- https://github.com/campusx-official/insurance-premium-prediction-fastapi/tree/master
- https://github.com/campusx-official/fastapi-course

### Steps to create a Docker Image
SETUP:
1. Install Docker
2. Create an account on Docker Hub

STEPS:
1. Create a docker file: "Dockerfile"
2. Build the docker image: [```docker build -t sonureso/fastapi_app:1.1 .```]
3. Login to Docker Hub: [```docker login```]
4. Push the image to Docker Hub: [```docker push sonureso/fastapi_app:1.1```]
5. Pull the docker image from Docker Hub
6. Run the docker container: [```docker run -d -p 8000:8000 sonureso/fastapi_app:1.1```]

```dockerfile
# Use Python 3.11 base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of application code
COPY . .

# Expose the application port
EXPOSE 8000

# Command to start FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

> # 2. Deploy to AWS
1. Create an EC2 instance.
2. Connect to the instance using SSH.
3. Run the following commands:
    - ```sudo apt update```
    - ```sudo apt-get install -y docker.io```
    - ```sudo systemctl start docker```
    - ```sudo systemctl enable docker```
    - ```sudo usermod -aG docker $USER```
    - exit and reconnect to the instance
4. Restart a new connection to EC2 instance.
5. Run the following commands:
    - ```docker pull sonureso/fastapi_app:1.1```
    - ```docker run -d -p 8000:8000 sonureso/fastapi_app:1.1```
6. Change security group setting to allow inbound traffic on port 8000.
    - Go to EC2 dashboard -> Security Groups -> Edit Inbound Rules -> Add Rule -> Custom TCP -> Port 8000 -> Source: Anywhere (0.0.0.0/0)
7. Check the application by visiting http://<EC2_PUBLIC_IP>:8000 in the browser.

