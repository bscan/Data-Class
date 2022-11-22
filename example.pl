

use strict;
use warnings;



use Data::Class;

class CatFood {

    has pounds = 0;
    has brand = 'SWEET-TREATZ';
    private ratings: arrayref[int] = sub { [] };

    set pounds ($self, $amount){
        die "Cannot have negative food" if $amount < 0;
        $self->pounds = $amount;
    }

    def feed_lion ($self, $amount: int = 1){
        $self->pounds -= $amount;
        $self->record_review({rating=>5, taste=>'Delicious'});
    }
    
    private def record_review($self, $review: {rating: int, tasting_notes: str}) {
        push $self->ratings->@*, $review->{rating};
    }
}

my $food  = CatFood->new(pounds=>10);
$food->feed_lion();






class BankAccount {

    protected balance : int = 0;

    set balance( $self, $value : int ) {
        die "Account overdrawn!" if $value < 0;
        $self->balance = $value;
    }

    def deposit ( $self, $amount : int ) {
        $self->balance += $amount;
    }
    
    def withdraw ( $self, $amount: int ) {
        $self->balance -= $amount;
    }

    def check_balance ($self) : int{
        return $self->balance;
    }
}

class CheckingAccount extends BankAccount {

    def atm_withdrawal($self, $amount){
        $self->balance -= ($amount + 2);
    }
}

my $account1 = BankAccount->new( balance => 100 );

my $account = CheckingAccount->new( balance => 100 );

$account->atm_withdrawal(10);
print $account->check_balance;