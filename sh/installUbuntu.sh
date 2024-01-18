#!/bin/bash -e

# ubuntuの手動インストール手順
# 参考サイト: https://gist.github.com/subrezon/9c04d10635ebbfb737816c5196c8ca24 , https://heywoodlh.io/minimal-ubuntu-install

# 設定ファイルの読み込み
conf_file_path=$(cd $(dirname $0) ;cd ../; pwd)/conf/config.sh
if [ ! -e "$conf_file_path" ]; then
    echo "設定ファイルが指定されていません。"
    exit
fi
source "$conf_file_path"

# マウント
sudo mount "$_ROOT_PART" "$_MOUNT_DIR"
sudo mkdir -p "$_MOUNT_DIR"/boot/efi
sudo mount "$_EFI_PART" "$_MOUNT_DIR"/boot/efi

# -------------------------- 必要なパッケージの追加 --------------------------
if [ "$_START_NUMBER" -le 0 ]; then
    # arch-install-scriptsはarch-chrootをするためのパッケージ
    sudo add-apt-repository universe
    sudo apt update
    sudo apt install -y debootstrap arch-install-scripts
fi

# -------------------------- debootstrap周り --------------------------
if [ "$_START_NUMBER" -le 1 ]; then

# debootstrapでの最小構成の設置
sudo debootstrap --arch "$_DEBOOT_TARGET" --variant minbase jammy "$_MOUNT_DIR" http://de.archive.ubuntu.com/ubuntu

# fstabの設定
sudo genfstab -U "$_MOUNT_DIR" >> "$_MOUNT_DIR"/etc/fstab

# aptのミラーサイト設定
{
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
} | sudo sh -c "cat > $_MOUNT_DIR/etc/apt/sources.list"

fi

# -------------------------- カーネルのインストール --------------------------
if [ "$_START_NUMBER" -le 2 ]; then

sudo arch-chroot "$_MOUNT_DIR" << EOF
    apt update
    apt install -y --no-install-recommends \
        linux-{image,headers}-$_LINUX_KERNEL_VER-generic \
        linux-firmware initramfs-tools efibootmgr
    apt install -y ubuntu-minimal
    exit
EOF

fi

# -------------------------- パッケージのインストール --------------------------
if [ "$_START_NUMBER" -le 3 ]; 

sudo arch-chroot "$_MOUNT_DIR" << EOF
    apt install -y vim curl git
    exit
EOF

fi

# ------------------------------- その他設定 -------------------------------
if [ "$_START_NUMBER" -le 4 ]; then

# 日付、地域、キーボードの設定
sudo arch-chroot "$_MOUNT_DIR" << EOF
    timedatectl set-timezone Asia/Tokyo
    locale-gen en_US.UTF-8
    localectl set-locale en_US.UTF-8
    exit
EOF
sudo arch-chroot "$_MOUNT_DIR" dpkg-reconfigure keyboard-configuration

# localhostの指定
sudo arch-chroot "$_MOUNT_DIR" << EOF
    echo $_LOCALHOST > /etc/hostname
    echo "127.0.0.1 $_LOCALHOST" >> /etc/hosts
    exit
EOF

# root、ユーザーの設定
echo "root password"
sudo arch-chroot "$_MOUNT_DIR" passwd
echo "user: $_USER password"
sudo arch-chroot "$_MOUNT_DIR" useradd -mG sudo "$_USER"
sudo arch-chroot "$_MOUNT_DIR" passwd "$_USER"

# ネットワーク設定
sudo arch-chroot "$_MOUNT_DIR" << EOF
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

fi

# いくつかのパッケージのインストール←インストール後に実行するようにする
#sudo arch-chroot "$_MOUNT_DIR" << EOF
#apt-get install -y gnome-shell gnome-terminal gdm3 firefox
#exit
#EOF

# grub設定
if [ "$_START_NUMBER" -le 5 ]; then

sudo arch-chroot "$_MOUNT_DIR" << EOF
    apt install -y $_GRUB_EFI_PACKAGE
    grub-install $_DISK --target=$_GRUB_TARGET
    update-grub
    exit
EOF

fi

# umount
sudo umount "$_MOUNT_DIR"/boot/efi
sudo umount "$_MOUNT_DIR"

# fin
