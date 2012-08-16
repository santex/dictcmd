use strict;
use warnings;
use Test::More qw( no_plan );

use lib "../lib";

use feature "say";

BEGIN
{
    use_ok("Dictcmd")
}

=pod
my $pattern = qr(^\w+? : \w*?genial\w*?$);
my $con_ref = take_the_file_content(\*DATA);
say $_ for (@{ $con_ref });
my @searched_words = search_word($pattern, $con_ref);
#say $_ for (@searched_words);
my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

say $_  foreach ( grep { /$pattern/i } @compare_array );
#is_deeply(\@searched_words, \@compare_array, "arrays equal");

__DATA__
ingenious : genial                                
ingeniously : genial                                
ingeniously : geniale                               
=cut
