FROM ubuntu:16.04

ARG PACKER_VERSION="1.4.4"
ENV PACKER_VERSION="$PACKER_VERSION"
ENV ANSIBLE_CALLBACK_WHITELIST="profile_tasks"

# Install Ansible
WORKDIR /install
RUN apt-get update && \
    apt-get install -y software-properties-common unzip python-pip wget sudo curl && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    pip install -U "pywinrm>=0.3.0"

# Install Packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

RUN useradd -ms /bin/bash ansible