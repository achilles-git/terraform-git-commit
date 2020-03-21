#!/bin/sh

git config --global user.email "bot@goci.io"
git config --global user.name "goci.io"

mkdir -p ~/.ssh
ssh-keyscan ${4} >> ~/.ssh/known_hosts
