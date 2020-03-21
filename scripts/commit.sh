#!/bin/sh
set -e

git_host=${1:-github.com}
git_user=${2:-git}
ssh_key_file=${3}
repository_remote=${4}
repository_dir=${5}
branch=${6:-master}
commit_msg=${7}

git config --global user.email "bot@goci.io"
git config --global user.name "$git_user"

mkdir -p ~/.ssh
ssh-keyscan ${git_host} >> ~/.ssh/known_hosts

export GIT_SSH_COMMAND="ssh -i ${ssh_key_file}"

if [[ ! -d ${repository_dir} ]]; then
    git clone ${repository_remote} ${repository_dir}
    git checkout ${branch}
else
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

if [[ -z $(git status -s) ]]; then
    echo "No changes required on $branch."
    exit 0
fi

cp -R ../changes/ ./

git add .
git commit -m "$commit_msg"
git push origin ${branch}
