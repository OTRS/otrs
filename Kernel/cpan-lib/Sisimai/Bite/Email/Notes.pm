package Sisimai::Bite::Email::Notes;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;
use Encode;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['------- Failure Reasons '],
    'rfc822'  => ['------- Returned Message '],
};
my $MessagesOf = {
    'userunknown' => [
        'User not listed in public Name & Address Book',
        'ディレクトリのリストにありません',
    ],
    'networkerror' => ['Message has exceeded maximum hop count'],
};

sub description { 'Lotus Notes' }
sub scan {
    # Detect an error from Lotus Notes
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
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    return undef unless index($mhead->{'subject'}, 'Undeliverable message') == 0;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $characters = '';    # (String) Character set name of the bounce mail
    my $removedmsg = 'MULTIBYTE CHARACTERS HAVE BEEN REMOVED';
    my $encodedmsg = '';
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

        unless( $characters ) {
            # Get character set name
            # Content-Type: text/plain; charset=ISO-2022-JP
            $characters = lc $1 if $mhead->{'content-type'} =~ /\A.+;[ ]*charset=(.+)\z/;
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

            # ------- Failure Reasons  --------
            # 
            # User not listed in public Name & Address Book
            # kijitora@notes.example.jp
            #
            # ------- Returned Message --------
            $v = $dscontents->[-1];
            if( $e =~ /\A[^ ]+[@][^ ]+/ ) {
                # kijitora@notes.example.jp
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} ||= $e;
                $recipients++;

            } else {
                next if $e eq '';
                next if index($e, '-') == 0;

                if( $e =~ /[^\x20-\x7e]/ ) {
                    # Error message is not ISO-8859-1
                    $encodedmsg = $e;
                    if( $characters ) {
                        # Try to convert string
                        eval { Encode::from_to($encodedmsg, $characters, 'utf8'); };
                        $encodedmsg = $removedmsg if $@;    # Failed to convert

                    } else {
                        # No character set in Content-Type header
                        $encodedmsg = $removedmsg;
                    }
                    $v->{'diagnosis'} .= $encodedmsg;

                } else {
                    # Error message does not include multi-byte character
                    $v->{'diagnosis'} .= $e;
                }
            }
        } # End of if: rfc822
    }

    unless( $recipients ) {
        # Fallback: Get the recpient address from RFC822 part
        for my $e ( @$rfc822list ) {
            if( $e =~ /^To:[ ]*(.+)$/ ) {
                $v->{'recipient'} = Sisimai::Address->s3s4($1);
                $recipients++ if $v->{'recipient'};
                last;
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'recipient'} = Sisimai::Address->s3s4($e->{'recipient'});

        for my $r ( keys %$MessagesOf ) {
            # Check each regular expression of Notes error messages
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
            $e->{'reason'} = $r;

            my $pseudostatus = Sisimai::SMTP::Status->code($r);
            $e->{'status'} = $pseudostatus if $pseudostatus;
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

Sisimai::Bite::Email::Notes - bounce mail parser class for C<Lotus Notes Server>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Notes;

=head1 DESCRIPTION

Sisimai::Bite::Email::Notes parses a bounce email which created by
C<Lotus Notes Server>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Notes->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Notes->smtpagent;

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

