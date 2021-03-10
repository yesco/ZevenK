my $word = $ARGV[0];

my $verbose = 0;

if ($word) {
    $verbose = 2;
    one($word);
} else {
    $verbose = 1;
    $verbose = 0;
    
    print STDERR ": match .*\n";
    print STDERR ". match one char\n";
    print STDERR "I:N start and and with i and n\n";

    print STDERR "\n>" if $verbose;
    my $wn = 0;
    while ($word = <>) {
	chop($word);
	$word =~ s/\W+/ /g; # remove other
	foreach $w (split(/\s+/, $word)) {
	    if ($wn % 30 == 0 && !$verbose) {
		print STDERR "** $wn $word\n";
	    }
	    $wn++;
	    one($w);
	}
	print STDERR "\n>" if $verbose;
    }
}

sub one {
    my ($word) = @_;

    # sanitize
    $word =~ s/[\(\)\,]//g;

    if ($verbose) {
	print "------------------------------$word\n";
    }

    my $wre = '';
    my $type = '';
    foreach $w (split('', $word)) {
	my $v = $w;
	#print "$w\n";
	my $c = '';
	$c = 'a' if $w =~ /[qazp]/;
	$c = 's' if $w =~ /[wsxol]/;
	$c = 'd' if $w =~ /[edcik]/;
	$c = 'f' if $w =~ /[rfvujm]/;
	$c = 'g' if $w =~ /[tgbyhn]/;

	$v = '[qazp]' if $w =~ /[qazp]/;
	$v = '[wsxol]' if $w =~ /[wsxol]/;
	$v = '[edcik]' if $w =~ /[edcik]/;
	$v = '[rfvujm]' if $w =~ /[rfvujm]/;
	$v = '[tgbyhn]' if $w =~ /[tgbyhn]/;

	# regexp shortcuts
	$v = lc($w) if $w eq uc($w);
	$v = '.+' if $w eq ':';
	$v = '.+' if $w eq '-';
	$v = '.' if $w eq '.';
	$v = '*' if $w eq '*';
	$v = '[' if $w eq '[';
	$v = ']' if $w eq ']';
	
	next if $v =~ /[\(\)]/;
	#print "==>$v\n";
	$wre .= $v;
	$type .= $c || $v;
    }

    if ($verbose) {
	print "--WORDRE: '$type' || $wre\n"
    } else {
	print "($type) $word --";
    }

    search($word, $wre);
}

sub search {
    my ($word, $wre, $max, $lns) = @_;
    $max = 10 if !$max;
    $lns = 10000 if !$lns;
    
    open(IN, "count_1w.txt") || die "No file";

    my $line = 0;
    my $n = 0;
    while(<IN>) {
	if ($line && $line % 1000==0) {
	    print "," unless $verbose;
	}
	
        $line++;
	last if $line > $lns;

	chop;
	my ($w, $f) = split('\t', $_);
	
	#print "$w $wre\n";
	next unless $w =~/^$wre$/;
    
	$n++;
	if ($verbose) {
	    print "$line\t$f\t$w\n";
	} else {
	    print " $w";
	}
	
	last if $n >= $max;
    }
    print "\n";

    close(IN);
}
