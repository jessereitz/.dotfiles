#!/usr/bin/env bash

#########################################################################
# Install Docker on Ubuntu 18.04
# 
# This is a shameless copy/condensation of the official instructions 
# from docker's website. I just wanted a quick script to run to install
# it though.
# 
# Se https://docs.docker.com/install/linux/docker-ce/ubuntu/
#########################################################################

echo "#####################################"
echo -e "\n          It's Docker Time          \n"
echo "#####################################"

# Update the apt package index
sudo apt-get update

# Let apt use HTTPS
echo "Installing packages required for apt over HTTPS"
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    
# Get Docker's GPG key
echo "Getting Docker's GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint
echo "Verifying the fingerprint of Docker's GPG key.."
sudo apt-key fingerprint 0EBFCD88
echo "Good."

# Add the repo
echo "Adding the Docker repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo "Done."

# Update package lists with new repo
sudo apt-get-update

# Install that sucka
echo "Actually installing docker starting... now."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Sanity check to make sure it worked
echo "Did it work?"
sudo docker run hello-world
echo "It did!"

echo "Adding the current user ${$USER} to the group: docker"
sudo usermod -aG docker $USER
echo "Done."

echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Done."

echo "Successfully installed Docker and docker-compose."
