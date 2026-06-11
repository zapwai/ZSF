#!/usr/bin/env perl
## Given n, this script computes the smallest k (k >= n/2) for which the ZSF graph is disconnected.

## Thanks to ChatGPT for the gcd method. (This is faster than my global computation of edges approach.)

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

print "Input n: ";

my $n = <STDIN>;
chomp $n;

exit unless $n =~ /^\d+$/;

my $K = ($n % 2 == 0)
    ? $n / 2
    : ($n + 1) / 2;

G_Disc_Finder($K, $n);


#for my $n (3 .. 100) {
#    my $K = ($n % 2 == 0)
#	? $n / 2
#	: ($n + 1) / 2;
#
#    G_Disc_Finder($K, $n);
#}
