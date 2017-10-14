#!/bin/bash
NODE_NAME="${NAME}"
NODE_IP="${IP}"

ETCD_VER=v3.2.8

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/coreos/etcd/releases/download
DOWNLOAD_URL=$GOOGLE_URL


rm -f /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd

curl -L $DOWNLOAD_URL/$ETCD_VER/etcd-$ETCD_VER-linux-amd64.tar.gz -o /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
tar xzvf /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1

/tmp/etcd/etcd --data-dir=data.etcd --name "$NODE_NAME" \
    --initial-advertise-peer-urls "http://$NODE_IP:2380" --listen-peer-urls "http://0.0.0.0:2380" \
    --advertise-client-urls "http://$NODE_IP:2379" --listen-client-urls "http://0.0.0.0:2379" \
    --initial-cluster "${CLUSTER}" \
    --initial-cluster-state "${CLUSTER_STATE}" --initial-cluster-token "${TOKEN}"