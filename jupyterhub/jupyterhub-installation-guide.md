## Jupyterhub

This guide refers to this [Jupyterhub installtion]
This installation using Jupyterhub chart version 3.3.7 which equavilent to Jupterhub App Version 4.1.5. Refering to this [document](https://hub.jupyter.org/helm-chart/) for releases.



### Add Jupyterhub to Helm repo

```sh
helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm repo update
```

### Create config file

```sh
#!/bin/bash
# config.yaml

singleuser:
  storage:
    type: static # có 2 mode: static và dynamic
    static:
      pvcName: hub-db-dir # tên của PVC
      subPath: "{username}"
    capacity: 50Gi
    homeMountPath: /home/aircadm # thư mục Jupyterhub sẽ lưu dữ liệu
hub:
  config:
    JupyterHub:
      admin_access: true
      authenticator_class: dummy
    KubeSpawner:
      start_timeout: 100
      http_timeout: 100
    Spawner:
      args: ['--allow-root'] # cấp quyền cho Spawner
  db:
    type: sqlite-pvc
    upgrade:
    pvc:
      annotations: {}
      selector: {}
      accessModes:
        - ReadWriteOnce
      storage: 50Gi
      subPath:
      storageClassName: hostpath

debug:
  enabled: true
```

### Tạo PV(Persistent Volume)

```sh
#!/bin/bash
#hub-db-dir-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: hub-db-dir-pv
  labels:
    type: local
spec:
  storageClassName: hostpath # trùng với storageClassName trong PV
  capacity:
    storage: 50Gi 
  volumeMode: Filesystem # Là lưu Local
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain  # Or Delete, Recycle based on your preference
  hostPath:
    path: /mnt/data/jupyterhub  # đảm bảo là đường dẫn này đều có trên tất cả các node
```

### Tạo storageClassName
```sh
#!/bin/bash
# storageClass.yaml

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: hostpath # trùng với PV
provisioner: kubernetes.io/no-provisioner # nôm na là ko dùng cloud service
volumeBindingMode: WaitForFirstConsumer
```

### Cấp quyền cho các thư mục

Ở trong file pv.yaml có một giá trị hostPath.path: /mnt/data/jupyterhub. Đây là vị trí mà database sẽ được thiết lập, vì thì cần cấp Ownership và Permission cho Jupterhub tới folder đó.
```sh
# Thực hiện trên tất cả các node 
sudo chown -R 1000:1000 /mnt/data/jupyterhub
sudo chmod -R 755 /mnt/data/jupyterhub
```

### Install Jupterhub
```sh
helm upgrade --cleanup-on-fail \
  --install jupyterhub-release jupyterhub/jupyterhub \
  --namespace jupyterhub \
  --create-namespace \
  --version=3.3.7 \
  --values config.yaml
```



## Reference

[Jupyterhub installtion]: https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html
