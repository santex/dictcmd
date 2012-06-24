#! /usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use OnlineRequest;
use Dictcmd;

use feature "say";

sub online_mode;
sub offline_mode;
sub print_results(@);
sub usage;

my ($de_en, $en_de, $offline, $online, $help) = 0;
GetOptions(
    'de|de2en' => \$de_en,
    'en|en2de' => \$en_de,
    'offline' => \$offline,
    'online' => \$online,
    'help' => \$help,
);

my $term = 0;
my @result_list = ();
our $pattern = qr(^.*?$term.*?$);
if ( $ARGV[0] ) {
    $term = $ARGV[0];
}
else { &usage; }

# language decision 
if ( $de_en ) {
    # german word is given
    $pattern = qr(^\w+? : \w*?$term\w*?$);
}
elsif ( $en_de ) {
    # english word is given
    $pattern = qr(^\w*?$term\w*? : \w+?$);
}
else { &usage; }

my @resulst_list = ();

# Mode decision
if ( $offline ) {
    no OnlineRequest;
    @result_list = &offline_mode;
}
elsif ( $online ) {
    no Dictcmd;
    @result_list = &online_mode;
}
else {
    my @tmp_1 = ();
    my @tmp_2 = ();
    @tmp_1 = &offline_mode;
    @tmp_2 = &online_mode;
    @result_list = (@tmp_1, @tmp_2);
}

print_results(@result_list);

sub online_mode
{
    my $ref_res = 0;
    $ref_res = online_request($term);
    my @list = parse_online_result($ref_res);
    return @list;
}

sub offline_mode
{
    my @list = search_word($pattern);
    return @list;
}

# Formatted output of the results, not perfect but readable
sub print_results(@)
{
    my @list = @_;
    my ($german, $english) = 0;
    my $formatted;
    for (@list) {
        ($english, $german) = split( ' : ', $_);
        if ( (length($english) > 38 ) || (length($german) > 38 ) ) {
            # skip lines which are to long
            next;
        }
        printf("%38s\t%-38s\n", $english, $german);
    }
}


if ( $help ) { &usage; }

sub usage 
{
my $helpstring = <<"ENDHELP";
dictcmd OPTION SEARCHITEM

-de2en
-de the given word is a german one and you want to search the english equivalent.
-en2de
-en the given word is a english one and you want to search the german equivalent.
-online use only online search 
-offline use only offline search in the en-de.ISO-8859-1.vok file

ENDHELP
    
    say $helpstring;
    exit;
}


__END__

=pod

=head1 NAME
dictcmd - for easily translation from your commandline

=head1 DESCRIPTION

=cut
