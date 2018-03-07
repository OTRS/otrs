package Sisimai::Order::JSON;
use parent 'Sisimai::Order';
use feature ':5.10';
use strict;
use warnings;
use Sisimai::Bite::JSON;

my $DefaultOrder = __PACKAGE__->default;
my $PatternTable = {
    'keyname' => { 'notificationType' => ['Sisimai::Bite::JSON::AmazonSES'] }
};

sub default {
    # Make default order of MTA modules to be loaded
    # @return   [Array] Default order list of MTA modules
    # @since v4.13.1
    my $class = shift;
    my $order = [];

    return $DefaultOrder if ref $DefaultOrder eq 'ARRAY';
    push @$order, map { 'Sisimai::Bite::JSON::'.$_ } @{ Sisimai::Bite::JSON->index() };
    return $order;
}

sub by {
    # Get regular expression patterns for specified key name
    # @param    [String] group  Group name for "ORDER BY"
    # @return   [Hash]          Pattern table for the group
    # @since v4.13.2
    my $class = shift;
    my $group = shift || return undef;

    return $PatternTable->{ $group } if exists $PatternTable->{ $group };
    return {};
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Order::JSON - Make optimized order list for calling MTA modules

=head1 SYNOPSIS

    use Sisimai::Order::JSON

=head1 DESCRIPTION

Sisimai::Order::JSON makes optimized order list which include MTA modules to be
loaded on first from bounce object key names in the decoded JSON object. This
module are called from only Sisimai::Message::JSON.

=head1 CLASS METHODS

=head2 C<B<default()>>

C<default()> returns default order of MTA modules

    print for @{ Sisimai::Order::JSON->default };

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut


