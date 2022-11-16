use strict;
use warnings;
use Test::More tests=>5;
use Data::Class;


class Account {
    has balance;
    
    private sub modify($self, $value: int) {
        $self->balance = $value;
    }

    public sub call_modify($self) {
        $self->modify(10);
    }

    protected def call_with_val($self, $value: int) {
        $self->modify($value);
    }

    public def trickier 
            (
                $self: object, 
                $value: { newval: int } ) : undef
    {
        $self->modify($value->{newval});
    }
}

my $account = Account(balance=>100);



eval { $account->modify(); };
like($@, qr(modify is a private method), 'Private functions reject');

$account->call_modify(); 
is($account->balance, 10, 'Public functions work');

eval { $account->call_with_val(25); };
like($@, qr(call_with_val is a protected method), 'Protected def reject');

$account->trickier({newval=>30});
is($account->balance, 30, 'Different syntax');


# Hard test to manage, but important. Ensures keywords above have not messed with the line numbers
eval { die("DEAD") };
like($@, qr/line 49/, 'Ensure line numbers match'); 
