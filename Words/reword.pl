# see how common the sequences are in rewordable.lst

$filelst = $ARGV[0] || "rewordable.lst";
@lst = split(/[^a-z]+/, lc `cat $filelst`);

my $txt = lc join('', <STDIN>);
my $tt = $txt;

#print $txt;

my $nn = 0;
my $nc = 0;
for $s (@lst) {
    # skip one letter subst
    next if $s =~ /^.$/;
    my $t = $txt;
    my $n = ($t =~ s/$s/_/g);
    my $ttt = $tt;
    my $tn = ($ttt =~ s/$s/uc $s/g);
    $tt =~ s/$s/uc $s/ge;
    $nn += $n;
    $nc += $tn * length($s);
    print "$s\t$n\n";
}

print "-" x 40, "\n";
print "$tt\n";

print "_" x 40, "\n";
# see how much not covered
my $ttt = $tt;
$ttt =~ s/[a-z]/_/g;
print "$ttt\n";

# frequency of missing chars

my $freq = ();
for $i (0..length($tt)-1) {
    add(substr($tt, $i, 1));
    add(substr($tt, $i, 2));
    add(substr($tt, $i, 3));
    add(substr($tt, $i, 4));
}

sub add {
    my ($s) = @_;
    # only add those contigious
    return unless $s =~ /^[a-z]+$/;
    #print "=== $s\n";
    $freq{$s}++;
}

# sort by frequency

@f = sort { return $freq{$a} <=> $freq{$b}; } keys(%freq);
print map { ":: $_ $freq{$_}\n" } @f;

print "=" x 40, "\n";
print "\n";
print "MATCHES\t$nn\n";
print "CHARS\t$nc\n";
print "LENGTH\t".length($txt)."\n";


