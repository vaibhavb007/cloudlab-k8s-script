#!/bin/bash -i

set -euo pipefail

MINICONDA_VERSION="latest"
INSTALL_DIR="$HOME/miniconda"
ARCH=$(uname -m)
INSTALLER="Miniconda3-${MINICONDA_VERSION}-Linux-${ARCH}.sh"

curl -sSLO "https://repo.anaconda.com/miniconda/${INSTALLER}"

INSTALL_ARGS=(-b -p "$INSTALL_DIR")
if [ -d "$INSTALL_DIR" ]; then
    echo "Existing Miniconda installation detected at $INSTALL_DIR. Updating in place."
    INSTALL_ARGS=(-b -u -p "$INSTALL_DIR")
fi

bash "$INSTALLER" "${INSTALL_ARGS[@]}"
rm "$INSTALLER"

if ! grep -Fq "$INSTALL_DIR/bin" "$HOME/.bashrc"; then
    echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
fi

export PATH="$INSTALL_DIR/bin:$PATH"

if [ ! -x "$INSTALL_DIR/bin/conda" ]; then
    echo "Miniconda install did not produce a conda binary at $INSTALL_DIR/bin/conda" >&2
    exit 1
fi

"$INSTALL_DIR/bin/conda" init bash >/dev/null 2>&1 || true
"$INSTALL_DIR/bin/conda" --version

echo "Miniconda installation completed."
