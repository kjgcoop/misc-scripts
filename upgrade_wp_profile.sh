#!/bin/bash

# Written by KJ Coop, https://kjcoop.com
# 2020-12-19

# Keep a stash of the latest version of Wordpress. There will be a second
# script to update sites using the information in this directory. This way we
# don't have to use a bunch of WP's bandwidth.

# @todo: Grab wp_profile from config file so the install script doesn't have to
#     hard-code to the same name. It will still have to hard-code to the same
#     include path.
wp_profile='/home/kj/vhosts/wp-profile'

if  [ $wp_profile ! -d ]; then
    mkdir -p $wp_profile;
fi

# Get base Wordpress
wget https://wordpress.org/latest.zip -p $wp_profile
unzip $wp_profile/latest.zip
rm $wp_profile/latest.zip

# Cookie Notice plugin doesn't have a consistent name, so we can't (easily)
# script its download and installation. Tell the user to go grab it:

echo "This script can't download the latest Cookie Notice plugin. Go grab it from:"
echo https://wordpress.org/plugins/cookie-notice/
echo ''

echo "To install: "
echo "    1. Download from the URL above."
echo "    2. Unzip it with:"
echo "         unzip [whatever]"
echo "    3. Put the new directory in wordpress/wp-content/plugins/"

echo ''

echo "You may want to go grab the latest version of your theme too. You'll have to"
echo "find the URL yourself (I don't know what theme you're using), but once you"
echo "have it, the installation instructions are much the same as the above, but"
echo "it goes to wordpress/wp-content/theme"

echo '';

# @todo: send an email.
