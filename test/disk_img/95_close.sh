#!/bin/bash -e

# マウントを解除

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# umount
bash "$_COM_DIR/unset.sh"