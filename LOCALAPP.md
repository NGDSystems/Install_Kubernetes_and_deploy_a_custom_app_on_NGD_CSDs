# How to build an image and deploy it on a local cluster of CSD devices

## What is docker buildx?

A CSD cluster is heterogeneous by nature, i.e, there are a mix of machines architectures available. The CSDs are based on aarch64 and the host is tipically x86_64. In order to deploy applications that run in the host and inside the CSDs, we need to cross-compile our images for both architectures. Docker buildx helps us by providing a preconfigured environment and commands that does exactly this. Using its interface, we tell docker the architectures we need to build and where they must be deployed, everything else is taken care automatically.

## What is a Private Registry?

A registry is a place we put and organize our images separated primarily by tags and different architectures. A public registry, like hub.docker.com, is a great way of sharing the images we have created, allowing others to reuse our images or extend them. A private registry is similar to a public registry but we may host it inside a private network, allowing only a subset of users to access its images. There are other benefits as well, like higher download and upload speeds when retrieving images on a local network nodes or updating the image with a new nightly build. This is specially usefull during the development of new images or to keep sensitive projects in-house.

## Configure Docker's BuildX

## Create a Private Docker Registry

## Cross-compile a local image and publish it in Docker Hub

## Cross-compile a local image and publish it in the private docker registry

docker build -t

## Deploy in Hybrid Mode

## Deploy in CSD mode

## Deploy in Host mode
