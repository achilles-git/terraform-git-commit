#!/bin/sh
set -e

rm -rf ${2}
GIT_SSH_COMMAND="ssh -i ${3}" git clone ${1} ${2}
