# $Id: Utils.pm,v 1.1 2011-03-02 15:54:38 sb Exp $
# $OldId: There is no old ID for this file

package SOAP::Lite::Utils;
use strict;

sub import {
    my $caller = caller();
    no strict qw(refs);
    *{ "$caller\::__mk_accessors" } = \&__mk_accessors;
}

sub __mk_accessors {
    my ($class, @method_from) = @_;
    no strict 'refs';
    for my $method ( @method_from ) {
        my $field = '_' . $method;
        *{ "$class\::$method" } = sub {
            my $self = ref $_[0] ? shift : shift->new();
            if (@_) {
                $self->{$field} = shift;
                return $self
            }
            return $self->{$field};
        }
    }
}


1;

__END__
