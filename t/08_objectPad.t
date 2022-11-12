use v5.26;
use Object::Pad;
use Type::Hints qw(def);
use Test::More tests => 2;

class Point {

    has $x :param :reader = 0;
    has $y :param :reader = 0;

    def add( $self, $val1 : int, $val2 : int ) : int {
        return $val1 + $val2 + $self->sum();
    }

    method sum() {
        return $x + $y;
    }

}

my $point = Point->new( x => 5, y => 10 );

is( $point->x, 5, 'Regular Object::Pad variables' );

is( $point->add( 3, 5 ), 23, 'Def in Object::Pad class' );
