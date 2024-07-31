## Docker

The installation process mostly refer to this [Docker installtion]

### Clone the repo

```sh
git clone https://github.com/PhungQuan-business/installation_documentation.git
```

```sh
# change to the docker directory
cd docker
```

### Install Docker using shell script

```sh
chmod +x docker.sh
./docker.sh
```

#### Change the default cgroup to from `cgroupfs` to `systemd`

```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```

#### Reload the daemon and docker

```sh
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### Turn of swap

```sh
# find the line with swap and comment it
sudo nano /etc/fstab

#reboot if necessary
sudo reboot
```

<!-- thêm phần cài đặt firewall cho master ở đây -->

### Confirm the installation

After rebooting the system should meet the following condition

- swap is `turned off`
- the default cgroup is `systemd`

#### Check if swap is turned off

```sh
# the line for swap should be all 0
free -h
```

#### Check if default cgroup is systemd

```sh
sudo docker info | grep -i cgroup
```

You should see something like this

> Cgroup Driver: systemd \
> Cgroup Version: 1

## Reference

[Docker installtion]: https://docs.docker.com/engine/install/ubuntu/
