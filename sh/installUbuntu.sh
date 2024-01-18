#!/bin/bash

# ubuntuの手動インストール手順
# 参考サイト: https://gist.github.com/subrezon/9c04d10635ebbfb737816c5196c8ca24 , https://heywoodlh.io/minimal-ubuntu-install

_DISK=/dev/sdb
_EFI_PART=/dev/sdb1
_ROOT_PART=/dev/sdb2
_LINUX_KERNEL_VER=6.2.0-26
_LOCALHOST=localhost
_USER=user
_NETWORK_INTERFACE=enp1s0
_MOUNT_DIR=/mnt/tmp

# rootログイン
sudo su

# 必要なパッケージの追加
# arch-install-scriptsはarch-chrootをするためのパッケージ
add-apt-repository universe
apt update && apt install -y debootstrap arch-install-scripts

# ここでパーティション作成
# 1つめのパーティションはefi形式(512M,ef00)
# 2つめのパーティションはroot用(任意サイズ,8300)
gdisk "$_DISK"

# パーティション作成の反映
partprobe

# フォーマット
mkfs.vfat "$_EFI_PART"
mkfs.ext4 "$_ROOT_PART"

# マウント
mount "$_ROOT_PART" "$_MOUNT_DIR"
mkdir -p "$_MOUNT_DIR"/boot/efi
mount "$_EFI_PART" "$_MOUNT_DIR"/boot/efi

# debootstrapでの最小構成の設置
debootstrap jammy "$_MOUNT_DIR" http://de.archive.ubuntu.com/ubuntu

# fstabの設定
genfstab -U "$_MOUNT_DIR" >> "$_MOUNT_DIR"/etc/fstab

# aptのミラーサイト設定
{
  echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
  echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
  echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
} > "$_MOUNT_DIR"/etc/apt/sources.list

# カーネルのインストール
arch-chroot "$_MOUNT_DIR" << EOF
apt update
apt install -y --no-install-recommends linux-{image,headers}-"$_LINUX_KERNEL_VER"-generic linux-firmware initramfs-tools efibootmgr
apt install -y vim
exit
EOF

# 日付、地域、キーボードの設定
arch-chroot "$_MOUNT_DIR" << EOF
dpkg-reconfigure tzdata
dpkg-reconfigure locales
dpkg-reconfigure keyboard-configuration
exit
EOF

# localhostの指定
arch-chroot "$_MOUNT_DIR" << EOF
echo "$_LOCALHOST" > /etc/hostname
echo "127.0.0.1 $_LOCALHOST" >> /etc/hosts
exit
EOF

# root、ユーザーの設定
arch-chroot "$_MOUNT_DIR" << EOF
echo "root password"
passwd
echo "user: $_USER password"
useradd -mG sudo "$_USER"
passwd "$_USER"
exit
EOF

# ネットワーク設定
arch-chroot "$_MOUNT_DIR" << EOF
systemctl enable systemd-networkd
{
echo '[Match]'
echo "Name=$_NETWORK_INTERFACE"
echo ''
echo '[Network]'
echo 'DHCP=yes'
} > /etc/systemd/network/ethernet.network
exit
EOF

# いくつかのパッケージのインストール
arch-chroot "$_MOUNT_DIR" << EOF
apt-get install -y gnome-shell gnome-terminal gdm3 firefox
exit
EOF

# grub設定
arch-chroot "$_MOUNT_DIR" << EOF
apt install grub-efi-amd64
grub-install "$_DISK"
update-grub
exit
EOF

# umount
umount "$_MOUNT_DIR"/boot/efi
umount "$_MOUNT_DIR"

# root exit
exit

# fin
