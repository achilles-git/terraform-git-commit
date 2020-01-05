#!/bin/sh

cd ${1}
branch=${2:-master}

git fetch
git rev-parse --verify ${branch}
branch_exit_code=$?
has_changes=$(git status -s)

if [[ ! -z ${has_changes} ]]; then
    git stash
fi

if [[ ${branch_exit_code} -eq 0 ]]; then
    git checkout ${branch}
    git pull origin ${branch} --rebase
else
    git checkout -b ${branch}
    git pull origin master --rebase
fi

if [[ ! -z ${has_changes} ]]; then
    git stash pop
fi
