#!/usr/bin/env bash

set -e

declare -r WORKFLOW_ROOT="$(cd $(dirname $0); pwd)"
declare -r PROJECTS_ROOT="$WORKFLOW_ROOT/projects"

declare DIGDAG_URL="http://localhost:65432/"
for OPT in "$@"
do
    case "$OPT" in
        '-e'|'--endpoint' )
            DIGDAG_URL="$2"
            shift 2
            ;;
    esac
done

function lookup_projects() {
    (
        cd $PROJECTS_ROOT
        if [ "$PROJECTS" ]; then
            for p in $(echo ${PROJECTS[@]}); do
                ls | grep -x $p
            done
        else
            ls
        fi
    )
}

function push_project() {
    local -r target_project="$1"
    if [ -z "$target_project" ]; then
        echo "require target_project"
        exit 1
    fi
    local -r target_project_path="$PROJECTS_ROOT/$target_project"

    digdag push "$target_project" \
        --project "$target_project_path" \
        --endpoint "$DIGDAG_URL" 2>&1
}

for p in $(lookup_projects); do
    echo "========= [Project]: $p ========="
    push_project "${p}"
done
