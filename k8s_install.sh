# Kubernetes components
# update package
sudo apt update

# upgrade packages
sudo apt upgrade

# add sigining key into the system(repeat on other node)
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# add software repository, since k8s is not included in ubuntu repository by default
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt-get update -y

# install k8s tools
sudo apt-get install -y kubelet kubeadm kubectl -y

sudo apt-mark hold kubelet kubeadm kubectl -y