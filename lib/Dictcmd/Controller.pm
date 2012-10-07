#! /usr/bin/perl

package Dictcmd::Controller;

use strict;
use warnings;
use Carp;
use Config;
use Getopt::Long;
use Dictcmd::Ressources::Offline;
use if $Config{useithreads}, 'threads';
use IO::Prompt;
use Term::ReadLine;
use Term::ANSIColor qw(:constants);

use feature "say";

require Exporter;
our @ISA = qw(Exporter);
our @EXPORTER = qw(
  main
);

sub main;
sub processing_args($$$$$);
sub online_mode($);
sub offline_mode;
sub pretty_printer(\@);
sub print_results(@);
sub sort_precise(\@);
sub output(@);
sub usage;

#
# Variables managing colors much cleaner
#
my $red = RED;
my $blue = BLUE;
my $green = GREEN;
my $white = WHITE;
my $yellow = YELLOW;
my $reset = RESET;

# prompt Layout = dictcmd:<mode>:<input language>

sub main($$$$$$$)
{
    my ($de_en, $en_de, $interactive, $offline, $online, $help, $term) = @_;
    eval 'use Dictcmd::Ressoures::OnlineRequest';
    if ( $@ ) {
        $offline = 1;
        $online =  0;
    }


    my $term = $ARGV[0] || '';
    my ($mode, $lang) = ("", "");

    say qq/type :q or :quit to exit interactive mode\n/ if $interactive;
    processing_args($de_en, $en_de, $offline, $online, $term) if $term;

    unless ( $term or $interactive ) {
        &usage;
    }

    ($mode, $lang) = &_get_modes if $interactive;

    my $readline = new Term::ReadLine 'dictcmd';
    while ($interactive) {
        $term = $readline->readline(qq/dictcmd:$yellow$mode:$green$lang$reset>/);
        last if $term =~ /^:q(:?uit)?$/;
        if ($term =~ s/^:c\s?(en|de|off|on|hyb)$/$1/) {
            ($mode, $lang) = parse_commands($term);
        }
        else {
            processing_args($de_en, $en_de, $offline, $online, $term);
        }
    }
    if ( $help ) { &usage; }
}

sub _get_modes($$$$)
{
    my ($de_en, $en_de, $offline, $online) = @_;
    my ($mode, $lang) = ("hybrid", "");

    if ($offline) {
        $mode = 'offline';
    }
    elsif ($online) {
        $mode = 'online';
    }
    else {
        $mode = 'hybrid';
    }

    if ($de_en) {
        $lang = 'de';
    }
    elsif ($en_de) {
        $lang = 'en';
    }
    else {
        $en_de = 1;
        $lang = 'en';
    }

    return wantarray ? ($mode, $lang) : 1;
}

sub parse_commands($$$$$)
{
    my ($de_en, $en_de, $offline, $online, $cmd) = @_;
    my $mode = '';
    my $lang = '';

    if ($cmd =~ /en/) {
        $de_en = 0;
        $en_de = 1;
    }
    elsif ($cmd =~ /de/) {
        $de_en = 1;
        $en_de = 0;
    }
    elsif ($cmd =~ /off/) {
        $offline = 1;
        $online = 0;
    }
    elsif ($cmd =~ /on/) {
        $online = 1;
        $offline = 0;
    }
    elsif ($cmd =~ /hyb/) {
        $online = 0;
        $offline = 0;
    }
    else {
        warn("unknown command: $cmd");
        return 0;
    }

    ($mode, $lang) = &_get_modes;
    #say qq/[DEBUG] de_en: $de_en, en_de: $en_de/;
    #say qq/[DEBUG] offline: $offline, online: $online/;
    #say qq/[DEBUG] mode: $mode, lang: $lang/;
    return wantarray ? ($mode, $lang) : 1;
}

