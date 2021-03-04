$_ = join('', <>);

@w = m,<td class="col_(?:9|10)">(.*?)</td>,g;

$_ = join("\n", @w);

# actually should put these first as they are more important to learn
s,<strong>(.*?)</strong>,=$1,g;

s,right word,,;

@langs = split(/left word/, $_);

$_ = $langs[1]; # english

s,=(\w+),&foo($1),ge;

sub foo {
    local($w) = @_;
    print "$w\n";
    return "";
}

s,\n+,\n,g;

#print @w;

print;




