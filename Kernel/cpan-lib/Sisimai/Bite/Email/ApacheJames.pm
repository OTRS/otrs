package Sisimai::Bite::Email::ApacheJames;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    # apache-james-2.3.2/src/java/org/apache/james/transport/mailets/
    #   AbstractNotify.java|124:  out.println("Error message below:");
    #   AbstractNotify.java|128:  out.println("Message details:");
    'message' => [''],
    'rfc822'  => ['Content-Type: message/rfc822'],
    'error'   => ['Error message below:'],
};

sub description { 'Java Apache Mail Enterprise Server' }
sub scan {
    # Detect an error from ApacheJames
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
    # @since v4.1.26
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # 'subject'    => qr/\A\[BOUNCE\]\z/,
    # 'received'   => qr/JAMES SMTP Server/,
    # 'message-id' => qr/\d+[.]JavaMail[.].+[@]/,
    $match ||= 1 if $mhead->{'subject'} eq '[BOUNCE]';
    $match ||= 1 if defined $mhead->{'message-id'} && rindex($mhead->{'message-id'}, '.JavaMail.') > -1;
    $match ||= 1 if grep { rindex($_, 'JAMES SMTP Server') > -1 } @{ $mhead->{'received'} };
    return undef unless $match;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $diagnostic = '';    # (String) Alternative diagnostic message
    my $subjecttxt = undef; # (String) Alternative Subject text
    my $gotmessage = 0;     # (Integer) Flag for error message
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

            # Message details:
            #   Subject: Nyaaan
            #   Sent date: Thu Apr 29 01:20:50 JST 2015
            #   MAIL FROM: shironeko@example.jp
            #   RCPT TO: kijitora@example.org
            #   From: Neko <shironeko@example.jp> 
            #   To: kijitora@example.org
            #   Size (in bytes): 1024
            #   Number of lines: 64
            $v = $dscontents->[-1];

            if( $e =~ /\A[ ][ ]RCPT[ ]TO:[ ]([^ ]+[@][^ ]+)\z/ ) {
                #   RCPT TO: kijitora@example.org
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\A[ ][ ]Sent[ ]date:[ ](.+)\z/ ) {
                #   Sent date: Thu Apr 29 01:20:50 JST 2015
                $v->{'date'} = $1;

            } elsif( $e =~ /\A[ ][ ]Subject:[ ](.+)\z/ ) {
                #   Subject: Nyaaan
                $subjecttxt = $1;

            } else {
                next if $gotmessage == 1;

                if( $v->{'diagnosis'} ) {
                    # Get an error message text
                    if( $e eq 'Message details:' ) {
                        # Message details:
                        #   Subject: nyaan
                        #   ...
                        $gotmessage = 1;

                    } else {
                        # Append error message text like the followng:
                        #   Error message below:
                        #   550 - Requested action not taken: no such user here
                        $v->{'diagnosis'} .= ' '.$e;
                    }
                } else {
                    # Error message below:
                    # 550 - Requested action not taken: no such user here
                    $v->{'diagnosis'} = $e if $e eq $StartingOf->{'error'}->[0];
                    $v->{'diagnosis'} .= ' '.$e unless $gotmessage;
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    unless( grep { index($_, 'Subject:') == 0 } @$rfc822list ) {
        # Set the value of $subjecttxt as a Subject if there is no original
        # message in the bounce mail.
        push @$rfc822list, 'Subject: '.$subjecttxt;
    }

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'} || $diagnostic);
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::ApacheJames - bounce mail parser class for C<ApacheJames>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::ApacheJames;

=head1 DESCRIPTION

Sisimai::Bite::Email::ApacheJames parses a bounce email which created by C<ApacheJames>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::ApacheJames->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::ApacheJames->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

