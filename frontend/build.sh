#!/bin/bash

set -e

if [[ $PWD != */frontend ]]; then
  echo 'this script must be called from the directory containing it' >&2
  exit 1
fi

# update or clone repo
if [[ "$KEEP_GIT" == "" ]]; then
  if [[ -d ./Piped ]]; then
    echo updating repo
    cd Piped
    git checkout -f origin/master
    git reset --hard
    git pull
  else
    echo cloning repo
    git clone --depth 1 https://github.com/TeamPiped/Piped.git
    cd Piped
  fi

  echo applying patches
  for file in ../*.patch; do
    git apply "$file"
  done
else
  cd Piped
fi

echo building site

if [[ -d ../web ]]; then
  rm -rf ../web
fi
mkdir ../web

pnpm install
pnpm build
cp -r ./dist/* ../web/

cd ..
echo 'done'
