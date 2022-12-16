#!/usr/bin/perl

use v5.14;


sub has_repeated_chars {
    my $word = shift;
    my %counts;
    for (split //, $word) {
        my $c = ++$counts{$_};
        if ($c > 1) {
            return 1;
        }
    }
    return 0;
}

$/ = \1;
my $seen = '';
my $ix = 1;
my $distinct_chars = 14;
while (<>) {
    $seen .= $_;
    my $l = length $seen;
    if ($l > $distinct_chars) {
        substr($seen, 0, $l - $distinct_chars, '');
        $l = length $seen;
    }

    last if ($l == $distinct_chars && !has_repeated_chars ($seen));
    $ix++;
}

say "Processed " . $ix . " before finding the start sequence";
