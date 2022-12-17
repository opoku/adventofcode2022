#!/usr/bin/perl

use v5.14;
use Data::Dumper;

my @trees;

while (<>) {
    chomp;
    my @row = split //;
    push @trees, [@row];
}

my $num_cols = scalar @{ $trees[0] };
my $num_rows = scalar @trees;
# my $num_visible = (2 * ($num_cols + 1)) + (2 * ($num_rows - 1)) ;

say "Size: $num_cols , $num_rows";

my %visible;
my %viewing_distance;
my @high_line;
my @high_pos;

# Left to right
@high_line = (-1) x $num_rows;
for (my $i = 0; $i < $num_cols; $i++) {
    for (my $j = 0; $j < $num_rows; $j++) {
        my $c = $trees[$j][$i];

        my $coord = "$i,$j";

        if ($high_line[$j] < $c) {
            $viewing_distance{$coord} = $i;

            $high_line[$j] = $c;
            $high_pos[$j] = $i;
            $visible{$coord} .= 'L';

        } elsif ($high_line[$j] == $c)  {

            $viewing_distance{$coord} = $i - $high_pos[$j];
            $high_pos[$j] = $i;

        } else { # high_line[j] > c
            # find the tree that is lower than highest but higher or equal the current tree
            # by definition its lower than highest
            # go backwards from the current tree
            NEXT_HIGHEST:
            for (my $ii = $i-1; $ii >= $high_pos[$j]; $ii--) {
                if ($trees[$j][$ii] >= $c) {
                    $viewing_distance{$coord} = $i - $ii;
                    last NEXT_HIGHEST;
                }
            }
        }
    }
}
# Top to bottom
@high_line = (-1) x $num_cols;
@high_pos = ();
for (my $j = 0; $j < $num_rows; $j++) {
    for (my $i = 0; $i < $num_cols; $i++) {
        my $c = $trees[$j][$i];
        my $coord = "$i,$j";

        if ($high_line[$i] < $c) {
            $viewing_distance{$coord} *= $j;

            $high_line[$i] = $c;
            $high_pos[$i] = $j;
            $visible{$coord} .= 'T';
        } elsif ($high_line[$i] == $c) {
            $viewing_distance{$coord} *= ($j - $high_pos[$i]);
            $high_pos[$i] = $j;
        } else {
            NEXT_HIGHEST:
            for (my $jj = $j-1; $jj >= $high_pos[$i]; $jj--) {
                if ($trees[$jj][$i] >= $c) {
                    $viewing_distance{$coord} *= ($j - $jj);
                    last NEXT_HIGHEST;
                }
            }
        }
    }
}

# Right to left
@high_line = (-1) x $num_rows;
@high_pos = ();
for (my $i = $num_cols - 1; $i >= 0; $i--) {
    for (my $j = 0; $j < $num_rows; $j++) {
        my $c = $trees[$j][$i];
        my $coord = "$i,$j";

        if ($high_line[$j] < $c) {
            $viewing_distance{$coord} *= ($num_cols - 1 - $i);

            $high_line[$j] = $c;
            $high_pos[$j] = $i;
            $visible{$coord} .= 'R';
        } elsif ($high_line[$j] == $c) {
            $viewing_distance{$coord} *= ($high_pos[$j] - $i);
            $high_pos[$j] = $i;
        } else {
            NEXT_HIGHEST:
            for (my $ii = $i+1; $ii <= $high_pos[$j]; $ii++) {
                if ($trees[$j][$ii] >= $c) {
                    $viewing_distance{$coord} *= ($ii - $i);
                    last NEXT_HIGHEST;
                }
            }

        }
    }
}

# Bottom to top
@high_line = (-1) x $num_cols;
@high_pos = ();
for (my $j = $num_rows - 1; $j >= 0; $j--) {
    for (my $i = 0; $i < $num_cols; $i++) {
        my $c = $trees[$j][$i];
        my $coord = "$i,$j";

        if ($high_line[$i] < $c) {
            $viewing_distance{$coord} *= ($num_rows - 1 - $j);
            $high_line[$i] = $c;
            $high_pos[$i] = $j;
            $visible{$coord} .= 'B';
        } elsif ($high_line[$i] == $c) {
            $viewing_distance{$coord} *= ($high_pos[$i] - $j);
            $high_pos[$i] = $j;
        } else {
            NEXT_HIGHEST:
            for (my $jj = $j+1; $jj <= $high_pos[$i]; $jj++) {
                if ($trees[$jj][$i] >= $c) {
                    $viewing_distance{$coord} *= ($jj - $j);
                    last NEXT_HIGHEST;
                }
            }
        }
    }
}

say "Number of visible trees: " . scalar keys %visible;

my $max_scenic_factor = 0;
for (values %viewing_distance) {
    $max_scenic_factor = $_ if $max_scenic_factor < $_;
}
say "Max scenic factor: $max_scenic_factor";
