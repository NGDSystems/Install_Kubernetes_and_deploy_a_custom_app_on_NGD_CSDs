#!/usr/bin/env bash

if [ `whoami` = 'root' ]
then
  echo "WARN: Running as root"
fi

echo -n "master: "
sudo service k3s status | grep -E '(active|inactive)'

NODES=`./ngd_nodes.sh`

for node in $NODES
do
  echo -n "${node}: "
  ssh $node sudo service k3s-agent status | grep -E '(active|inactive)'
done

