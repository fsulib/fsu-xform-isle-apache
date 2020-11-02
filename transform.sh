#!/usr/bin/env bash

# The object here is to clone the isle-apache repo, copy the contents of 
# transformations over it and patch the files that require patching.

[[ $CLONE_BASE ]] || CLONE_BASE=./isle-apache
OWD="${PWD}"
git clone https://github.com/Islandora-Collaboration-Group/isle-apache.git "${CLONE_BASE}"
cp -r transformations/* "${CLONE_BASE}"
cd "${CLONE_BASE}"
patch < Dockerfile.patch
cd rootfs/etc/confd/conf.d
patch < apache-site-conf.toml.patch
patch < apache-sql.toml.patch
cd ../templates/apache
patch < site_template.conf.tpl.patch
cd ../../../cont-init.d
patch < 01-confd-site-enable.patch
cd "${OWD}/${CLONE_BASE}"
find . -type f -iname \*.patch -delete
cd "${OWD}"
exit 0
