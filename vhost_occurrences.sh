#!/bin/bash

# Written by KJ Coop
# 12/27/20

# Find all Apache config files where a given TDL appears

base='/etc/apache2'

sites=`~/bin/find_vhosts.sh | uniq | sort`

for tld in $sites; do
    files=`grep -lr $tld $base`

    echo $tld | tr [a-z] [A-Z]  # EXAMPLE.COM
    echo $files  | tr " " "\n"  # List of files on newlines; @todo prefix with *

    # Minimize wall of text
    echo ''
    echo ''
done



