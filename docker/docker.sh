#!/bin/bash

# Function to retry a command up to 5 times with a delay
retry() {
    local n=1
    local max=5
    local delay=5
    while true; do
        "$@" && break || {
            if [[ $n -lt $max ]]; then
                ((n++))
                echo "Command failed. Attempt $n/$max:"
                sleep $delay;
            else
                echo "The command has failed after $n attempts."
                return 1
            fi
        }
    done
}

# Uninstall old Docker versions and packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg
done

# Add Docker's official GPG key
retry sudo apt-get update
retry sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
retry sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
retry sudo apt-get update

retry sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Use Docker command without sudo
sudo groupadd docker

# Add your username to the Docker group
sudo usermod -aG docker ${USER}

# To apply the new group membership
newgrp docker

# Verify the connection to the Docker server
retry docker info

# Verify the Docker engine
retry docker run hello-world

# Add the below block to .bashrc to ensure user is not deleted every time logout the SSH connection
block="# Check if user added to Docker group\nif ! groups | grep -q '\\\bdocker\\\b'; then\n  exec newgrp docker\nfi\n"

# Add the block to the end of .bashrc file if it doesn't exist
if ! grep -Fq "# Check if user added to Docker group" ~/.bashrc; then
    printf "%b" "$block" >> ~/.bashrc
    echo "Block added to .bashrc"
else
    echo "Block already exists in .bashrc"
fi
