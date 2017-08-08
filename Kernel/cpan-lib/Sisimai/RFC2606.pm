package Sisimai::RFC2606;
use strict;
use warnings;

sub is_reserved {
    # Whether domain part is Reserved or not
    # @param    [String] argv1  Domain part
    # @return   [Integer]       1: is Reserved top level domain
    #                           0: is NOT reserved top level domain
    # @see      http://www.ietf.org/rfc/rfc2606.txt
    my $class = shift;
    my $argv1 = shift || return 0;

    return 1 if $argv1 =~ m/[.](?:test|example|invalid|localhost)\z/;
    return 1 if $argv1 =~ m/example[.](?:com|net|org)\z/;
    return 1 if $argv1 =~ m/example[.]jp\z/;
    return 1 if $argv1 =~ m/example[.](?:ac|ad|co|ed|go|gr|lg|ne|or)[.]jp\z/;
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::RFC2606 - Check the email address is reserved or not

=head1 SYNOPSIS

    use Sisimai::RFC2606;
    print Sisimai::RFC2606->is_reserved('example.com');    # 1

=head1 DESCRIPTION

Sisimai::RFC2606 checks that the domain part of the email address in the 
argument is reserved or not.

=head1 CLASS METHODS

=head2 C<B<is_reserved(I<Domain Part>)>>

C<is_reserved()> returns 1 if the domain part is reserved domain, returns 0 if
the domain part is NOT reserved domain.

    print Sisimai::RFC2606->is_reserved('example.org');    # 1
    print Sisimai::RFC2606->is_reserved('bouncehammer.jp');# 0

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
