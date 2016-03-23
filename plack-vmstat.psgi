#!/usr/bin/env perl

use strict;
use warnings;

my $app = sub {
  my $env = shift;

  return sub {
    my $responder = shift;
    my $cmd = 'vmstat 1 60 2>&1';
    my $res = open (my $ph, '-|', $cmd);
    unless ($res) {
       return [500, ['Content-Type' => 'text/plain'], ["ERROR [$!]"]];
    }

    my $writer = $responder->(
      [ 200, [ 'Content-Type', 'text/plain' ]]
    ); # contentを渡さない場合はwriterが返る。

    while(<$ph>) {
      $writer->write($_);
    }
    close($ph);
    $writer->close();
  };
};

return $app;
