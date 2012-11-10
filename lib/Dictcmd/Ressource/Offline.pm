#! /usr/bin/perl

package Dictcmd::Ressource::Offline;

use strict;
use warnings;
use Carp;
use Env qw(HOME);
use constant FILE => "/en-de.ISO-8859-1.vok";

use feature "say";

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
    run
    search_word
    take_the_file_content
    getting_offline_resource
);

our $VERSION = 0.1;

# setting offline resource
our $filename;
$filename = "$HOME/.dictcmd/".FILE;

#
# Reads the whole file given by a filehandle
# line by line in a list.
# Returns a reference to that list.
#
sub take_the_file_content($)
{
	my $handle = shift;
	my @content_list = ();
	while ( <$handle> ) {
		chomp($_);
		push @content_list, $_;
	}
	close $handle;

	return \@content_list;
}

#
# open the offline resource
# returns the filehandle
#
sub getting_offline_resource
{
	my $handle = do { local *HANDLE };
	open $handle, '<', $filename or croak qq/could not open $!/;
	return $handle;
}

# 
# Given scalar parameter is a regular expression.
# The subroutine will search after that in a given file.
# Returns a list with the results were the parameter matched.
#
sub search_word($$)
{
    my $regex = shift;
    my $handle = shift;
    my @results = ();
    my $ref_file_content = take_the_file_content($handle);
    @results = grep {/$regex/i} @{$ref_file_content};
    return @results;
}

sub run
{
    my $regex = shift;
    my $handle = getting_offline_resource();
    my @list = search_word($regex, $handle);
    return @list;
}

1;
__END__
=pod

=head1 NAME

Dictcmd.pm Module for file handling 

=head1 DESCRIPTION

This module provides the file handling for the offline persistence. 
In generall it will read the File which is the offline dictionary and 
search after a regular expression in it. 

=cut
