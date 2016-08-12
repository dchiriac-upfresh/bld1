#!/bin/bash 

source ./conf/common.sh
set -e

#
# Config
readonly LYNIS_VERSION='2.3.1'
readonly LYNIS_FILE_NAME="lynis-${LYNIS_VERSION}.tar.gz"
readonly DOWNLOAD_LOCATION="https://cisofy.com/files/${LYNIS_FILE_NAME}"
readonly MY_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly CURRENT_DIR=$(pwd)
readonly PREFIX="/opt"
readonly UNARCHIVE_DIR="${MY_DIR}/${BUILD_DIR}/${PREFIX}"
readonly ITERATION=1
readonly PACKAGE_SUFFIX="upfresh"
readonly ARCH="noarch"


#
# Pre cleanup
pre_build_cleanup

#
# Get the file
if [ ! -f "${SPOOL_DIR}/${LYNIS_FILE_NAME}" ]; then
curl -fLC - --retry 3 --retry-delay 3 -o "${SPOOL_DIR}/${LYNIS_FILE_NAME}" "${DOWNLOAD_LOCATION}"
fi

#
# Unarchive in the build dir
mkdir -p ${UNARCHIVE_DIR}
tar -C ${UNARCHIVE_DIR} -xzf ./${SPOOL_DIR}/${LYNIS_FILE_NAME}

#
# Build deb using fpm
 fpm \
    -s dir \
    -t rpm \
    --rpm-sign \
    --log debug \
    -C ${BUILD_DIR} \
    --after-install  ./internals/lynis/rpm/postinstall \
    --after-remove   ./internals/lynis/rpm/postrm \
    --provides    "lynis" \
    --maintainer  "systems@upfresh.com" \
    --name      "lynis" \
    -a  all \
    --version   "${LYNIS_VERSION}_${PACKAGE_SUFFIX}" \
    --iteration "${ITERATION}" \
    --package   "${PKG_DIR}/lynis-${LYNIS_VERSION}_${PACKAGE_SUFFIX}-${ITERATION}_${ARCH}.rpm" \
    --depends   "file, net-tools, binutils" \
    --description " \
Lynis is a security auditing tool for Unix and Linux based systems. 
It performs in-depth security scans, with almost no configuration.
" \
    ./

#
# put .empty back
touch ./fakeroot/.empty