use v5.38;

# disconnect_predictor was used to see if *all* minimum k values produce disconnects when p divides n.
## That is, we already know that k = n * min(z(p)/p) will produce a disconnect (and is the smallest such k)
## We are now testing whether k = n * z(p)/p (where p divides n) will always be disconnected.
# It was confirmed for the first 2000 integers.

# More is true : When a k value disconnects a prime, it also disconnects any composites.
# (Likely true for powers of primes as well.)

# e.g. 1053 = 13*3^4. The disconnects for 13 are 9 (the min), 11, and 12 (but not 10).
# Scaling n = 1053 by the ratios 9/13, 11/13, and 12/13 will produce k-values which disconnect G_n.
# Scaling n = 1053 by the ratio 10/13 will yield a k-value which connects G_n.
# All powers of 3 disconnect everywhere above their minimal disconnect value.
# e.g. 9 disconnects not just on 6, but also on 7 and 8.
# It therefore leads to disconnecting k-values for n = 1053 of k = 7/9 * n and 8/9 * n in addition to 6/9 * n.
# (The same is true for 27 and 81 - they lead to 8 + 26 more disconnecting k-values.)
# We should expect 29 disconnects - 3 from 13 and 26 from 81 (the largest power of 3)
# (This is what happens)

# A smaller example:
# 255 = 3*5*17 has 6 disconnects.
# They come from 170 (255 * 3/5), 210 (255 * 2/3), 210 (255 * 14/17), as well as the other disconnects coming from 5 and 17.
# In addition to k = 14, n = 17 disconnects on k = 15 and k = 16. (255 * 15/17 = 225, and 255 * 16/17 = 240)
# n = 5 disconnects on k = 4 as well. (255 * 4/5 = 204)
# These are the disconnect values for n = 255.
    
# This script verifies this for the first 2000 integers.


my @line;
open my $fh, "<", "composite_connectedness";
while (<$fh>) {
    chomp $_;
    push @line, $_;
}
close $fh;
open $fh, "<", "composite_connectedness2";
while (<$fh>) {
    chomp $_;
    push @line, $_;
}
close $fh;
my %h;			  # $h{"k-n"} = 2 if disconnected, 1 otherwise
for my $line (@line) {
    my ($a, $b) = split 'n: ', $line;
    my $key = substr $a, 3;
    $key = substr $key, 0, -1;
    $b =~ /^(\d+)\s/;
    $key .= "-$1";
    if ($line =~ /DISCONNECTED/) {
	$h{$key} = 2;
    } else {
	$h{$key} = 1;
    }
}

# Generate primes
my @x = (2 .. 2000);
my @p = (2);
for my $x (@x) {
    my $flag = 0;
    for my $p (@p) {
	last if ($p > $x);
	if ($x % $p == 0) {
	    $flag = 1;
	    last;
	}
    }
    push @p, $x unless ($flag);
}
# Hash lookup for primes
my %is_prime = map { $_ => 1 } @p;

#for my $n (3 .. 2000) {
for my $n (1081 .. 1081) {
    next if ($is_prime{$n});
    # Factorization of the n
    my %f;
    my $x = $n;
    for my $p (@p) {
	while ($x % $p == 0) {
	    $x /= $p;
	    $f{$p}++;
	}
	last if ($x == 1);
    }

    my @factor;
    for my $k (keys %f) {
	my $factor = $k**$f{$k};
	push @factor, $factor;
    }
    say "@factor";
    # Predicted Disconnection K-Values for n
    my @predictor;

    ## Fix this. Replace n with the factor.
    for my $f (@factor) {
	my $least_k = ($f % 2 == 0) ? $f / 2 : ($f + 1) / 2;
	my $found_first = 0; # Minimal Disconnect Value was not included, we have to add it for each factor.
	for my $i ($least_k .. $f - 1) {
	    my $key = "$i-$f";
	    if ($h{$key}) {
		unless ($found_first == 1) {
		    my $first = $i-1;
		    my $r = $first / $f;
		    my $k = $n * $r;
		    push @predictor, $k;
		    $found_first = 1;
		}
		if ($h{$key} == 2) {
		    my $r = $i/$f;
		    my $k = $n * $r;
		    push @predictor, $k;
		}
	    }
	}
    }
    # n = 3 is not included in the composite list, so r = 2/3 is never included. We fix this here.
    for my $f (@factor) {
	if ($f == 3) {
	    my $r = 2/3;
	    my $k = $n * $r;
	    push @predictor, $k;
	    last;
	}
    }
    say "@predictor";
    my %pr = map {$_ => 1} @predictor;

    # Observed Disconnection K-Values for n
    my @observed;
    my $least_k = ($n % 2 == 0) ? $n / 2 : ($n + 1) / 2;
    for my $i ($least_k .. $n - 1) {
	my $key = "$i-$n";
	if ($h{$key}) {
	    # Minimal Disconnection Value was not included in the connectedness list. If list is empty, add this boundary entry.
	    if (@observed == 0) {
		my $first = $i-1;
		my $r = $first / $n;
		my $k = $n * $r;
		push @observed, $k;
	    }
	    if ($h{$key} == 2) {
		my $r = $i/$n;
		my $k = $n * $r;
		push @observed, $k;
	    }
	}
    }

    for my $obs (@observed) {
	say "$obs was observed as a disconnect, but was not predicted for $n." unless ($pr{$obs});
    }
    
}
