#!/bin/bash -e

# ubuntuのデスクトップ環境を構築する
# 「install_ubuntu」の手順の場合はCUIでしかアクセスできないため、
# ここでGUIの設定をする

# ---------- 未作成 ----------


# いくつかのパッケージインストール
sudo apt-get install -y vim git curl

## nvidia driverインストール
#1. `sudo apt-get --purge remove nvidia-*`で既存のnvidiaドライバーのアンインストール
#2. `sudo apt-get --purge remove cuda-*`で既存のCUDAのアンインストール
#3. `sudo add-apt-repository ppa:graphics-drivers/ppa`
#4. `sudo apt update`
#5. `sudo apt install -y nvidia-driver-535`でドライバーインストール(535は`ubuntu-drivers devices`で確認)
#6. `sudo reboot`再起動
#7. `nvidia-smi`で確認