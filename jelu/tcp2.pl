use Data::Dumper;

$seq_above = 1000;
$num_seq = 10;

%c=();
while(<>) {
    my $in = $_;
    if (/(\S+)\s+\>\s+(\S+\.53):\s+Flags\s+\[([^\]]+).*seq ([0-9:]+)/go) {
        ($c, $f, $s) = ($1, $3, $4);
        if ($f =~ /S/go) {
            unless (exists($c{$c})) {
                $c{$c}->[0]=0;
            }
            $c{$c}->[1]=$in;
            $c{$c}->[2]=1;
        }
        if ($f =~ /F/go) {
            if ($c{$c}->[0] > $num_seq) {
                $S = "";
                if (exists $c{$c}->[2] and $c{$c}->[2] == 1) {
                    $S = "(S) ";
                }
                print("$c{$c}->[0] $c $S(F)\n");
                print("  ",$c{$c}->[1]);
            }
            delete $c{$c};
        } elsif ($s =~ /([0-9]+):/go) {
            if ($1 > $seq_above) {
                if (exists($c{$c})) {
                    $c{$c}->[0]++;
                } else {
                    $c{$c}->[0]=1;
                    $c{$c}->[2]=0;
                }
                $c{$c}->[1]=$in;
            }
        }
    }
}


foreach $c (keys %c) {
    if ($c{$c}->[0] > $num_seq) {
        $S = "";
        if (exists $c{$c}->[2] and $c{$c}->[2] == 1) {
            $S = " (S)";
        }
        print("$c{$c}->[0] $c$S\n");
        print("  ",$c{$c}->[1]);
    }
}
        
