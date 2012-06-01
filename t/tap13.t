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
tap13_pragma "-strict"; # +strict does not work in TAP::Harness with the nested TAP yet
ok(1, "more hot stuff");

subtest 'An example subtest' => sub {
                                     plan tests => 2;
                                     pass("This is a subtest");
                                     tap13_yaml($data);
                                     tap13_pragma "-strict";
                                     pass("So is this");
                                    };
