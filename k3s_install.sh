#!/usr/bin/env bash

NODES=$(ngd_nodes.sh)

if [ -e '/etc/systemd/system/k3s.service' ]
then
  echo "It seams like k3s is already installed, use k3s_uninstall.sh to remove it first"
  exit 0
fi

echo "Installing master at localhost..."
curl -sfL https://get.k3s.io | sh -s - server \
    --cluster-cidr 10.235.32.0/19 \
    --service-cidr 10.235.0.0/19 \
    --resolv-conf /run/systemd/resolve/resolv.conf \
    --kubelet-arg="image-gc-high-threshold=95" \
    --tls-san host \
    --bind-address 0.0.0.0 \
    --docker

echo "Configuring workers agents..."
TOKEN=`sudo cat /var/lib/rancher/k3s/server/node-token`
ADDRESS=`hostname -I | awk '{ print $1 }'`

for node in $NODES
do
  ssh $node "curl -sfL https://get.k3s.io | sudo sh -s - agent --docker --server https://${ADDRESS}:6443 --token ${TOKEN}" --kubelet-arg="image-gc-high-threshold=95" &
done

wait
echo "Done!"
