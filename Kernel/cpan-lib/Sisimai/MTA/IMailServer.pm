package Sisimai::MTA::IMailServer;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'x-mailer' => qr/\A[<]SMTP32 v[\d.]+[>][ ]*\z/,
    'subject'  => qr/\AUndeliverable Mail[ ]*\z/,
};
my $Re1 = {
    'begin'  => qr/\A\z/,    # Blank line
    'error'  => qr/Body of message generated response:/,
    'rfc822' => qr/\AOriginal message follows[.]\z/,
    'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $ReSMTP = {
    'conn' => qr{(?:
         SMTP[ ]connection[ ]failed,
        |Unexpected[ ]connection[ ]response[ ]from[ ]server:
        )
    },
    'ehlo' => qr|Unexpected response to EHLO/HELO:|,
    'mail' => qr|Server response to MAIL FROM:|,
    'rcpt' => qr|Additional RCPT TO generated following response:|,
    'data' => qr|DATA command generated response:|,
};
my $ReFailure = {
    'hostunknown' => qr{
        Unknown[ ]host
    },
    'userunknown' => qr{\A(?:
         Unknown[ ]user
        |Invalid[ ]final[ ]delivery[ ]userid    # Filtered ?
        )
    }x,
    'mailboxfull' => qr{
        \AUser[ ]mailbox[ ]exceeds[ ]allowed[ ]size
    }x,
    'securityerr' => qr{
        \ARequested[ ]action[ ]not[ ]taken:[ ]virus[ ]detected
    }x,
    'undefined' => qr{
        \Aundeliverable[ ]to[ ]
    }x,
    'expired' => qr{
        \ADelivery[ ]failed[ ]\d+[ ]attempts
    }x,
};
my $Indicators = __PACKAGE__->INDICATORS;

# X-Mailer: <SMTP32 v8.22>
sub headerlist  { return ['X-Mailer'] }
sub pattern     { return $Re0 }
sub description { 'IPSWITCH IMail Server' }

sub scan {
    # Detect an error from IMailServer
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
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    $match ||= 1 if $mhead->{'subject'} =~ $Re0->{'subject'};
    $match ||= 1 if defined $mhead->{'x-mailer'} && $mhead->{'x-mailer'} =~ $Re0->{'x-mailer'};
    return undef unless $match;

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
            last if $readcursor & $Indicators->{'message-rfc822'};

            # Unknown user: kijitora@example.com
            #
            # Original message follows.
            $v = $dscontents->[-1];

            if( $e =~ m/\A(.+)[ ](.+)[:][ \t]*([^ ]+[@][^ ]+)/ ) {
                # Unknown user: kijitora@example.com
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'diagnosis'} = $1.' '.$2;
                $v->{'recipient'} = $3;
                $recipients++;

            } elsif( $e =~ m/\Aundeliverable[ ]+to[ ]+(.+)\z/ ) {
                # undeliverable to kijitora@example.com
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } else {
                # Other error message text
                $v->{'alterrors'} .= ' '.$e if length $v->{'alterrors'};
                if( $e =~ $Re1->{'error'} ) {
                    # Body of message generated response:
                    $v->{'alterrors'} = $e;
                }
            }
        } # End of if: rfc822
    }

    return undef unless $recipients;
    require Sisimai::String;

    for my $e ( @$dscontents ) {
        $e->{'agent'} = __PACKAGE__->smtpagent;

        if( exists $e->{'alterrors'} && length $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} = $e->{'alterrors'}.' '.$e->{'diagnosis'};
            $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
            delete $e->{'alterrors'};
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        COMMAND: for my $r ( keys %$ReSMTP ) {
            # Detect SMTP command from the message
            next unless $e->{'diagnosis'} =~ $ReSMTP->{ $r };
            $e->{'command'} = uc $r;
            last;
        }

        SESSION: for my $r ( keys %$ReFailure ) {
            # Verify each regular expression of session errors
            next unless $e->{'diagnosis'} =~ $ReFailure->{ $r };
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

Sisimai::MTA::IMailServer - bounce mail parser class for C<IMail Server>.

=head1 SYNOPSIS

    use Sisimai::MTA::IMailServer;

=head1 DESCRIPTION

Sisimai::MTA::IMailServer parses a bounce email which created by 
C<Ipswitch IMail Server>. Methods in the module are called from only 
Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MTA::IMailServer->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MTA::IMailServer->smtpagent;

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

