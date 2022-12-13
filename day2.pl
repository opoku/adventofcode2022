#!/usr/bin/perl

use v5.14;

my %value_to_score = (
    'rock' => 1,
    'paper' => 2,
    'scissors' => 3,
    );

my %code_to_value = (
    'A' => 'rock',
    'B' => 'paper',
    'C' => 'scissors',
    'X' => 'rock',
    'Y' => 'paper',
    'Z' => 'scissors',
    );

my %result = (
    'X' => 'lose',
    'Y' => 'draw',
    'Z' => 'win',
    );

my %result_score = (
    'lose' => 0,
    'win' => 6,
    'draw' => 3,
    );

my %defeats = (
    'rock' => 'scissors',
    'scissors' => 'paper',
    'paper' => 'rock',
    );

my %defeated_by = (
    'rock' => 'paper',
    'scissors' => 'rock',
    'paper' => 'scissors',
    );

sub play_score {
    my ($opp, $self) = @_;
    if ($defeats{$opp} eq $self) {
        # you lost
        return 0;
    } elsif ($opp eq $self) {
        # draw
        return 3;
    } else {
        # you won
        return 6;
    }
}

sub self_played_value {
    my ($opp, $res) = @_;

    if ($res eq 'lose') {
        return $defeats{$opp};
    } elsif ($res eq 'draw') {
        return $opp;
    } else {
        return $defeated_by{$opp};
    }
}

sub total_score {
    # $a is opponent
    # $b is you
    my ($a, $b) = @_;
    my $opp = $code_to_value{$a};
    my $self = $code_to_value{$b};

    my $score = play_score ($opp, $self);
    # say "$opp vs $self : $score + $value_to_score{$self}";

    return $value_to_score{$self} + play_score($opp, $self);
}

sub total_score2 {
    # $a is opponent
    # $b is you
    my ($a, $b) = @_;
    my $opp = $code_to_value{$a};
    my $result_round = $result{$b};

    my $self = self_played_value($opp, $result_round);

    my $round_score = $result_score{$result_round};
    # say "$result_round: $opp => $self : $round_score + $value_to_score{$self}";

    return $value_to_score{$self} + $round_score;
}


my $score = 0;

while (<>) {
    chomp;
    my ($a, $b) = split / /;
    $score += total_score2($a, $b);
}

say "Total score: $score";
