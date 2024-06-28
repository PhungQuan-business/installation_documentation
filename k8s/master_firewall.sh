sudo ufw allow 6443/tcp  # Kubernetes API server
sudo ufw allow 2379:2380/tcp  # etcd server client API
sudo ufw allow 10250/tcp  # Kubelet API
sudo ufw allow 10259/tcp  # kube-scheduler
sudo ufw allow 10257/tcp  # kube-controller-manager
sudo ufw allow 179/tcp # Calico networking (BGP)
sudo ufw allow 5473/tcp # Calico with typha
sudo ufw allow 51820/tcp # IPv4 Wireguard enabled
sudo ufw allow 51821/tcp # IPv6 Wireguard enabled
sudo ufw allow 4789/tcp # Flannel networking