use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.04

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/MooseX/Method/Signatures.pm',
    'lib/MooseX/Method/Signatures/Meta/Method.pm',
    'lib/MooseX/Method/Signatures/Types.pm'
);

notabs_ok($_) foreach @files;
done_testing;