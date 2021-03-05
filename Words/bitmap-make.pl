# builds a 3-letter "bitmap"

# tripplets, change may not work
my $len = 3;

my %freq;
$freq{'zzz'} = 99;

$_ = join('', <>);
s/[\n\s\W]+/  /g;
$_ = lc("  $_  ");

for $i (0..length($_)-$len) {
    my $seq = substr($_, $i, $len);
    print "$i:$seq ";
    $freq{$seq}++;
}

print "\n\n";

for $a (' ','a'..'z') {
    for $b (' ', 'a'..'z') {
	for $c (' ', 'a'..'z') {
	    my $n = $freq{"$a$b$c"};
	    next if !$n;
	    print "$a$b$c $n\n";
	}
    }
}

sub find {
    for $i (0..length($_)-$len) {
	my $seq = substr($_, $i, $len);
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
    print "\t\t\t=>$s$a$b","[", join('', @matches), "]\n";

    if ($#xx < $len-1) {
	print "-------------$s$a$b---\n";
	return;
    }
    
    my @res;
    for $c (@matches) {
	my $w = $s.$a.$b.$c;
	print ">$w<\n";
	my @d = enumerate($s.$a, $b, $c, @xx);
	# flatten
	push(@res, @d);
    }
    print "\n\n";
    
    return @res;
}

sub nextchar {
    my ($a, $b, $cc) = @_;
    
    my @res;
    for $c (split('', $cc)) {
	print "$a$b$c\n";
	my $w = "$a$b$c";
	my $n = $freq{$w} + 0;;
	next if !$n;
	# found one more valid char
	print "====$a$b$c====\n";
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

#my $word = '  one  she  ';
my $typed = 'sgd'; 

# require it is complete word
# (i.e. match all typed, "including space")
#my $isword=0;
my $isword=1;

my @rr = asdfg($typed);

print "typed= $typed\n";
print "rr = @rr\n";

push(@rr, ' ', ' ', ' ');
if ($isword) {
    push(@rr, ' ');
}

my @r = enumerate('', ' ', ' ',
		  @rr);
# 3 empty strings at end
#$isword ? ' ' : undefined);
		 
# if one ' ' after last => match so far!
#

print @r;





