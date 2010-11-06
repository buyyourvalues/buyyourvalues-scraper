#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  main.pl
#
#        USAGE:  ./main.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  11/06/2010 11:57:36 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Scraper;

sub usage
{
    print << "FINI";
Usage:

    $0 [datafile]

FINI
}

sub main
{
    if (my $file_name = $ARGV[0])
    {
        my $scraper = Scraper->new;
        $scraper->work(
            file_name => $file_name,
        );
    }
    else
    {
        usage;
    }

}

main;
