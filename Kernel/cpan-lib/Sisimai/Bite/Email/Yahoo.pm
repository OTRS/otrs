package Sisimai::Bite::Email::Yahoo;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Sorry, we were unable to deliver your message'],
    'rfc822'  => ['--- Below this line is a copy of the message.'],
};

# X-YMailISG: YtyUVyYWLDsbDh...
# X-YMail-JAS: Pb65aU4VM1mei...
# X-YMail-OSG: bTIbpDEVM1lHz...
# X-Originating-IP: [192.0.2.9]
sub headerlist  { return ['X-YMailISG'] }
sub description { 'Yahoo! MAIL: https://www.yahoo.com' }
sub scan {
    # Detect an error from Yahoo! MAIL
    # @param         [Hash] mhead       Message headers of a bounce email
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

    # 'subject' => qr/\AFailure Notice\z/,
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
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( index($e, $StartingOf->{'message'}->[0]) == 0 ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e eq $StartingOf->{'rfc822'}->[0] ) {
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

            if( $e =~ /\A[<](.+[@].+)[>]:[ \t]*\z/ ) {
                # <kijitora@example.org>:
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } else {
                if( index($e, 'Remote host said:') == 0 ) {
                    # Remote host said: 550 5.1.1 <kijitora@example.org>... User Unknown [RCPT_TO]
                    $v->{'diagnosis'} = $e;

                    # Get SMTP command from the value of "Remote host said:"
                    $v->{'command'} = $1 if $e =~ /\[([A-Z]{4}).*\]\z/;
                } else {
                    # <mailboxfull@example.jp>:
                    # Remote host said:
                    # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                    # [RCPT_TO]
                    if( $v->{'diagnosis'} eq 'Remote host said:' ) {
                        # Remote host said:
                        # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                        if( $e =~ /\[([A-Z]{4}).*\]\z/ ) {
                            # [RCPT_TO]
                            $v->{'command'} = $1;

                        } else {
                            # 550 5.2.2 <mailboxfull@example.jp>... Mailbox Full
                            $v->{'diagnosis'} = $e;
                        }
                    } else {
                        # Error message which does not start with 'Remote host said:'
                        $v->{'diagnosis'} .= ' '.$e;
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} =~ s/\\n/ /g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     =  __PACKAGE__->smtpagent;
        $e->{'command'} ||=  'RCPT' if $e->{'diagnosis'} =~ /[<].+[@].+[>]/;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::Yahoo - bounce mail parser class for C<Yahoo! MAIL>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Yahoo;

=head1 DESCRIPTION

Sisimai::Bite::Email::Yahoo parses a bounce email which created by C<Yahoo! MAIL>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Yahoo->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Yahoo->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

