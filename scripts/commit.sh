#!/bin/sh
set -e

cd ${1}
branch=${2:-master}

if [[ -z $(git status -s) ]]; then
    echo "No changes required on $branch."
    exit 0
fi

git add .
git commit -m "$3"

GIT_SSH_COMMAND="ssh -i ${4}" git push origin ${branch}
