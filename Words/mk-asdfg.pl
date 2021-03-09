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
    # skip commented out
    next if /^#/;
    
    if (/\((\w+)\).*?--(.*)/) {
	my ($t,$rest) = ($1, $2);
	my @words = ($rest =~ m/(?<![\(a-z])([a-z]+)/ig);
	# make it match only full words
	# and only when typing space
	# TODO: for unique prefixes
	# can expand directly without _!
	$t = "%".$t."_";

	#print "$t\t@words -- $_";
	if ($have{$t}) {
	    print STDERR "%% conflict for '%t} in $ARGV: $_";
	    next;
	}

	$have{$t} = 1;
	# TODO: find and list alternatives
	print "$t\t@words\n";
    } else {
	print STDERR "%% not parsed: $_\n";
    }
}

