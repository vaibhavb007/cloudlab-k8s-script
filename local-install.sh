#!/bin/bash

sudo apt install -y screen

bash ./install-go.sh
bash ./install-docker.sh
bash ./miniconda-install.sh
bash ./install-containerd.sh
bash ./install-k8s.sh