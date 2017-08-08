package Sisimai::MSP::US::Yahoo;
use parent 'Sisimai::MSP';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'subject' => qr/\AFailure Notice\z/,
};
my $Re1 = {
    'begin'   => qr/\ASorry, we were unable to deliver your message/,
    'rfc822'  => qr/\A--- Below this line is a copy of the message[.]\z/,
    'endof'   => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $Indicators = __PACKAGE__->INDICATORS;

# X-YMailISG: YtyUVyYWLDsbDh...
# X-YMail-JAS: Pb65aU4VM1mei...
# X-YMail-OSG: bTIbpDEVM1lHz...
# X-Originating-IP: [192.0.2.9]
sub headerlist  { return ['X-YMailISG'] }
sub pattern     { return $Re0 }
sub description { 'Yahoo! MAIL: https://www.yahoo.com' }

sub scan {
    # Detect an error from Yahoo! MAIL
    # @param         [Hash] mhead       Message header of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    # @since v4.1.3
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'x-ymailisg'};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between $Re1->{'begin'} and $Re1->{'rfc822'}.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e =~ $Re1->{'begin'} ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e =~ $Re1->{'rfc822'} ) {
                $readcursor |= $Indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $Indicators->{'message-rfc822'} ) {
            # After "message/rfc822"
            unless( length $e ) {
                $blanklines++;
                last if $blanklines > 1;
                next;
            }
            push @$rfc822list, $e;

        } else {
            # Before "message/rfc822"
            next unless $readcursor & $Indicators->{'deliverystatus'};
            next unless length $e;

            # Sorry, we were unable to deliver your message to the following address.
            #
            # <kijitora@example.org>:
            # Remote host said: 550 5.1.1 <kijitora@example.org>... User Unknown [RCPT_TO]
            $v = $dscontents->[-1];

            if( $e =~ m/\A[<](.+[@].+)[>]:[ \t]*\z/ ) {
                # <kijitora@example.org>:
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } else {
                if( $e =~ m/\ARemote host said:/ ) {
                    # Remote host said: 550 5.1.1 <kijitora@example.org>... User Unknown [RCPT_TO]
                    $v->{'diagnosis'} = $e;

                    if( $e =~ m/\[([A-Z]{4}).*\]\z/ ) {
                        # Get SMTP command from the value of "Remote host said:"
                        $v->{'command'} = $1;
                    }
                } else {
                    # <mailboxfull@example.jp>:
                    # Remote host said:
                    # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                    # [RCPT_TO]
                    if( $v->{'diagnosis'} =~ m/\ARemote host said:\z/ ) {
                        # Remote host said:
                        # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                        if( $e =~ m/\[([A-Z]{4}).*\]\z/ ) {
                            # [RCPT_TO]
                            $v->{'command'} = $1;

                        } else {
                            # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                            $v->{'diagnosis'} = $e;
                        }
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;
    require Sisimai::String;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} =~ s{\\n}{ }g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     =  __PACKAGE__->smtpagent;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MSP::US::Yahoo - bounce mail parser class for C<Yahoo! MAIL>.

=head1 SYNOPSIS

    use Sisimai::MSP::US::Yahoo;

=head1 DESCRIPTION

Sisimai::MSP::US::Yahoo parses a bounce email which created by C<Yahoo! MAIL>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MSP::US::Yahoo->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MSP::US::Yahoo->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

