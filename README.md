# UbuntuSettings

## 概要
- ubuntuのデスクトップインストール手順からインストール後の諸々設定手順を記述
- `apt upgrade`を実行すると、カーネルのABIバージョンが上がり、OSに合わなくて起動できなくなることがあった

## ubuntu手動インストールの場合
- [リドミ](/sh/install_ubuntu/README.md)を参考にしてubuntuをインストールする
- その後[デスクトップ設定](/sh/setupUbuntuDesktop.sh)を行ってGUIも適切に設定する

## 対話型自動インストールの場合
- liveメディアによるインストールの場合は[ここ](https://lang-ship.com/blog/work/usb-ssd-ubuntu/)を参考にしてインストールする
- 初回起動時
    1. nvidiaのドライバーが悪さをして画面描画がおかしくなることがある
    2. rub画面をshift連打で呼び出し、カーネルのコマンドに`nomodeset`を指定することで回避できる
    3. その後適切にnvidiaのドライバーをインストールする
- その後[デスクトップ設定](/sh/setupUbuntuDesktop.sh)を行う
- grubを一部修正
    1. `/etc/default/grub`の`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`を`GRUB_CMDLINE_LINUX_DEFAULT=""`に指定
    2. `update-grub`を実行

## nvidia driverのインストール
1. `sudo apt-get --purge remove nvidia-*`で既存のnvidiaドライバーのアンインストール
2. `sudo apt-get --purge remove cuda-*`で既存のCUDAのアンインストール
3. `sudo add-apt-repository ppa:graphics-drivers/ppa`でリポジトリ登録
4. `sudo apt update`
5. `sudo apt install -y nvidia-driver-535`でドライバーインストール(535は`ubuntu-drivers devices`でrecommendとなっているものにする)
6. `sudo reboot`再起動
7. `nvidia-smi`で確認

## openVPN設定
1. [サーバー側openVPN設定シェル](/sh/openVPNSettings.sh)の実行
2. `~/openVPNSettings`にクライアント用の認証情報が作成されるので、接続するクライアントPCに鍵を移行してopenVPN等で接続(参考サイトを参照)
3. 固定IPアドレスに設定
4. ルーターの設定で特定のポートを3で指定した固定IPにポート番号1194で転送するように設定
5. クライアント側の設定
    - サーバーのIPアドレスはサーバーのグローバルIPアドレスを指定
    - 同じくポート番号は4で設定した特定のポートを設定する
    - tap/tunはtunを指定
    - 圧縮は無効

## ssh設定
1. [sshサーバー設定シェル](/sh/sshServerSettings.sh)の実行
2. `~/sshSettings`にクライアント用の認証情報が作成されるので、接続するクライアントPCに鍵を移行してssh接続
    - [openVPN設定](#openVPN設定)を行ってから実行すること
    - クライアントの設定項目
        - ipアドレスは10.8.0.1(VPN接続中なら)
        - ポートは22

## 参考サイト
- [パーティション作成](https://qiita.com/kakkie/items/8f960f2dc5eb6e591d9d)
- [ドライバー確認](https://qiita.com/aosho235/items/079b37a9485041b96ed0)
- [nvidia driverインストール](https://qiita.com/porizou1/items/74d8264d6381ee2941bd)
- [client openVPN](https://www.openvpn.jp/download/)
- [Ubuntuの手動インストール](https://gist.github.com/subrezon/9c04d10635ebbfb737816c5196c8ca24)
- [debootstrapのvariantによる違いについて](https://zat.ifdef.jp/html/2008/04-03.html)
- [man debootstrapの情報が記載](https://linux.die.net/man/8/debootstrap)
- [aptのsource.listについて](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0677)
