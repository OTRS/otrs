package Sisimai::Reason::MesgTooBig;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'mesgtoobig' }
sub description { 'Email rejected due to an email size is too big for a destination mail server' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr{(?>
         exceeded[ ]maximum[ ]inbound[ ]message[ ]size
        |max[ ]message[ ]size[ ]exceeded
        |message[ ](?:
             file[ ]too[ ]big
            |length[ ]exceeds[ ]administrative[ ]limit
            |size[ ]exceeds[ ](?:
                 fixed[ ]limit
                |fixed[ ]maximum[ ]message[ ]size
                |maximum[ ]value
                )
            |too[ ]big
            |too[ ]large[ ]for[ ]this[ ].+
            )
        |size[ ]limit
        )
    }ix;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # The message size is too big for the remote host
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is too big message size
    #                                   0: is not big
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return 1 if $argvs->reason eq __PACKAGE__->text;

    require Sisimai::SMTP::Status;
    my $statuscode = $argvs->deliverystatus // '';
    my $diagnostic = $argvs->diagnosticcode // '';
    my $tempreason = Sisimai::SMTP::Status->name($statuscode);
    my $reasontext = __PACKAGE__->text;
    my $v = 0;

    if( $tempreason eq $reasontext ) {
        # Delivery status code points "mesgtoobig".
        # Status: 5.3.4
        # Diagnostic-Code: SMTP; 552 5.3.4 Error: message file too big
        $v = 1;

    } else {
        if( $tempreason eq 'exceedlimit' || $statuscode eq '5.2.3' ) {
            #  5.2.3   Message length exceeds administrative limit
            $v = 0;

        } else {
            # Check the value of Diagnosic-Code: header with patterns
            $v = 1 if __PACKAGE__->match($diagnostic);
        }
    }

    return $v;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::MesgTooBig - Bounce reason is C<mesgtoobig> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::MesgTooBig;
    print Sisimai::Reason::MesgTooBig->match('400 Message too big');   # 1

=head1 DESCRIPTION

Sisimai::Reason::MesgTooBig checks the bounce reason is C<mesgtoobig> or not.
This class is called only Sisimai::Reason class.

This is the error that a sent email size is too big for a destination mail
server. In many case, There are many attachment files with email, or the file
size is too large. Sisimai will set C<mesgtoobig> to the reason of email bounce
if the value of Status: field in a bounce email is C<5.3.4>.

    Action: failure
    Status: 553 Exceeded maximum inbound message size

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<mesgtoobig>.

    print Sisimai::Reason::MesgTooBig->text;  # mesgtoobig

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::MesgTooBig->match('400 Message too big');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<mesgtoobig>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 SEE ALSO

=over

=item L<Sisimai::Reason::ExceedLimit> - Sisimai::Reason::ExceedLimit

=back

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
