#!/bin/bash

function RemoteExec() {
    echo $2
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2";
}

function setupNode() {
    # check if the ssh folder exists
    RemoteExec $1 'if [ ! -d ~/cloudlab-k8s-script ];then git clone git@github.com:vaibhavb007/cloudlab-k8s-script.git; fi'
    RemoteExec $1 'cd ~/cloudlab-k8s-script && git pull'
    RemoteExec $1 'cd ~/cloudlab-k8s-script; bash ./local-install.sh'
}

python3 parser.py

# check if the hosts are part of the know hosts file
for host in $(cat hosts.txt); do
    ssh-keyscan -H $host >> ~/.ssh/known_hosts

    RemoteExec $host 'if [ ! -d ~/.ssh ];then mkdir ~/.ssh; fi'
    RemoteExec $host 'if [ ! -f ~/.ssh/id_ed25519 ]; then cp -r /proj/krios-PG0/.ssh/* ~/.ssh/; fi'
    RemoteExec $host 'eval "$(ssh-agent -s)"'
    RemoteExec $host 'ssh-add ~/.ssh/id_ed25519'

    setupNode $host

done