#!/bin/bash

echo "shutting down any running k8s instance"
sudo kubeadm reset -f
sudo rm -rf $HOME/.kube
sleep 15

echo "Initializing Kubernetes"
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sleep 60

bash install-calico.sh

