use strict;
use warnings;
package Test::TAPv13;
# ABSTRACT: provide TAP v13 support to test scripts

use Test::Builder;
use TAP::Parser::YAMLish::Writer;

my $Test;
my $OUT;

BEGIN {
    $Test = Test::Builder->new;
    $OUT  = $Test->output;
    print $OUT "TAP version 13\n";
}

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::tap13_pragma'} = \&tap13_pragma;
    *{$caller.'::tap13_yaml'}   = \&tap13_yaml;

    $Test->exported_to($caller);
    $Test->plan(@_);
}

sub tap13_pragma {
    my ($msg) = @_;
    print $OUT "pragma $msg\n";
}

sub tap13_yaml {
    my ($data) = @_;

    my $writer = TAP::Parser::YAMLish::Writer->new;
    my $output;
    $writer->write($data, \$output);

    my $indent = " " x 4 x ($Test->level-1). "  ";
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

This would create TAP like this:

  TAP version 13
  1..2
  ok 1 - hot stuff
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
  ok 2 - more hot stuff
