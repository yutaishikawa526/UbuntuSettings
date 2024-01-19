#!/bin/bash -e

_DIR=$(cd $(dirname $0) ; pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

if [ ! -d "$_LIST_DIR" ];then
    mkdir -p "$_LIST_DIR"
fi

# 4つで25分かかった...
declare -A list=(
    ['minbase']='--variant minbase'
    ['minbase_arch']='--variant minbase --arch amd64'
    ['normal']=''
    ['normal_arch']='--arch amd64'
)

for one in "${!list[@]}"; do
    fl="$one"
    arch_variant="${list[${one}]}"
    ded="$_LIST_DIR/$fl"
    if [ ! -d "$ded" ];then
        mkdir -p "$ded"
        cmd="sudo debootstrap $arch_variant jammy $ded http://de.archive.ubuntu.com/ubuntu"
        eval "$cmd"
        {
            echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
            echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
            echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
        } | sudo sh -c "cat > $ded/etc/apt/sources.list"
        sudo cp /etc/resolv.conf $ded/etc/resolv.conf
    fi
done
