package Sisimai::Order;
use feature ':5.10';
use strict;
use warnings;

sub by      { return {} }
sub default { return [] }
sub another { return [] }
sub headers { return {} }

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Order - Parent class for making optimized order list for calling MTA,
modules.

=head1 SYNOPSIS

    use Sisimai::Order

=head1 DESCRIPTION

Sisimai::Order class makes optimized order list which include MTA modules to be
loaded on first from MTA specific headers in the bounce mail headers such as
X-Failed-Recipients.
This module are called from only Sisimai::Message::* child classes.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
