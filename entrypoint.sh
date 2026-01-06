#!/bin/bash

set -e

pkg=$1

sudo chown -R builder: /home/builder/src

sudo chown -R alpm: /repo
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/${pkg}.git
cd ${pkg}

echo "----------------------> Building package $pkg"
sed -i -E 's/^epoch=1$//gm;t' PKGBUILD
makepkg -s --nocheck --noconfirm
sudo mv *.pkg.tar.zst /repo
echo "----------------------> Done building package $pkg"

echo "----------------------> Updating repo $pkg"
find . -type f -iname '*.pkg.tar.zst' -print0 | xargs -0 sudo repo-add -n /repo/jarias.db.tar.zst
echo "----------------------> Done updating repo $pkg"
