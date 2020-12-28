#!/bin/bash

# Written by KJ Coop
# 12/27/20

# Find all Apache config files where a given TDL appears

base='/etc/apache2'

if [ "$1" == "" ]; then
    sites=`~/bin/find_vhosts.sh | uniq | sort`
else
    sites="$1"
fi

for tld in $sites; do
    files=`grep -lr $tld $base`

    if [ "$files" == "" ]; then
        echo $tld not found
    else
        echo $tld | tr [a-z] [A-Z]  # EXAMPLE.COM
        echo $files  | tr " " "\n"  # List of files on newlines; @todo prefix with *

        # Minimize wall of text
        echo ''
        echo ''
    fi

done



