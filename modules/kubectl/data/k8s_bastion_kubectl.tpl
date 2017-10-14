#!/bin/bash

CLUSTER_PUBLIC_ADDRESS=${CLUSTER_PUBLIC_ADDRESS}
TLS_DIR_PATH=${TLS_DIR_PATH}
CLUSTER_NAME=KUBERNETES_CLUSTER

# Download and Install Worker Binaries

wget -q --show-progress --https-only --timestamping https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl

# Install the kubectl binary

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Configure kubectl

kubectl config set-cluster $CLUSTER_NAME \\
  --certificate-authority=$TLS_DIR_PATH/ca.pem \\
  --embed-certs=true \\
  --server=https://$CLUSTER_PUBLIC_ADDRESS:6443

kubectl config set-credentials admin \\
  --client-certificate=$TLS_DIR_PATH/admin.pem \\
  --client-key=$TLS_DIR_PATH/admin-key.pem

kubectl config set-context $CLUSTER_NAME \\
  --cluster=$CLUSTER_NAME \\
  --user=admin

kubectl config use-context $CLUSTER_NAME