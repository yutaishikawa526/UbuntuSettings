#!/bin/bash -e

# ユーザー設定

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# マウント
bash "$_COM_DIR/mount.sh"
bash "$_COM_DIR/sys_setup.sh"

# 日付、地域、キーボードの設定
sudo chroot "$_MNT_DIR" << EOF
    dpkg-reconfigure tzdata
    dpkg-reconfigure locales
    dpkg-reconfigure keyboard-configuration
    exit
EOF

# localhostの指定
sudo chroot "$_MNT_DIR" << EOF
    echo 'localhost' > /etc/hostname
    echo '127.0.0.1 localhost' >> /etc/hosts
    exit
EOF

# rootユーザーの設定
echo "----------- Enter root password -----------"
sudo chroot "$_MNT_DIR" passwd

# ネットワーク設定
sudo chroot "$_MNT_DIR" << EOF
    systemctl enable systemd-networkd
    {
        echo '[Match]'
        echo "Name=$_NW_INTERFACE"
        echo ''
        echo '[Network]'
        echo 'DHCP=yes'
    } > /etc/systemd/network/ethernet.network
    exit
EOF

# umount
bash "$_COM_DIR/unset.sh"