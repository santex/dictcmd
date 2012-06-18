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
    &take_the_file;
    my @list = search_word($pattern);
    return @list;
}

# Formatted output of the results 
sub print_results(@)
{
    my @list = @_;
    my ($german, $english) = 0;
    $~ = "OUTPUT";
    $^ = "OUTPUT_TOP";
    my $formatted;
    for (@list) {
        ($english, $german) = split( ' : ', $_);
        #write;
        #   printf("%-20s\t\t\t\t%s\n", $english, $german);
        $formatted = sprintf("%-38s %-38s\n", $english, $german);
        print $formatted;
    }
format OUTPUT_TOP = 
English                                 German
---------------------------------------------------------------------
.
format OUTPUT =
~@<<<<<<<<<<<<<<<<<<<<<<<<<<<         ~@<<<<<<<<<<<<<<<<<<<<<<<<<<<
$english, $german
.
}


if ( $help ) { &usage; }

sub usage 
{
my $helpstring = <<"ENDHELP";
here comes some comments how to use this tool
ENDHELP
    
    say $helpstring;
    exit;
}



__END__