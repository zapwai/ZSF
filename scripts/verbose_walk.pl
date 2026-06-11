#!/usr/bin/env perl
use feature qw( signatures say );

## Initial attempt at producing ZSF graphs and finding walks. (Too slow for large n.)

my $k = 3;
my $n = 7;
G($k, $n);

# for my $n (1001 .. 1002) {
#     for my $k (2 .. $n/2 - 1) {
# 	G($k, $n);
#     }
# }

sub V($k, $n) {
    my @l = grep { $k*$_ % $n != 0} (1 .. $n-1);
     say "V: @l";
    return @l;
}

sub E($k, $n, @V) {
     for my $x (1 .. $k - 1) {
     	say $x."a + " . ($k-$x) . "b = 0? (mod n)"
     }
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

sub walk($v, $e) {
    my @V = @$v;
    my @E = @$e;

    my %seen;
    my @P = ($V[0]);
    $seen{$V[0]} = 1;

    do {
	my @new;

	for my $u (@P) {
	    for my $r (@E) {
		my ($a, $b) = @$r;

		if ($a == $u && !$seen{$b}) {
		    $seen{$b} = 1;
		    push @new, $b;
		} elsif ($b == $u && !$seen{$a}) {
		    $seen{$a} = 1;
		    push @new, $a;
		}
	    }
	}

	@P = @new;
    }	while (@P);
    if (keys(%seen) == @V) {
	say "Connected";
    } else {
	say "Disconnected";
    }
}

sub G($k, $n) {
    print "k: $k n: $n ";
    my @V = V($k, $n);
    my @E = E($k, $n, @V);
    walk(\@V, \@E);
}
