use strict;
use warnings;
package Test::TAPv13;
# ABSTRACT: provide TAPv13 support to test scripts

use Test::Builder;
use TAP::Parser::YAMLish::Writer;

my $Test;
my $OUT;

BEGIN {
    $Test = Test::Builder->new;
    $OUT  = $Test->output;
    print $OUT "TAP Version 13\n";
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
