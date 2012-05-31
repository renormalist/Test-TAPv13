#! /usr/bin/perl

use Test::TAPv13; # must come before Test::More
use Test::More tests => 2;

my $data = { affe => { one   => 111,
                       birne => "amazing",
                       kram  => [ qw( one two three) ],
             },
             zomtec => "here's another one",
};

ok(1, "hot stuff");
tap13_pragma "0xAFFE";
tap13_yaml($data);
ok(1, "more hot stuff");
