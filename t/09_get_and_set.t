use strict;
use warnings;
use Test::More tests=>8;
use Data::Dumper;
use Data::Class qw(has class private lazy get set def);
use experimental 'signatures';

class Foo {
    use Carp;
    has bar;
    
    set bar ($self, $update) {
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
    get balance($self) {
        # Log access to the account for security reasons.
         # Charge 1 cent to look at your balance. Helps with the test to make sure this is called, and that getters and setters don't infinite loop
        $self->balance -= 1;
        return $self->balance;
    }
    set balance($self, $value) {
        # More than just a type constraint, perhaps we want alert someone if overdraft attempted
        croak("Overdraft fee applied!") if ($value < 0);
        $self->balance = $value - 5; # Charge two cents to update a balance
    }
}
my $account = Account(balance=>100);
$account->balance -= 10; # Calls a get and a set
is($account->balance, 78, 'Getter and a setter');


class SecretDoc {
    has name;
    private content;
    get content($self) {
        return $self->content . ' retrieved';
    }
    set content($self, $value) {
        $value .= ' updated';
        $self->content = $value;
    }

    def steal($self) {
        $self->content = 'redacted';
        return $self->content;
    }
}

def foo 
(
    $bar,
    $baz, 
    $qux: { red: int,
            green: int,
            blue: int }
)
{
    return "nothing";
}
my $doc = SecretDoc(name=>'secrets', content=>'Dont look at this');

is($doc->name, 'secrets', 'Private public coexist');

eval { my $out = $doc->content };
like($@, qr/is a private attribute/, 'Ensure private getters are private'); 

eval { $doc->content = 'Redacted' };
like($@, qr/is a private attribute/, 'Ensure private setters are private'); 

is($doc->steal, 'redacted updated retrieved', 'Private get and set');

# Hard test to manage, but important. Ensures keywords above have not messed with the line numbers
eval { die("DEAD") };
like($@, qr/line 88/, 'Ensure line numbers match'); 
