# Install the operator on your cluster.
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml

# Download the custom resources necessary to configure Calico.
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O

# Create the manifest to install Calico.
kubectl create -f custom-resources.yaml


