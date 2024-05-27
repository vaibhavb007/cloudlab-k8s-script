#!/bin/bash -i

# Specify the Go version to install
GO_VERSION="1.22.2"

# Download and install Go
curl -LO "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"

# Add Go binary directory to PATH
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc

tail -n +10 ~/.bashrc | bash


# Verify Go installation
go version

# Clean up downloaded archive
rm "go${GO_VERSION}.linux-amd64.tar.gz"

echo "Go ${GO_VERSION} installation completed."
