#!/bin/sh
# setup the minikube environment (don't need to run every time)
# minikube start
# eval $(minikube docker-env)

# delete old Deployment
kubectl --context=minikube delete --filename deployment.yml --ignore-not-found

# build the local binary
go fmt
go test . ./rules
CGO_ENABLED=0 GOOS=linux GOARCH=amd go build -a -installsuffix cgo

# build the docker container
docker rmi pod-reaper
docker build --file Dockerfile-minikube --tag=target/pod-reaper:latest .

# create a new deployment
kubectl --context=minikube apply --filename deployment.yml
