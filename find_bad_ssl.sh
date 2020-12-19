#!/bin/bash

# Find sites that don't have valid global SSL certs. It can go off a list of
# domains in a file specified below, or domains can be itemized at the command
# line
file=domains.txt

# @todo: Suffix domain line with request time. Some domains on the same meachine
#     seem to take forever. This wouldn't say why, it would just be interesting.
# @todo: Only list tlds/subdomains
# @todo: Comment out domains in list
# @todo: greps out lines from the file with a #. The idea is to be able to
#     comment out lines, but any URLs with an anchor tag will be a casualty. If
#     I go to the trouble of checking if it's the first character, then I can
#     say "$whatever skipped"
# @todo: Error number padding to make a pretty line so it doesn't bump to the
#     right when it goes from 9 to 10.

num_prob=1

if [ "$#" -gt 0 ]; then
    if [ "$#" -eq 1 ]; then
        is_one=1
    else
        is_one=0
    fi

    is_itemized=1
    list="$@"
else
    is_itemized=0
    # grep out hash signs so we can comment lines out.
    list=`grep -v '#' $file`
    is_one=`wc -l < $file`
fi

for tld in $list; do

    # Check if the certificate is working.
    if curl -Ls --head --request GET https://$tld | grep "200 OK" > /dev/null; then

        # It is - check if it works for subdomains. -L switch tells it to follow
        # redirects.
        if curl -Ls --head --request GET "https://fake."$tld | grep "200 OK" > /dev/null; then

        # Don't say anything about the domains that worked.
        echo -n '';

        # There was a problem with a subdomain
        else
            # There was only one site being checked - don't bother with the
            # number
            if [ "$is_one" -eq 1 ]; then
                echo Subdomain problem: https://fake.$tld

            # Checked multiple domain names.
            else
                echo $num_prob. Subdomain problem: https://fake.$tld
            fi
            ((num_prob))
        fi

    # Certificate is not working. It may also have a subdomain problem, but
    # don't bother running a second check once we've already highlighted it as
    # requiring attention.
    else

        # If we're just checking one site, then don't list the number.
        if [ "$is_one" -eq 1 ]; then
            echo Problem: https://$tld

        # If we're listing multiple sites, do give a number
        else
            echo $num_prob. Problem: https://$tld
        fi

        ((num_prob++))
    fi
done

if [ $num_prob -eq 1 ]; then
    echo 'All domains worked'
fi
