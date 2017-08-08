package Sisimai::MSP::JP::KDDI;
use parent 'Sisimai::MSP';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'from'       => qr/no-reply[@].+[.]dion[.]ne[.]jp/,
    'reply-to'   => qr/\Afrom[ \t]+\w+[.]auone[-]net[.]jp[ \t]/,
    'received'   => qr/\Afrom[ ](?:.+[.])?ezweb[.]ne[.]jp[ ]/,
    'message-id' => qr/[@].+[.]ezweb[.]ne[.]jp[>]\z/,
};
my $Re1 = {
    'begin' => qr/\AYour[ ]mail[ ](?:
         sent[ ]on:?[ ][A-Z][a-z]{2}[,]
        |attempted[ ]to[ ]be[ ]delivered[ ]on:?[ ][A-Z][a-z]{2}[,]
        )
    /x,
    'rfc822' => qr|\AContent-Type: message/rfc822\z|,
    'error'  => qr/Could not be delivered to:? /,
    'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $ReFailure = {
    'mailboxfull' => qr/As[ ]their[ ]mailbox[ ]is[ ]full/x,
    'norelaying'  => qr/Due[ ]to[ ]the[ ]following[ ]SMTP[ ]relay[ ]error/x,
    'hostunknown' => qr/As[ ]the[ ]remote[ ]domain[ ]doesnt[ ]exist/x,
};
my $Indicators = __PACKAGE__->INDICATORS;

sub pattern     { return $Re0 }
sub description { 'au by KDDI: http://www.au.kddi.com' }

sub scan {
    # Detect an error from au by KDDI
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
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    $match ||= 1 if $mhead->{'from'} =~ $Re0->{'from'};
    $match ||= 1 if $mhead->{'reply-to'} && $mhead->{'reply-to'} =~ $Re0->{'reply-to'};
    $match ||= 1 if grep { $_ =~ $Re0->{'received'} } @{ $mhead->{'received'} };
    return undef unless $match;

    require Sisimai::String;
    require Sisimai::Address;

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

            $v = $dscontents->[-1];
            if( $e =~ m/\A[ \t]+Could not be delivered to: [<]([^ ]+[@][^ ]+)[>]/ ) {
                # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900 
                #     Could not be delivered to: <******@**.***.**>
                #     As their mailbox is full.
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }

                my $r = Sisimai::Address->s3s4($1);
                if( Sisimai::RFC5322->is_emailaddress($r) ) {
                    $v->{'recipient'} = $r;
                    $recipients++;
                }
            } elsif( $e =~ m/Your mail sent on: (.+)\z/ ) {
                # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900 
                $v->{'date'} = $1;

            } else {
                #     As their mailbox is full.
                $v->{'diagnosis'} .= $e.' ' if $e =~ m/\A[ \t]+/;
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( defined $mhead->{'x-spasign'} && $mhead->{'x-spasign'} eq 'NG' ) {
            # Content-Type: text/plain; ..., X-SPASIGN: NG (spamghetti, au by KDDI)
            # Filtered recipient returns message that include 'X-SPASIGN' header
            $e->{'reason'} = 'filtered';

        } else {
            if( $e->{'command'} eq 'RCPT' ) {
                # set "userunknown" when the remote server rejected after RCPT
                # command.
                $e->{'reason'} = 'userunknown';

            } else {
                # SMTP command is not RCPT
                SESSION: for my $r ( keys %$ReFailure ) {
                    # Verify each regular expression of session errors
                    next unless $e->{'diagnosis'} =~ $ReFailure->{ $r };
                    $e->{'reason'} = $r;
                    last;
                }
            }
        }
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::MSP::JP::KDDI - bounce mail parser class for C<au by KDDI>.

=head1 SYNOPSIS

    use Sisimai::MSP::JP::KDDI;

=head1 DESCRIPTION

Sisimai::MSP::JP::KDDI parses a bounce email which created by C<au by KDDI>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MSP::JP::KDDI->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MSP::JP::KDDI->smtpagent;

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
