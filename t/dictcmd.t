use strict;
use warnings;
use Test::More 'no_plan';

use lib "../src";
use feature "say";

BEGIN
{
    use_ok("Dictcmd")
}

require_ok("dictcmd.pl");

my $pattern = qr(^\w+? : \w*?genial\w*?$);
my @searched_words = search_word($pattern);
my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

is_deeply(\@searched_words, \@compare_array, "arrays equal");

=pod
sub compute_differences
{
    my (@union, @intersection, @differences) = ();
    my %count = ();
    my @tmp1 = &offline_mode;
    my @tmp2 = &online_mode;
    foreach my $elements (@tmp1, @tmp2) {
        $count{$elements}++;
    }
    foreach my $elements (keys %count) {
        push @union, $elements;
        push @{ $count{$elements} > 1 ? \@intersection : \@differences }, $elements;
    }

    # test print 
    print "-"x20;
    print "\tunion\t";
    print "-"x20;
    for my $i ( 0 .. $#union) {
        say $union[$i];
    }
}
=cut

&compute_differences;
