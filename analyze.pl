# analyze input, identify what isn't in the asdfg.generated.lst

# OUTPUT:
#
# for each input line
#
#   %T:filename.line: text text text
#
# each time a word is not found:
#
#   asdfg	word	# =missing=
#
# and in the end, for all words:
#
# 
#   freq:asdfg	word	totalcount	# =miss=
#
#   freq:asdfg	word	totalcount
#

# dict data
my %dict; # word->1 # could be more if...
my %tdict; # asdfg->"word word word"

# data about the text
my %freq;
my %tfreq;

my %missing;
my %words; # 'asdfg'->'word word...'

my $total = 0;
my $hv = 0;
my $miss = 0;

# read endings and prefixes
my @ends = map {"$_\$"} split(/[ \n-]+/m, `cat Words/suffixes.lst`); shift(@ends);

my @pres = map {"^$_"} split(/[ \n-]+/m, `cat Words/prefixes.lst`); shift(@pres);

# no care name, just any matches...
@ends = (@ends, @pres);

my %endf = ();
my %endc = ();
my $ec = 0;

&readdict();

while(<>) {
    print "\n%T $ARGV:$.: $_\n";
    
    s/\b([A-Za-z]+)\b/&check($1)/ige;
}

sub check {
    my ($word) = @_;
    $total++;
    
    my $w = lc($word);
    $freq{$w}++;

    my $t = asdfg($w);
    $tfreq{$t}++;

    my $have = $dict{$w};
    
    if ($have) {
	# have
	$hv++;
	my $tconf = $tdict{$t};
	print "$t\t$w\n";
    } else {
	# no have
	$missing{$w}++;
	$miss++;

	derivable($w);

	my $tconf = $tdict{$t};
	$tconf = $tconf ? " =confl=$tconf" : "";

	print "$t\t$w\t# =miss=$tconf\n";
    }
}

# print stats

print "end-TEXT: for all instances of words\n";
my $text_resolved = $ec;

report_ends('TEXT');

my $uniqc = 0;
my $umiss = 0;
my $uhv = 0;

while( ($w, $c) = each(%freq) ) {
    $uniqc++;
    my $t = asdfg($w);

    my $stm = $stems{$w};
    $stm = $stm ? ' stems: $stm' : '';
    
    if ($missing{$w}) {
	$umiss++;

	derivable($w);
	
	my $tconf = $tdict{$t};
	$tconf = $tconf ? " =confl=$tconf" : "";
	print "freq: $t\t$w\t# $c =miss=$tconf$stm\n";
    } else {
	$uhv++;

	my $tconf = $tdict{$t};
	#print "TDICT: $tconf\n";

	print "freq: $t\t$w\t# $c$stm\n";
    }
}

print "\n\nend-UNIQ: end=>resolved: $ec\n";
my $uniq_resolved = $ec;

print "end-TEXT: for all unique words\n";
report_ends('UNIQ');

print "\n\n";
print "% stats:  words (adjusted after stemming)\n";
print "% stats:   total: $total\n";
print "% stats:    have: $hv (",$hv+$text_resolved,")\n";
print "% stats: missing: $miss (",$miss-$text_resolved,")\n";
print "% stats:     unique count: $uniqc\n";
print "% stats:     unique  have: $uhv (",$uhv+$uniq_resolved,")\n";
print "% stats:     unique  miss: $umiss (",$umiss-$uniq_resolved,")\n";

print "TDICT=".keys(%tdict),"\n";

sub asdfg {
    my ($t) = @_;

    $t =~ s/[qazp]/a/g;
    $t =~ s/[wsxol]/s/g;
    $t =~ s/[edcik]/d/g;
    $t =~ s/[rfvujm]/f/g;
    $t =~ s/[tgbyhn]/g/g;

    return $t;
}

sub derivable {
    my ($w) = @_;
    
    # derivable?
    for $e (@ends) {
	if ($w =~ /$e/) {
	    $endc{$e}++;
	    
	    my $v = $w;
	    $v =~ s/$e//g;

	    my $h = $dict{$v};
	    if ($h) {
		$ec++;
		$efound{$e}++;
		$stems{$v}++;
	    }
	}
    }
}

sub report_ends {
    my ($info) = @_;
    
    for $e (@ends) {
	my $cases=$endc{$e};
	my $indict=$efound{$e};
	next unless $cases+$indict;
	
	print "end-$info: ", sprintf("%6s", $e),": $endf{$c}",sprintf("   cases=%3d  indict=%3d", $cases, $indict), "\n";


    }
    %endc = ();
    %endf = ();
    $ec = 0;
    %efound = ();
}

sub readdict {
    open(DICT, "asdfg.generated.lst") or die "%% No dictionary";
	 
    while(<DICT>) {
	next if /^#/;
	next if /^$/;
	chop();

	if (/^(\S+)\t(.+)$/) {
	    my ($t, $words, $comment) = ($1, $2, $3);
	    #print "TFOO=$t W=$words, C=$comment\n";
	    my $tt = $t;
	    $tt =~ s/[%_]//g;
	    $tdict{$tt} = $words;
	    my @w = split(/[,\s]+/, $words);
	    foreach $v (@w) {
		$dict{$v} = $t;
	    }

	} else {
            print STDERR "%% dict: unparsed: $_\n";
	}
    }

    close(DICT);
}
