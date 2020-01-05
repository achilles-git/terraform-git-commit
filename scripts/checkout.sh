#!/bin/sh

cd ${1}
branch=${2:-master}

git fetch
git rev-parse --verify ${branch}
branch_exit_code=$?

git stash

if [[ ${branch_exit_code} -eq 0 ]]; then
    git checkout ${branch}
    git pull origin ${branch} --rebase
else
    git checkout -b ${branch}
    git pull origin master --rebase
fi

git stash pop
