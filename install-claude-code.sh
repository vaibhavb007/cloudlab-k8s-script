#!/bin/bash
set -euo pipefail

CLAUDE_BIN_DIR="$HOME/.local/bin"
export PATH="$CLAUDE_BIN_DIR:$PATH"

if [ -x "$(command -v claude)" ]; then
    echo "Claude Code has already been installed"
else
    # Native installer (no Node.js required); installs to ~/.local/bin/claude
    curl -fsSL https://claude.ai/install.sh | bash
fi

if ! grep -Fq "$CLAUDE_BIN_DIR" "$HOME/.bashrc"; then
    echo "export PATH=\"$CLAUDE_BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
fi

claude --version

echo "Claude Code installation completed. Run 'claude' on the node to log in."
