package Dictcmd::Controller;

use strict;
use warnings;
use Carp;
use Config;
use Getopt::Long;
use if $Config{useithreads}, 'threads';
use Term::ReadLine;
use Term::ANSIColor qw(:constants);
use Module::Pluggable search_path => "Dictcmd::Plugin", require => 1;
use Dictcmd::Ressource::Offline;

use feature "say";

require Exporter;
our @ISA = qw(Exporter);
our @EXPORTER = qw(
    isInteractive
    start
);

# ABSTRACT: Commandline Client for German English translation

=attr
 Variables managing colors
=cut
my $red = RED;
my $blue = BLUE;
my $green = GREEN;
my $white = WHITE;
my $yellow = YELLOW;
my $reset = RESET;

=method new:
Constructor initialize a Dict::Controller object
=cut
sub new
{
    my $class = shift;
    my ($de_en, $en_de, $offline, $online, $term) = @_;
    my $mode = "";
    unless ($offline or $online) {
        $mode = qq/hyb/;
    }
    else {
        $mode = ($offline) ? qq/off/ : qq/on/;
    }

    return bless {
        lang => ($de_en) ? qq/de/ : qq/en/,
        pattern => {
            de => qr(^\w+? : \w*$term\w*?$),
            en => qr(^\w*?$term\w*? : \w+?$),
        },
        offline => $offline,
        online => $online,
        mode => $mode,
        term => $term,
    }, $class;
}

=method update_pattern:
sets the current search term in the reqular expression pattern
for the offline search
=cut
sub update_pattern
{
    my $self = shift;
    my $term = $self->{term};
    $self->{pattern}->{de} = qr(^\w+? : \w*$term\w*?$);
    $self->{pattern}->{en} = qr(^\w*?$term\w*? : \w+?$);
}


=method runInteractive:
Handle the interacitve mode, represents a read eval print loop
for the specific dictcmd commands.
It runs a prompt with the following Layout = dictcmd:<mode>:<input_language>
=cut
sub runInteractive
{
    my $self = shift;
    say qq/type :q or :quit to exit interactive mode\n/;
    my $mode = \$self->{mode};
    my $lang = \$self->{lang};
    my $readline = new Term::ReadLine 'dictcmd';
    while (1) {
        $self->{term} = $readline->readline(qq/dictcmd:$yellow$$mode:$green$$lang$reset>/);
        last if $self->{term} =~ /^:q(:?uit)?$/;
        if ($self->{term} =~ s/^:c\s?(en|de|off|on|hyb)$/$1/) {
            $self->parse_commands();
        }
        else {
            $self->update_pattern();
            $self->start();
        }
    }
}

=method parse_commands:
Updates object attributes if they should be changed because of controll
command input in interactive mode
=cut
sub parse_commands
{
    my $self = shift;
    my $cmd = $self->{term};

    if ($cmd eq qq/en/ or $cmd eq qq/de/) {
        $self->{lang} = $cmd;
        return;
    }
    elsif ($cmd eq qq/on/ or $cmd eq qq/off/ or $cmd eq qq/hyb/) {
        unless ($cmd eq qq/on/ or $cmd eq qq/off/) {
            $self->{offline} = 0;
            $self->{online} = 0;
        }
        else {
            $self->{offline} = ($cmd eq qq/off/) ? 1 : 0;
            $self->{online} = ($cmd eq qq/on/) ? 1 : 0;
        }
        $self->{mode} = $cmd;
    }
}

=method start;
This method represents the evaluation of the modes
=cut
sub start
{
    my $self = shift;

    unless ($self->{offline} or $self->{online}) {
        if ( $Config{useithreads} ) {
            $self->handle_threads();
            return;
        }
        my @tmp_1 = ();
        my @tmp_2 = ();
        @tmp_1 = $self->offline_mode();
        @tmp_2 = $self->online_mode();
        output(@tmp_1, @tmp_2);
    }
    else {
        output($self->offline_mode()) if $self->{offline};
        output($self->online_mode()) if $self->{online};
    }
}

=method handle_threads:
 Thread handling routine here we start two threads, one for the offline
 request and another for the online request. The master-thread will wait
 until one of them is joinable, then he takes the result of the thread and
 calls the routines for output. The he waits until the second thread is ready
 too.
=cut
sub handle_threads
{
    my $self = shift;
    my ( $offline_thr ) = threads->create(\&offline_mode, $self);
    my ( $online_thr ) = threads->create(\&online_mode, $self);

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

=method output:
 Calls the subroutines to getting a nice output
=cut
sub output(@)
{
    my @raw_list = @_;
    pretty_printer(\@raw_list);
    @raw_list= sort_precise(\@raw_list);
    print_results(@raw_list);
}

=method sort_precise;
 Sorts the results by the shortest first.
=cut
sub sort_precise(\@)
{
    my @list = @{ shift() };
    @list = sort { length($a) <=> length($b) } @list;
    return @list;
}

=method prettry_printer;
 This subroutine deletes some ugly features in the list.
=cut
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

=method online_mode:
 Triggers the certain subroutines to make the online request
 Returns the list which will be returned by the module.
=cut
sub online_mode
{
    my $self = shift;
    my $term = $self->{term};
    my @list = ();
    for my $plugin ($self->plugins()) {
       push @list, $plugin->run($term);
    }
    return @list;
}

=method offline_mode:
 takes the handle of the offline resource at first
 triggers the search routines from Dictcmd.pm, getting
 a list which contains the results.
 Returns the list which will be returned by the module.
=cut
sub offline_mode
{
    my $self = shift;
    my $pattern = $self->{pattern}->{$self->{lang}};
    my @list = ();
    @list = run($pattern);

    return @list;
}

=method print_results:
 Formatted output of the results, not perfect but readable
 without eyebleeding
=cut
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

1;
