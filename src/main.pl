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

sub main
{
    my $scraper = Scraper->new;
    $scraper->work;
}

main;
