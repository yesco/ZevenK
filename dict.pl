# dict data
our %dict; # word->1 # could be more if...
our %tdict; # asdfg->"word word word"

&readdict();

1;

sub readdict {
    open(DICT, "asdfg.generated.lst") or die "%% No dictionary";
	 
    while(<DICT>) {
	next if /^#/;
	next if /^$/;
	chop();

	if (/^(\S+)\t(.+)$/) {
	    my ($t, $words, $comment) = ($1, $2, $3);
	    #print "TFOO=$t W=$words, C=$comment\n";
	    my $tt = $t;
	    $tt =~ s/[%_]//g;
	    $tdict{$tt} = $words;
	    my @w = split(/[,\s]+/, $words);
	    foreach $v (@w) {
		$dict{$v} = $t;
	    }

	} else {
            print STDERR "%% dict: unparsed: $_\n";
	}
    }

    close(DICT);
}

