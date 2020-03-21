#!/bin/sh

mkdir -p ~/.ssh
ssh-keyscan ${4} >> ~/.ssh/known_hosts

GIT_SSH_COMMAND="ssh -i ${3}" git clone ${1} ${2}
