#!/bin/sh
set -e

branch=${4:-master}
ssh_key_file=${5}
repository_dir=${3}
git_user=${6:-git}
git_host=${1:-github.com}
git_remote=${2}

git config --global user.email "bot@goci.io"
git config --global user.name "$git_user"

mkdir -p ~/.ssh
ssh-keyscan ${git_host} >> ~/.ssh/known_hosts

export GIT_SSH_COMMAND="ssh -i ${ssh_key_file}"

if [[ ! -d ${repository_dir} ]]; then
    git clone ${git_remote} ${repository_dir}
fi

if [[ "$branch" != "master" ]]; then
    cd ${repository_dir}
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
