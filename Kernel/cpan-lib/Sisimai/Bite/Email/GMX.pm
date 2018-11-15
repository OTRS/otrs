package Sisimai::Bite::Email::GMX;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['This message was created automatically by mail delivery software'],
    'rfc822'  => ['--- The header of the original message is following'],
};
my $MessagesOf = { 'expired' => ['delivery retry timeout exceeded'] };

# Envelope-To: <kijitora@mail.example.com>
# X-GMX-Antispam: 0 (Mail was not recognized as spam); Detail=V3;
# X-GMX-Antivirus: 0 (no virus found)
# X-UI-Out-Filterresults: unknown:0;
sub headerlist  { return ['X-GMX-Antispam'] }
sub description { 'GMX: http://www.gmx.net' }
sub scan {
    # Detect an error from GMX and mail.com
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
    # @since v4.1.4
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # 'from'    => qr/\AMAILER-DAEMON[@]/,
    # 'subject' => qr/\AMail delivery failed: returning message to sender\z/,
    return undef unless defined $mhead->{'x-gmx-antispam'};

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
            if( index($e, $StartingOf->{'rfc822'}->[0]) == 0 ) {
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

            # This message was created automatically by mail delivery software.
            #
            # A message that you sent could not be delivered to one or more of
            # its recipients. This is a permanent error. The following address
            # failed:
            #
            # "shironeko@example.jp":
            # SMTP error from remote server after RCPT command:
            # host: mx.example.jp
            # 5.1.1 <shironeko@example.jp>... User Unknown
            $v = $dscontents->[-1];

            if( $e =~ /\A["]([^ ]+[@][^ ]+)["]:\z/ || $e =~ /\A[<]([^ ]+[@][^ ]+)[>]\z/ ) {
                # "shironeko@example.jp":
                # ---- OR ----
                # <kijitora@6jo.example.co.jp>
                #
                # Reason:
                # delivery retry timeout exceeded
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\ASMTP error .+ ([A-Z]{4}) command:\z/ ) {
                # SMTP error from remote server after RCPT command:
                $v->{'command'} = $1;

            } elsif( $e =~ /\Ahost:[ \t]*(.+)\z/ ) {
                # host: mx.example.jp
                $v->{'rhost'} = $1;

            } else {
                # Get error message
                if( $e =~ /\b[45][.]\d[.]\d\b/  || $e =~ /[<][^ ]+[@][^ ]+[>]/ || $e =~ /\b[45]\d{2}\b/ ) {
                    $v->{'diagnosis'} ||= $e;

                } else {
                    next if $e eq '';
                    if( $e eq 'Reason:' ) {
                        # Reason:
                        # delivery retry timeout exceeded
                        $v->{'diagnosis'} = $e;

                    } elsif( $v->{'diagnosis'} eq 'Reason:' ) {
                        $v->{'diagnosis'} = $e;
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     =  __PACKAGE__->smtpagent;
        $e->{'diagnosis'} =~ s/\\n/ /g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$MessagesOf ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
            $e->{'reason'} = $r;
            last;
        }
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::GMX - bounce mail parser class for C<GMX> and mail.com.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::GMX;

=head1 DESCRIPTION

Sisimai::Bite::Email::GMX parses a bounce email which created by C<GMX>. 
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::GMX->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::GMX->smtpagent;

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

