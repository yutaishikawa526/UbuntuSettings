#!/bin/bash -e

TEST=`{
cat << EOF
1111
2222
EOF
}`
echo "start:$TEST:end"

TEST=`{
    echo '3333'
    echo '4444'
}`
echo "start:$TEST:end"

TEST=`
cat << EOF
5555
6666
EOF
`
echo "start:$TEST:end"