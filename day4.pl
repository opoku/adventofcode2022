#!/usr/bin/perl

use v5.14;


my $contained_sum = 0;
my $overlap_sum = 0;

while (<>) {
    chomp;
    /(\d+)-(\d+),(\d+)-(\d+)/;

    $contained_sum++ if (($1 <= $3 && $2 >= $4) || ($3 <= $1 && $4 >= $2));

    $overlap_sum++ unless (($2 < $3) || ($1 > $4));
}

say "Number of fully contained pairs: " . $contained_sum;
say "Number of fully overlaped pairs: " . $overlap_sum;
