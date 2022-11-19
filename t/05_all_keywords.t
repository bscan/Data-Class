use strict;
use warnings;
use Test::More tests=>1;
use Data::Dumper;
use Data::Class;
use experimental 'signatures';

class Foo {
    has bar;
    has qux = 3;

    def frob ($self, $baz: int, $quux: int = 7) : int{
        let $thud = $self->bar + $self->qux + $baz + 1;
        return $thud;
    }
}

my $foo = Foo->new(bar=>2);

is($foo->frob(5), 11, 'Simple assignment');

