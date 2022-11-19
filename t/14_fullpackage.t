use Data::Class;
class PackClass;
use strict;
use warnings;

has bar;
private privateVar = 2;


package Pack2;
use strict;
use warnings;
use Test::More tests=>2;


my $foo = PackClass->new(bar=>2, privateVar=>5);
is($foo->bar, 2, 'Same package non-main');
eval { $foo->privateVar = 3 };
like($@, qr/is a private attribute/, 'Private protection'); 

