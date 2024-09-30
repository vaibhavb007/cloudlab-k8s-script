#!/bin/bash

NEW_VERSION="registry.k8s.io/pause:3.9"
# Function to update or add the sandbox image configuration
update_sandbox_image() {
    if grep -q '\[plugins."io.containerd.grpc.v1.cri"\]' "$CONFIG_FILE"; then
        # Section exists, update the sandbox_image line
        if grep -q 'sandbox_image = ' "$CONFIG_FILE"; then
            # sandbox_image line exists, update it
            sudo sed -i '/sandbox_image = /c\  sandbox_image = "'"$NEW_VERSION"'"' "$CONFIG_FILE"
        else
            # sandbox_image line doesn't exist, add it
            sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri"\]/a\  sandbox_image = "'"$NEW_VERSION"'"' "$CONFIG_FILE"
        fi
    else
        # Section doesn't exist, add it with the sandbox_image line
        echo -e '\n[plugins."io.containerd.grpc.v1.cri"]\n  sandbox_image = "'"$NEW_VERSION"'"' | sudo tee -a "$CONFIG_FILE" > /dev/null
    fi
}

echo "Installing ContainerD"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable"

sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y containerd.io
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
update_sandbox_image
sudo systemctl restart containerd
sudo systemctl enable containerd