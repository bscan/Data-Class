use strict;
use warnings;
use Test::More tests=>6;

use Type::Hints qw(let);

{
    let $foo : int = 2;
    is($foo, 2, "Simple assignment");
}

{
    let $foo = 3;
    is($foo, 3, "No hints");
}

{
    let $foo;
    is(defined($foo), '', "No assignment");
}

{
    let $foo : arrayref[str | int] = [1,2, '3'];
    is_deeply($foo, [1,2,'3'], "No assignment");
}

{
    let $foo :
        int
            = 7;
    is_deeply($foo, 7, "Whitespace");
}

{
    let ($foo : int, $bar: str, $baz : {arg1: str, arg2: arrayref[int | str]}) = (2, "blah", {arg1=>'SomeArg', arg2=> [2,3,'4']});
    is_deeply($bar, "blah", "Inline object let");
}