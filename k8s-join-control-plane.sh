#!/bin/bash

function RemoteExec() {
    echo "$2"
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2";
}

RemoteExec $1 "sudo kubeadm reset -f"

RemoteExec $1 "kubeadm config images pull"

join="sudo kubeadm join $2:6443 --token $3 --discovery-token-ca-cert-hash sha256:$4 --control-plane --certificate-key $5"

RemoteExec $1 "$join"

RemoteExec $1 "sudo tc qdisc add dev eno1 root netem delay 0ms"