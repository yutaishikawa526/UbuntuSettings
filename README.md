# UbuntuSettings

## 概要
- ubuntuのデスクトップインストール手順からインストール後の諸々設定手順を記述

## ubuntuインストール ...未作成

### パーティション作成

### chroot

### ubuntuインストール

### grubインストール

### fstab設定

## 初回起動時 ...未作成
- nomodesetを指定

## vimインストール
- `sudo apt-get install vim`を実行

## nvidia driverインストール ...未作成

## grub設定
1. `/etc/default/grub`の`GRUB_DEFAULT`を`GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.2.0-26-generic"`に指定
2. `/etc/default/grub`の`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`を`GRUB_CMDLINE_LINUX_DEFAULT=""`に指定
3. `/etc/default/grub`の`GRUB_DISABLE_OS_PROBER`を`GRUB_DISABLE_OS_PROBER=false`に指定
4. `update-grub`を実行

## openVPN設定 ...未作成

## ssh設定 ...未作成

## 参考サイト
- [パーティション作成](https://qiita.com/kakkie/items/8f960f2dc5eb6e591d9d)
- [ドライバー確認](https://qiita.com/aosho235/items/079b37a9485041b96ed0)
- [nvidia driverインストール](https://qiita.com/porizou1/items/74d8264d6381ee2941bd)

