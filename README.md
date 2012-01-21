# Problem

My linode server runs a wordpress blog and occasionally the disk IO & CPU usage shoot through the roof.

# Cause

As far as I can tell there are 2 causes of this problems

* Servers crawling my site with no timeout between crawl requests
* Servers trying to post spammy comments to wp-comments

# Solution

My reactive solution is to run this script which looks through my access logs for certain time periods and counts how many times each ip hits my server.  Each ip is looked up to see if it's a legitmate crawler or if it should be banned by my server 



# Run the script

    ruby access_ip_analyzer.rb -h                                                                                 
    Options:                                                                                                                                                                              --date-pattern, -d <s>:   02/Oct/2011:15:05 OR 02/Oct
     --top-occurances, -t <i>:   Show top occurances (default: 20)
                --verbose, -v:   Be really verbose
                   --nick, -n:   Only search NicksTrafficTricks access log
               --comments, -c:   Only search for hits to wp-comments
                  --block, -b:   Group IP's by block i.e. 123.123.123.*
                   --help, -h:   Show this message
 
