# reads a sorted "%afd_\tword word word"
# file and optimizes expansion for
# unique words that aren't prefix of others

my $last, $tlast;

while(<>) {
    if (/(%\w+)_/) {
	my $t = $1;

	if ($t =~ /^$tlast/) {
	    # last word is a prefix
	    # - can't optimize
	} else {
	    # not prefix, thus we can
	    # - expand on last letter!
	    $last =~ s/(\S+)_/$1/;
	}	    
	print $last;
	
	$tlast = $t;
	$last = $_;
    } else {
	print STDERR "%% parse error: $_";
    }
}
    
# very last line is not prefix!
$last =~ s/(\S+)_/$1/;
print $last;
