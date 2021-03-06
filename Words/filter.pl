# Reads from stdin only allowing words
# that are in the dictionary.
#
# - Non-(recognized)-words are printed
# prefixed with %%.
# - Dictionary file must be given
# as argument w lines: "^word(|\tfreq)$"

# reead dict
my $dicf = $ARGV[0];
open(IN, $dicf) or die "%% Can't open $dicf\n";
my %dict;
while (<IN>) {
    chop();
    if (/(\w+)(?:|[\t\s]*(\d+))/) {
	my ($w, $f) = ($1, $2);
	my $f = $dict{$w} += +$f || 1;
	#print "word=$w freq=$f\n";
    } else {
	print STDERR "%% Dict: unrecognized line: $_\n";
    }
}
close(IN);
    
# process lines

# looking for first [a-z]+ not enclosed in
# parenthesis and lower case letters
#
# Example:
#   3 (aag)   599    pay (aag) pay -- pay,,, pan, pat,,,, apt,,

while(<STDIN>) {
    if (/(?<![\(a-z])([a-z]+)/) {
	my $w = $1;
	#print "$w -- $_";
	if ($dict{$w}) {
	    print;
	} else {
	    print STDERR "%% Rejected $_";
	}
    } else {
	print STDERR "%% not parsed: $_\n";
    }
}

