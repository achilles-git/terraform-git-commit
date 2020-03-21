#!/bin/sh
set -e

cd ${1}
branch=${2:-master}

GIT_SSH_COMMAND="ssh -i ${3}" git fetch

set +e
git rev-parse --verify origin/${branch}
branch_exit_code=$?
set -e

if [[ ! -z $(git status -s) ]]; then
    git stash
fi

if [[ ${branch_exit_code} -eq 0 ]]; then
    git checkout ${branch}
    git pull origin ${branch} --rebase -Xours
else
    git checkout -b ${branch}
    git pull origin master --rebase -Xours
fi

if [[ ! -z $(git stash list) ]]; then
    git stash pop
fi
