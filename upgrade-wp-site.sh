#!/bin/bash

# Written by KJ Coop, https://kjcoop.com
# 2020-12-19

# @todo: Ask the user what they want to do.

# Grab locally-cached updated Wordpress source code.
usage=$0 [path to site above webroot] [whether or not this is a new site] [whether or not to initialize git]

# Where you stashed the latest version of WP
wp_profile='/home/kj/vhosts/wp-profile'

# This will be appended to $1 to create the full path to the webroot - we need
# both bits of information so it has a path to copy the existing webroot to.
webroot='/htdocs'
webroot_bkp=$webroot_`date +%Y%m%d`

# It may be a clone, it may not be. If it is, this directory will exist.
git_path=$full_path/.git

# Directory we're starting from. Useful because we may have to descent into a
# directory to git-ize it.
starting_pwd=`pwd`

# Path to the site in question - this should be something like /var/www/site;
# Don't include the webroot directory as we'll suffix the path with whatever you
# set $htdocs to.

# Need at least one argument (the path where the domain files live)
if [ "S1" == "" ]; then
    echo $usage
    exit;
else
    # Need to know where the webroot is and the level above it. This assumes a
    # consistency wherein misc files are kept at a level above the webroot, then
    # the files itself are therein. For example, my sites are at ~/vhosts/[tld]
    # with the webroot ~/vhosts/[tld]/htdocs/.
    site=$1
    full_path=$site/$webroot

    #
    if [ ! -d "$full_path" ]; then
        echo "The webroot you supplied ($full_path) doesn't seem to exist."
        echo $usage
        exit
    fi
fi

# If there's a second argument, that tells this script it's a new site; create
# these paths rather than alerting that they don't exist
if [ "$2" != "" ] && [ "$2" == "new" ]; then
    new=1

    if [ "$3" != ""] && [ "$3" == "1" ]; then
        git_init=1;
    else
        git_init=0
    fi
else
    new=0
fi

if [ "$new" == "1" ]; then
    mkdir -p $site $full_path
fi

if [ "$git_init" == "1" ]; then
    if [ -d "$git_path" ]; then
        echo ""
        echo "This is already a git clone."
        echo ""
    else
        echo ""
        echo "Not a git clone - creating one, per user request."
        git init
        echo ""
    fi
fi


# Copy htdocs (or whatever the user calls it). Just assuming it's not huge and
# there's space for a duplicate.
bkp_path=$site/$webroot_bkp

if [ -d bkp_path ]; then
    echo "Backup directory exits. To proceed, manually delete it then run this script"
    echo "again. The command to delete the promblematic directory is:"
    echo "    rm $bkp_path"
    exit
else
    cp -r $full_path $bkp_path
fi

# If it's a git clone, check in the before picture. I question the wisdom of
# adding everything and dumping it in whatever branch happens to be there.
# However, if this biffs it, then it's a good thing you have a duplicate in
# $bkp_path

# Could have a hard-coded value at the top for what branch to check-in to.

# Descend into the clone.
cd $full_path

if [ -d $git_path ]; then
    echo "Found git directory. Adding everything then checking in the current branch."
    echo "Not pushing to origin so you have a chance to look it over first."
    echo ""

    git add .
    git commit -m "Checking everthing in in anticipation of Wordpress update on "
    echo `date +%Y-%m-%d`
    # Don't push to origin in case adding/committing turned out to be not wise.
fi

# Come back to the path where we started
cd $starting_pwd

# The line it all comes down to: move the wordpress files into the webroot
cp -R $wp_profile/wordpress/* $full_path

# @todo: database backup? Those details surely differ by site, so that's hard
# to script.

# @todo: commit again?

echo "Kept the old webroot at $bkp_path. Take a look at how the newly"
echo "created or updated site looks. If you're happy, upgrade your plugins and"
echo "theme manually."
echo ""

echo "Once the upgrade is complete, you can delete the backup with:"
echo "    rm -r $bkp_path"
echo ''
