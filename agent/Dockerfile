FROM ubuntu:16.04
ARG TERRAFORM_VERSION=0.12.20
ARG GO_VERSION=1.12.14

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes



RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  jq \
  git \
  iputils-ping \
  libcurl3 \
  libicu55 \
  libunwind8 \
  netcat \ 
  apt-transport-https \
  lsb-release \
  gnupg \
  build-essential \
  wget \
  unzip

# Setup Azure CLI
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
  cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

RUN AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
  tee /etc/apt/sources.list.d/azure-cli.list 

RUN apt-get update && apt-get install -y --no-install-recommends \
  azure-cli  && \
  rm -rf /var/lib/apt/lists/*


# Install Terraform
RUN wget -q -O terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
  unzip terraform.zip -d /usr/local/bin && \
  rm terraform.zip

# Install Golang
# RUN wget -q -O golang.tar.gz "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
#   tar -xvf golang.tar.gz && \
#   mv go /usr/local && \
#   rm golang.tar.gz

# ENV GOROOT=/usr/local/go
# ENV GOPATH $HOME/go
# ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH


WORKDIR /azp

COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]