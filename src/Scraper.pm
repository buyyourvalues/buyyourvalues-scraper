#
#===============================================================================
#
#         FILE:  Scraper.pm
#
#  DESCRIPTION:  Get the most recent liquor license filing data from 
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  11/06/2010 11:53:59 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

package Scraper;

use base 'Object';
use DBI;
use FileHandle;
use LWP::Simple;

sub work
{
    my ($this, %args) = @_;

    my $file_name = $args{'file_name'};

    if (my $fh = FileHandle->new("< $file_name"))
    {
        my @results;
        for ($fh->getlines)
        {
            if (my $id_obj = $this->get_id($_))
            {
                if (my $url = $this->generate_url($id_obj))
                {
                    if (my $content = $this->get_url($url))
                    {
                        my $owner = $this->extract_name_and_premise($content);
						push @results, {
							id      => $id_obj->{id},
							type    => $id_obj->{type},
							address => $id_obj->{address},
							state   => $id_obj->{state},
							city    => $id_obj->{city},
							zip     => $id_obj->{zip},
							name    => $owner->{principal_name},
							premise => $id_obj->{premise},
						};
                    }
                }
            }
        }

        if (@results)
        {
            $this->write_data(@results);
        }
    }
    else
    {
        die "Problem reading $file_name: $!";
    }
}

sub write_data
{
    my ($this, @data) = @_;

    my $dbh = DBI->connect('dbi::SQLite:dbname=../data/data.db', '', '', {
            AutoCommit => 0,
            PrintError => 1,
        }
    );

    my $sth = $dbh->prepare('insert into results_from_website (id, name, premise, type, address, city, state, zip) values (?, ?, ?, ?, ?, ?, ?, ?, ?)');

    while (@data)
    {
        $sth->execute(
            $_->{id},
            $_->{name},
            $_->{premise},
            $_->{type},
            $_->{address},
            $_->{city},
            $_->{state},
            $_->{zip},
        );
    }

    $dbh->commit;
}

sub extract_name_and_premise
{
    my ($this, $content) = @_;

    my $principal_name;
    my $principal_found = 0;
    my $principal_name_found = 0;

    my $seen_principals_name = 0;

    for (split /\r\n|\n|\r/, $content)
    {
        if (m@Principal's Name:@i)
        {
            $principal_found = 1;
            next;
        }
        if ($principal_found and !$principal_name_found)
        {
            $principal_name .= $_;

            if (m@</td>@)
            {
                $principal_name_found = 1;
                last;
            }
        }
    }

    $principal_name = $this->cleanup($principal_name);

    return {
        principal_name => $principal_name,
    };
}

sub cleanup
{
    my ($this, $string) = @_;

    $string =~ s/\r\n|\n|\r/\n/g;

    $string =~ s@<[^>]+?>@@g;

    $string =~ s/^\s*//g;
    $string =~ s/\s*$//g;

    return $string;
}

sub generate_url
{
    my ($this, $id_obj) = @_;

    my $base_url = "http://www.trans.abc.state.ny.us/servlet/ApplicationServlet?pageName=com.ibm.nysla.data.publicquery.PublicQuerySuccessfulResultsPage&validated=true&serialNumber=$id_obj->{id}&licenseType=$id_obj->{type}";

    return $base_url;
}

sub get_id
{
    my ($this, $line) = @_;

    if ($line =~ /^\d{7}/)
    {
        my ($id, undef, $type, undef, $premise, $address, $city, $state, $zip) = split /\t+/, $line;

        $zip =~ s/\r\n|\n|\r//g;

	my $id_obj = {
		id      => $id,
		type    => $type,
		address => $address,
		city    => $city,
		state   => $state,
		zip     => $zip,
		premise => $premise,
	};

        return $id_obj;
    }
}

sub get_url
{
    my ($this, $url) = @_;

    my $content = get($url);

    return $content;
}

1;
