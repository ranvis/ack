#!perl

use warnings;
use strict;

use Test::More tests => 4;

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

NEEDS_LINE_SCAN_IDENTIFIES_NEWLINES: {
    my @expected = '9';

    my $file = 't/swamp/newlines.txt';
    my @args = qw( ^9$ );
    my @results = run_ack( @args, $file );

    lists_match( \@results, \@expected, 'needs_line_scan() recognizes non-\n newlines.' );
}
