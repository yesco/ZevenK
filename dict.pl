# dict data
our %dict; # word->asdfg
our %tdict; # asdfg->"word word word"
our %udict; # uniquely asdfg
our %fdict; # first word in asdfg list
our @dictwords; # sorted list of all words

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

	    # removing technics
	    my $tt = $t;
	    $tt =~ s/[%_]//g;
	    $tdict{$tt} = $words;

	    my @w = split(/[,\s]+/, $words);
	    $udict{$w[0]} = 1 if 1==scalar @w;	    
	    $fdict{$w[0]} = 1;
	    foreach $v (@w) {
		$dict{$v} = $t;
	    }

	} else {
            print STDERR "%% dict: unparsed: $_\n";
	}
    }

    close(DICT);

    # convenience
    @dictwords = sort keys %dict;
}
