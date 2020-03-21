#!/bin/sh
set -e

git config --global user.email "bot@goci.io"
git config --global user.name "$5"

mkdir -p ~/.ssh
ssh-keyscan ${1} >> ~/.ssh/known_hosts

branch=${3:-master}
export GIT_SSH_COMMAND="ssh -i ${4}"

if [[ ! -d ${2} ]]; then
    git clone ${1} ${2}
fi

if [[ "$branch" != "master" ]]; then
    cd ${2}
    git fetch

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
fi
