#!perl

use strict;
use warnings;

{

    package Ape;
    use Moo;
    use MooX::StrictConstructor;
    has foo => ( is => 'rw' );
    has bar => ( is => 'rw' );

}

my $a = Ape->new( { foo => 1, baz => 10, flop => 'doh' } );

