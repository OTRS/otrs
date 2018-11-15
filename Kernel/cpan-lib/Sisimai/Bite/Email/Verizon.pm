package Sisimai::Bite::Email::Verizon;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;

sub description { 'Verizon Wireless: http://www.verizonwireless.com' }
sub scan {
    # Detect an error from Verizon
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
    my $match = -1;

    while(1) {
        # Check the value of "From" header
        # 'subject' => qr/Undeliverable Message/,
        last unless grep { rindex($_, '.vtext.com (') > -1 } @{ $mhead->{'received'} };
        $match = 1 if $mhead->{'from'} eq 'post_master@vtext.com';
        $match = 0 if $mhead->{'from'} =~ /[<]?sysadmin[@].+[.]vzwpix[.]com[>]?\z/;
        last;
    }
    return undef if $match < 0;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $senderaddr = '';    # (String) Sender address in the message body
    my $subjecttxt = '';    # (String) Subject of the original message

    my $StartingOf = {};    # (Ref->Hash) Delimiter strings
    my $MarkingsOf = {};    # (Ref->Hash) Delimiter patterns
    my $MessagesOf = {};    # (Ref->Hash) Error message patterns
    my $boundary00 = '';    # (String) Boundary string
    my $v = undef;

    if( $match == 1 ) {
        # vtext.com
        $MarkingsOf = {
            'message' => qr/\AError:[ \t]/,
            'rfc822'  => qr/\A__BOUNDARY_STRING_HERE__\z/,
        };
        $MessagesOf = {
            # The attempted recipient address does not exist.
            'userunknown' => ['550 - Requested action not taken: no such user here'],
        };

        $boundary00 = Sisimai::MIME->boundary($mhead->{'content-type'});
        if( $boundary00 ) {
            # Convert to regular expression
            $boundary00 = '--'.$boundary00.'--';
            $MarkingsOf->{'rfc822'} = qr/\A\Q$boundary00\E\z/; 
        }

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

                # Message details:
                #   Subject: Test message
                #   Sent date: Wed Jun 12 02:21:53 GMT 2013
                #   MAIL FROM: *******@hg.example.com
                #   RCPT TO: *****@vtext.com
                $v = $dscontents->[-1];

                if( $e =~ /\A[ \t]+RCPT TO: (.*)\z/ ) {
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;
                    next;

                } elsif( $e =~ /\A[ \t]+MAIL FROM:[ \t](.+)\z/ ) {
                    #   MAIL FROM: *******@hg.example.com
                    $senderaddr ||= $1;

                } elsif( $e =~ /\A[ \t]+Subject:[ \t](.+)\z/ ) {
                    #   Subject:
                    $subjecttxt ||= $1;

                } else {
                    # 550 - Requested action not taken: no such user here
                    $v->{'diagnosis'} = $e if $e =~ /\A(\d{3})[ \t][-][ \t](.*)\z/;
                }
            } # End of if: rfc822
        }
    } else {
        # vzwpix.com
        $StartingOf = { 'message' => ['Message could not be delivered to mobile'] };
        $MarkingsOf = { 'rfc822'  => qr/\A__BOUNDARY_STRING_HERE__\z/ };
        $MessagesOf = { 'userunknown' => ['No valid recipients for this MM'] };

        $boundary00 = Sisimai::MIME->boundary($mhead->{'content-type'});
        if( $boundary00 ) {
            # Convert to regular expression
            $boundary00 = '--'.$boundary00.'--';
            $MarkingsOf->{'rfc822'} = qr/\A\Q$boundary00\E\z/; 
        }

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

                # Original Message:
                # From: kijitora <kijitora@example.jp>
                # To: 0000000000@vzwpix.com
                # Subject: test for bounce
                # Date:  Wed, 20 Jun 2013 10:29:52 +0000
                $v = $dscontents->[-1];

                if( $e =~ /\ATo:[ \t]+(.*)\z/ ) {
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = Sisimai::Address->s3s4($1);
                    $recipients++;
                    next;

                } elsif( $e =~ /\AFrom:[ \t](.+)\z/ ) {
                    # From: kijitora <kijitora@example.jp>
                    $senderaddr ||= Sisimai::Address->s3s4($1);

                } elsif( $e =~ /\ASubject:[ \t](.+)\z/ ) {
                    #   Subject:
                    $subjecttxt ||= $1;

                } else {
                    # Message could not be delivered to mobile.
                    # Error: No valid recipients for this MM
                    $v->{'diagnosis'} = $e if $e =~ /\AError:[ \t]+(.+)\z/;
                }
            } # End of if: rfc822
        }
    }
    return undef unless $recipients;

    if( ! grep { index($_, 'From: ') == 0 } @$rfc822list ) {
        # Set the value of "MAIL FROM:" or "From:"
        push @$rfc822list, 'From: '.$senderaddr;

    } elsif( ! grep { index($_, 'Subject: ') == 0 } @$rfc822list ) {
        # Set the value of "Subject"
        push @$rfc822list, 'Subject: '.$subjecttxt;
    }

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

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

Sisimai::Bite::Email::Verizon - bounce mail parser class for C<Verizon Wireless>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Verizon;

=head1 DESCRIPTION

Sisimai::Bite::Email::Verizon parses a bounce email which created by C<Verizon Wireless>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Verizon->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Verizon->smtpagent;

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
