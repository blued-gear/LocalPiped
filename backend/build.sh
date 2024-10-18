#!/bin/bash

set -e

if [[ $PWD != */backend ]]; then
  echo 'this script must be called from the directory containing it' >&2
  exit 1
fi

# update or clone repo
if [[ "$BACKEND_KEEP_GIT" == "" ]]; then
  if [[ -d ./Piped-Backend ]]; then
    echo updating repo
    cd Piped-Backend
    git checkout -f origin/master
    git reset --hard
    git pull
  else
    echo cloning repo
    git clone --depth 1 https://github.com/TeamPiped/Piped-Backend.git
    cd Piped-Backend
  fi

  echo applying patches
  git config set --local core.autocrlf true
  for file in ../*.patch; do
    git apply "$file"
  done
else
  cd Piped-Backend
fi

echo building jar
./gradlew shadowJar
cp ./build/libs/piped-1.0-all.jar ../backend.jar

cd ..
echo 'done'
