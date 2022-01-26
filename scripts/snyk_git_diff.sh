#!/bin/bash

declare -x SNYK_GIT_DIFF_UPSTREAM_REF=${SNYK_DIFF_UPSTREAM_REF:=origin\/main}

declare -x SNYK_GIT_DIFF_FILENAME="${SNYK_GIT_DIFF_FILENAME:=build.gradle.kts}"

read -ra snyk_args <<< "$*"

git fetch --no-tags --prune --depth=1 origin +refs/heads/*:refs/remotes/origin/*

#read -ra git_diff <<< $(git --no-pager diff ${SNYK_DIFF_UPSTREAM_REF} HEAD --name-only --diff-filter=d)

#echo "${git_diff[@]}"

for diff in $(git --no-pager diff ${SNYK_DIFF_UPSTREAM_REF} HEAD --name-only --diff-filter=d); do
    echo "checking ${diff}"
    if [ "${SNYK_GIT_DIFF_FILENAME}" == "$(basename ${diffs})" ]; then
        echo "snyk ${snyk_args[*]} --file=${diffs}"
    fi
done
