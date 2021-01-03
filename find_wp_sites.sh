#!/bin/bash

# Written by KJ Coop, https://kjcoop.com
# 2021-01-02

# Find all the Wordpress sites in a given directory.

base=/home/kj/vhosts
grep_out='dead' # @todo: Check if blank
plugin_suffix='wp-content/plugins'
theme_suffix='wp-content/themes'

for site in `find $base -name wp-admin | grep -v $grep_out`; do
    htdocs=`dirname $site`
    echo Site: $htdocs


    echo '    Plugins:'
    for plugin in `find $htdocs/$plugin_suffix -maxdepth 1 -type d`; do
        if [ $plugin != "$htdocs/$plugin_suffix" ]; then
            echo "     * `basename $plugin`"
        fi
    done


    echo '    Themes:'
    for theme in `find $htdocs/$theme_suffix -maxdepth 1 -type d`; do
        if [ $theme != "$htdocs/$theme_suffix" ]; then
            echo "     * `basename $theme`"
        fi
    done
    echo ""
done
