#!/bin/bash
# Determine if wp-admin is publically accessible. I keep a rule in .htaccess
# that forbids wp-admin. When I want to use it, I go comment that line out, 
# which allows Apache to serve it. If there's a hash on that line, it means the
# part that hides it is commented out -> it's public -> problem

if [ `grep wp-admin vhosts/kjcoop.com/htdocs/.htaccess |grep '#'|wc -l` -eq 1 ] ; then
    echo "wp-admin in kjcoop.com is public."
fi

