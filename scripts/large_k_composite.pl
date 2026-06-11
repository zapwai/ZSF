#!/usr/bin/env perl

# Checking higher values of k for connectedness.
# (We print k,n and whether it's connected or not.)
# We use data from min_k_composite in the K_min function below.
# All k values considered, above the minimal disconnection value and below n.

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

	if (connected($k, $n, @V)) {
	    say "k: $k n: $n connected";
	} else {
            say "k: $k n: $n DISCONNECTED";
        }
    }

    #    say "No disconnected graph found";
}

sub K_min($n) {
    my @R;
    push @R, [2, 3];
    push @R, [2, 4];
    push @R, [3, 5];
    push @R, [5, 7];
    push @R, [8, 11];
    push @R, [9, 13];
    push @R, [14, 17]; 
    push @R, [16, 19]; 
    push @R, [21, 23]; 
    push @R, [24, 29]; 
    push @R, [28, 31]; 
    push @R, [33, 37]; 
    push @R, [35, 41]; 
    push @R, [40, 43]; 
    push @R, [45, 47]; 
    push @R, [48, 53]; 
    push @R, [56, 59]; 
    push @R, [57, 61]; 
    push @R, [63, 67]; 
    push @R, [69, 71]; 
    push @R, [68, 73]; 
    push @R, [77, 79]; 
    push @R, [74, 83]; 
    push @R, [83, 89]; 
    push @R, [92, 97];

    push @R, [91, 101];
    push @R, [96, 103];
    push @R, [104, 107];
    push @R, [101, 109];
    push @R, [110, 113];
    push @R, [120, 127];
    push @R, [128, 131];
    push @R, [134, 137];
    push @R, [136, 139];
    push @R, [144, 149];
    push @R, [147, 151];
    push @R, [153, 157];
    push @R, [160, 163];
    push @R, [165, 167];
    push @R, [163, 173];
    push @R, [168, 179];
    push @R, [177, 181];
    push @R, [189, 191];
    push @R, [183, 193];
    push @R, [192, 197];
    push @R, [197, 199];
    push @R, [208, 211];
    push @R, [216, 223];
    push @R, [218, 227];
    push @R, [225, 229];
    push @R, [230, 233];
    push @R, [237, 239];
    push @R, [234, 241];
    push @R, [245, 251];
    push @R, [254, 257];
    push @R, [261, 263];
    push @R, [259, 269];
    push @R, [267, 271];
    push @R, [273, 277];
    push @R, [272, 281];
    push @R, [274, 283];
    push @R, [283, 293];
    push @R, [298, 307];
    push @R, [309, 311];
    push @R, [308, 313];
    push @R, [312, 317];
    push @R, [328, 331];
    push @R, [327, 337];
    push @R, [344, 347];
    push @R, [345, 349];
    push @R, [350, 353];
    push @R, [357, 359];
    push @R, [359, 367];
    push @R, [369, 373];
    push @R, [376, 379];
    push @R, [381, 383];
    push @R, [384, 389];
    push @R, [393, 397];
    push @R, [392, 401];
    push @R, [402, 409];
    push @R, [416, 419];
    push @R, [413, 421];
    push @R, [426, 431];
    push @R, [428, 433];
    push @R, [429, 439];
    push @R, [440, 443];
    push @R, [440, 449];
    push @R, [447, 457];
    push @R, [451, 461];
    push @R, [456, 463];
    push @R, [458, 467];
    push @R, [477, 479];
    push @R, [480, 487];
    push @R, [480, 491];
    push @R, [494, 499];
    push @R, [501, 503];
    push @R, [499, 509];
    push @R, [515, 521];
    push @R, [514, 523];
    push @R, [533, 541];
    push @R, [543, 547];
    push @R, [552, 557];
    push @R, [554, 563];
    push @R, [560, 569];
    push @R, [564, 571];
    push @R, [572, 577];
    push @R, [578, 587];
    push @R, [590, 593];
    push @R, [597, 599];
    push @R, [594, 601];
    push @R, [600, 607];
    push @R, [609, 613];
    push @R, [614, 617];
    push @R, [615, 619];
    push @R, [628, 631];
    push @R, [632, 641];
    push @R, [634, 643];
    push @R, [645, 647];
    push @R, [648, 653];
    push @R, [648, 659];
    push @R, [657, 661];
    push @R, [663, 673];
    push @R, [667, 677];
    push @R, [679, 683];
    push @R, [685, 691];
    push @R, [696, 701];
    push @R, [701, 709];
    push @R, [717, 719];
    push @R, [720, 727];
    push @R, [720, 733];
    push @R, [733, 739];
    push @R, [741, 743];
    push @R, [749, 751];
    push @R, [753, 757];
    push @R, [755, 761];
    push @R, [762, 769];
    push @R, [763, 773];
    push @R, [778, 787];
    push @R, [787, 797];
    push @R, [800, 809];
    push @R, [808, 811];
    push @R, [816, 821];
    push @R, [816, 823];
    push @R, [824, 827];
    push @R, [825, 829];
    push @R, [837, 839];
    push @R, [840, 853];
    push @R, [840, 857];
    push @R, [856, 859];
    push @R, [861, 863];
    push @R, [870, 877];
    push @R, [875, 881];
    push @R, [879, 883];
    push @R, [885, 887];
    push @R, [904, 907];
    push @R, [908, 911];
    push @R, [914, 919];
    push @R, [923, 929];
    push @R, [930, 937];
    push @R, [931, 941];
    push @R, [944, 947];
    push @R, [950, 953];
    push @R, [960, 967];
    push @R, [968, 971];
    push @R, [974, 977];
    push @R, [981, 983];
    push @R, [987, 991];
    push @R, [984, 997];
    

    my @p;
    my @r;
    foreach my $R (@R) {
	my @a = @$R;
	my ($p, $r) = ($a[1], $a[0]/$a[1]);
	push @p, $p;
	push @r, $r;
    }

    my $cnt = 1;
    while ($cnt > 0) {
	$cnt = 0;
	for my $i (0 .. $#R - 1) {
	    my $r1 = $r[$i];
	    my $r2 = $r[$i + 1];
	    if ($r1 > $r2) {
		$cnt++;
		$r[$i] = $r2;
		$r[$i + 1] = $r1;
		my $tmp = $p[$i];
		$p[$i] = $p[$i + 1];;
		$p[$i + 1] = $tmp;
	    }
	}
    }

    my $r;
    for my $i (0 .. $#p) {
	if ($n % $p[$i] == 0) {
	    $r = $r[$i];
	    last;
	}
    }
    return $n * $r + 1;
}

$| = 1;
for my $n (301 .. 999) {
    my $K = K_min($n);
    G_Disc_Finder($K, $n);
}

