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
echo "Making nightly build of Rednukem..."
echo "---------------------------------------------------------------"
REPO="https://github.com/FriskTheFallenHuman/Prey2006"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./Prey2006
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd Prey2006/neo
sed -i 's/(intptr_t)command.parmList/(void*)command.parmList/g' Prey/game_anim.cpp
cmake . \
	-DCMAKE_BUILD_TYPE=Release \
	-DSDL3=ON #-DCMAKE_CXX_FLAGS="-Wno-narrowing -Wno-error=conversion"
make -j$(nproc)
mv -v gamex86_64.so ../../AppDir/bin
mv -v ../output/linux/prey06 ../output/linux/prey06ded ../output/linux/base ../../AppDir/bin
