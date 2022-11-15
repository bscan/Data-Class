use strict;
use warnings;
use Test::More tests=>5;

package MooPack { 
    use Moo;
    use strict;
    use Data::Class;


    has mooVar => (is=>'rw');
    public foo;
    public bar: int = 10;
    private baz;

    def add($self, $val1: int, $val2: int) : int {
        return $val1 + $val2;
    }
}

my $mooObj = MooPack->new(mooVar=>1);

is($mooObj->mooVar, 1, 'Moo variables');

is($mooObj->bar, 10, 'Type defaults');

$mooObj->foo = 12;
is($mooObj->foo, 12, 'Lvalues in Moo');

eval { my $tmp = $mooObj->baz ; };
like($@, qr(baz is a private attribute), 'Private attributes');

is($mooObj->add(3, 5), 8, 'Def in Moo class');