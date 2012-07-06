#! /usr/bin/perl

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                     => 'Dictcmd',
    VERSION_FROM             => 'src/Dictcmd.pm',
    PM                       => {
       'Dictcmd.pm'             => 'src/Dictcmd.pm',
       'OnlineRequest.pm'    => 'src/OnlineRequest.pm',
   },
   PREREQ_PM                 => {
       'Getopt::Long'        => 0,
       'WWW::Dict::Leo::Org' => 0,
   },
);

1;
