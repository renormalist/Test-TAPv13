#! /usr/bin/perl

use Test::TAPv13 ':all'; # must come before Test::More
use Test::More tests => 3;

my $data = { affe => { tiger => 111,
                       birne => "amazing",
                       loewe => [ qw( 1 two three) ],
                     },
             zomtec => "here's another one",
             DrWho  => undef,
           };

ok(1, "hot stuff");
tap13_yaml($data);
tap13_pragma "+strict";
ok(1, "more hot stuff");

subtest 'An example subtest' => sub {
                                     plan tests => 2;
                                     
                                     pass("This is a subtest");
                                     pass("So is this");
                                    };
