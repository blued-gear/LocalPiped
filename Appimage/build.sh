#!/bin/bash

set -e

if [[ $PWD != */Appimage ]]; then
    echo 'this script must be called from the directory containing it' >&2
    exit 1
fi

cd ..

printf '\n### building backend ###\n\n'
cd ./backend
./build.sh
cd ..

printf '\n### building frontend ###\n\n'
cd ./frontend
./build.sh
cd ..

cd Appimage

if [[ ! -d tools ]]; then
  printf '\n### downloading tools ###\n\n'
  mkdir tools
  cd tools

  BINSERVE_VERSION='binserve-v0.2.0-x86_64-unknown-linux-gnu'
  wget -vv -O binserve.tar.gz https://github.com/mufeedvh/binserve/releases/download/v0.2.0/$BINSERVE_VERSION.tar.gz
  tar -zxv --strip-components=1 -f binserve.tar.gz "$BINSERVE_VERSION/binserve"
  rm binserve.tar.gz

  wget -O appimagetool.AppImage https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
  chmod +x ./appimagetool.AppImage
  wget -O AppRun https://github.com/AppImage/AppImageKit/releases/download/13/AppRun-x86_64
  chmod +x AppRun

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
cp ./tools/binserve $INSTALL_DIR/usr/bin/
cp ../config.properties $INSTALL_DIR/usr/

./tools/appimagetool.AppImage $INSTALL_DIR
