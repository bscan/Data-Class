use v5.20;
use Test::More tests => 1;
is(1+1,2,'Ignoring object::pad for now');
# use warnings;
# use Object::Pad;
# use Data::Class qw(def);
# use Test::More tests => 2;
# no warnings qw(experimental::signatures);

# class Point {

#     has $x :param :reader = 0;
#     has $y :param :reader = 0;

#     def add( $self, $val1 : int, $val2 : int ) : int {
#         return $val1 + $val2 + $self->sum();
#     }

#     method sum() {
#         return $x + $y;
#     }

# }

# my $point = Point->new( x => 5, y => 10 );

# is( $point->x, 5, 'Regular Object::Pad variables' );

# is( $point->add( 3, 5 ), 23, 'Def in Object::Pad class' );
