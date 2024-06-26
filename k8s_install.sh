# Kubernetes components v1.29

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Cretae if `/etc/apt/keyrings` not exist.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

##### Từ đây trở xuống là phải viết thành docs##########

# enable cri(container runtime interface)
sudo vi /etc/containerd/config.toml
# comment the only line and save
sudo systemctl restart containerd

# intialize the cluster on master node
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=<MASTER_IP>

# for the master node only
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# apply network plugin
kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml