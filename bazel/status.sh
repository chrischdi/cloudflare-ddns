#!/bin/bash

set -euo pipefail

# git_tree_state prints the state of the git repository.
#
# It prints one of the following values:
#
#   VALUE                  MODIFIED FILES   UNTRACKED FILES
#   clean                  no               no
#   dirty                  yes              maybe
#   untracked-files-only   no               yes
#
function git_tree_state() {
  if [[ -n $(git status --porcelain=v1 --untracked-files=no) ]]; then
    echo "dirty"
  elif [[ -n $(git status --porcelain=v1 --untracked-files=normal) ]]; then
    echo "untracked-files-only"
  else
    echo "clean"
  fi
}

function git_version() {
  
  local VERSION_SUFFIX
  if [[ "$(git_tree_state)" == "dirty" ]]; then
    VERSION_SUFFIX="-dirty"
  fi

  local TAGGED_VERSION
  TAGGED_VERSION="$(git tag --points-at HEAD | grep '^v')"

  if [ $(echo ${TAGGED_VERSION} | wc -w) -gt 1 ]
  then
    printf "ERROR: There are more than one tags on HEAD:\n$TAGGED_VERSION\n"
    exit 1
  fi

  if [ "$TAGGED_VERSION" != "" ]; then
    echo "${TAGGED_VERSION}${VERSION_SUFFIX}"
    return
  fi

  echo "${git rev-parse HEAD}${VERSION_SUFFIX}"
}

echo "GIT_VERSION $(git_version)"
