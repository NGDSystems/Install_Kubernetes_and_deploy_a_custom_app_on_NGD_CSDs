#!/usr/bin/env bash

###############################################################################
# Author: Diego Souza
# 
# Description: Use this script to create a new certificate for a new local 
# docker registry.
###############################################################################

set -e

echo "Configuring subjectAltName ..."

#HOST_IP=`hostname -I | awk '{ print $1 }'`
HOST_IP="10.1.1.1"
TGT="subjectAltName = IP:${HOST_IP}"

if [ `sudo cat /etc/ssl/openssl.cnf | grep "$TGT"` = "" ]
then
  sudo cat /etc/ssl/openssl.cnf | sed "s/\[ v3_ca \]/[ v3_ca ]\n$TGT/" > ./tmp
  mv ./tmp /etc/ssl/openssl.cnf
else
  echo "This machine is already a subjectAltName"
fi

echo "Creating certificate at ~/.certs ..."
mkdir -p ~/.certs
sudo openssl req -newkey rsa:4096 -nodes -keyout ~/.certs/registry.key \
  -x509 -days 365 -out ~/.certs/registry.crt \
  -addext "subjectAltName = IP:$HOST_IP" \
  -subj '/C=BR/ST=RJ/L=Rio de Janeiro/O=Wespa/CN=host.local/'

echo "Done!"
