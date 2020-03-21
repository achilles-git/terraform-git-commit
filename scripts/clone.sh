#!/bin/sh

GIT_SSH_COMMAND="ssh -i ${3}" git clone ${1} ${2}
