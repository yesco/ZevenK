# builds a 3-letter "bitmap"

# Usage:
#   perl bitmap-make.pl -d foo.lst bar.dict file.txt
#
# will read two dictionaries and then analyze and try to match every word in the text file

# this was an experiment to see if
# we could train a bitmap to guess
# the words that written, and it does
# find the words if it was trained
# on them, or similar enough, however,
# it finds, of course, also,
# lot of garbage

# IDEAS:
# - use char frequencey (not really bitmap, for ranking)
# - use 4 char sequences?
# - still useful, as it limits number of words needed to be looked up?
# - unless dictionary entries are sorted/stored with the the one hand mapping
# - it does get rather big

# tripplets, change may not work
my $CHARLEN = 3;

my %freq;
my %dict; # word->frequency

my $nextisdict = 0;
for $f (@ARGV) {
    if ($f eq '-d') {
	$nextisdict = 1;
	next;
    }

    $nextisdict = 1 if $f =~ /dict/;
    
    if ($nextisdict) {
	print STDERR "%% Reading dict file: $f\n";
	readdict($f);
    } else {
	print STDERR "%% Reading text file: $f\n";
	readfile($f);
    }

    $nextisdict = 0;

    #print "DICT are=",$dict{"are"},"\n";
    #print "DICT not=",$dict{"not"},"\n";
}

# print bitsummary not using $CHARLEN
for $a (' ','a'..'z') {
    for $b (' ', 'a'..'z') {
	for $c (' ', 'a'..'z') {
	    for $d (' ', 'a'..'z') {
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

    my $txt = join('', <IN>);
    $txt =~ s/[\n\s\t\W]+/  /g;
    $txt = lc("  $txt  ");

    # for all seq of length $CHARLEN inc count
    for $i (0..length($txt)-$CHARLEN) {
	my $seq = substr($txt, $i, $CHARLEN);
	#print "$i:$seq ";
	$freq{$seq}++;
    }
    #print "\n\n";
    close(IN);
}

# word\nword... | word[\s\t]+freq\n...
sub readdict {
    my ($f) = @_;
    open(IN, $f) or die "No file: $f\n";

    my $txt;
    while($txt = <IN>) {
	chop($txt);
	# extract frequency
	my $f = 1;
	$f = +$1 if $txt =~ s/[\t\s]+(\d+)//;
	$dict{$txt} = $f;
	
	$txt = "  $txt  "; # $CHARLEN?
	#print $txt, "\n";
	
	for $i (0..length($txt)-$CHARLEN) {
	    my $seq = substr($txt, $i, $CHARLEN);
	    #print "$i:$seq ";
	    $freq{$seq} += $f;
	}
    }
    #print "\n\n";
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
    my ($freq, $s, $a, $b, @xx) = @_;

    my @matches = nextchar($a, $b, shift(@xx));
    #print "\t\t\t=>$s$a$b","[", join('', @matches), "]\n";

    if ($#xx < $CHARLEN-1) {
	print "-------------$s$a$b--- $freq\n";
	return "$freq $s$a$b";
    }
    
    my @res;
    while (@matches) {
	my $c = shift(@matches);
	my $fr = shift(@matches);
	my $w = $s.$a.$b.$c;
	#print ">$w<\n";
	my @d = enumerate($freq+$fr,$s.$a, $b, $c, @xx);
	# flatten
	push(@res, @d);
    }
    #print "\n\n";
    
    return @res;
}

# returns next valid char with freq
# returns ('c', 47, 'd', 99...)
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
	# don't give points for partials
	$n = 0 if $w =~ / /;
	push(@res, $c, $n);
    }
    return @res;
}

print 'x' x 35, "\n";

#test('sgd');

while(<STDIN>) {
    chop();
    test($_, 1);
}

sub test {
    my ($typed, $fullword) = @_;

    my @rr = asdfg($typed);

    print "typed= $typed\n";
    print "rr = @rr\n";

    push(@rr, ' ', ' ', ' ');
    if ($fullword) {
	push(@rr, ' ');
    }

    my @r = enumerate(0, '', ' ', ' ',
		      @rr);
    #@r = sort { $a <=> $b; } @r;
    sub dic {
	my ($l) = @_;
	my $w = '';
	my $f = 1;
	$w = $1 if $l =~ /([a-z]+)/i;
	$f = +$1 if $l =~ /(\d+)/;
	my $df = $dict{$w};
	return $df if $df;
	return $f/10000;
    }

    @r = sort { dic($a) <=> dic($b); } @r;
    
    #@r = sort { $dict{$a}."x".$a <=> $dict{$b}."x".$b; } @r;
    
    print "WORDS------\n";
    if (1) {
	for $l (@r) {
	    my $w = '';
	    my $f = 1;
	    $w = $1 if $l =~ /([a-z]+)/i;
	    $f = +$1 if $l =~ /(\d+)/;
	    my $df = $dict{$w};
	    print "$l ($df)\n";
	}
    } else {
	print join("\n", @r);
    }
    
    print "\n----- $ typed\n";
}

