#!perl

use warnings;
use strict;

use Test::More tests => 2;

use lib 't';
use Util;

prep_environment();

VARIOUS_NEWLINES: {
    my $file = 't/swamp/newlines.txt';

    open( my $fh, '<:raw', $file ) or die "Can't read $file: \n";
    {
        local $/ = undef;
        $_ = <$fh>;
    }
    my @expected = map { "$file:$_:$_" } split( /\D+/s, $_ );
    close $fh;

    my @args = qw( -H . );
    my @results = run_ack( @args, $file );

    lists_match( \@results, \@expected, 'Various newlines recognition' );
}
