# install old docker versions and packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Update existing packages
sudo apt update

# install prerequisite
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add GPG key for the official Docker repository to your system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources.
# It automatically install the stable version of Docker meant for Ubuntu 20.04 which is 'focal' 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

# install docker without prompt and stuff
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io

# install docker
yes | sudo apt install docker-ce docker-ce-cli containerd.io


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
