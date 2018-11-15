package Sisimai::Reason::VirusDetected;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'virusdetected' }
sub description { 'Email rejected due to a virus scanner on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'it has a potentially executable attachment',
        'the message was rejected because it contains prohibited virus or spam content',
        'this form of attachment has been used by recent viruses or other malware',
        'your message was infected with a virus',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is security error or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: virus detected
    #                                   0: virus was not detected
    # @since v4.22.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::VirusDetected - Bounce reason is C<virusdetected> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::VirusDetected;
    print Sisimai::Reason::VirusDetected->match('5.7.1 Email not accept');   # 1

=head1 DESCRIPTION

Sisimai::Reason::VirusDetected checks the bounce reason is C<virusdetected> or
not. This class is called only Sisimai::Reason class.

This is an error that any virus or trojan horse detected in the message by a
virus scanner program at a destination mail server. This reason has been divided
from C<securityerror> at Sisimai 4.22.0.

    Your message was infected with a virus. You should download a virus
    scanner and check your computer for viruses.

    Sender:    <sironeko@libsisimai.org>
    Recipient: <kijitora@example.jp>

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<virusdetected>.

    print Sisimai::Reason::VirusDetected->text;  # virusdetected

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    my $v = 'Your message was infected with a virus. ...';
    print Sisimai::Reason::VirusDetected->match($v);    # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<virusdetected>. The argument must
be Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
