#!/bin/bash
set -euo pipefail

SENTINEL='# >>> custom PS1 (cloudlab-k8s-script) >>>'
if ! grep -Fq "$SENTINEL" "$HOME/.bashrc"; then
    {
        echo ""
        echo "$SENTINEL"
        echo "PS1='\${CONDA_PROMPT_MODIFIER}\[\033[01;35m\]\D{%Y-%m-%d %H:%M:%S}\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \[\033[01;32m\]\\\$\[\033[00m\] '"
        echo '# <<< custom PS1 (cloudlab-k8s-script) <<<'
    } >> "$HOME/.bashrc"
fi
