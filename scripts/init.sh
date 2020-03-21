#!/bin/sh

git config --global user.email "bot@goci.io"
git config --global user.name "$1"

mkdir -p ~/.ssh
ssh-keyscan ${2} >> ~/.ssh/known_hosts
