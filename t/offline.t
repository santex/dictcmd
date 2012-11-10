use strict;
use warnings;
use Test::More tests => 2;

use feature "say";

BEGIN { use_ok("Dictcmd::Ressource::Offline"); }

my @compare_array = (
"ingenious : genial",
"ingeniously : genial",
"ingeniously : geniale",
);

my $pattern = qr(^\w+? : \w*?genial\w*?$);
my @searched_words = search_word($pattern, \*DATA);
is_deeply(\@searched_words, \@compare_array, "arrays equal");

__DATA__
ingenious : genial
ingeniously : genial
ingeniously : geniale
more instinctive : triebhaftere
more insufficient : ungenuegendere
more intelligent : intelligentere
more intense : intensivere
more interesting : interessantere
more intimate : innigere
more intolerable : unertraeglichere
more intolerant : intolerantere
more intractable : unfuegsamere

