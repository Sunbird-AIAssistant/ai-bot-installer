#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages on Ubuntu
install_ubuntu_packages() {
    echo "Installing packages for Ubuntu..."
    # Add installation steps for Ubuntu here
    sudo apt update
    sudo apt install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt update
        sudo apt install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        chmod +x get_helm.sh
        ./get_helm.sh
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        sudo apt install -y awscli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository ppa:deadsnakes/ppa
        sudo apt update
        sudo apt install -y python3.7
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on Linux
install_linux_packages() {
    echo "Installing packages for Linux..."
    # Add installation steps for Linux here
    sudo yum update -y
    sudo yum install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        sudo yum install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        chmod +x get_helm.sh
        ./get_helm.sh
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        sudo yum install -y aws-cli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        sudo yum install -y python3 python3-devel python3-pip
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on MacOS
install_macos_packages() {
    echo "Installing packages for MacOS..."
    # Add installation steps for MacOS here
    echo "Installing packages for macOS..."
    brew update
    brew install curl unzip
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        brew install helm
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        brew install awscli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        brew install python@3.7
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on Windows
install_windows_packages() {
    echo "Installing packages for Windows..."
     # Execute PowerShell script to install Chocolatey
    powershell.exe -ExecutionPolicy Bypass -File install_choco.ps1
    
    # Install packages using Chocolatey
    choco install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        choco install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        choco install -y kubernetes-helm
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        choco install -y awscli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        choco install -y python --version=3.7
    else
        echo "Python 3.7 is already installed."
    fi

}
# Function to configure AWS credentials
configure_aws_credentials() {
    read -p "Enter AWS Access Key ID: " aws_access_key_id
    read -p "Enter AWS Secret Access Key: " aws_secret_access_key
    read -p "Enter AWS Default Region: " aws_default_region

    export AWS_ACCESS_KEY_ID="$aws_access_key_id"
    export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
    export AWS_DEFAULT_REGION="$aws_default_region"
}

# Function to install AWS dependencies
install_aws_dependencies() {
    echo "Installing Using AWS..."
    # Add commands to install AWS dependencies
    cd AWS || exit

    # Configure AWS CLI
    configure_aws_credentials

    # Run Terraform commands
    terraform init
    terraform plan
    terraform apply -auto-approve
    aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name sbai
    cd ../helmcharts || exit
    #Installing Databases
    helm upgrade -i databases ./databases -n sb-ai-assistant --create-namespace -f global-values.yaml -f global-cloud-values.yaml
    
    # Install ai-assistant app
    helm upgrade -i applications ./applications -n sb-ai-assistant --create-namespace -f global-values.yaml -f global-cloud-values.yaml

}


# Function to run setup based on user's OS selection
run_os_setup() {
    case $os_selection in
        1)
            echo "Selected operating system: Ubuntu"
            install_ubuntu_packages
            ;;
        2)
            echo "Selected operating system: Linux"
            install_linux_packages
            ;;
        3)
            echo "Selected operating system: MacOS"
            install_macos_packages
            ;;
        4)
            echo "Selected operating system: Windows"
            install_windows_packages
            ;;
        *)
            echo "Invalid option. Please select a valid option."
            exit 1
            ;;
    esac
}

# Ask user for their operating system
echo "Select your operating system:"
echo "1. Ubuntu"
echo "2. Linux"
echo "3. MacOS"
echo "4. Windows"
read -p "Enter your choice (1-4): " os_selection

# Run setup based on user's OS selection
run_os_setup

# Install AWS dependencies
install_aws_dependencies

# Print completion message
echo "Package has been deployed successfully"
