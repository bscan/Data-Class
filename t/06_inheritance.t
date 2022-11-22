use strict;
use warnings;
use Test::More tests=>18;
use Data::Dumper;
use Data::Class qw(has class private);

package PackageParent {
    has packBaseAttr = 10;
    has packBaseAttrUnint; # This variable is not required in child classes
    sub return42 {
        my $self = shift;
        return 42;
    }
}


class GrandParent {
    has gpAttr;
    has grandparentAttr = 2;
    has grandparentAttrOverride = 3;
    has grandparentAttrOverrideInChild = 4;
    has doubleOveride= 1;
    has overideWithUndef = 5;
    private priv_attr;
    sub return4 {
        my $self = shift;
        return 4;
    }
}

class ClassParent extends GrandParent {
    has baseattr;
    has baseattrDefault = 13;
    has grandparentAttrOverride = 5;
    has doubleOveride= 2;

    sub return57 {
        my $self = shift;
        return 57;
    }

    sub overridden {
        return 14;
    }
}

class Child1 extends PackageParent {
    has bar;
}

class Child2 extends ClassParent {
    has foo; 
    has grandparentAttrOverrideInChild = 7;
    has doubleOveride = 3;
    has overideWithUndef = undef;
    
    sub overridden {
        my $self = shift;
        my $val = 10 + $self->SUPER::overridden();
        return $val
    }
}

{
    my $child = Child1->new(bar=>10);
    is($child->bar, 10, 'Child1');
    $child->bar++;
    is($child->bar, 11, 'Child1++');
    is($child->return42, 42, 'Inherit sub from plain package');
    is($child->packBaseAttr, 10, 'Inherit has from plain package');
    is($child->packBaseAttrUnint, undef, 'Non-required attrs from plain parents')
}

{
    my $child = Child2->new(foo=>15, baseattr=>14, priv_attr=>10);
    is($child->foo, 15, 'Child2');
    $child->foo++;
    is($child->foo, 16, 'Child2++');
    is($child->return57, 57, 'Inherit sub from class');
    is($child->baseattr, 14, 'Child2 inherit params');
    is($child->baseattrDefault, 13, 'Child2 inherit defaults');

}


{
    my $child = Child2->new(foo=>15, baseattr=>14, baseattrDefault=>27, gpAttr=>8);
    is($child->baseattrDefault, 27, 'Override defaults from base');
    $child->baseattrDefault++;
    is($child->baseattrDefault, 28, 'Getters and setters from base');
    is($child->grandparentAttr, 2, 'Original parent');
    is($child->grandparentAttrOverride, 5, 'Overidden in first child');
    is($child->grandparentAttrOverrideInChild, 7, 'Overidden in grandchild');
    is($child->gpAttr, 8, 'No default');
    is($child->overideWithUndef, undef, 'Override with undef');
    is($child->overridden, 24, 'Override methods and use SUPER');
}