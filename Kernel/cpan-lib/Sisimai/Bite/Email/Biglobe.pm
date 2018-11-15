package Sisimai::Bite::Email::Biglobe;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['   ----- The following addresses had delivery problems -----'],
    'rfc822'  => ['Content-Type: message/rfc822'],
    'error'   => ['   ----- Non-delivered information -----'],
};
my $MessagesOf = {
    'filtered'    => ['Mail Delivery Failed... User unknown'],
    'mailboxfull' => ["The number of messages in recipient's mailbox exceeded the local limit."],
};

sub description { 'BIGLOBE: http://www.biglobe.ne.jp' }
sub scan {
    # Detect an error from Biglobe
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

    return undef unless $mhead->{'from'} =~ /postmaster[@](?:biglobe|inacatv|tmtv|ttv)[.]ne[.]jp/;
    return undef unless index($mhead->{'subject'}, 'Returned mail:') == 0;

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

            # This is a MIME-encapsulated message.
            #
            # ----_Biglobe000000/00000.biglobe.ne.jp
            # Content-Type: text/plain; charset="iso-2022-jp"
            #
            #    ----- The following addresses had delivery problems -----
            # ********@***.biglobe.ne.jp
            #
            #    ----- Non-delivered information -----
            # The number of messages in recipient's mailbox exceeded the local limit.
            #
            # ----_Biglobe000000/00000.biglobe.ne.jp
            # Content-Type: message/rfc822
            #
            $v = $dscontents->[-1];

            if( $e =~ /\A([^ ]+[@][^ ]+)\z/ ) {
                #    ----- The following addresses had delivery problems -----
                # ********@***.biglobe.ne.jp
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
            } else {
                next if $e =~ /\A[^\w]/;
                $v->{'diagnosis'} .= $e.' ';
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

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

Sisimai::Bite::Email::Biglobe - bounce mail parser class for C<BIGLOBE>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Biglobe;

=head1 DESCRIPTION

Sisimai::Bite::Email::Biglobe parses a bounce email which created by C<BIGLOBE>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Biglobe->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Biglobe->smtpagent;

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

