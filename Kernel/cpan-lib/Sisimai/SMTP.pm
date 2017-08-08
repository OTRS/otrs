package Sisimai::SMTP;
use feature ':5.10';
use strict;
use warnings;

sub command {
    # Detector for SMTP commands in a bounce mail message
    # @private
    # @return   [Hash] SMTP command regular expressions
    return {
        'helo' => qr/\b(?:HELO|EHLO)\b/,
        'mail' => qr/\bMAIL F(?:ROM|rom)\b/,
        'rcpt' => qr/\bRCPT T[Oo]\b/,
        'data' => qr/\bDATA\b/,
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP - SMTP Status Codes related utilities

=head1 SYNOPSIS

    use Sisimai::SMTP;
    print keys %{ Sisimai::SMTP->command }; # helo, mail, rcpt, data

=head1 DESCRIPTION

Sisimai::SMTP is a parent class of Sisimai::SMTP::Status and Sisimai::SMTP::Reply.

=head1 CLASS METHODS

=head2 C<B<command>>

C<command()> returns regular expressions for each SMTP command: C<HELO(EHLO)>,
C<MAIL>, C<RCPT>, and C<DATA>.

    my $v = Sisimai::SMTP->command;
    print for keys %v;  # helo, mail, rcpt, data

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

