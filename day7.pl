#!/usr/bin/perl

use v5.14;
use Data::Dumper;

my %sizes;
my @cur_dir = ();

sub get_cur_dir {
    return join '/', @_
}

while (<>) {
    chomp;
    if (/^\$ (.*)/) {
        my $cmd_str = $1;
        my ($cmd, $args) = split(/ /,$cmd_str ,2);
        if ($cmd eq 'cd') {
            if ($args eq '..') {
                my $old = get_cur_dir @cur_dir;
                pop @cur_dir;
                my $new = get_cur_dir @cur_dir;
                $sizes{$new} += $sizes{$old};
            } elsif ($args eq '/') {
                splice @cur_dir, 0, $#cur_dir, "";
            } else {
                push @cur_dir, $args;
            }
        } elsif ($cmd eq 'ls') {
            next;
        }
    } elsif (/(\d+) (.+)/) {
        $sizes{get_cur_dir @cur_dir} += $1;
    } elsif (/dir (.+)/) {
        next;
    }
}

while ($#cur_dir) {
    my $old = get_cur_dir @cur_dir;
    pop @cur_dir;
    my $new = get_cur_dir @cur_dir;
    $sizes{$new} += $sizes{$old};
}

my $sum = 0;
while (my ($d, $size) = each %sizes) {
    if ($size <= 100000) {
        $sum += $size;
    }
}

say "Total size: $sum";

my $total = 70000000;
my $req = 30000000;

my $free = $total - $sizes{""};
my $needed = $req - $free;
say "Current Free space: $free";
say "Space needed: $needed";

my $min = $req;

while (my ($d, $size) = each %sizes) {
    if (($size >= $needed) && ($size < $min)) {
        $min = $size;
    }
}

say "Min needed is $min";
