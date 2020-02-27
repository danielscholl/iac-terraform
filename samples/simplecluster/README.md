# Simple Cluster Template

The `simplecluster` template provisions a kubernetes cluster with access to a container registry and keyvault.


## Provisioned Resources

This deployment creates the following:

 1. Azure Resource Group
 2. Container Registry (ACR)
 3. Kubernetes Cluster (AKS)
 4. Virtual Network
 5. Keyvault
 6. Service Principal
 7. AD Application


## Example Usage

1. Execute the following commands to set up your terraform workspace.

```bash
# This configures terraform to leverage a remote backend that will help you and your
# team keep consistent state
terraform init -backend-config "storage_account_name=${TF_VAR_remote_state_account}" -backend-config "container_name=${TF_VAR_remote_state_container}"

# This command configures terraform to use a workspace unique to you. This allows you to work
# without stepping over your teammate's deployments
terraform workspace new $USER || terraform workspace select $USER
```

2. Execute the following commands to provision resources.

```bash
# See what terraform will try to deploy without actually deploying
terraform plan

# Execute a deployment
terraform apply
```

3. Execute the following command to teardown your deployment and delete your resources when done with them.

```bash
# Destroy resources and tear down deployment. Only do this if you want to destroy your deployment.
terraform destroy
```

#### Required Variables

 1. `name`: An identifier used to construct the names of all resources in this sample.
 2. `location`: The deployment location of resource group container for all your Azure resources.


## Deploy a Sample Application to the Cluster


1. Ensure the proper AKS Credentials have been retrieved

```bash
ResourceGroup="<your_resource_group>"
Cluster="<your_cluster>"
# Pull the cluster admin context
az aks get-credentials --name <your_cluster> \
  --resource-group $ResourceGroup \
  --admin

# Validate the cluster
kubectl get nodes
kubectl get pods --all-namespaces
```

1. Build the Docker Images and Deploy using the Azure CLI

```bash
## Ensure kubectl is using the appropriate configuration!!
#--------------------------------------------------------

ResourceGroup="<your_resource_group>"
deploy.sh $ResourceGroup

# Watch to see the app come alive
kubectl get service azure-vote-front --watch
```

2. Build and Deploy a Sample Application using Docker

_Build the application_

```bash
## Ensure kubectl is using the appropriate configuration!!
#--------------------------------------------------------

# Set the variable to your resource group where ACR exists.
ResourceGroup="<your_resource_group>"

# Login to the Registry
Registry=$(az acr list -g $ResourceGroup --query [].name -otsv)
az acr login -g $ResourceGroup -n $Registry

# Get the FQDN to be used
RegistryServer=$(az acr show -g $RegistryGroup -n $Registry --query loginServer -otsv)

# Create a Compose File for the App
cat > docker-compose.yaml <<EOF
version: '3'
services:

  azure-vote-back:
    image: redis
    container_name: azure-vote-back
    ports:
        - "6379:6379"

  azure-vote-front:
    build: ./src/azure-vote
    image: ${RegistryServer}/azure-vote-front
    container_name: azure-vote-front
    environment:
      REDIS: azure-vote-back
    ports:
        - "8080:80"
EOF


# Build and push the Docker Images
docker-compose build
docker-compose push
```


_Deploy the application_

```bash
# Retrieve the Registry Server FQDN
RegistryServer=$(az acr show -g $ResourceGroup -n $Registry --query loginServer -otsv)

# Create a k8s manifest file for the App
cat > deployment.yaml <<EOF
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: azure-vote-back
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: azure-vote-back
    spec:
      containers:
      - name: azure-vote-back
        image: redis
        ports:
        - containerPort: 6379
          name: redis
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-back
spec:
  ports:
  - port: 6379
  selector:
    app: azure-vote-back
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: azure-vote-front
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      containers:
      - name: azure-vote-front
        image: ${RegistryServer}/azure-vote-front
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 250m
          limits:
            cpu: 500m
        env:
        - name: REDIS
          value: "azure-vote-back"
---
apiVersion: v1
kind: Service
metadata:
  name: azure-vote-front
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: azure-vote-front
EOF

kubectl apply -f deployment.yaml
kubectl get service azure-vote-front --watch  # Wait for the External IP to come live


# Set the variable to your resource group where ACR exists.
ResourceGroup="demo-cluster"
Cluster=$(az aks list -g $ResourceGroup --query [].name -otsv)

# Open the dashboard
az aks browse -n $Cluster -g $ResourceGroup 
```