#!/bin/bash

# Written by KJ Coop, https://kjcoop.com
# 12/27/20

# Find all the domain names listed in .conf files in /etc/apache.
# @todo: switch for names vs aliases vs both

vhosts='/etc/apache2/vhosts.d'
senabled='/etc/apache2/sites-enabled'


# Apache and NGINX tend to store their virtual hosts in one of two paths.
if [ -d $vhosts ]; then
    base=$vhosts
elif [ -d $senabled ]; then
    base=$senabled
else
    echo Couldn\'t find $vhosts or $senabled - not sure where else to look.
    exit
fi

# If you stash the irrelevant/old config files in a subdirectory
exclude_paths='' # CSV directory list, no spaces: ignore,old,uninteresting

# Doesn't do any kind of checking to see if the given paths are valid.
if [ $exclude_paths=='' ]; then
    exclude_dir=''
else
    exclude_dir=$exclude_paths
fi

# egrep: Find all lines containing ServerAlias or ServerName

# grep -v: Silence commented lines
    # @todo: Limit search to opening #; will also silence lines wherein a
    # comment is after a name, as in "ServerAlias site.tld #this is my favorite"

# sed expression to remove ServerName and ServerAlias: https://stackoverflow.com/questions/7814205/remove-first-word-in-text-stream

# sed expression to remove leading "*." in case of wildcard aliases.

# uniq: Some sites will have two config files per site (one for HTTPS, the other
# for regular HTTP).

# awk: remove leading whitespace: https://unix.stackexchange.com/questions/102008/how-do-i-trim-leading-and-trailing-whitespace-from-each-line-of-some-output

# tr: Spaces to newlines: https://unix.stackexchange.com/questions/105569/bash-replace-space-with-new-line

# The uniq and sort commands at the end don't seem to be sticking. I assume it's
# due to tr's behavior.
# @todo Fix
egrep -rh "ServerAlias|ServerName" $base/*.conf $exclude_dir | grep -v '#' | sed -e 's/ServerName //g' | sed -e 's/ServerAlias //g' | sed -e 's/*.//g' | awk '{$1=$1};1' | tr " " "\n" | uniq | sort



