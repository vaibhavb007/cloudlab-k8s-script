#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <cloudlab-username> [manifest-path]"
    exit 1
fi

CLOUDLAB_USER="$1"
MANIFEST_FILE="${2:-manifest.xml}"

function RemoteExec() {
    echo "$2"
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2"
}

function setupNode() {
    RemoteExec "$1" 'if [ ! -d ~/cloudlab-k8s-script ];then git clone git@github.com:vaibhavb007/cloudlab-k8s-script.git; fi'
    RemoteExec "$1" 'cd ~/cloudlab-k8s-script && git pull'
    RemoteExec "$1" 'cd ~/cloudlab-k8s-script; bash ./local-install.sh'
}

python3 parser.py -u "$CLOUDLAB_USER" -m "$MANIFEST_FILE"

for entry in $(cat hosts.txt); do
    entry=${entry%$'\r'}
    [ -z "$entry" ] && continue
    host="${entry#*@}"
    ssh_target="$entry"

    ssh-keyscan -H "$host" >> ~/.ssh/known_hosts

    RemoteExec "$ssh_target" 'if [ ! -d ~/.ssh ];then mkdir ~/.ssh; fi'
    if ! ssh -oStrictHostKeyChecking=no -p 22 "$ssh_target" 'test -f ~/.ssh/id_ed25519'; then
        scp -o StrictHostKeyChecking=no -P 22 -r ~/.ssh "$ssh_target:~/"
    fi
    RemoteExec "$ssh_target" 'eval "$(ssh-agent -s)" && if ls ~/.ssh/id_* >/dev/null 2>&1; then for key in ~/.ssh/id_*; do if [ -f "$key" ] && [ "${key##*.}" != "pub" ]; then ssh-add "$key"; fi; done; fi'

    setupNode "$ssh_target"
done
