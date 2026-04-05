#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    libdecor \
    openal   \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

mkdir -p ./AppDir/bin
cd Prey2006/neo && mkdir build && cd build
cmake .. \
	-DCMAKE_BUILD_TYPE=Release \
	-DSDL3=ON
make -j$(nproc)
mv -v prey06 ../../../AppDir/bin
mv -v prey06ded ../../../AppDir/bin
