#!/usr/bin/env bash

NODES=`ngd_nodes.sh`

uninstall_node()
{
  node=$1
  echo "Removing worker agent at $node"
  ssh $node sudo k3s-agent-uninstall.sh 
}

uninstall_host()
{
  echo "Removing master at localhost"
  sudo k3s-uninstall.sh
}

sudo echo "Starting uninstall..."

for node in $NODES
do
  uninstall_node $node &
done

uninstall_host &

wait
echo "Done!"

