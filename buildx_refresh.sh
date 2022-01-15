#!/bin/env bash

###############################################################################
# Author: Diego Souza
# 
# Description: Use this script to refresh the buildx image. Sometimes it stops
# recognizing architectures after reboot.
###############################################################################

set -e 

echo "Refreshing buildx image"

docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
docker buildx create --use --name mybuilder
docker buildx inspect --bootstrap
docker update --restart=always buildx_buildkit_mybuilder0

echo "Done!"
