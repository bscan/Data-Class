package Pack1;

use strict;
use warnings;
use Test::More tests=>4;
use Data::Class;# qw(has class private lazy def readonly);
require Exporter;
our @ISA = qw(Exporter);  # inherit all of Exporter's methods
our @EXPORT_OK = qw(Foo is like);  # symbols to export on request


class Foo {
    has bar;
    private privateVar = 2;
}

my $foo = Foo(bar=>2, privateVar=>5);
is($foo->bar, 2, 'Same package non-main');
eval { $foo->privateVar = 3 };
like($@, qr/is a private attribute/, 'Private protection'); 


package Pack2;

Pack1->import(qw(Foo is like));

my $foo2 = Foo(bar=>4, privateVar=>7);
is($foo->bar, 2, 'Different package non-main');

eval { $foo->privateVar = 3 };
like($@, qr/is a private attribute/, 'Private protection different package'); 