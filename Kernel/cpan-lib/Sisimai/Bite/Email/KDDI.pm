package Sisimai::Bite::Email::KDDI;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = { 'rfc822' => ['Content-Type: message/rfc822'] };
my $MarkingsOf = {
    'message' => qr/\AYour[ ]mail[ ](?:
         sent[ ]on:?[ ][A-Z][a-z]{2}[,]
        |attempted[ ]to[ ]be[ ]delivered[ ]on:?[ ][A-Z][a-z]{2}[,]
        )
    /x,
};
my $MessagesOf = {
    'mailboxfull' => ['As their mailbox is full'],
    'norelaying'  => ['Due to the following SMTP relay error'],
    'hostunknown' => ['As the remote domain doesnt exist'],
};

sub description { 'au by KDDI: http://www.au.kddi.com' }
sub scan {
    # Detect an error from au by KDDI
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
    my $match = 0;

    # 'message-id' => qr/[@].+[.]ezweb[.]ne[.]jp[>]\z/,
    $match ||= 1 if $mhead->{'from'} =~ /no-reply[@].+[.]dion[.]ne[.]jp/;
    $match ||= 1 if $mhead->{'reply-to'} && $mhead->{'reply-to'} eq 'no-reply@app.auone-net.jp';
    $match ||= 1 if grep { rindex($_, 'ezweb.ne.jp (') > -1 } @{ $mhead->{'received'} };
    $match ||= 1 if grep { rindex($_, '.au.com (') > -1 } @{ $mhead->{'received'} };
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
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e =~ $MarkingsOf->{'message'} ) {
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

            $v = $dscontents->[-1];
            if( $e =~ /\A[ \t]+Could not be delivered to: [<]([^ ]+[@][^ ]+)[>]/ ) {
                # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900 
                #     Could not be delivered to: <******@**.***.**>
                #     As their mailbox is full.
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }

                my $r = Sisimai::Address->s3s4($1);
                if( Sisimai::RFC5322->is_emailaddress($r) ) {
                    $v->{'recipient'} = $r;
                    $recipients++;
                }
            } elsif( $e =~ /Your mail sent on: (.+)\z/ ) {
                # Your mail sent on: Thu, 29 Apr 2010 11:04:47 +0900 
                $v->{'date'} = $1;

            } else {
                #     As their mailbox is full.
                $v->{'diagnosis'} .= $e.' ' if $e =~ /\A[ \t]+/;
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
                SESSION: for my $r ( keys %$MessagesOf ) {
                    # Verify each regular expression of session errors
                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
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

Sisimai::Bite::Email::KDDI - bounce mail parser class for C<au by KDDI>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::KDDI;

=head1 DESCRIPTION

Sisimai::Bite::Email::KDDI parses a bounce email which created by C<au by KDDI>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::KDDI->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::KDDI->smtpagent;

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
