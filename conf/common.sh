#!/bin/bash

#
# Common config
#

SPOOL_DIR="spool"
TEMP_DIR="tmp"
BUILD_DIR="fakeroot"
PKG_DIR="pkgs"

#
# Common functions
#

myerr() { echo -e " [!] $1 ";   exit 1; }
myinfo() { echo -e " [+] $1 "; }
mywarn() { echo -e " [!] $1 "; }


pre_build_cleanup() {
  if [ -n "$BUILD_DIR" ]; then 
    rm -rf ./${BUILD_DIR}/*
    rm -rf ./fakeroot/.empty
  fi

  if [ -n "$TEMP_DIR" ]; then 
    rm -rf ./${TEMP_DIR}/*
  fi
  }