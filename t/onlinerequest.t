use strict;
use warnings;
use Test::More;


use feature "say";

use lib "../lib";

BEGIN
{
   eval 'use OnlineRequest';
   if ( $@ ) {  
       plan(skip_all => 'Online Module not installed');
   }
   else {
       plan(tests => 10);
   }
   use_ok("OnlineRequest");
}

my $anwser = online_request("Pizza");
my @result = &parse_online_result($anwser);

for my $i ( 0 .. $#result ) {
    like($result[$i], qr/.*\s:\s.*/, q/result hast the right format/);
}
