#!/bin/bash

## messages
source lib/message.sh

## variables
source conf/conf.tmp
source conf/urls.conf


file="darchos.tar.gz"
# Transfer Darchos files to sdcard/darchos/
cd ${TMP_PATH}
if [[ ! -f "${TMP_PATH}/$file" ]]; then
    echo "Downloading DArchOS resources:"
    curl -Lo "$file" "${DARCHOS_REPO}/archive/${BRANCH}.tar.gz"
    if [[ $? -ne 0 ]]; then
        echo "Error while downloading DArchOS resources from ${DARCHOS_REPO}/archive/${BRANCH}.tar.gz"
        exit 1
    fi
else
    echo "File $file already found in ${TMP_PATH}, so will use it as DArchOS resources"
fi

init "Extracting DArchOS resources"
tar --extract --preserve-permissions --file "$file" --directory "${MOUNT_POINT:?}/root/" &> /dev/null
if [[ -z $NO_REMOVE_DARCHOS ]]; then
    init "Removing $file"
    rm --force "$file"
    end
fi
mv --force "${MOUNT_POINT:?}/root/darchos-${BRANCH}" "${MOUNT_POINT:?}/root/darchos"
chown --recursive root "${MOUNT_POINT:?}/root/darchos"
sync
end

echo "DArchOS resources ready"