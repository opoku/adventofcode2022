#!/usr/bin/perl

use v5.14;
use Data::Dumper;

# R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2

my %tail_visited;

my $rope_length = 10;

my @rope;
for (1..$rope_length) {
    push @rope, [0,0];
}

my %move_dir = (
    'R' => [1,0],
    'U' => [0,1],
    'L' => [-1,0],
    'D' => [0,-1],
);


while (<>) {
    chomp;
    my ($move, $repeat) = split / /;
    my ($x, $y) = @{ $move_dir{$move} };
    for (1..$repeat) {

        my $head_pos = $rope[0];
        $head_pos->[0] += $x;
        $head_pos->[1] += $y;

        my $tail_pos;
        for my $knot (1..$#rope) {
            $tail_pos = $rope[$knot];

            my $tail_delta_x = 0;
            my $tail_delta_y = 0;

            my $sep_x = $head_pos->[0] - $tail_pos->[0];
            my $sep_y = $head_pos->[1] - $tail_pos->[1];

            if ($sep_x == 2) {
                $tail_delta_x = 1;
                if ($sep_y == 1) {
                    $tail_delta_y = 1;
                } elsif ($sep_y == -1) {
                    $tail_delta_y = -1;
                }
            } elsif ($sep_x == -2) {
                $tail_delta_x = -1;
                if ($sep_y == 1) {
                    $tail_delta_y = 1;
                } elsif ($sep_y == -1) {
                    $tail_delta_y = -1;
                }
            }

            if ($sep_y == 2) {
                $tail_delta_y = 1;
                if ($sep_x == 1) {
                    $tail_delta_x = 1;
                } elsif ($sep_x == -1) {
                    $tail_delta_x = -1
                }
            } elsif ($sep_y == -2) {
                $tail_delta_y = -1;
                if ($sep_x == 1) {
                    $tail_delta_x = 1;
                } elsif ($sep_x == -1) {
                    $tail_delta_x = -1
                }
            }

            $tail_pos->[0] += $tail_delta_x;
            $tail_pos->[1] += $tail_delta_y;



        } continue {
            # say "Current rope: ", Dumper \@rope;
            $head_pos = $rope[$knot];
        }

        $tail_visited{join ',',@{ $tail_pos }} += 1;
    }
}

# say Dumper \%tail_visited;

my $tail_visit_count = scalar keys %tail_visited;

say "The tail visited $tail_visit_count places";
