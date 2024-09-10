#!/bin/bash

# check if the ssh folder exists
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi

cp -r /proj/krios-PG0/.ssh/* ~/.ssh/

# add ssh key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519