# Simple Cluster Template

The `simplecluster` template provisions a kubernetes cluster with access to a container registry and keyvault.


## Provisioned Resources

This deployment creates the following:

 1. Azure Resource Group
 2. Container Registry (ACR)
 3. Kubernetes Cluster (AKS)


## Example Usage

1. Execute the following commands to provision resources.

```bash
# Download required modules
terraform init

# See what terraform will try to deploy without actually deploying
terraform plan

# Execute a deployment
terraform apply
```

2. Execute the following command to teardown your deployment and delete your resources when done with them.

```bash
# Destroy resources and tear down deployment. Only do this if you want to destroy your deployment.
terraform destroy
```

#### Required Variables

 1. `name`: An identifier used to construct the names of all resources in this sample.
 2. `location`: The deployment location of resource group container for all your Azure resources.


## Deploy a Sample Application to the Cluster

1. Export the required environment variables from the provisioned resources.

```bash
# Environment Variables
export RESOURCE_GROUP="<your_resource_group_name>"
export CLUSTER_NAME="<your_cluster_name>"
export PRINCIPAL_ID="<your_principal_id>"
export PRINCIPAL_SECRET="<your_principal_secret>"
export REGISTRY_NAME="<your_registry_name>"
```

1. Execute the following command to configure your local Azure CLI.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

1. Ensure the proper AKS Credentials have been retrieved

```bash
# Pull the cluster admin context
az aks get-credentials --name $CLUSTER_NAME \
  --resource-group $RESOURCE_GROUP \
  --admin


# Validate the cluster
kubectl get nodes
kubectl get pods --all-namespaces
```

1. Build and Deploy a Sample Application using Docker

_Build the application_
```bash
# Login to the Registry and get the FQDN
az acr login -n $REGISTRY_NAME
RegistryServer=$(az acr show -n $REGISTRY_NAME --query loginServer -otsv)

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
    build: ./app/azure-vote
    image: ${RegistryServer}/azure-vote-front:${USER}
    container_name: azure-vote-front
    environment:
      REDIS: azure-vote-back
    ports:
        - "8080:80"
EOF


# Build and push the Docker Images
docker-compose build
docker-compose push

# Check Repository for Images and Tags
az acr repository list -n $REGISTRY_NAME
az acr repository show-tags -n $REGISTRY_NAME --repository azure-vote-front
```

_Deploy the application_

```bash
# Create a k8s manifest file for the App
cat <<EOF | kubectl apply --namespace default -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-back
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-back
  template:
    metadata:
      labels:
        app: azure-vote-back
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
      - name: azure-vote-back
        image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
        env:
        - name: ALLOW_EMPTY_PASSWORD
          value: "yes"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
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
apiVersion: apps/v1
kind: Deployment
metadata:
  name: azure-vote-front
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azure-vote-front
  template:
    metadata:
      labels:
        app: azure-vote-front
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
      - name: azure-vote-front
        image: ${RegistryServer}/azure-vote-front:${USER}
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 80
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

kubectl get service azure-vote-front --watch  # Wait for the External IP to come live
```
