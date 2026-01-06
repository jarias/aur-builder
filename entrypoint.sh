#!/bin/bash

set -e

pkg=$1

sudo chown -R builder: /home/builder/src

sudo chown -R alpm: /repo
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/${pkg}.git
cd ${pkg}
source PKGBUILD
fullpkgname=${pkgname}-${pkgver}-${pkgrel}

if [ ! -f /repo/${fullpkgname}-x86_64.pkg.tar.zst ]; then
  echo "----------------------> Building package $fullpkgname"
  sed -i -E 's/^epoch=1$//gm;t' PKGBUILD
  makepkg -s --nocheck --noconfirm
  sudo mv ${fullpkgname}-x86_64.pkg.tar.zst /repo
  echo "----------------------> Done building package $fullpkgname"

  echo "----------------------> Updating repo $fullpkgname"
  cd /repo
  sudo repo-add -n jarias.db.tar.zst ${fullpkgname}-x86_64.pkg.tar.zst
  echo "----------------------> Done updating repo $fullpkgname"
fi
