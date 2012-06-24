use strict;
use warnings;
use Test::More 'no_plan';

use lib "../src";
use feature "say";

BEGIN
{
    use_ok("Dictcmd")
}

#my $ref_list = &_take_the_file;
#isnt($#{$ref_list}, 0, "anything is in the list");
my $pattern = qr(^\w+? : \w*?genial\w*?$);
my @searched_words = search_word($pattern);
my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

is_deeply(\@searched_words, \@compare_array, "arrays equal");

