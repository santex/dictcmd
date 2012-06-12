#! /usr/bin/perl

package Dictcmd;

use strict;
use warnings;

use WWW::Babelfish;

use feature "say";


my $babel_obj = new WWW::Babelfish( service => 'Yahoo', 
    agent => 'Mozilla/13.0');


sub de_en($)
{
    my $de_word = shift;
    my $en_word = $babel_obj->translate(
        'source' => 'German',
        'destination' => 'English',
        'text' => $de_word,
        'delimiter' => "\n\t",
        'ofh' => \*STDOUT,
    );
    return $en_word;
}

1;
__END__
