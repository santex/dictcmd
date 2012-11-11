
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Commandline Client for German English translation",
  "AUTHOR" => "blastmaster <oeste.sebastian\@googlemail.com>",
  "BUILD_REQUIRES" => {
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "dictcmd",
  "EXE_FILES" => [
    "bin/dict"
  ],
  "LICENSE" => "perl",
  "NAME" => "dictcmd",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Config" => 0,
    "Env" => 0,
    "Exporter" => 0,
    "Getopt::Long" => 0,
    "Module::Pluggable" => 0,
    "Term::ANSIColor" => 0,
    "Term::ReadLine" => 0,
    "WWW::Dict::Leo::Org" => 0,
    "constant" => 0,
    "feature" => 0,
    "if" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



