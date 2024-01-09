# UbuntuSettings

## 概要
- ubuntuのデスクトップインストール手順からインストール後の諸々設定手順を記述

## ubuntuインストール ...未作成

### パーティション作成

### chroot

### ubuntuインストール

### grubインストール

### fstab設定

## 初回起動時
- 初回起動時はgpuドライバーの問題で画面描画がおかしくなる
- grub画面をshift連打で呼び出し、カーネルのコマンドに`nomodeset`を指定する

## いくつかのパッケージインストール
- `sudo apt-get install vim git`でvim,gitをインストール

## nvidia driverインストール
1. `sudo apt-get --purge remove nvidia-*`で既存のnvidiaドライバーのアンインストール
2. `sudo apt-get --purge remove cuda-*`で既存のCUDAのアンインストール
3. `sudo add-apt-repository ppa:graphics-drivers/ppa`
4. `sudo apt update`
5. `sudo apt install nvidia-driver-535`でドライバーインストール(535は`ubuntu-drivers devices`で確認)
6. `sudo reboot`再起動
7. `nvidia-smi`で確認

## grub設定
1. `/etc/default/grub`の`GRUB_DEFAULT`を`GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.2.0-26-generic"`に指定
2. `/etc/default/grub`の`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`を`GRUB_CMDLINE_LINUX_DEFAULT=""`に指定
3. `/etc/default/grub`の`GRUB_DISABLE_OS_PROBER`を`GRUB_DISABLE_OS_PROBER=false`に指定
4. `update-grub`を実行

## openVPN設定
1. [サーバー側openVPN設定シェル](/sh/openVPNSettings.sh)の実行
2. `~/openVPNSettings`にクライアント用の認証情報が作成されるので、接続するクライアントPCに鍵を移行してopenVPN等で接続(参考サイトを参照)

## ssh設定 ...未作成

## 参考サイト
- [パーティション作成](https://qiita.com/kakkie/items/8f960f2dc5eb6e591d9d)
- [ドライバー確認](https://qiita.com/aosho235/items/079b37a9485041b96ed0)
- [nvidia driverインストール](https://qiita.com/porizou1/items/74d8264d6381ee2941bd)
- [client openVPN](https://www.openvpn.jp/download/)
