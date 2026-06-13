use v5.38;

## This is being used to see if *all* minimum k values produce disconnects when p divides n.
## That is, we already know that k = n * min(z(p)/p) will produce a disconnect (and is the smallest such k)
## We are now testing whether k = n * z(p)/p (where p divides n) will always be disconnected.

# This has been confirmed, for first 2000 integers.

# More is true : When a k value disconnects a prime, it also disconnects any composites.

## Min K algorithm:
## Sort ratios and primes, to find "dominant prime" of n.
my @R;
open my $f, "<", "pR";
while (<$f>) {
    chomp $_;
    push @R, $_;
}

my @p;
my @r;
foreach my $R (@R) {
    my ($a, $b) = split ',', $R;
    my $k = substr $a, 1;
    my $n = substr $b, 1, -1;
    push @p, $n;
    push @r, $k/$n;
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
#### Primes and Ratios Sorted ####


open my $fh, "<", "composite_connectedness2";
my @line;
while (<$fh>) {
    chomp $_;
    #next if (/graph/);
    push @line, $_;
}
my %h;

for my $line (@line) {
    my ($a, $b) = split 'n: ', $line;
    my $key = substr $a, 3;
    $key = substr $key, 0, -1;
    $b =~ /^(\d+)\s/;
    $key .= "-$1";
    $h{$key} = ($line =~ /connected/)
}

for my $n (1000 .. 2000) {
#for my $n (4 .. 999) {
    # Find primes which divide n:
    my @pdiv;		   # primes which divide n
    my @rdiv;		   # their ratios, r = z(p)/p
    my @kdiv;		   # the associated k-values for n (k = n * r)
    my $prime;
    my $ratio;
    for my $i (0 .. $#p) {
	my $p = $p[$i];
	last if ($p > $n);
	if ($n % $p == 0) {
	    push @pdiv, $p;
	    push @rdiv, $r[$i];
	    push @kdiv, $n*$r[$i];
	}
    }

    ## %h contains connected status for each k.
    ## Keys look like n-k and values are undef (disc) or 1 (conn)
    for my $i (0 .. $#kdiv) {
	my $k = $kdiv[$i];
	my $key = "$k-$n";
	if ($h{$key}) {
	    say "$key was observed connected, but predicted disconnected. $pdiv[$i] divides $n and $k should have disconnected it.";
	}
    }
}
