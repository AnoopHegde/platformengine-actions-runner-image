ARG ACTIONS_BASE="ghcr.io/actions/actions-runner:2.316.1"
FROM $ACTIONS_BASE

ARG KUBECTL_VER="1.28.3"
ARG TERRAFORM_VER="1.8.3"


RUN sudo apt update -y \
  && umask 0002 \
  && sudo apt install -y ca-certificates curl wget apt-transport-https lsb-release gnupg unzip ssh git jq software-properties-common openssl

# Install MS Key
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add MS Apt repo
RUN umask 0002 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ jammy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# Install Azure CLI and powershell
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
RUN wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
  sudo dpkg -i packages-microsoft-prod.deb && \
  rm packages-microsoft-prod.deb && \
  sudo apt-get update && sudo apt-get install -y powershell

RUN sudo rm -rf /var/lib/apt/lists/*


# Download and install kubectl
RUN sudo curl -LO https://dl.k8s.io/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl
RUN sudo  chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl

# Download and install Terraform
RUN set -x \
  && curl -O -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip \
  && sudo unzip terraform_${TERRAFORM_VER}_linux_amd64.zip -d /usr/local/bin \
  && sudo chmod 755 /usr/local/bin/terraform

# Download and Install Node JS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN sudo apt-get install -y nodejs \
  && node --version

  
  


  
