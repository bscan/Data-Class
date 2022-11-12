use strict;
use warnings;
use Test::More tests=>3;
use Data::Dumper;
use Type::Hints qw(has class private lazy);
use experimental 'signatures';

class Foo {
    use Carp;
    has bar;
    
    sub set_bar {
        my ($self, $update) = @_;
        if ($update > 2){
            croak("Can't set new value to more than 2");
        }
        $self->bar = $update;
    } 
}

my $foo = Foo(bar=>2);

eval { $foo->bar = 15 };
like($@, qr/Can't set new value to more than 2/, 'Call setter'); 

eval { my $foo2 = Foo(bar=>20) };
like($@, qr/Can't set new value to more than 2/, 'Call setter during constructor'); 

class Account {
    has balance = 0;
    sub get_balance($self) {
        # Log access to the account for security reasons.
         # Charge 1 cent to look at your balance. Helps with the test to make sure this is called, and that getters and setters don't infinite loop
        $self->balance -= 1;
        return $self->balance;
    }
    sub set_balance($self, $value) {
        # More than just a type constraint, perhaps we want alert someone if overdraft attempted
        croak("Overdraft fee applied!") if ($value < 0);
        $self->balance = $value - 5; # Charge two cents to update a balance
    }
}
my $account = Account(balance=>100);
$account->balance -= 10; # Calls a get and a set
is($account->balance, 78, 'Getter and a setter');