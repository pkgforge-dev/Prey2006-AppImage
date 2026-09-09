#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake  \
    openal \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Prey2006..."
echo "---------------------------------------------------------------"
REPO="https://github.com/FriskTheFallenHuman/Prey2006"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./Prey2006
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd Prey2006/neo
if [ "$ARCH" = "aarch64" ]; then
	sed -i 's/(int)(const char\*)command.parmList/(int)(intptr_t)(const char*)command.parmList/g' Prey/game_anim.cpp
fi
cmake . \
	-DCMAKE_BUILD_TYPE=Release \
	-DSDL3=ON
make -j$(nproc)
mv -v game*.so ../output/linux/prey06 ../output/linux/prey06ded ../output/linux/base ../../AppDir/bin
