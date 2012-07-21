use strict;
use warnings;
use Test::More tests => 2;

use lib "../src";

use feature "say";

BEGIN
{
    use_ok("Dictcmd")
}

my $pattern = qr(^\w+? : \w*?genial\w*?$);
my @searched_words = search_word($pattern);
my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

is_deeply(\@searched_words, \@compare_array, "arrays equal");

