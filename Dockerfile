ARG ACTIONS_BASE="ghcr.io/actions/actions-runner:2.324.0"
FROM $ACTIONS_BASE

ARG KUBECTL_VER="1.33.1"
ARG TERRAFORM_VER="1.4.0"
ARG YQ_VER="v4.35.1"

# Install dependencies and tools in a single RUN command to minimize layers
RUN sudo apt update -y && \
    umask 0002 && \
    sudo apt install -y ca-certificates curl wget apt-transport-https lsb-release gnupg unzip ssh git jq software-properties-common openssl && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ jammy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && \
    wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && sudo apt-get install -y powershell && \
    sudo rm -rf /var/lib/apt/lists/* && \
    # Download and install kubectl
    sudo curl -LO https://dl.k8s.io/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl && \
    sudo chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    # Download and install Terraform
    curl -O -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    sudo unzip terraform_${TERRAFORM_VER}_linux_amd64.zip -d /usr/local/bin && \
    sudo chmod 755 /usr/local/bin/terraform && \
    rm terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    # Download and install yq
    sudo curl -fsSL https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_amd64 -o /usr/local/bin/yq && \
    sudo chmod 755 /usr/local/bin/yq && \
    # Download and Install Node JS
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    node --version
