# list asdfg combination that are free

require './dict.pl';

my $maxlen = 6;

# enumerate

print "\n-------------------------\n";

my @asdfg = (' ', 'a', 's', 'd', 'f', 'g');

# 5 letters in asdfg + space
for $n (0..6**$maxlen-1) {

    # convert it to base 5
    my $t = '';
    my $v = $n;
    while($v) {
	my $c = $asdfg[$v % 6];
	$t = $c . $t;
	$v = int($v/6);
    }

    # only leading spaces
    next if $t =~ /\w /;

    my $hv = $tdict{$t};
    if ($hv) {
	$hv = "\t$hv";
    } else {
	$hv = "";
    }
    print "$t$hv\n";
}

print STDERR "taken:\t... | grep -i '\t'\n";
print STDERR "free:\t... | grep -iv '\t'\n";
print STDERR "cat Words/linux-words | grep '^.\{1,6\}$\n";



#print 5**$maxlen, "\n";
