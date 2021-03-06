#!/bin/bash

# Written by KJ Coop, https://kjcoop.com
# 2020-12-18

# Find sites that don't have valid global SSL certs. It can go off a list of
# domains in a file specified below, or domains can be itemized at the command
# line
file=~/domain_scripts/domains.txt

# @todo: Option to show only domain problems vs subdomain problems.
# @todo: This greps out lines from the file with a #. The idea is to be able to
#     comment out lines, but any URLs with an anchor tag will be a casualty.
# @todo: Error number padding to make a pretty line so it doesn't bump to the
#     right when it goes from 9 to 10.
# @todo: Refactor curl logic into a function.
# @todo: Round load times? printf %.2f $exe_time_tld -- see:
#     https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash#574474

num_prob=1
tmp_tld_file=/tmp/$0_tld_`date +%Y%m%d%H%M%s%N`
tmp_subd_file=/tmp/$0_subd_`date +%Y%m%d%H%M%s%N`

# If one or more arguments have been sent...
if [ "$#" -gt 0 ]; then

    # The first one should tell us whether or not domains have been itemized
    # Check if only one has been itemized. If so, display it differently.
    if [ "$#" -eq 1 ]; then
        is_one=1
    else
        is_one=0
    fi

    # Yes it's been itemized
    is_itemized=1

    # Use all the arguments as the list of domains
    list="$@"

    # Don't skip any
    skipped=''
else

    # If we're going for the hard-coded list of files, barf it not found.
    if [ ! -f $file ]; then
        echo ERROR: Hard-coded list of domain names not found
        echo Usage: $0 [list of domains] or hard-code a path listing domains.
        exit
    fi

    # Just because we didn't itemize doesn't mean there's more than one domain.
    is_one=`wc -l < $file`

    # Not itemized - to grab from list
    is_itemized=0

    # grep out hash signs so we can comment lines out. This also destroys the
    # ability to leave comments after domain names such as: 
    #     thing.tld # redirect to whatever.tld

    # Get all the items in the file
    list=`grep -v '#' $file`

    # keep track of what we skipped
    skipped=`grep '#' $file`

fi

for tld in $list; do

    # Check if the certificate is working.
    curl -Ls --head --request GET https://$tld -w %{time_total} > $tmp_tld_file
    exe_time_tld=`tail -n 1 $tmp_tld_file`

    if grep "200 OK" $tmp_tld_file > /dev/null; then

        # It is working. Check if it works for subdomains. -L switch tells it to
        # follow redirects.
        #    Above I changed the curl command to retain the execution time. It's
        # not being updated with this call, so this will always show the amount
        # of time it took to get to the no-subdomain site.
        curl -Ls --head --request GET "https://fake."$tld -w %{time_total} > $tmp_subd_file
        exe_time_subd=`tail -n 1 $tmp_subd_file`

        if grep "200 OK" $tmp_subd_file > /dev/null; then

            # Don't say anything about the domains that worked.
            echo -n '';

        # There was a problem with a subdomain
        else
            # There was only one site being checked - don't bother with the
            # number
            if [ "$is_one" -eq 1 ]; then
                echo Subdomain problem: https://fake.$tld "   (domain: $exe_time_tld, subdomain: $exe_time_subd)"

            # Checked multiple domain names.
            else
                echo $num_prob. Subdomain problem: https://fake.$tld "   ($exe_time_tld)"
            fi
            ((num_prob++))
        fi

    # Certificate is not working. It may also have a subdomain problem, but
    # don't bother running a second check once we've already highlighted it as
    # requiring attention.
    else

        # If we're just checking one site, then don't list the number.
        if [ "$is_one" -eq 1 ]; then
            echo Problem: https://$tld "   ($exe_time_tld)"

        # If we're listing multiple sites, do give a number
        else
            echo $num_prob. Problem: https://$tld "   ($exe_time_tld)"
        fi

        ((num_prob++))
    fi
done

if [ $num_prob -eq 1 ]; then
    echo 'All domains worked'
fi

if [ "$skipped" == '' ]; then
    echo -n ''
else
    echo Skipped: $skipped
fi

rm $tmp_tld_file $tmp_subd_file
