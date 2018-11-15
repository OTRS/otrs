package Sisimai::Bite::Email::Google;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Delivery to the following recipient'],
    'error'   => ['The error that the other server returned was:'],
};
my $MarkingsOf = {
    'start'   => qr/Technical details of (?:permanent|temporary) failure:/,
    'rfc822'  => qr{\A(?:
         -----[ ]Original[ ]message[ ]-----
        |[ \t]*-----[ ]Message[ ]header[ ]follows[ ]-----
        )\z
    }x,
};

my $MessagesOf = {
    'expired' => [
        'DNS Error: Could not contact DNS servers',
        'Delivery to the following recipient has been delayed',
        'The recipient server did not accept our requests to connect',
    ],
    'hostunknown' => [
        'DNS Error: Domain name not found',
        'DNS Error: DNS server returned answer with no data',
    ],
};
my $StateTable = {
    # Technical details of permanent failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 500 Remote server does not support TLS (state 6).
    '6'  => { 'command' => 'MAIL', 'reason' => 'systemerror' },

    # http://www.google.td/support/forum/p/gmail/thread?tid=08a60ebf5db24f7b&hl=en
    # Technical details of permanent failure:
    # Google tried to deliver your message, but it was rejected by the recipient domain. 
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 535 SMTP AUTH failed with the remote server. (state 8).
    '8'  => { 'command' => 'AUTH', 'reason' => 'systemerror' },

    # http://www.google.co.nz/support/forum/p/gmail/thread?tid=45208164dbca9d24&hl=en
    # Technical details of temporary failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 454 454 TLS missing certificate: error:0200100D:system library:fopen:Permission denied (#4.3.0) (state 9).
    '9'  => { 'command' => 'AUTH', 'reason' => 'systemerror' },

    # http://www.google.com/support/forum/p/gmail/thread?tid=5cfab8c76ec88638&hl=en
    # Technical details of permanent failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 500 Remote server does not support SMTP Authenticated Relay (state 12). 
    '12' => { 'command' => 'AUTH', 'reason' => 'relayingdenied' },

    # Technical details of permanent failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was: 
    # 550 550 5.7.1 <****@gmail.com>... Access denied (state 13).
    '13' => { 'command' => 'EHLO', 'reason' => 'blocked' },

    # Technical details of permanent failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 550 550 5.1.1 <******@*********.**>... User Unknown (state 14).
    # 550 550 5.2.2 <*****@****.**>... Mailbox Full (state 14).
    # 
    '14' => { 'command' => 'RCPT', 'reason' => 'userunknown' },

    # http://www.google.cz/support/forum/p/gmail/thread?tid=7090cbfd111a24f9&hl=en
    # Technical details of permanent failure:
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 550 550 5.7.1 SPF unauthorized mail is prohibited. (state 15).
    # 554 554 Error: no valid recipients (state 15). 
    '15' => { 'command' => 'DATA', 'reason' => 'filtered' },

    # http://www.google.com/support/forum/p/Google%20Apps/thread?tid=0aac163bc9c65d8e&hl=en
    # Technical details of permanent failure:
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 550 550 <****@***.**> No such user here (state 17).
    # 550 550 #5.1.0 Address rejected ***@***.*** (state 17).
    '17' => { 'command' => 'DATA', 'reason' => 'filtered' },

    # Technical details of permanent failure: 
    # Google tried to deliver your message, but it was rejected by the recipient domain.
    # We recommend contacting the other email provider for further information about the
    # cause of this error. The error that the other server returned was:
    # 550 550 Unknown user *****@***.**.*** (state 18).
    '18' => { 'command' => 'DATA', 'reason' => 'filtered' },
};

