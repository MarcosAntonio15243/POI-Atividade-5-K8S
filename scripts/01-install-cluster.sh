#!/bin/bash
set -e
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f kubectl minikube-linux-amd64

sg docker -c "minikube start --driver=docker --cpus=4 --memory=6144"
