#!/usr/bin/env bash

###############################################################################
# Author: Diego Souza
# 
# Description: Use this script to download and instantiate a local image to 
# build containers for multiple architectures.
###############################################################################

set -e 

echo "Installing buildx..."

export DOCKER_BUILDKIT=1

sudo apt update
sudo apt-get install -y qemu-user-static

docker build --platform=local -o . git://github.com/docker/buildx
mkdir -p ~/.docker/cli-plugins && mv buildx ~/.docker/cli-plugins/docker-buildx

echo "Done!"
