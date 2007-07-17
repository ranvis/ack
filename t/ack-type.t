#!perl

use warnings;
use strict;

use Test::More tests => 19;
use File::Next 0.34; # For the reslash() function

use lib 't';
use Util qw( sets_match );

delete $ENV{ACK_OPTIONS};

my $cc = [qw(
    t/swamp/c-source.c
)];

my $hh = [qw(
    t/swamp/c-header.h
)];

my $ruby = [qw(
    t/etc/shebang.rb.xxx
)];

my $perl = [qw(
    ack
    ack-standalone
    Ack.pm
    Makefile.PL
    squash
    t/00-load.t
    t/ack-a.t
    t/ack-binary.t
    t/ack-c.t
    t/ack-g.t
    t/ack-text.t
    t/ack-type.t
    t/ack-v.t
    t/ack-w.t
    t/etc/shebang.pl.xxx
    t/filetypes.t
    t/interesting.t
    t/longopts.t
    t/pod-coverage.t
    t/pod.t
    t/standalone.t
    t/swamp/0
    t/swamp/Makefile.PL
    t/swamp/options.pl
    t/swamp/perl-test.t
    t/swamp/perl-without-extension
    t/swamp/perl.cgi
    t/swamp/perl.pl
    t/swamp/perl.pm
    t/swamp/perl.pod
    t/zero.t
    t/Util.pm
)];

my $perl_ruby = [ @{$perl}, @{$ruby} ];
my $cc_hh = [ @{$cc}, @{$hh} ];

check_with( '--perl', $perl );
check_with( '--perl --noruby', $perl );
check_with( '--ruby', $ruby );
check_with( '--ruby --noperl', $ruby );
check_with( '--perl --ruby', $perl_ruby );
check_with( '--ruby --perl', $perl_ruby );

check_with( '--type=perl', $perl );
check_with( '--type=perl --type=noruby', $perl );
check_with( '--type=ruby', $ruby );
check_with( '--type=ruby --type=noperl', $ruby );
check_with( '--type=perl --type=ruby', $perl_ruby );
check_with( '--type=ruby --type=perl', $perl_ruby );

check_with( '--perl --type=noruby', $perl );
check_with( '--ruby --type=noperl', $ruby );
check_with( '--perl --type=ruby', $perl_ruby );
check_with( '--ruby --type=perl', $perl_ruby );

check_with( '--cc', $cc_hh );
check_with( '--hh', $hh );
check_with( '--cc --nohh', $cc );

sub check_with {
    my $options = shift;
    my $expected = shift;

    my @expected = sort @{$expected};

    my @results = sort `$^X ./ack-standalone -f $options`;
    chomp @results;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    return sets_match( \@results, \@expected, "File lists match via $options" );
}
