use Storable;

$C = retrieve('tcp.state');
defined($C) || $C = \%{};

while(<>){
    if (/(\S+)\s+\>\s+(\S+):\s+Flags\s+\[([^\]]+)/go){
	    #print $1," ",$3,"\n";
	    ($c,$f)=($1,$3);
	    if ($f =~ /S/go) {
		    if (exists $C->{$c}) {
			    print "o ",$c," ",$C->{$c},"\n";
		    }
		    $C->{$c}="S";
	    } elsif ($f =~ /F/go) {
		    if (exists $C->{$c} && $C->{$c} == "S") {
			    delete $C->{$c};
		    } else {
			    $C->{$c}="F";
		    }
	    } elsif ($f =~ /P/go) {
		    unless (exists $C->{$c}) {
			    $C->{$c}="P";
		    }
	    } elsif ($f =~ /R/go) {
		    delete $C->{$c};
	    }
    }
}

foreach $k (keys %c){
	print $k," ",$c{$k},"\n";
}
