#!/bin/bash

function RemoteExec() {
    echo $2
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2";
}

cmd = "sudo kubeadm join 128.110.217.234:6443 --token u4nstj.tvvmgt9r4qepo29a --discovery-token-ca-cert-hash sha256:902954712e791a0135f914c3696804e1f010e5430e06086a5029ba950105d091 --control-plane --certificate-key $2"

RemoteExec $1 cmd

RemoteExec $1 "sudo tc qdisc add dev eno1 root netem delay 0ms"