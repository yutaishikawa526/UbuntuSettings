#!/bin/bash

# パーティションの作成を実行する

sudo fdisk -l | grep -E '^(Disk /dev/|Disk model:)'

echo "パーティションを作成するディスクを選択してください。"
read -p ":" _PARTTION_DISK

# 1つめのパーティションはefi形式(512M,ef00)
# 2つめのパーティションはroot用(任意サイズ,8300)
sudo gdisk "$_PARTTION_DISK"

# パーティション作成の反映
sudo partprobe
