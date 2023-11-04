use Data::Dumper;

%l=();
%c=();
while(<>) {
    my $in = $_;
    if (/(\S+)\s+\>\s+(\S+\.53):\s+Flags\s+\[([^\]]+).*seq ([0-9:]+)/go) {
        ($c, $f, $s) = ($1, $3, $4);
        if ($f =~ /F/go) {
            if ($c{$c} > 1) {
                print("$c{$c} $c (F)\n");
                print("  ",$l{$c});
            }
            delete $c{$c};
            delete $l{$c};
        } elsif ($s =~ /([0-9]+):/go) {
            if ($1 > 1000) {
                if (exists($c{$c})) {
                    $c{$c}++;
                } else {
                    $c{$c}=1;
                }
                $l{$c}=$in;
            }
        }
    }
}


foreach $c (keys %c) {
    if ($c{$c} > 1) {
        print("$c{$c} $c\n");
        print("  ",$l{$c});
    }
}
        
