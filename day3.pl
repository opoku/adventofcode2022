#!/usr/bin/perl

use v5.14;

my $ord_a = ord 'a';
my $ord_A = ord 'A';

sub letter_priority {
    my $l = shift;
    my $o = ord $l;
    if ($o >= $ord_a) {
        return $o - $ord_a + 1;
    } else {
        return $o - $ord_A + 27;
    }
}


sub score {
    my $line = shift;
    my $length = length($line);

    my $part1 = substr $line, 0, $length/2;
    my $part2 = substr $line, $length/2;

    $part1 =~ /([$part2])/;

    return letter_priority $1;

}

sub misplaced {
    my $score = 0;

    while (<>) {
        chomp;
        $score += score($_);
    }
    return $score;
}

sub badges {
    my $score = 0;

    my @team = ();
    TOP: while(1) {
        my $line = <>;
        last if !$line;

        my %chars = ();

        my $cur = 1;

        chomp $line;
        map { $chars{$_} |= $cur } split //, $line;
        $line = <>;
        chomp $line;
        $cur = 2;
        map { $chars{$_} |= $cur } split //, $line;
        $line = <>;
        chomp $line;
        $cur = 4;
        map { $chars{$_} |= $cur } split //, $line;

        while (my ($key, $value) = each %chars) {
            if ($value == 7) {
                $score += letter_priority $key;
                next TOP;
            }
        }
    }
    return $score;
}

# say "Total score: " . misplaced();
say "Total badges: " . badges();
