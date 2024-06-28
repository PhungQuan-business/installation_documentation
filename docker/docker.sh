# install old docker versions and packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

yes | sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## Use docker command without sudo

sudo groupadd docker

# add your username to the docker group
sudo usermod -aG docker ${USER}

# To apply the new group membership
newgrp docker

# verify the connection to the Docker server
docker info

# verfiy the Docker engine
docker run hello-world

# add the below block to .bashrc to ensure user is not deleted everytime logout the ssh connection
block = "# Check if user added to Docker group\nif ! groups | grep -q '\\\bdocker\\\b'; then\n  exec newgr docker\nfi\n"

# add the block to the end of .bashc file if it doesn't exist
if ! grep -Fq "# Check if user added to Docker group" ~/.bashrc; then
    printf "%b" "$block" >> ~/.bashrc
    echo "Block added to .bashrc"
else
    echo "Block already exists in .bashrc"
fi
