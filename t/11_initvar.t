use strict;
use warnings;
use Test::More tests=>5;
use Data::Dumper;
use Data::Class qw(has class initvar);
use experimental 'signatures';

class Color {
    has color :str;
    initvar red = undef;
    initvar green=undef;
    initvar blue=undef;

    sub _init ($self, $args) {
        if(defined($args->{color})){
            $self->color = $args->{color};
        } else {
            $self->color = "RGB($args->{red}, $args->{green}, $args->{blue})";
        }
    }
}

{
    my $teal = Color->new(color=>'teal');
    is($teal->color, 'teal', 'Normal access');
    eval { my $red = $teal->red;  };
    like($@, qr(Can't locate object method "red"), 'Init var does not exist in class');
    is($teal->{'red'}, undef, 'Underlying value undef');
}

{
    my $orange = Color->new(red=>255, green=>165, blue=>0);
    is($orange->color, 'RGB(255, 165, 0)', 'Normal access');
    eval { my $red = $orange->red;  };
    like($@, qr(Can't locate object method "red"), 'Init var does not exist in class');
    
    # TODO remove the initvars
    #is($orange->{'red'}, undef, 'Underlying value undef');
}
