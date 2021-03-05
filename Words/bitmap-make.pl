# builds a 3-letter "bitmap"

# tripplets, change may not work
my $CHARLEN = 3;

my %freq;


for $f (@ARGV) {
    print STDERR "%% Reading file: $f\n";
    readfile($f);
}

# print bitsummary not using $CHARLEN
for $a (' ','a'..'z') {
    for $b (' ', 'a'..'z') {
	for $c (' ', 'a'..'z') {
	    for $c (' ', 'a'..'z') {
		my $n = $freq{"$a$b$c$d"};
		next if !$n;
		print "$a$b$c$d $n\n";
	    }
	}
    }
}

sub readfile {
    my ($f) = @_;
    open(IN, $f) or die "No file: $f\n";

    my $txt = join('', <>);
    $txt =~ s/[\n\s\W]+/  /g;
    $txt = lc("  $txt  ");

    # for all seq of length $CHARLEN inc count
    for $i (0..length($txt)-$CHARLEN) {
	my $seq = substr($txt, $i, $CHARLEN);
	print "$i:$seq ";
	$freq{$seq}++;
    }
    print "\n\n";
    close(IN);
}


sub find {
    for $i (0..length($_)-$CHARLEN) {
	my $seq = substr($_, $i, $CHARLEN);
	print "$i:$seq ";
	$freq{$seq}++;
    }
}

sub asdfg {
    my ($word) = @_;
    my @c = split('', $word);
    my @rr = ();
    for $a (@c) {
	my $r;
	$r = 'qazp' if $a =~ /[qazp]/;
	$r = 'wsxol' if $a =~ /[wsxol]/;
	$r = 'edcik' if $a =~ /[edcik]/;
	$r = 'rfvujm' if $a =~ /[rfvujm]/;
	$r = 'tgbyhn' if $a =~ /[tgbyhn]/;
	$r = ' ' if $a =~ / /;
	push(@rr, $r) if $r;;
    }
    return @rr;
}

sub enumerate {
    my ($s, $a, $b, @xx) = @_;

    my @matches = nextchar($a, $b, shift(@xx));
    #print "\t\t\t=>$s$a$b","[", join('', @matches), "]\n";

    if ($#xx < $CHARLEN-1) {
	print "-------------$s$a$b---\n";
	return;
    }
    
    my @res;
    for $c (@matches) {
	my $w = $s.$a.$b.$c;
	#print ">$w<\n";
	my @d = enumerate($s.$a, $b, $c, @xx);
	# flatten
	push(@res, @d);
    }
    #print "\n\n";
    
    return @res;
}

sub nextchar {
    my ($a, $b, $cc) = @_;
    
    my @res;
    for $c (split('', $cc)) {
	#print "$a$b$c\n";
	my $w = "$a$b$c";
	my $n = $freq{$w} + 0;;
	next if !$n;
	# found one more valid char
	#print "====$a$b$c====\n";
	push(@res, $c);
    }
    return @res;
}

sub matches {
    my (@xx) = @_;
    
    my @res;
    for $a (split('', @xx[0])) {
        for $b (split('', @xx[1])) {
	    for $c (split('', @xx[2])) {
		print "$a$b$c\n";
		my $w = "$a$b$c";
		my $n = $freq{$w} + 0;;
		next if !$n;
		# found one more valid char
		print "====$a$b$c====\n";
		push(@res, $c);
	    }
	}
    }
    return @res;
}
    
print 'x' x 35, "\n";

test('sgd');




sub test {
    my ($typed, $fullword) = @_;

    my @rr = asdfg($typed);

    print "typed= $typed\n";
    print "rr = @rr\n";

    push(@rr, ' ', ' ', ' ');
    if ($isword) {
	push(@rr, ' ');
    }

    my @r = enumerate('', ' ', ' ',
		  @rr);
    print "WORDS: @r\n";
}

