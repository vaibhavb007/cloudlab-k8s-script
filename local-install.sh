#!/bin/bash



bash ./install-go.sh
bash ./install-docker.sh
bash ./miniconda-install.sh
bash ./install-containerd.sh
bash ./install-k8s.sh

sudo apt install -y screen htop

# Install Node.js (includes npm and npx)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs