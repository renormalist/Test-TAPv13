use strict;
use warnings;
package Test::TAPv13;
# ABSTRACT: provide TAP v13 support to test scripts

use Test::Builder;
use Data::YAML::Writer;

my $Test;
my $OUT;

BEGIN {
    $Test = Test::Builder->new;
    $OUT  = $Test->output;
    print $OUT "TAP version 13\n";
}

use Sub::Exporter
 -setup => {
            exports => [
                        qw( tap13_pragma
                            tap13_yaml
                         ),
                       ],
            groups => {
                       all => [ qw( tap13_pragma
                                    tap13_yaml
                                 )
                              ],
                      },
           };

sub tap13_pragma {
    my ($msg) = @_;
    print $OUT "pragma $msg\n";
}

sub tap13_yaml {
    my ($data) = @_;

    my $writer = Data::YAML::Writer->new;
    my $output;
    $writer->write($data, \$output);

    my $indent = $Test->{Indent}. "  ";
    $output =~ s/^/$indent/msg;
    print $OUT $output;
}

1;

__END__

=head1 ABOUT

This module is to utilize TAP version 13 features in your test
scripts.

TAP, the L<Test Anything Protocol|http://testanything.org/>, allows
some new elements beginning with L<version
13|http://testanything.org/wiki/index.php/TAP_version_13_specification>. The
most prominent one is to embed data as indented L<YAML
blocks|http://testanything.org/wiki/index.php/YAMLish>.

This module automatically declares C<TAP version 13> first in the TAP
stream which is needed to tell the TAP::Parser to actually parse those
new features. With some utility functions you can then actually
include data, etc.

=head1 SYNOPSIS

  use Test::TAPv13 ':all'; # before other Test::* modules
  use Test::More tests => 2;
  
  my $data = { affe => { tiger => 111,
                         birne => "amazing",
                         loewe => [ qw( one two three) ],
               },
               zomtec => "here's another one",
  };
  
  ok(1, "hot stuff");
  tap13_yaml($data);
  tap13_pragma "+strict";
  ok(1, "more hot stuff");

This would create TAP like this:

  TAP version 13
  1..2
  ok 1 - hot stuff
    ---
    affe:
      birne: amazing
      loewe:
        - one
        - two
        - three
      tiger: 111
    zomtec: 'here''s another one'
    ...
  pragma +strict
  ok 2 - more hot stuff

=head2 tap13_yaml($data)

For example

  tap13_yaml($data);

prints out an indented YAML block of the data, like this:

    ---
    affe:
      birne: amazing
      kram:
        - one
        - two
        - three
      one: 111
    zomtec: "here's another one"
    ...

To make it meaningful, e.g. in a L<TAP::DOM|TAP::DOM>, you should do
that B<directly after> an actual test line to which this data block
will belong as a child.

=head2 tap13_pragma($string)

For example

  tap13_pragma("+strict");

prints out a TAP pragma line:

  pragma +strict

You most probably do not want or need this, but anyway, the C<+strict>
pragma is part of the TAP v13 specification and makes the TAP parser
complain about non-TAP (I<unknown>) lines.
