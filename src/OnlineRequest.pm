#! /usr/bin/perl

package OnlineRequest;

use strict;
use warnings;

use WWW::Dict::Leo::Org;

use feature "say";

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(
    parse_online_result
    online_request
);


sub online_request($)
{
    my $word = shift;
    my $leo = new WWW::Dict::Leo::Org(
        UserAgent => 'Mozilla/13.0.1',
        Language => 'de',
    );

    my @matches = $leo->translate($word);
    return \@matches;
}

# parse the data structure and returns a double colon seperatet list for
# output
sub parse_online_result($)
{
    my $ref = shift;
    my @result_list = ();
    for my $i ( 0 .. $#{$ref} ) {
        for my $j ( 0 .. $#{$ref->[$i]->{data}} ) {
            if ( $ref->[$i]->{data}->[$j]->{left} &&
                $ref->[$i]->{data}->[$j]->{left} ) {
                if ( $ref->[$i]->{data}->[$j]->{left} eq '' 
                    || $ref->[$i]->{data}->[$j]->{right} eq '' ) {
                    next;
                }
                else {
                    push @result_list, join ' : ', 
                    $ref->[$i]->{data}->[$j]->{left}, 
                    $ref->[$i]->{data}->[$j]->{right};
                }
            }
        }
    }
    return @result_list;
}


1;
__END__
