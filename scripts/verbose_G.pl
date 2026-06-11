use v5.38;

# First script, printing only vertices and edges of a ZSF graph for given k, n.

sub V($k, $n) {
    my @l = grep { $k*$_ % $n != 0} (1 .. $n-1);
    say "V: @l";
    return @l;
}

sub E($k, $n, @V) {
    # for my $x (1 .. $k - 1) {
    # 	say $x."a + " . ($k-$x) . "b = 0? (mod n)"
    # }
    my @E;
    for my $i (0 .. $#V - 1) {
	my $a = $V[$i];
	for my $j ($i + 1 .. $#V) {
	    my $b = $V[$j];
	    my $flag = 0;
	    for my $x (1 .. $k - 1) {
		my $val = $x*$a + ($k-$x)*$b;
		if ($val % $n == 0) {
		    $flag = 1;
		    last;
		}
	    }
	    push @E, [$a, $b] unless ($flag);
	}
    }
    say "E: ";
    for (@E) {
	say "\t@$_";
    }
    return @E;
}    

sub G($k, $n) {
    say "k: $k n: $n";
    my @V = V($k, $n);
    my @E = E($k, $n, @V);
}

my $k = 3;
my $n = 7;
G($k, $n);
