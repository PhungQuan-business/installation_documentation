# Add the Calico helm repo
helm repo add projectcalico https://docs.tigera.io/calico/charts

# Create the tigera-operator namespace.
kubectl create namespace tigera-operator

# Install the Tigera Calico operator and custom resource definitions using the Helm chart
helm install calico projectcalico/tigera-operator --version v3.28.0 --namespace tigera-operator