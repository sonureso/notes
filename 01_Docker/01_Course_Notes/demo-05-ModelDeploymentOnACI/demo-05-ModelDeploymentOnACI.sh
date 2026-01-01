##################################################################
############## demo-05-ModelDeploymentOnACI ##############
##################################################################

# Behind the scenes set up a folder in the home directory ~/notebooks

# Place the notebook there

ModelTrainingAndSerialization

# In the recording first

# Start on the terminal under ~/notebooks, show the notebook

ls -l 


# Switch and show the notebook open on Jupyter Notebooks (no need to show the opening, naming etc)

# Have the code already there - run the code cells one by one

# After running the code cells come back to this file to continue further

-------------------------------------------------

# On the terminal under ~/notebooks

# Show the serialized pickle file
ls -l

# Copy over the pickle file into ~/docker-demos and move into that directory

cp churn_pred_model.pkl ../docker-demos

cd ../docker-demos

# Drag the ~/docker-demos folder into Sublimetext and show the files there in this order

(IMPORTANT: Please match the scikit-learn version with what you used to train the model)
requirements.txt
app.py
gunicorn_config.py
Dockerfile


# On the terminal in ~/docker-demos
docker build -t bank_customer_churn_pred_model:1.0 .


# Run the container (note no warnings)
docker run -p 5000:5000 --name churn-pred-model-container \
	bank_customer_churn_pred_model:1.0


---------------------------------------------
# Go to the browser

http://localhost:5000

# Should see the welcome message

# Open up a new terminal tab

# Prediction should be "exited"

curl -X POST http://localhost:5000/predict -H "Content-Type: application/json" -d '{
           "CreditScore": [620], 
           "Geography": ["France"],
           "Gender": ["Female"], 
           "Age": [42], 
           "Tenure": [2], 
           "Balance": [0.0], 
           "NumOfProducts": [1], 
           "HasCrCard": ["Yes"], 
           "IsActiveMember":["Yes"], 
           "EstimatedSalary": [100000.00]
    }'

# Prediction should be "not exited"

curl -X POST http://localhost:5000/predict -H "Content-Type: application/json" -d '{
            "CreditScore": [850],
            "Geography": ["Spain"],
            "Gender": ["Female"],
            "Age": [43],
            "Tenure": [2],
            "Balance": [12000.0],
            "NumOfProducts": [1],
            "HasCrCard": ["Yes"],
            "IsActiveMember": ["Yes"],
            "EstimatedSalary": [78000.0]
    }'

# Go back to the terminal where you have the container running

# Kill it with Ctrl + C

##############################################################
######### Deploying the app to Azure on ACI

# For this you need an Azure account and need to have the Azure CLI installed

# You can install the Azure CLI behind the scenes, no need to reinstall this


# Go to the Azure portal and show that we are logged in

https://portal.azure.com/#home 


# Go to the documentation page and see how we can install the Azure CLI

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

# On this page click on the following links

Install on Windows

Install on MacOS

# Show the options in each of these pages


----------------------------------------

# On the terminal window

# Show that we have Azure CLI installed
az --version

# Login to Azure
az login


# Create a resource group
az group create --name loony-deployment-rg --location eastus


# Create a container registry within the resource group

az acr create --resource-group loony-deployment-rg --name loonyacr --sku Basic


# Head over to the Azure Portal on the browser

# Refresh and show the loony-deployment-rg (search for it if it does not show up on refresh)

# Click through to the container registry and note its "Login server" on the top-right of the page

# Now back to the terminal

# Login to the container registry

az acr login --name loonyacr

# Now we tag and push the images to the ACR
# <login_server>/<repository>/<image>:<image_tag>
# The repository name and the image name will be the same
docker tag bank_customer_churn_pred_model:1.0 \
loonyacr.azurecr.io/bank_customer_churn_pred_model:1.0

# Now push to the ACR
docker push loonyacr.azurecr.io/bank_customer_churn_pred_model:1.0

----------------------------------
# Go to our ACR on the Azure Porta

# On the left click on Services -> Repositories

# Click on thi repository

bank_customer_churn_pred_model

# Click on the image tag v1

# Show we now have the command to pull from this repository (don't run the command, just show it)


# Back to the terminal

az acr repository list --name loonyacr --output table

# Show image tags

az acr repository show-tags --name loonyacr --repository bank_customer_churn_pred_model --output table

--------------------------------
# Access the credentials for the registry

# On the browser go to the loonyacr

# On the left go to Settings -> Access key

# Select "Admin" and see the credentials

# Back to the terminal

# Enable admin and get credentials
az acr update -n loonyacr --admin-enabled true

acr_credentials=$(az acr credential show --name loonyacr)

# Show credentials
echo $acr_credentials


# Extract and show password

password=$(echo "$acr_credentials" | jq -r '.passwords[0].value')

echo $password

# Now let's deploy the model in a container

az container create --resource-group loony-deployment-rg --name churn-prediction-app --image loonyacr.azurecr.io/bank_customer_churn_pred_model:1.0 --cpu 1 --memory 1 --registry-login-server  loonyacr.azurecr.io --registry-username loonyacr --registry-password $password  --dns-name-label clfmodel --ports 5000

# Show deployment succeeded

az container show --resource-group loony-deployment-rg --name churn-prediction-app --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table



# Go to the Azure Portal -> Search for Container Instances

# Note the chunr-prediction-app there

# Click on the app and show -> Note the FQDN

# Back to the terminal

# Prediction should be "yes"

curl -X POST http://clfmodel.eastus.azurecontainer.io:5000/predict -H "Content-Type: application/json" -d '{
           "CreditScore": [620], 
           "Geography": ["France"],
           "Gender": ["Female"], 
           "Age": [42], 
           "Tenure": [2], 
           "Balance": [0.0], 
           "NumOfProducts": [1], 
           "HasCrCard": ["Yes"], 
           "IsActiveMember":["Yes"], 
           "EstimatedSalary": [100000.00]
    }'


# Prediction should be no

curl -X POST http://clfmodel.eastus.azurecontainer.io:5000/predict -H "Content-Type: application/json" -d '{
            "CreditScore": [850],
            "Geography": ["Spain"],
            "Gender": ["Female"],
            "Age": [43],
            "Tenure": [2],
            "Balance": [12000.0],
            "NumOfProducts": [1],
            "HasCrCard": ["Yes"],
            "IsActiveMember": ["Yes"],
            "EstimatedSalary": [78000.0]
    }'


# Clean up resources

az container delete --resource-group loony-deployment-rg --name churn-prediction-app


# Show container deleted

az container list --resource-group loony-deployment-rg --output table



# Delete resource group

az group delete --name loony-deployment-rg































