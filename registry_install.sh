#!/usr/bin/env bash

###############################################################################
# Author: Diego Souza
# 
# Description: This will create a local docker registry using the certificates 
# stored in ~/.certs
###############################################################################

set -e

echo "Deploying docker registry ..."

if [ ! -e "/home/$USER/.certs/registry.crt" -o ! -e "/home/$USER/.certs/registry.key" ]
then
  echo "You must create the certificates first. Did you execute registry_certificate_create.sh ?"
  exit 0
fi

if [ "$(docker ps | grep ngd_registry)" != "" ]
then
  echo "It looks like another registry is already present in this system. Use registry_uninstall.sh to remove it first."
  exit 0
fi


docker rm ngd_registry || true
docker run -d \
  --restart=always \
  --name ngd_registry \
  -v "$(echo ~/.certs)":/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
  -p 27443:443 \
  registry:2

docker ps | grep ngd_registry

echo "Done!"
