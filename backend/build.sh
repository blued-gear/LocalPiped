#!/bin/bash

set -e

if [[ $PWD != */backend ]]; then
  echo 'this script must be called from the directory containing it' >&2
  exit 1
fi

# update or clone repo
if [[ -d ./Piped-Backend ]]; then
  echo updating repo
  cd Piped-Backend
  git checkout -f master
  git reset --hard
  git pull
else
  echo cloning repo
  git clone --depth 1 https://github.com/TeamPiped/Piped-Backend.git
  cd Piped-Backend
fi

echo applying patches
for file in ../*.patch; do
  git apply "$file"
done

echo building jar
./gradlew shadowJar
cp ./build/libs/piped-1.0-all.jar ../backend.jar

cd ..
echo 'done'
