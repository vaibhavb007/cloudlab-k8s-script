#!/bin/bash -i

# Define Miniconda version and installation directory
MINICONDA_VERSION="latest"
INSTALL_DIR="$HOME/miniconda"

# Download Miniconda installer
curl -LO "https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"

# Run the installer
bash "Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" -b -p "$INSTALL_DIR"

# Add Miniconda to PATH
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
eval "$(tail -n +11 ~/.bashrc)"

# Clean up the installer
rm "Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"

echo "Miniconda installation completed."

# Activate the base environment
eval "$(tail -n +11 ~/.bashrc)"

# Initialize conda (add it to your shell's startup scripts)
conda init



# Verify that conda is working
conda --version
