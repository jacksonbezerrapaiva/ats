# Create configuration

Create configurations

# Requirements

- Minikube

## Configure Minikube

```sh
alias kubectl="minikube kubectl --"
minikube start
minikube addons enable metrics-server
minikube addons enable ingress
minikube dashboard
```

## Build image DockerHub

```sh
docker build -t ats .
docker tag ats jacksonbezerrapaiva/ats
docker login
docker push jacksonbezerrapaiva/nginx-image
```

## Create cluster

```sh
kubectl create namespace traffic
kubectl apply -f nginx.yaml
kubectl apply -f volume-traffic.yaml
kubectl apply -f pv-claim.yaml
kubectl apply -f traffic.yaml
```

## Add to /etc/hosts

```sh
IP traffic-volume-poc.com
IP traffic-nginx.com
```