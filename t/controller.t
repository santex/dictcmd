use strict;
use warnings;
use Test::More q(no_plan);

use feature "say";

BEGIN { use_ok("Dictcmd::Controller"); }

my ($de_en, $en_de, $offline, $online) = (0, 1, 0, 0);

my $controller = Dictcmd::Controller->new($de_en, $en_de, $offline, $online, qq/hallo/);
isa_ok($controller, qq/Dictcmd::Controller/, qq/getting Dictcmd::Controller object/);

is($controller->{mode}, qq/hyb/, qq/right defult mode/);
is($controller->{lang}, qq/en/, qq/getting right lang/);

#my @config = $controller->_get_modes($de_en, $en_de, $offline, $online);
#is_deeply(\@config, [qw(offline en)], "getting right mode");

