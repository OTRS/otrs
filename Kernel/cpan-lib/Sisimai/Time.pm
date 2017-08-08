package Sisimai::Time;
use parent 'Time::Piece';
use feature ':5.10';
use strict;
use warnings;

sub TO_JSON {
    # Instance method for JSON::encode()
    # @return   [Integer] Machine time
    my $self = shift;
    return $self->epoch;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Time - Child class of Time::Piece for Sisimai::Data

=head1 SYNOPSIS

    use Sisimai::Time;
    my $v = Sisimai::Time->new;

=head1 DESCRIPTION

Sisimai::Time is a child class of Time::Piece for Sisimai::Data.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