#
# determine parameters in anonymous block
#
sub processing_args($$$$$)
{
    my ($de_en, $en_de, $offline, $online, $term) = @_;
    #my $term = shift;
    #say qq/[DEBUG] term: $term/;
    my @result_list = ();
    my $pattern = "";

# language decision
    if ( $de_en ) {
        $pattern = qr(^\w+? : \w*?$term\w*?$);
    }
    elsif ( $en_de ) {
        $pattern = qr(^\w*?$term\w*? : \w+?$);
    }
    else { &usage; }

# Mode decision
    if ( $offline ) {
        #say qq/[DEBUG] offline mode:/;
        @result_list = &offline_mode;
    }
    elsif ( $online ) {
        #say qq/[DEBUG] online mode/;
        @result_list = online_mode($term);
    }
    else {
        #say qq/[DEBUG] hybrid mode/;
        #say qq/[DEBUG] term: $term/;
        my @tmp_1 = ();
        my @tmp_2 = ();

        if ( $Config{useithreads} ) {
            handle_threads($term, $pattern);
        }
        else {
            @tmp_1 = &offline_mode;
            @tmp_2 = online_mode($term);
            @result_list = (@tmp_1, @tmp_2);
        }
    }
    output(@result_list);
}

#
# Thread handling routine here we start two threads, one for the offline
# request and another for the online request. The master-thread will wait
# until one of them is joinable, then he takes the result of the thread and
# calls the routines for output. The he waits until the second thread is ready
# too.
#
sub handle_threads($$)
{
    my $term = shift;
    my $pattern = shift;
    my ( $offline_thr ) = threads->create('offline_mode', $pattern);
    my ( $online_thr ) = threads->create('online_mode', $term);

    do {
        if ($offline_thr->is_joinable()) {
            my @offline_result = $offline_thr->join();
            output(@offline_result);
        }
        if ($online_thr->is_joinable()) {
            my @online_result = $online_thr->join();
            output(@online_result);
        }
    } while ( threads->list() );

}

#
# Calls the subroutines to getting a nice output
#
sub output(@)
{
    my @raw_list = @_;
    pretty_printer(@raw_list);
    @raw_list= sort_precise(@raw_list);
    print_results(@raw_list);
}

#
# Sorts the results by the shortest first.
#
sub sort_precise(\@) 
{
    my @list = @{ shift() };
    @list = sort { length($a) <=> length($b) } @list;
    return @list;
}

#
# This subroutine deletes some ugly features in the list.
#
sub pretty_printer(\@)
{
    my $su = sub 
    { 
        s/(?:\[.*?\])//g;
        s/(?:\-\s.*?\:??)//g;
        s/(?:\(.*?\))//g;
        s/\s{2,}/ /g;
        $_;
    };
    map { $su->($_) } @{shift()};
}

#
# Triggers the certain subroutines to make the online request
# Returns the list which will be returned by the module.
#
sub online_mode($)
{
    my $term = shift;
    my $ref_res = online_request($term);
    my @list = parse_online_result($ref_res);
    return @list;
}

#
# takes the handle of the offline resource at first
# triggers the search routines from Dictcmd.pm, getting
# a list which contains the results.
# Returns the list which will be returned by the module.
#
sub offline_mode($)
{
    my $pattern = shift;
    my @list = ();
    my $handle = &getting_offline_resource;
    @list = search_word($pattern, $handle);
    return @list;
}

#
# Formatted output of the results, not perfect but readable
# without eyebleeding
#
sub print_results(@)
{
    my @list = @_;
    my ($german, $english) = 0;
    my $limit = ( @list <= 15 ) ? @list : 15 ;

    for ( my $n = 0; $n < $limit; $n++ ) {
        ($english, $german) = split( ' : ', $list[$n]);
        if ( (length($english) > 38 ) || (length($german) > 38 ) ) {
            # skip lines which are to long
            next;
        }
        printf("%38s\t%-38s\n", $english, $german);
    }
}


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

1;

