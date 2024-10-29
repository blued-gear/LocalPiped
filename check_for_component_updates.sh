#!/bin/bash

set -e

UPDATE_FOUND=0

echo "checking for component updates"
while read -r line; do
  if [[ "$line" == "" ]]; then continue; fi
  read -r repo commitHash branch <<< "$line"
  read -r -a remoteCommit <<< "$(git ls-remote "$repo" "$branch")"

  echo "$repo" : "${remoteCommit[0]}" ?= "$commitHash"
  if [[ "${remoteCommit[0]}" != "$commitHash" ]]; then
    echo "found update for" "$repo"
    UPDATE_FOUND=1

    export REPO="$repo"
    export UPDATED_LINE="$repo ${remoteCommit[0]} $branch"
    if [[ ! -f component_versions.txt.new ]]; then cp component_versions.txt component_versions.txt.new; fi
    awk -i inplace '{if($1 == ENVIRON["REPO"]){ print ENVIRON["UPDATED_LINE"] } else { print $0 }}' component_versions.txt.new
  fi
done < component_versions.txt

if [[ $UPDATE_FOUND == 0 ]]; then
  echo "no updates found"
  exit 0
else
  mv component_versions.txt.new component_versions.txt
  exit 10
fi
