open(IN, "selfmatch.lst");
$line = 0;
while (<IN>) {
    $line++;

    if (/(\(\w+\))\s(\w+)/) {
	my ($asdfg, $word) = ($1, $2);
	my $len = length($asdfg)-2;
	my $L = ($word =~ /^[\(\)qwertasdfgzxcvb]*$/ ? 'L' : ' ');
	my $R = ($word =~ /^[\(\)yuiophjklnm]*$/ ? 'R' : ' ');

	#my $out = sprintf("%2d %5d $L$R $_", $len, $line);
	chop(); my $out = sprintf("%2d $asdfg %5d $R$L $word $_", $len, $line);	

	if (/\W(\w+) --[, ]*\1\W/) {
	    print $out;
	    print "\n";
	} else {
	    #print "=== $out"
	    print "$out ===\n";
	}
    } else {
	die "%% Fish!\n";
    }
}
close(IN);
