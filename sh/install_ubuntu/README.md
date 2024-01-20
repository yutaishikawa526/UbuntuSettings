# 説明
- ubuntuの手動でのインストールするためのシェル
- インストール対象のデバイスとは別のデバイス上で実行する
- シェルの実行前に`./conf/conf-sample.sh`の記載に従い、適切に設定ファイルを作成する
- 最初にディスクを初期化する方法として`1a_create_disk.sh`と`1b_setup_partition.sh`の2種類ある

# 各シェルについて

- `1a_create_disk.sh`
ディスクイメージを直接作成する\
efi用とroot用の2種類作成し、それぞれ`./disk`ディレクトリに生成される\
`91a_~~`から`94a_~`によって、バックアップ&復元ができる

- `1b_setup_partition.sh`
物理ディスクに対してパーティションの作成を行う\
パーティション構成は`/`と`/boot/efi`をマウントする2つの構成となる

- `2_debootstrap.sh`
デブートストラップを実行する\
これにより、ubuntuの最小構成を作成する

- `kernek_install.sh`
カーネルとinitrdのインストールを行う

- `4_user_setting.sh`
ユーザー設定(時差やキーボード設定)を行う

- `5_grub_install.sh`
grubのインストールを行う
