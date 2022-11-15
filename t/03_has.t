use strict;
use warnings;
use Test::More tests=>16;
use Data::Dumper;
use Data::Class;

package FooParent {
    private priv_attr;
    protected prot_attr;
}

package Foo {
    use parent -norequire, 'FooParent';
    has bar;
    has qux = 3;
    has quux : int = 5;
    has thud : str = "A thud";
    private thwop;
    readonly ro_def = 3;
    readonly ro_nodef;
    public garply;

    has fooSub = sub { return 17 };

    sub new { 
        my ($class, %args) = @_; 
        bless \%args, $class; 
    } 

    sub updateProt {
        my $self = shift;
        $self->prot_attr = 14;
    }

    sub updatePriv {
        my $self = shift;
        $self->priv_attr = 15;
    }
}

my $foo = Foo->new( bar=>2, thud=>'Overridden', thwop=>10, ro_nodef=>2);

is($foo->bar, 2, 'Simple assignment');

is($foo->{"qux"}, undef, 'Defaults not pre-assigned for hash syntax');

is($foo->fooSub, 17, 'Sub generator');

is($foo->qux, 3, 'Defaults');

is($foo->quux, 5, 'Defaults with hints');

is($foo->thud, 'Overridden', 'Defaults that are overridden');

$foo->quux = 7;
is($foo->quux, 7, 'L value');

$foo->{"quux"} = 11;
is($foo->quux, 11, 'Hash assignments');

$foo->garply = 10;
is($foo->garply, 10, 'Public vars');


is($foo->updateProt(), 14, 'Protected is fine');

eval { $foo->updatePriv() };
like($@, qr(priv_attr is a private attribute), 'Private parent attributes');

eval { my $tmp = $foo->prot_attr ; };
like($@, qr(prot_attr is a protected attribute), 'Protected parent attributes');

eval { my $tmp = $foo->priv_attr ; };
like($@, qr(priv_attr is a private attribute), 'Direct parent attributes');

eval { my $tmp = $foo->thwop ; };
like($@, qr(thwop is a private attribute), 'Private attributes');

eval { $foo->ro_def = 5; };
like($@, qr( is readonly ), 'Readonly attributes');

eval { $foo->ro_nodef = 6; };
like($@, qr( is readonly ), 'Readonly attributes');