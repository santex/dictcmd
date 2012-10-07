use strict;
use warnings;
use Test::More q(no_plan);

use feature "say";

BEGIN { use_ok("Dictcmd::Controller"); }

my ($de_en, $en_de, $offline, $online, $help) = (0, 0, 0, 0, 0, 0,);

$offline = 1;
$en_de = 1;

# try to pass @_ implicit should be cleaner

my @config = Dictcmd::Controller::_get_modes($de_en, $en_de, $offline, $online);
is_deeply(\@config, [qw(offline en)], "getting right mode");

