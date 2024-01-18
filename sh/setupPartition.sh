#!/bin/bash -e

# パーティションの作成を実行する

sudo fdisk -l | grep -E '^(Disk /dev/|Disk model:)'

echo "パーティションを作成するディスクを選択してください。"
read -p ":" _PARTTION_DISK

# 1つめのパーティションはefi形式(512M,ef00)
# 2つめのパーティションはroot用(任意サイズ,8300)
sudo gdisk "$_PARTTION_DISK"

# パーティション作成の反映
sudo partprobe

echo 'パーティションの候補'
sudo fdisk -l | grep "$_PARTTION_DISK"

echo "efiパーティションを選択してください。"
read -p ":" _EFI_DISK

echo "rootパーティションを選択してください。"
read -p ":" _ROOT_DISK

# パーティションのフォーマット
sudo mkfs.vfat "$_EFI_DISK"
sudo mkfs.ext4 "$_ROOT_DISK"
