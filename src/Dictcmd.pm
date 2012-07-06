#! /usr/bin/perl

package Dictcmd;

use strict;
use warnings;
use constant FILE => "../en-de.ISO-8859-1.vok";

use feature "say";

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
        search_word
);

our @EXPORT_OK = qw(
    _take_the_file
);

our $VERSION = 0.1;

sub _take_the_file
{
    my $fh;
    my @content_list = ();
    if ( -f  FILE ) {
        open $fh, "<", FILE || warn qq/cannot open file $!/;
        while ( <$fh> ) {
            chomp($_);
            push @content_list, $_;
        }
        close $fh || warn qq/cannot close file $!/;
    }
    else {
        warn qq/no translation file found ... switching to online mode/;
    }
    return \@content_list;
}

sub search_word($)
{
    my $regex = shift;
    my @results = ();
    my $ref_file_content = &_take_the_file;
    @results = grep {/$regex/i} @{$ref_file_content};
    return @results;
}

sub write_back($)
{
    my $ref_file_content = shift;
    my $fh;
    open $fh, ">", FILE || warn qq/cannot opne file $!/;
    print {$fh} $_ for (@{$ref_file_content});
    close $fh || warn qq/cannot close file $!/;
    return;
}

1;
__END__
