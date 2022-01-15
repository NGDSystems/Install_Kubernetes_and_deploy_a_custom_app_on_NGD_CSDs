# Introduction

This repository demonstrates how to configure a CSD server with kubernetes. In particular, we are going to use Rancher's Kubernetes (K3S), as it consumes very few resources and works almost out of the box.

# What is Kubernetes and K3S?

[Kubernetes (K8S)](https://kubernetes.io/) is a cluster management solution initially developed by Google for its internal use. Its goal is to facilitate the management, orchestration, scalability, and deployment of cloud applications on a cluster of machines. At this moment, K8S is an open-source project which means that other parties may copy it, modify and create new versions. One of these versions is the [Rancher's Lightweight Kubernetes (K3S)](https://rancher.com/docs/k3s/latest/en/), powered by the company [Rancher](https://rancher.com/). K3S contains many of the functionalities included in K8S, but it was dried up to run in low power devices, like NGD Systems' CSDs.

Kubernetes is container-based, which means it integrates with the container manager in every node it coordinates and asks for containers to be started, stopped, restarted, coordinates how many of them are running, and so on. Kubernetes does this automatically following the user's configuration requests on how to deploy and scale its application.

# Installing k3s

Installing K3S is pretty straightforward. If you use the scripts in this repository, we basically need SSH access to every CSD node, the application curl and the repositopry source code. The following commands summarize the process.

Step 1. Make sure your user has access without password to every CSD in the server. For instance:

```shell
# Create a RSA key with no password if you don't have one
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""

# Register the public key on every nome, type the password to import the public key if requested
for NODE in `ngd_nodes.sh`
do
  ssh-copy-id -i ~/.ssh/id_rsa.pub $NODE
done
```

Step 2. Make sure every CSD has curl installed

```shell
for NODE in `ngd_nodes.sh`
do
  ssh $NODE sudo apt install curl -yq
done
```

Step 3. Get this project source

```shell
git clone https://github.com/NGDSystems/Install_Lightweight_Kubernetes_K3S_on_NGD_CSDs.git
cd Install_Lightweight_Kubernetes_K3S_on_NGD_CSDs
```

Step 4. Install K3S

```shell
# The command bellow must be executed in the host machine. It will install k3s master in the host and k3s-agent on every CSD node.
./k3s_install.sh
```

# Unintalling K3S

To uninstall K3S from the host and all CSD nodes, simply execute the following command.

```shell
./k3s_uninstall.sh
```

# Play With Your Cluster

If you feel like trying a simple app deployed with K3S now. Check out the tutorial on [How to build an image and deploy it on a local cluster of CSD devices](LOCALAPP.md). You will learn: (1) how to use docker buildx for cross-compiling the image and publish it on a private and public registry; (2) How to deploy a simple private docker registry on your host machine; and (3) how to control the deploy, deploying on all machines or just a certain type of nodes.
