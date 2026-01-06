#!/bin/bash

set -e

pkg=$1

sudo chown -R builder: /home/builder/src

echo "----------------------> Building package $pkg"
sudo chown -R alpm: /repo
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/${pkg}.git
cd ${pkg}
sed -i -E 's/^epoch=1$//gm;t' PKGBUILD
makepkg -s --nocheck --noconfirm
sudo mv *.pkg.tar.zst /repo
echo "----------------------> Updating repo $pkg"
cd /repo
find . -type f -iname '*.pkg.tar.zst' -print0 | xargs -0 sudo repo-add -n jarias.db.tar.zst
sudo rm *.old || true
echo "----------------------> Done updating repo $pkg"
echo "----------------------> Done building package $pkg"
