#!perl

use strict;
use warnings;

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;

my @modules = qw(
  B::Hooks::EndOfScope
  Carp
  Context::Preserve
  Data::Dumper
  Devel::Declare
  Devel::Declare::Context::Simple
  Eval::Closure
  ExtUtils::MakeMaker
  File::Spec
  File::Spec::Functions
  IO::Handle
  IPC::Open3
  List::Util
  Module::Build::Tiny
  Module::Runtime
  Moose
  Moose::Meta::Class
  Moose::Meta::Method
  Moose::Role
  Moose::Util
  Moose::Util::TypeConstraints
  MooseX::LazyRequire
  MooseX::Meta::TypeConstraint::ForceCoercion
  MooseX::Types
  MooseX::Types::Moose
  MooseX::Types::Structured
  MooseX::Types::Util
  Parse::Method::Signatures
  Parse::Method::Signatures::Param::Named
  Parse::Method::Signatures::Param::Placeholder
  Parse::Method::Signatures::TypeConstraint
  Parse::Method::Signatures::Types
  Scalar::Util
  Sub::Name
  Task::Weaken
  Test::CheckDeps
  Test::Deep
  Test::Fatal
  Test::Moose
  Test::More
  Text::Balanced
  aliased
  attributes
  lib
  metaclass
  namespace::autoclean
  namespace::clean
  perl
  strict
  warnings
);

# replace modules with dynamic results from MYMETA.json if we can
# (hide CPAN::Meta from prereq scanner)
my $cpan_meta = "CPAN::Meta";
if ( -f "MYMETA.json" && eval "require $cpan_meta" ) { ## no critic
  if ( my $meta = eval { CPAN::Meta->load_file("MYMETA.json") } ) {
    my $prereqs = $meta->prereqs;
    delete $prereqs->{develop};
    my %uniq = map {$_ => 1} map { keys %$_ } map { values %$_ } values %$prereqs;
    $uniq{$_} = 1 for @modules; # don't lose any static ones
    @modules = sort keys %uniq;
  }
}

my @reports = [qw/Version Module/];

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];
  }
  else {
    push @reports, ["missing", $mod];
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "Prerequisite Report:\n", map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

pass;

# vim: ts=2 sts=2 sw=2 et:
