#!/bin/bash

function RemoteExec() {
    echo $2
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2";
}


RemoteExec $1 $2

RemoteExec $1 "sudo tc qdisc add dev eno1 root netem delay 0ms"