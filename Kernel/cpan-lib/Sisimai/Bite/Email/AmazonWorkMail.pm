package Sisimai::Bite::Email::AmazonWorkMail;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

# https://aws.amazon.com/workmail/
my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Technical report:'],
    'rfc822'  => ['content-type: message/rfc822'],
};

# X-Mailer: Amazon WorkMail
# X-Original-Mailer: Amazon WorkMail
# X-Ses-Outgoing: 2016.01.14-54.240.27.159
sub headerlist  { return ['X-SES-Outgoing', 'X-Original-Mailer'] }
sub description { 'Amazon WorkMail: https://aws.amazon.com/workmail/' }
sub scan {
    # Detect an error from Amazon WorkMail
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
    # @since v4.1.29
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $xmail = $mhead->{'x-original-mailer'} || $mhead->{'x-mailer'} || '';

    # 'subject' => qr/Delivery[_ ]Status[_ ]Notification[_ ].+Failure/,
    # 'received'=> qr/.+[.]smtp-out[.].+[.]amazonses[.]com\b/,
    $match++ if $mhead->{'x-ses-outgoing'};
    if( $xmail ) {
        # X-Mailer: Amazon WorkMail
        # X-Original-Mailer: Amazon WorkMail
        $match++ if $xmail eq 'Amazon WorkMail';
    }
    return undef if $match < 2;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'lhost' => '',      # The value of Reporting-MTA header
    };
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e eq $StartingOf->{'message'}->[0] ) {
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

            if( $connvalues == scalar(keys %$connheader) ) {
                # Action: failed
                # Final-Recipient: rfc822; kijitora@libsisimai.org
                # Diagnostic-Code: smtp; 554 4.4.7 Message expired: unable to deliver in 840 minutes.<421 4.4.2 Connection timed out>
                # Status: 4.4.7
                $v = $dscontents->[-1];

                if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # Final-Recipient: RFC822; kijitora@example.jp
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;

                } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                    # Action: failed
                    $v->{'action'} = lc $1;

                } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                    # Status: 5.1.1
                    $v->{'status'} = $1;

                } else {
                    if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                        # Diagnostic-Code: SMTP; 550 5.1.1 <kijitora@example.jp>... User Unknown
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;
                    }
                }
            } else {
                # Technical report:
                #
                # Reporting-MTA: dsn; a27-85.smtp-out.us-west-2.amazonses.com
                #
                if( $e =~ /\AReporting-MTA:[ ]*[DNSdns]+;[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; mx.example.jp
                    next if $connheader->{'lhost'};
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;
                }
            }

            # <!DOCTYPE HTML><html>
            # <head>
            # <meta name="Generator" content="Amazon WorkMail v3.0-2023.77">
            # <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            last if index($e, '<!DOCTYPE HTML><html>') == 0;
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});

        if( $e->{'status'} =~ /\A[45][.][01][.]0\z/ ) {
            # Get other D.S.N. value from the error message
            my $pseudostatus = '';
            my $errormessage = $e->{'diagnosis'};

            # 5.1.0 - Unknown address error 550-'5.7.1 ...
            $errormessage = $1 if $e->{'diagnosis'} =~ /["'](\d[.]\d[.]\d.+)['"]/;
            $pseudostatus = Sisimai::SMTP::Status->find($errormessage);
            $e->{'status'} = $pseudostatus if $pseudostatus;
        }

        # 554 4.4.7 Message expired: unable to deliver in 840 minutes.
        # <421 4.4.2 Connection timed out>
        $e->{'replycode'} = $1 if $e->{'diagnosis'} =~ /[<]([245]\d\d)[ ].+[>]/;
        $e->{'reason'}  ||= Sisimai::SMTP::Status->name($e->{'status'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::AmazonWorkMail - bounce mail parser class for C<Amazon WorkMail>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::AmazonWorkMail;

=head1 DESCRIPTION

Sisimai::Bite::Email::AmazonWorkMail parses a bounce email which created by C<Amazon WorkMail>.
Methods in the module are called from only Sisimai::Message. 

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::AmazonWorkMail->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::AmazonWorkMail->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

