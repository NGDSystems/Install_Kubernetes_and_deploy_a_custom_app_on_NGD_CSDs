#!/bin/env bash

###############################################################################
# Author: Diego Souza
# 
# Description: This script removes the buildx container installed from 
# buildx_install.sh.
###############################################################################

set -e 

echo "Uninstalling buildx..."

docker rm -f buildx_buildkit_mybuilder0
rm -f ~/.docker/cli-plugins/docker-buildx

echo "Done!"
