package Sisimai::MSP::US::Verizon;
use parent 'Sisimai::MSP';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'received' => qr/by .+[.]vtext[.]com /,
    'vtext.com' => {
        'from' => qr/\Apost_master[@]vtext[.]com\z/,
    },
    'vzwpix.com' => {
        'from'    => qr/[<]?sysadmin[@].+[.]vzwpix[.]com[>]?\z/,
        'subject' => qr/Undeliverable Message/,
    },
};
my $Indicators = __PACKAGE__->INDICATORS;

sub pattern     { 
    return {
        'from' => qr/[<]?(?:\Apost_master[@]vtext|sysadmin[@].+[.]vzwpix)[.]com[>]?\z/,
        'subject' => $Re0->{'vzwpix.com'}->{'subject'},
    };
}
sub description { 'Verizon Wireless: http://www.verizonwireless.com' }

sub scan {
    # Detect an error from Verizon
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
    my $match = -1;

    while(1) {
        # Check the value of "From" header
        last unless grep { $_ =~ $Re0->{'received'} } @{ $mhead->{'received'} };
        $match = 1 if $mhead->{'from'} =~ $Re0->{'vtext.com'}->{'from'};
        $match = 0 if $mhead->{'from'} =~ $Re0->{'vzwpix.com'}->{'from'};
        last;
    }
    return undef if $match < 0;

    require Sisimai::MIME;
    require Sisimai::String;
    require Sisimai::Address;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $senderaddr = '';    # (String) Sender address in the message body
    my $subjecttxt = '';    # (String) Subject of the original message

    my $Re1        = {};    # (Ref->Hash) Delimiter patterns
    my $ReFailure  = {};    # (Ref->Hash) Error message patterns
    my $boundary00 = '';    # (String) Boundary string
    my $v = undef;

    if( $match == 1 ) {
        # vtext.com
        $Re1 = {
            'begin'  => qr/\AError:[ \t]/,
            'rfc822' => qr/\A__BOUNDARY_STRING_HERE__\z/,
            'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
        };
        $ReFailure = {
            'userunknown' => qr{
                # The attempted recipient address does not exist.
                550[ ][-][ ]Requested[ ]action[ ]not[ ]taken:[ ]no[ ]such[ ]user[ ]here
            }x,
        };

        $boundary00 = Sisimai::MIME->boundary($mhead->{'content-type'});
        if( length $boundary00 ) {
            # Convert to regular expression
            $boundary00 = '--'.$boundary00.'--';
            $Re1->{'rfc822'} = qr/\A\Q$boundary00\E\z/; 
        }

        for my $e ( @hasdivided ) {
            # Read each line between $Re0->{'begin'} and $Re0->{'rfc822'}.
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

                # Message details:
                #   Subject: Test message
                #   Sent date: Wed Jun 12 02:21:53 GMT 2013
                #   MAIL FROM: *******@hg.example.com
                #   RCPT TO: *****@vtext.com
                $v = $dscontents->[-1];

                if( $e =~ m/\A[ \t]+RCPT TO: (.*)\z/ ) {
                    if( length $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;
                    next;

                } elsif( $e =~ m/\A[ \t]+MAIL FROM:[ \t](.+)\z/ ) {
                    #   MAIL FROM: *******@hg.example.com
                    $senderaddr ||= $1;

                } elsif( $e =~ m/\A[ \t]+Subject:[ \t](.+)\z/ ) {
                    #   Subject:
                    $subjecttxt ||= $1;

                } else {
                    # 550 - Requested action not taken: no such user here
                    $v->{'diagnosis'} = $e if $e =~ m/\A(\d{3})[ \t][-][ \t](.*)\z/;
                }
            } # End of if: rfc822
        }
    } else {
        # vzwpix.com
        $Re1 = {
            'begin'  => qr/\AMessage could not be delivered to mobile/,
            'rfc822' => qr/\A__BOUNDARY_STRING_HERE__\z/,
            'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
        };
        $ReFailure = {
            'userunknown' => qr{
                No[ ]valid[ ]recipients[ ]for[ ]this[ ]MM
            }x,
        };

        $boundary00 = Sisimai::MIME->boundary($mhead->{'content-type'});
        if( length $boundary00 ) {
            # Convert to regular expression
            $boundary00 = '--'.$boundary00.'--';
            $Re1->{'rfc822'} = qr/\A\Q$boundary00\E\z/; 
        }

        for my $e ( @hasdivided ) {
            # Read each line between $Re0->{'begin'} and $Re0->{'rfc822'}.
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

                # Original Message:
                # From: kijitora <kijitora@example.jp>
                # To: 0000000000@vzwpix.com
                # Subject: test for bounce
                # Date:  Wed, 20 Jun 2013 10:29:52 +0000
                $v = $dscontents->[-1];

                if( $e =~ m/\ATo:[ \t]+(.*)\z/ ) {
                    if( length $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = Sisimai::Address->s3s4($1);
                    $recipients++;
                    next;

                } elsif( $e =~ m/\AFrom:[ \t](.+)\z/ ) {
                    # From: kijitora <kijitora@example.jp>
                    $senderaddr ||= Sisimai::Address->s3s4($1);

                } elsif( $e =~ m/\ASubject:[ \t](.+)\z/ ) {
                    #   Subject:
                    $subjecttxt ||= $1;

                } else {
                    # Message could not be delivered to mobile.
                    # Error: No valid recipients for this MM
                    $v->{'diagnosis'} = $e if $e =~ m/\AError:[ \t]+(.+)\z/;
                }
            } # End of if: rfc822
        }
    }
    return undef unless $recipients;

    if( ! grep { $_ =~ /^From: / } @$rfc822list ) {
        # Set the value of "MAIL FROM:" or "From:"
        push @$rfc822list, sprintf("From: %s", $senderaddr);

    } elsif( ! grep { $_ =~ /^Subject: / } @$rfc822list ) {
        # Set the value of "Subject"
        push @$rfc822list, sprintf("Subject: %s", $subjecttxt);
    }

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

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

Sisimai::MSP::US::Verizon - bounce mail parser class for C<Verizon Wireless>.

=head1 SYNOPSIS

    use Sisimai::MSP::US::Verizon;

=head1 DESCRIPTION

Sisimai::MSP::US::Verizon parses a bounce email which created by C<Verizon
Wireless>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MSP::US::Verizon->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MSP::US::Verizon->smtpagent;

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
