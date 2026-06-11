#!/usr/bin/env perl

## This is the min_k script but only for primes.
## This creates a list of primes, then runs the script between $min and $max provided below.
## It uses nine forks to speed up computation.

use feature qw( signatures say );

sub gcd ($a, $b) {
    ($a, $b) = (abs($a), abs($b));

    while ($b) {
        ($a, $b) = ($b, $a % $b);
    }

    return $a;
}

sub invmod ($a, $n) {

    my ($t, $newt) = (0, 1);
    my ($r, $newr) = ($n, $a % $n);

    while ($newr) {
        my $q = int($r / $newr);

        ($t, $newt) = ($newt, $t - $q * $newt);
        ($r, $newr) = ($newr, $r - $q * $newr);
    }

    return undef if $r != 1;

    $t %= $n;
    $t += $n if $t < 0;

    return $t;
}

sub V ($k, $n) {
    return grep { ($k * $_) % $n != 0 } (1 .. $n - 1);
}

#
# Returns true iff there exists x with
#
#     1 <= x < k
#
# satisfying
#
#     x(a-b) = -kb (mod n)
#
sub admissible_x_exists ($a, $b, $k, $n) {

    my $m = $a - $b;
    my $c = -$k * $b;

    my $d = gcd($m, $n);

    return 0 if $c % $d;

    my $mp = int($m / $d);
    my $cp = int($c / $d);
    my $np = int($n / $d);

    my $inv = invmod($mp, $np);

    my $x0 = ($cp * $inv) % $np;
    $x0 += $np if $x0 < 0;

    #
    # Solutions are x = x0 + t*np
    #

    if ($x0 == 0) {
        #
        # Smallest positive solution
        #
        $x0 = $np;
    }

    return 1 if $x0 < $k;

    return 0;
}

#
# Edge exists iff NO admissible x exists.
#
sub adjacent ($a, $b, $k, $n) {
    return !admissible_x_exists($a, $b, $k, $n);
}

sub connected ($k, $n, @V) {

    return 1 if @V <= 1;

    my %seen;
    my @queue = ($V[0]);

    $seen{$V[0]} = 1;

    while (@queue) {

        my $u = shift @queue;

        for my $v (@V) {

            next if $u == $v;
            next if $seen{$v};

            if (adjacent($u, $v, $k, $n)) {

                $seen{$v} = 1;
                push @queue, $v;
            }
        }
    }

    return (keys %seen) == @V;
}

sub G_Disc_Finder ($K, $n) {

    for my $k ($K .. $n - 1) {

        my @V = V($k, $n);

        unless (connected($k, $n, @V)) {
            say "k: $k n: $n";
            return;
        }
    }

    say "No disconnected graph found";
}

$| = 1;
my @x = (3 .. 10000);

my @p = (2);
for my $x (@x) {
    my $flag = 0;
    for my $p (@p) {
	last if ($p*$p > $x);
	if ($x % $p == 0) {
	    $flag = 1;
	    last;
	}
    }
    push @p, $x unless ($flag);
}


# Fork Time
use Parallel::ForkManager;

my $workers = 9;
my $pm = Parallel::ForkManager->new($workers);

my $min = 1100;
my $max = 2000;
my $chunk = int(($max + $workers - 1) / $workers);

for my $worker (0 .. $workers - 1) {

    $pm->start and next;	# parent continues loop

    my $start = $min + $worker * $chunk + 1;
    my $end   = $min + ($worker + 1) * $chunk;
    $end = $max if $end > $max;

    for my $n (@p) {
	next if ($n < $start);
	last if ($n > $end);
	my $K = ($n+1)/2;
	G_Disc_Finder($K, $n);
    }

    $pm->finish;		# child exits
}

$pm->wait_all_children;

