#!/usr/bin/perl

use v5.14;
use POSIX qw(floor);
use Data::Dumper;

my %monkeys;

my $current_monkey;

while (<>) {
    chomp;
    if (/^Monkey (\d+):/) {
        # new monkey
        $current_monkey = $1;
    } elsif (/^$/) {
        next;
    } elsif (/Starting items: ([,\d\s]+)/) {
        my @items = split /, /, $1;
        $monkeys{$current_monkey}{'items'} = \@items;
    } elsif (/Operation: new = (old|\d+) (\*|\+) (old|\d+)/) {
        my $op_fun;
        my ($p1, $op, $p2) = ($1, $2, $3);
        if ($op eq '*') {
            $op_fun = sub {
                my $old = shift;
                my $res = 1;
                if ($p1 eq 'old') {
                    $res *= $old;
                } else {
                    $res *= $p1;
                }

                if ($p2 eq 'old') {
                    $res *= $old;
                } else {
                    $res *= $p2;
                }
                return $res;
            }
        } elsif ($op eq '+') {
            $op_fun = sub {
                my $old = shift;
                my $res = 0;
                if ($p1 eq 'old') {
                    $res += $old;
                } else {
                    $res += $p1;
                }

                if ($p2 eq 'old') {
                    $res += $old;
                } else {
                    $res += $p2;
                }
                return $res;
            }
        }

        $monkeys{$current_monkey}{'op_fun'} = $op_fun;
    } elsif (/Test: divisible by (\d+)/) {
        my $divisor = $1;

        my $true_monkey;
        my $false_monkey;
        while (<>) {
            if (/If true: throw to monkey (\d+)/) {
                $true_monkey = $1;
            } elsif (/If false: throw to monkey (\d+)/) {
                $false_monkey = $1;
            } else {
                last;
            }
        }
        $monkeys{$current_monkey}{'divisor'} = $divisor;
        $monkeys{$current_monkey}{'true_monkey'} = $true_monkey;
        $monkeys{$current_monkey}{'false_monkey'} = $false_monkey;

        my $next_monkey = sub { my $a = shift; return $true_monkey if (0 == ($a % $divisor)); return $false_monkey; };
        $monkeys{$current_monkey}{'next_monkey_fn'} = $next_monkey;
    }
}
my $mod_all = 1;
for my $m_info (values %monkeys) {
    $mod_all *= $m_info->{'divisor'};
}
say "Mod all: $mod_all";

my @monkeys_order = sort keys %monkeys;
my @monkey_eval_count;
for (1..10000) {

    # if (0 == $_ % 20) {
    #     say $_;
    # }
    for my $cur_monkey (@monkeys_order) {
        my $m = $monkeys{$cur_monkey};
        while (scalar @{ $m->{'items'} }) {
            my $worry = shift @{ $m->{'items'} };
            my $w1 = $m->{'op_fun'}->($worry);
            # my $w2 = floor($w1 / 3);
            my $w2 = $w1 % $mod_all;
            # my $w2 = $w1;
            my $next_monkey = $m->{'next_monkey_fn'}->($w2);

            # if ($next_monkey == $m->{'true_monkey'}) {
            #     # w2 is a perfect divisor
            #     my $divisor = $m->{'divisor'};
            #     say "Perfect divisor: $w2 / $divisor";
            #     $w2 = int($w2 / $divisor);
            # }
            push @{ $monkeys{$next_monkey}{'items'} }, $w2;
            $monkey_eval_count[$cur_monkey]++;
        }
    }
}

sub dump_monkey_items {
    for my $m (sort keys %monkeys) {
        say "Monkey $m: ". join(',', @{ $monkeys{$m}{'items'} }) . ". Evaluated items $monkey_eval_count[$m] times";
    }
    say "";
}

my @sorted = sort {$b <=> $a} @monkey_eval_count;
my $biz = $sorted[0] * $sorted[1];

dump_monkey_items();

say "Monkey business: $biz";

# say Dumper \%monkeys, \@monkey_eval_count;
