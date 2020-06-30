# Azure Pipeline Agent

This agent will allow the pipelines to build.

[Running in Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux)

```bash
# Copy the sample env and modify values as appropriate
cp .env_sample .env

# Build the docker image and start it
docker-compose build
docker-compose up -d

# Stop and Remove the image
docker-compose kill
docker-compose rm
```