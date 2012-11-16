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
    take_the_file_content
    getting_offline_resource
);

# ABSTRACT: Ressource module for offline search

=attr filename:
 setting offline resource
=cut
our $filename = "$HOME/.dictcmd/".FILE;

=method take_the_file_content:
 Reads the whole file given by a filehandle
 line by line in a list.
 Returns a reference to that list.
=cut
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

=method getting_offline_ressource:
 open the offline resource
 returns the filehandle
=cut
sub getting_offline_resource
{
	my $handle = do { local *HANDLE };
	open $handle, '<', $filename or croak qq/could not open $!/;
	return $handle;
}

=method run:
 Given scalar parameter is a regular expression.
 The subroutine will search after that in special file.
 Returns a list with the results were the parameter matched.
=cut
sub run
{
    my $regex = shift;
    my $handle = getting_offline_resource();
    my $ref_file_content = take_the_file_content($handle);
    my @list= grep {/$regex/i} @{$ref_file_content};
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
