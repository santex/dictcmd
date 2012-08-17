use strict;
use warnings;
use Test::More qw( no_plan );

use lib "../lib";

use feature "say";

BEGIN
{
    use_ok("Dictcmd")
}

my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

my $pattern = qr(^\w+? : \w*?genial\w*?$);
my $con_ref = take_the_file_content(\*DATA);

#my @searched_words = search_word($pattern, $con_ref);

is_deeply($con_ref, \@compare_array, "arrays equal");

__DATA__
ingenious : genial
ingeniously : genial
ingeniously : geniale
