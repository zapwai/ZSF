use v5.38;

## This is used to supply (n-k) difference and (k/n) ratio data. (Text processing)

my $f = "primes";
my $fh;
open $fh, "<", $f;
say "(k,n) -> Diff & Ratio";
while (<$fh>) {
    chomp $_;
    next if ($_ =~ /graph/);
    my ($a, $n) = split 'n: ', $_;
    my $k = substr($a, 3, -1);
    my $d = $n - $k;
    my $r = sprintf("%.5f", $k/$n);
    my $s = ($d < 10) ? " " : "";
    say "($k, $n) -> d:$d$s r:$r";
    #say "[$k, $n]"; # For processing min_k_primes data -> K_min function
}
