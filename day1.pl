#!/usr/bin/perl

use v5.14;

my @calories = ();
my $sum = 0;
while (<>) {
    chomp;
    if (length) {
        $sum += $_;
    } else {
        # say "End of Elf $#calories\nTotal cal: $sum";
        push @calories, $sum;
        $sum = 0;
    }
}

@calories = sort {$b <=> $a} @calories;
say "Highest calorie elf: $calories[0]";


my @top_sums = splice(@calories, 0, 3);
print "Top three elf calories: ";
say(join(" ", @top_sums));

my $top_sum = 0;
map {$top_sum += $_} @top_sums;
say("Sum of top 3: $top_sum");
