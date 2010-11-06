#
#===============================================================================
#
#         FILE:  Object.pm
#
#  DESCRIPTION:  Base object
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  11/06/2010 11:56:40 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

package Object;

sub new
{
    my ($proto, %args) = @_;
    my $class = ref $proto || $proto;
    my $this = {};
    bless $this, $class;
    $this->initialize(%args);
    return $this;
}

# Override
sub initialize
{
    my ($this, %args) = @_;
}

1;
