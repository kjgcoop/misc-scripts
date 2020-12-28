#!/bin/bash
# Create a new wordpress site

# todo: Create $1 if it DNE

pwd=`pwd`

if [ ! -d $1 ]; then
    echo Usage: $0 [dir to install into]
    exit
fi

cd $1
#mkdir htdocs # create later
mkdir logs

wget https://wordpress.org/latest.zip

# Off the top of my head I couldn't remember the syntax to get it to upzip to a 
# specific directory. Unzip it to wherever it wants and rename the directory.

unzip latest.zip
mv wordpress htdocs

cd htdocs
cp wp-config-sample.php wp-config.php

#echo "Your Wordpress site is ready for database credentials."

echo "Your Wordpress site is ready for human intervention."
echo "1. Create a database user and grant privileges"
echo "2. Alter the credentials in wp-config.php"
echo "3. Create a host for it in /etc/apache2/vhosts.d"
echo "4. Put the new fake domain (assuming it is fake) into /etc/hosts"
echo "5. Pull it up in the browser."

cd $pwd


