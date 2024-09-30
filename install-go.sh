#!/bin/bash -i


if [ -x "$(command -v go)" ]; then
    echo "Go has already been installed"
else
    # Specify the Go version to install
    GO_VERSION="1.23.1"

    # specify architecture type as amd64 or arm64
    ARCH=$(dpkg --print-architecture)

    # Download and install Go
    curl -LO "https://golang.org/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-${ARCH}.tar.gz"

    # Add Go binary directory to PATH
    export PATH=$PATH:/usr/local/go/bin
    sudo sh -c  "echo 'export PATH=\$PATH:/usr/local/go/bin' >> /etc/profile"

    # Verify Go installation
    go version

    echo "Go ${GO_VERSION} installation completed."
fi
