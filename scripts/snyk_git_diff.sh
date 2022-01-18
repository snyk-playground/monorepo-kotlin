#!/bin/bash

declare -x SNYK_GIT_DIFF_UPSTREAM_REF=${SNYK_DIFF_UPSTREAM_REF:=origin\/master}

declare -x SNYK_GIT_DIFF_FILENAME="${SNYK_GIT_DIFF_FILENAME:=build.gradle}"

read -ra snyk_args <<< "$*"

read -ra git_diff <<< $(git --no-pager diff ${SNYK_DIFF_UPSTREAM_REF} --name-only --diff-filter=d )

for diffs in "${git_diff[@]}"; do
    if [ "${SNYK_GIT_DIFF_FILENAME}" == "$(basename ${diffs})" ]; then
        echo "snyk ${snyk_args[*]} --file=${diffs}"
    fi
done
