# reads a spelled map giving a asdfg lst
#
# in:
#   one	1
#
# out:
#   sgd	2
#
# usage:
#   cat spell.map | perl mk-spell.pl | sort > spell.lst

my $prefix = '_-';

while(<STDIN>) {
    chop();

    if (/^#/) {
	print;
	next;
    }    
    
    if (/^$/) {
	print;
	next;
    }    

    if (s/^(\w+)[\s\t](\S+)//) {
        my ($t, $w)  = ($1, $2);
	$tt = asdfg($t);
	print "$prefix$tt\t$w\t# $t $_\n";
    } else {
	print STDERR "%% not parsed $_\n";
    }
}

sub asdfg {
    my ($w) = @_;
    $w =~ s/[qazp]/A/g;
    $w =~ s/[wsxol]/S/g;
    $w =~ s/[edcik]/D/g;
    $w =~ s/[rfvujm]/F/g;
    $w =~ s/[tgbyhn]/G/g;
    return $w;
}
