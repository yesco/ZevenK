# Reads from stdin/files creating an asdfg
# matching file.

# duplicates will print complains on STDOUT



# process lines

# word: is first [a-z]+ not enclosed in
# parenthesis and lower case letters
# type: is inside parenthesis \(\w+\)
# 
# Example:
#   3 (aag)   599    pay (aag) pay -- pay,,, pan, pat,,,, apt,,
# ==> word: pay, type: aag

my %have;

# <> will read stdin and files given
while(<>) {
    if (/\((\w+)\).*?(?<![\(a-z])([a-z]+)/) {
	my ($t, $w) = ($1, $2);
	#print "$t => $w -- $_";
	if ($have{$t}) {
	    print STDERR "%% duplicate: $_";
	    next;
	}

	$have{$t} = 1;
	# TODO: find and list alternatives
	print "$t\t$w\n";
    } else {
	print STDERR "%% not parsed: $_\n";
    }
}

