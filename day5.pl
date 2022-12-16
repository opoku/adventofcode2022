#!/usr/bin/perl

use v5.14;

my @crates = ();
my $crates_complete = 0;
while (<>) {
    chomp;
    if (/^$/) {
        $crates_complete = 1;
        next;
    }

    unless ($crates_complete) {
        my $stack = 0;
        while (/(?:(?:(?:\s{3}|(?:\[([A-Z])\]))\s?))/g) {
            $crates[$stack] .= $1;
            $stack++;
        }
    } else {
        /move (\d+) from (\d+) to (\d+)/;

        my $count = $1;
        my $from = $2 - 1 ;
        my $to = $3 - 1;

        my $removed = substr $crates[$from], 0, $count, "";
        substr $crates[$to], 0, 0, $removed;

    }
}
say "Top of crates: " . join("", map({ substr $_, 0, 1 } @crates));
