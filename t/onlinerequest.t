use strict;
use warnings;
use Test::More;

use feature "say";


BEGIN
{
   eval 'use Dictcmd::Ressources::OnlineRequest';

   if ( $@ ) {
       plan(skip_all => 'Online Module not installed');
   }

   use_ok("Dictcmd::Ressources::OnlineRequest");
}

my $anwser = online_request("Pizza");
my @result = parse_online_result($anwser);

for ( @result ) {
    like($_, qr/[.\.]*\s:\s[.\.]*/, q/result hast the right format/);
}

done_testing(scalar(@result) + 1);
