use strict;
use warnings;
use Test::More 'no_plan';

use feature "say";

use lib "../src";

BEGIN
{
    use_ok("OnlineRequest");
}

my $awnser = online_request("Freie Software");
&parse_online_result($awnser);