sub headerlist  { return ['X-Failed-Recipients'] }
sub description { 'Google Gmail: https://mail.google.com' }
sub scan {
    # Detect an error from Google Gmail
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
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # Google Mail
    # From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
    # Received: from vw-in-f109.1e100.net [74.125.113.109] by ...
    #
    # * Check the body part
    #   This is an automatically generated Delivery Status Notification
    #   Delivery to the following recipient failed permanently:
    #
    #        recipient-address-here@example.jp
    #
    #   Technical details of permanent failure: 
    #   Google tried to deliver your message, but it was rejected by the
    #   recipient domain. We recommend contacting the other email provider
    #   for further information about the cause of this error. The error
    #   that the other server returned was: 
    #   550 550 <recipient-address-heare@example.jp>: User unknown (state 14).
    #
    #   -- OR --
    #   THIS IS A WARNING MESSAGE ONLY.
    #
    #   YOU DO NOT NEED TO RESEND YOUR MESSAGE.
    #
    #   Delivery to the following recipient has been delayed:
    #
    #        mailboxfull@example.jp
    #
    #   Message will be retried for 2 more day(s)
    #
    #   Technical details of temporary failure:
    #   Google tried to deliver your message, but it was rejected by the recipient
    #   domain. We recommend contacting the other email provider for further infor-
    #   mation about the cause of this error. The error that the other server re-
    #   turned was: 450 450 4.2.2 <mailboxfull@example.jp>... Mailbox Full (state 14).
    #
    #   -- OR --
    #
    #   Delivery to the following recipient failed permanently:
    #
    #        userunknown@example.jp
    #
    #   Technical details of permanent failure:=20
    #   Google tried to deliver your message, but it was rejected by the server for=
    #    the recipient domain example.jp by mx.example.jp. [192.0.2.59].
    #
    #   The error that the other server returned was:
    #   550 5.1.1 <userunknown@example.jp>... User Unknown
    #
    return undef unless rindex($mhead->{'from'}, '<mailer-daemon@googlemail.com>') > -1;
    return undef unless index($mhead->{'subject'}, 'Delivery Status Notification') > -1;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $statecode0 = 0;     # (Integer) The value of (state *) in the error message
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $Indicators->{'deliverystatus'} if index($e, $StartingOf->{'message'}->[0]) > -1;
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e =~ $MarkingsOf->{'rfc822'} ) {
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

            # Technical details of permanent failure:=20
            # Google tried to deliver your message, but it was rejected by the recipient =
            # domain. We recommend contacting the other email provider for further inform=
            # ation about the cause of this error. The error that the other server return=
            # ed was: 554 554 5.7.0 Header error (state 18).
            #
            # -- OR --
            #
            # Technical details of permanent failure:=20
            # Google tried to deliver your message, but it was rejected by the server for=
            # the recipient domain example.jp by mx.example.jp. [192.0.2.49].
            #
            # The error that the other server returned was:
            # 550 5.1.1 <userunknown@example.jp>... User Unknown
            #
            $v = $dscontents->[-1];

            if( $e =~ /\A[ \t]+([^ ]+[@][^ ]+)\z/ ) {
                # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }

                my $addr0 = Sisimai::Address->s3s4($1);
                if( Sisimai::RFC5322->is_emailaddress($addr0) ) {
                    $v->{'recipient'} = $addr0;
                    $recipients++;
                }
            } else {
                $v->{'diagnosis'} .= $e.' ';
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        unless( $e->{'rhost'} ) {
            # Get the value of remote host
            if( $e->{'diagnosis'} =~ /[ \t]+by[ \t]+([^ ]+)[.][ \t]+\[(\d+[.]\d+[.]\d+[.]\d+)\][.]/ ) {
                # Google tried to deliver your message, but it was rejected by # the server 
                # for the recipient domain example.jp by mx.example.jp. [192.0.2.153].
                my $hostname = $1;
                my $ipv4addr = $2;
                if( $hostname =~ /[-0-9a-zA-Z]+[.][a-zA-Z]+\z/ ) {
                    # Maybe valid hostname
                    $e->{'rhost'} = $hostname;
                } else {
                    # Use IP address instead
                    $e->{'rhost'} = $ipv4addr;
                }
            }
        }

        $statecode0 = $1 if $e->{'diagnosis'} =~ /[(]state[ ](\d+)[)][.]/;
        if( exists $StateTable->{ $statecode0 } ) {
            # (state *)
            $e->{'reason'}  = $StateTable->{ $statecode0 }->{'reason'};
            $e->{'command'} = $StateTable->{ $statecode0 }->{'command'};

        } else {
            # No state code
            SESSION: for my $r ( keys %$MessagesOf ) {
                # Verify each regular expression of session errors
                next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
                $e->{'reason'} = $r;
                last;
            }
        }
        next unless $e->{'reason'};

        # Set pseudo status code
        $e->{'status'} = Sisimai::SMTP::Status->find($e->{'diagnosis'});
        if( $e->{'status'} =~ /\A[45][.][1-7][.][1-9]\z/ ) {
            # Override bounce reason 
            $e->{'reason'} = Sisimai::SMTP::Status->name($e->{'status'});
        }
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::Google - bounce mail parser class for C<Gmail>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Google;

=head1 DESCRIPTION

Sisimai::Bite::Email::Google parses a bounce email which created by C<Gmail>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Google->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Google->smtpagent;

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
