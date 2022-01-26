#!/bin/bash

declare -x SNYK_GIT_DIFF_UPSTREAM_REF=${SNYK_DIFF_UPSTREAM_REF:=origin\/main}

declare -x SNYK_GIT_DIFF_FILENAME="${SNYK_GIT_DIFF_FILENAME:=build.gradle.kts}"

read -ra snyk_args <<< "$*"

git fetch --no-tags --prune --depth=1 origin +refs/heads/*:refs/remotes/origin/*

# read -ra git_diff <<< $(git --no-pager diff ${SNYK_DIFF_UPSTREAM_REF} HEAD --name-only --diff-filter=d)
# echo "${git_diff[@]}"

response_code=0

for diff in $(git --no-pager diff ${SNYK_DIFF_UPSTREAM_REF} HEAD --name-only --diff-filter=d); do
    echo "checking ${diff}"
    if [ "${SNYK_GIT_DIFF_FILENAME}" == "$(basename ${diff})" ]; then
        # echo "snyk ${snyk_args[*]} --file=${diff}"
        snyk ${snyk_args[*]} --file=${diff}
        if [[ $? -gt > $response_code ]]; then
            response_code=$?
        fi
    fi
done

exit $response_code
