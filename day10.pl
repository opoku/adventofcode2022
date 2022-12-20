#!/usr/bin/perl

use v5.14;

my $reg = 1;
my $cycle = 1;

my $stop_cycle = 20;
my $stop_cycle_step = 40;
my $max_stop_cycle = 220;

my $crt_width = 40;
my $crt_end = 240;
my $crt_pos = 0;


my $signal_sum = 0;

my %cycle = (
    'noop' => 1,
    'addx' => 2,
    );

while (<>) {
    chomp;
    my ($op, $arg) = split / /;

    my $next_cycle = $cycle + $cycle{$op};

    if ($next_cycle > $stop_cycle && $cycle <= $stop_cycle) {

        my $signal = $reg * $stop_cycle;

        $signal_sum += $signal;

        if ($stop_cycle <= $max_stop_cycle) {
            $stop_cycle += $stop_cycle_step;
        }
    }

    for (my $crt = $cycle; $crt < $next_cycle; $crt++) {
        if ($crt_pos >= $crt_end) {
            last;
        }
        my $col = $crt_pos % $crt_width;
        if ($col >= ($reg - 1) && $col <= ($reg + 1)) {
            print '#';
        } else {
            print '.';
        }
        $crt_pos++;
        my $next_col = ($crt_pos % $crt_width);
        if ($next_col == 0) {
            print "\n";
        }
    }

    if ($op == 'addx') {
        $reg += $arg;
    }

    $cycle = $next_cycle;

}

say "Signal strength sum: $signal_sum";
