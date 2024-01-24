#!/bin/bash -e

# バックアップを復元

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

echo '以下から選択してください。'
while read b_name ; do
    echo `basename "$b_name"`
done << END
`find "$_DIR/disk" -mindepth 1 -maxdepth 1 -type d`
END

read -p ":" b_name
backup_dir="$_DIR/disk/$b_name"

if [ ! -d "$backup_dir" ]; then
    echo 'バックアップが存在しません。'
    exit 1
fi

sudo rm -r "$backup_dir"
