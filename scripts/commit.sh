#!/bin/bash
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
    mkdir -p ${repository_dir}
    git clone ${repository_remote} ${repository_dir} --depth 1 --single-branch
fi

cd ${repository_dir}
git fetch origin

set +e
git rev-parse --verify ${branch}
branch_exit_code=$?
git rev-parse --verify origin/${branch}
remote_branch_exit_code=$?
set -e

if [[ ${branch_exit_code} -eq 0 ]]; then
    git checkout ${branch}
else
    git checkout -b ${branch}
fi

if [[ ${remote_branch_exit_code} -eq 0 ]]; then
    git pull origin ${branch} --rebase -Xours
fi

if [[ -d ${repository_dir}/../changes ]]; then
    cp -R ${repository_dir}/../changes/* .

    if [[ -z $(git status -s) ]]; then
        echo "No changes required on $branch."
    else 
        git add .
        git commit -m "$commit_msg"
        git push origin ${branch}
    fi
else
    echo "No changes found in ${repository_dir}/../changes directory".
    echo "Nothing to commit."
fi
