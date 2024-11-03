#!/bin/bash

function RemoteExec() {
    echo $2
    ssh -oStrictHostKeyChecking=no -p 22 "$1" "$2";
}

# replace latency passed as a commandline argument
RemoteExec $1 "sudo tc qdisc replace dev eno1 root netem delay $2ms"