# GitOps Cluster Template

The `gitopscluster` template provisions a kubernetes cluster with a gitops workflow.


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

1. Execute the following command to configure your local Azure CLI.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

2. Execute the following commands to set up your terraform workspace.

```bash
# This configures terraform to leverage a remote backend that will help you and your
# team keep consistent state
terraform init -backend-config "storage_account_name=${TF_VAR_remote_state_account}" -backend-config "container_name=${TF_VAR_remote_state_container}"

# This command configures terraform to use a workspace unique to you. This allows you to work
# without stepping over your teammate's deployments
terraform workspace new $USER || terraform workspace select $USER
```

3. Execute the following commands to provision resources.

```bash
# See what terraform will try to deploy without actually deploying
terraform plan

# Execute a deployment
terraform apply
```

4. Execute the following command to teardown your deployment and delete your resources when done with them.

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
az login --service-principal -u $PRINCIPAL_ID -p $PRINCIPAL_SECRET --tenant $ARM_TENANT_ID
```

1. Ensure the proper AKS Credentials have been retrieved

```bash
# Pull the cluster admin context
az aks get-credentials --name $CLUSTER_NAME \
  --resource-group $RESOURCE_GROUP \
  --admin

# Install kubectl command
az aks install-cli --install-location ~/bin/kubectl

# Validate the cluster
~/bin/kubectl get nodes
~/bin/kubectl get pods --all-namespaces
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
        image: ${RegistryServer}/azure-vote-front:${USER}
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

~/bin/kubectl apply -f deployment.yaml
~/bin/kubectl get service azure-vote-front --watch  # Wait for the External IP to come live


## THIS SECTION NOT TESTED YET
# Add a clusterrolebinding for cluster-admin to the dashboard
~/bin/kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# Open the dashboard
az aks browse -n $CLUSTER_NAME -g $RESOURCE_GROUP 
```
