#! /usr/bin/perl

use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Copy;
use Env qw(HOME PWD);

mkdir "$HOME/.dictcmd" or warn qq/creating directory failed/;
copy("en-de.ISO-8859-1.vok", "$HOME/.dictcmd/") or warn qq/copying failed/;

my %params = (
	NAME                     => 'Dictcmd',
	AUTHOR => 'blastmaster',
	VERSION_FROM             => 'lib/Dictcmd/Ressources/Offline.pm',
	PREREQ_PM                 => {
		'Getopt::Long'        => 0,
		'WWW::Dict::Leo::Org' => 0,
        'Term::ANSIColor' => 0,
        'Term::ReadLine::Gnu' => 0,
	},
	EXE_FILES => [ 'bin/dict' ],
);

my $mmv = eval $ExtUtils::MakeMaker::VERSION;
if ( $mmv >= 6.45 ) {
	$params{META_MERGE} = {
		resources => {
			repository => 'git://github.com/blastmaster/dictcmd.git',
			bugtracker => 'https://github.com/blastmaster/dictcmd/issues',
		},
	};
}

WriteMakefile( %params );

1;
