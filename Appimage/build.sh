#!/bin/bash

set -e

if [[ $PWD != */Appimage ]]; then
    echo 'this script must be called from the directory containing it' >&2
    exit 1
fi

cd ..

if [[ "$NO_BUILD_DEP" == "" ]]; then
  printf '\n### building backend ###\n\n'
  cd ./backend
  ./build.sh
  cd ..

  printf '\n### building frontend ###\n\n'
  cd ./frontend
  ./build.sh
  cd ..

  printf '\n### building pipedproxy ###\n\n'
  cd ./pipedproxy
  ./build.sh
  cd ..
fi

cd Appimage

if [[ ! -d tools ]]; then
  printf '\n### downloading tools ###\n\n'
  mkdir tools
  cd tools

  wget -O appimagetool.AppImage https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
  chmod +x ./appimagetool.AppImage
  wget -O AppRun https://github.com/AppImage/AppImageKit/releases/download/13/AppRun-x86_64
  chmod +x AppRun

  cd ..
fi

if [[ "$NO_BUILD_FESERVER" == "" ]]; then
  printf '\n### building frontend-server ###\n\n'
  cd frontendserver
  ./gradlew shadowJar
  cd ..
fi

printf '\n### assembling files and building AppImage ###\n\n'
rm -rf ./build || true
mkdir build
INSTALL_DIR=./build/LocalPiped-x86_64.AppDir
cp -r ./LocalPiped.AppDir $INSTALL_DIR
cp ./tools/AppRun $INSTALL_DIR/
cp ../backend/backend.jar $INSTALL_DIR/usr/lib/
cp -r ../frontend/web $INSTALL_DIR/usr/share/frontend
cp ../pipedproxy/piped-proxy $INSTALL_DIR/usr/lib/
cp ./frontendserver/build/libs/frontendserver-1.0-all.jar $INSTALL_DIR/usr/lib/frontendserver.jar
cp ../config.properties $INSTALL_DIR/usr/

./tools/appimagetool.AppImage $INSTALL_DIR
