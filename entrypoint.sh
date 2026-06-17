#!/bin/bash

set -e

pkg=$1

sudo chown -R builder: /home/builder/src

echo "----------------------> Building package $pkg"
sudo chown -R alpm: /repo
sudo pacman -Syu --noconfirm
cd /pkgs/${pkg}
sed -E 's/^epoch=1$//gm;t' PKGBUILD >/tmp/PKGBUILD-$pkg
cp /tmp/PKGBUILD-$pkg PKGBUILD
rm /tmp/PKGBUILD-$pkg
makepkg -s --nocheck --noconfirm
echo "----------------------> Done building package $pkg"

echo "----------------------> Updating repo"
sudo mv *.pkg.tar.zst /repo
cd /repo
find . -type f -iname '*.pkg.tar.zst' -print0 | xargs -0 sudo repo-add -n jarias.db.tar.zst
sudo rm *.old || true
echo "----------------------> Done updating repo"
