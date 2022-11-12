use strict;
use warnings;
use Test::More tests=>7;

use Type::Hints qw(def);

def add( $foo : int, $bar : arrayref [ int | str ] ) : int {
    return $foo + $bar->[0] + $bar->[1];
}

is(add(2,[3, '5']), 10, "Simple math");


def concat(
        $baz : int ,
        $qux : str ) : str {
    return $baz . $qux;
}

def typedArgs($args: {foo: int, baz: str}){
     return $args->{foo};
}

def typedArgs2($args: {foo: int, 
                      bar: int,
                      baz: arrayref[int | str] }){
     return 2*$args->{bar};
}

is(concat('a', 'b'), 'ab', "String concatentation with tricky syntax");


def nosig () : str {
    return "No sig";
}

is(nosig(), 'No sig', "Works without signatures");


def defaults($foo : int =2, $bar = 3) : str {
    return $foo + $bar;
}

is(defaults(), 5, "Works with defaults");


def simple() {
    return "Simple";
}

is(simple(), "Simple", "Simple case works too");

is(typedArgs({foo=>12}), 12, 'Inline object signatures');

is(typedArgs2({bar=>13}), 26, 'Complex inline object signatures');