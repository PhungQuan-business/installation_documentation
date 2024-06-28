sudo ufw allow 179/tcp # Calico networking(BGP)
sudo ufw allow 4789/tcp # Calico VXLAN
sudo ufw allow 5473/tcp # Calico with typha
sudo ufw allow 51820/tcp # IPv4 Wireguard enabled
sudo ufw allow 51821/tcp # IPv6 Wireguard enabled
sudo ufw allow 4789/tcp # Flannel networking
sudo ufw allow 10250/tcp # Kubelet API
sudo ufw allow 10256/tcp
sudo ufw allow 30000:32767/tcp # Nodeport services