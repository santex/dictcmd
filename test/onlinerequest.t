use strict;
use warnings;
use Test::More 'no_plan';

use feature "say";

use lib "../src";

BEGIN
{
    use_ok("OnlineRequest");
}

my $awnser = online_request("Pizza");
my @result = &parse_online_result($awnser);

for my $i ( 0 .. $#result ) {
    like($result[$i], qr/.*\s:\s.*/, q/result hast the right format/);
}
