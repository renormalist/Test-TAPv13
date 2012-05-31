#! /usr/bin/perl

use Test::More 0.88;
use Test::TAPv13;

ok(1, "hot stuff");
tap13_pragma "0xAFFE";
tap13_yaml( { affe => { one   => 111,
                        birne => "amazing",
                        kram  => [ qw( one two three) ],
                      },
              zomtec => "here's another one",
            });
done_testing;
