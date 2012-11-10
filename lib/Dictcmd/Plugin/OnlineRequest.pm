#! /usr/bin/perl

package Dictcmd::Plugin::OnlineRequest;

use strict;
use warnings;

use WWW::Dict::Leo::Org;

use feature "say";

require Exporter;

our @ISA = qw(Exporter);

our $VERSION = 0.1;

our @EXPORT = qw(
    run
    parse_online_result
    online_request
);

#
# Getting the searched word as parameter
# and executes the search after on the leo.org
# dictionary service.
# Returns a reference on an complex datastructure.
#
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

#
# Getting a reference on the complex datastructure which
# contains the search results.
# Parse the relevant data in an colon seperated list.
# These list will be returned.
#
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

sub run
{
    shift;
    my $word = shift;
    my $ref = online_request($word);
    my @list = parse_online_result($ref);
    return @list;
}


1;
__END__

=pod

=head1 NAME

OnlineRequest.pm Module for handling the online search.

=head2 DESCRIPTION

This module is the interface to the WWW it will search after a word
in the online database of the dictionary service L<www.leo.org>
The result of the search is a complex data structure which will be parsed in
an ':' colon separeted list to simplify futher operations on it.

=cut

