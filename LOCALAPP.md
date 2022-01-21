# How to build an image and deploy it on a local cluster of CSD devices

This short tutorial will cover how to deploy a simple web service using a previously configured K3S cluster and a host with a few CSDs. We will use docker buildx for cross-compiling the custom image and a private docker registry to hold the images built.

## What is docker buildx?

A CSD cluster is heterogeneous by nature, i.e, there are a mix of machines architectures available. The CSDs are based on aarch64 and the host is tipically x86_64. In order to deploy applications that run in the host and inside the CSDs, we need to cross-compile our images for both architectures. Docker buildx helps us by providing a preconfigured environment and commands that does exactly this. Using its interface, we tell docker the architectures we need to build and where they must be deployed, everything else is taken care automatically.

## What is a Private Registry?

A registry is a place we put and organize our images separated primarily by tags and different architectures. A public registry, like hub.docker.com, is a great way of sharing the images we have created, allowing others to reuse our images or extend them. A private registry is similar to a public registry but we may host it inside a private network, allowing only a subset of users to access its images. There are other benefits as well, like higher download and upload speeds when retrieving images on a local network nodes or updating the image with a new nightly build. This is specially usefull during the development of new images or to keep sensitive projects in-house.

## Configure Docker's BuildX

This repository provides a few scripts for speeding up the creation and management of a simple buildx image. They are the scripts prefixed with "buildx\_".

To install buildx on your host machine, just execute the following. It will ask to install the dependency qemu-user-static and the command docker-buildx.

```shell
./buildx_install.sh
```

Whenever you restart your machine, use ./buildx_refresh.sh to bring back the buildx container on the host.

```shell
./buildx_refresh.sh
```

You should be able to cross-compile container images now using the command docker-buildx. However, to upload them into our private repository we will also need to register a custom certificate inside the buildx image. Keep following the tutorial to get to this point.

If you ever need to uninstall the buildx image and the cli command, use buildx_uninstall.sh.

```shell
./buildx_uninstall.sh
```

## Create a Private Docker Registry

To creating a private local registry we just need to start a container with the right image and, then, we are ready to upload our images. However, there is an important configuration in the registry image we must set. K3S requires a trusted registry to pull images from. Because of this, we need create a custom certificate and register this certificate on every K3S agents, the host and inside the docker buildx container.

To create the certificate in the folder ~/.certs, we will use the command registry_certificate_create.sh, as bellow.

```shell
./registry_certificate_create.sh
```

The certificate needs to be created just once, but we may need to deploy it multiple times. For instance, if we reecreate the buildx container or if we add more CSDs to the server. To deploy the certificate we created above in the host, the CSDs and the buildx container, use the command registry_certificate_deploy.sh.

```shell
./registry_certificate_deploy.sh
```

Now that the relevant agents are recognizing this new certificate we will configure a registry using it. The command registry_install.sh encapsulates this logic.

```shell
./registry_install.sh
```

The registry should be up and running now. We should be able to upload our cross-compiled images to it using buildx, and both docker and k3s should recognize it.

If we ever need to uninstall it, we can use the command registry_uninstall.sh, as bellow.

```shell
./registry_uninstall.sh
```

## Cross-compile a local image and publish it in the private docker registry

```shell
# Enter the folder holding the Dockerfile
cd example

# Build the image for amd64(x86_64) and arm64(aarch64) and push it to our repository
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --push=true \
    -t 10.1.1.1:27443/ngd-k3s-example:0.0.1 .
```

## Cross-compile a local image and publish it in Docker Hub

To upload the images to Docker Hub, you just need to replace the private registry with your username.

```shell
# Enter the folder holding the Dockerfile
cd src

# Build the image for amd64(x86_64) and arm64(aarch64) and push it to our repository
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --push=true \
    -t <DOCKER_HUB_USERNAME>/ngd-k3s-example:0.0.1 .
```

Sometimes the push fails due to network issues, try again if this is the case.

## Deploy in Hybrid, CSD or Host Mode

We describe three deploy modes but, in fact, you could deploy in as any mode you want. We describe these as it is a common setup to evaluate the performance of a host only machine, a CSD only cluster and a mixed cluster (hybrid). Select one of the commands below depending on the type of deploy you wish to test.

```shell
# To deploy in hybrid mode, use a daemonset with no filter
sudo kubectl apply -f daemonset_hybrid.yaml

# To deploy only to CSDs, use a daemonset with a filter selecting only arm64 devices
sudo kubectl apply -f daemonset_csd.yaml

# Create the daemonset with a filter excluding all arm64 devices
sudo kubectl apply -f daemonset_host.yaml
```

You can check if they were pulled and whether they are fine with the following commands

```shell
# List all daemonsets
sudo kubectl get daemonset -o wide

# List all Pods
sudo kubectl get pods -o wide

# Summary of Pod status
sudo kubectl describe pod <POD_NAME>

# Read the Pod log (stdout)
sudo kubectl logs <POD_NAME>

# Run something inside the pods
sudo kubectl exec -it <POD_NAME> -- bash
sudo kubectl exec -it <POD_NAME> -- hostname -i
sudo kubectl exec -it <POD_NAME> -- top
sudo kubectl exec -it <POD_NAME> -- ls /app
sudo kubectl exec -it <POD_NAME> -- cat /etc/hosts
```

After selecting the desired daemonset, create a service to expose the pods that it created.

```shell
# Create the service
sudo kubectl apply -f service.yaml
```

If all pods are already running and the service is initialized, we may test the service performing a simple request to our server. We will use a simple for and curl to call it multiple times.

```shell
for i in `seq 10`
do
  echo "$i"
  curl localhost:5000
done
```

Depending on the configuration you chose, some requests will be responded from CSDs and some will be responded by the host. There are many other configurations we can set using kubernetes configuration files. For instance, an interesting one to investigate further could be how to load balance the requests.

## Undeploy in Hybrid, CSD or Host Mode

To remove the daemonset, we call the same command as before, replacing apply for remove.

```shell
# To undeploy the hybrid mode
sudo kubectl delete -f daemonset_hybrid.yaml

# To undeploy the CSD mode
sudo kubectl delete -f daemonset_csd.yaml

# To undeploy the host mode
sudo kubectl delete -f daemonset_host.yaml
```

And undeploy the service

```shell
sudo kubectl delete -f service.yaml
```
