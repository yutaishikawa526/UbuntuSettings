#!/bin/bash -e

# debootstrapの実行

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

check_func 'debootstrap' 'debootstrap'

# マウント
bash "$_DIR/com/mount.sh"

sudo debootstrap $_DEB_OPTION "$_DEB_NAME" "$_MNT_POINT" http://de.archive.ubuntu.com/ubuntu

function get_uuid_by_device(){
    device=$1
    uuid=`sudo blkid "$device" \
        | grep -E '^/dev/.*:( .*)? UUID=([^ ]+)( .*)?$' \
        | sed -r 's#.*^/dev/.*:( .*)? UUID=([^ ]+)( .*)?$#\2#g'`
    if [[ $uuid =~ ^.+$ ]]; then
        echo "$uuid"
    else
        echo '対象のデバイスがありません。'
        exit 1
    fi
}

# fstabの設定
{
    echo '# root'
    echo "UUID=`get_uuid_by_device "$_PAT_ROOT"` / ext4 rw,relatime 0 1"
    echo '# boot'
    echo "UUID=`get_uuid_by_device "$_PAT_BOOT"` /boot ext4 rw,relatime 0 2"
    echo '# efi'
    echo "UUID=`get_uuid_by_device "$_PAT_EFI"` /boot/efi vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 2"
    if [[ $_PAT_SWAP != '' ]]; then
        echo '# swap'
        echo "UUID=`get_uuid_by_device "$_PAT_SWAP"` swap swap defaults 0 0"
    fi
} | sudo sh -c "cat > $_MNT_POINT/etc/fstab"

# aptのミラーサイト設定
{
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
} | sudo sh -c "cat > $_MNT_POINT/etc/apt/sources.list"

# umount
bash "$_DIR/com/unset.sh"
