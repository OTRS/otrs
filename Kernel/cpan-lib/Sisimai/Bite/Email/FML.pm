package Sisimai::Bite::Email::FML;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = { 'rfc822' => ['Original mail as follows:'] };
my $ErrorTitle = {
    'rejected' => qr{(?>
         (?:Ignored[ ])*NOT[ ]MEMBER[ ]article[ ]from[ ]
        |reject[ ]mail[ ](?:.+:|from)[ ],
        |Spam[ ]mail[ ]from[ ]a[ ]spammer[ ]is[ ]rejected
        |You[ ].+[ ]are[ ]not[ ]member
        )
    }x,
    'systemerror' => qr{(?:
         fml[ ]system[ ]error[ ]message
        |Loop[ ]Alert:[ ]
        |Loop[ ]Back[ ]Warning:[ ]
        |WARNING:[ ]UNIX[ ]FROM[ ]Loop
        )
    }x,
    'securityerror' => qr/Security Alert/,
};
my $ErrorTable = {
    'rejected' => qr{(?>
        (?:Ignored[ ])*NOT[ ]MEMBER[ ]article[ ]from[ ]
        |reject[ ](?:
             mail[ ]from[ ].+[@].+
            |since[ ].+[ ]header[ ]may[ ]cause[ ]mail[ ]loop
            |spammers:
            )
        |You[ ]are[ ]not[ ]a[ ]member[ ]of[ ]this[ ]mailing[ ]list
        )
    }x,
    'systemerror' => qr{(?:
         Duplicated[ ]Message-ID
        |fml[ ].+[ ]has[ ]detected[ ]a[ ]loop[ ]condition[ ]so[ ]that
        |Loop[ ]Back[ ]Warning:
        )
    }x,
    'securityerror' => qr/Security alert:/,
};

sub headerlist  { return ['X-MLServer'] }
sub description { 'fml mailing list server/manager' };
sub scan {
    # Detect an error from fml mailing list server/manager
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
    # @since v4.22.3
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless defined $mhead->{'x-mlserver'};
    return undef unless $mhead->{'from'} =~ /.+[-]admin[@].+/;
    return undef unless $mhead->{'message-id'} =~ /\A[<]\d+[.]FML.+[@].+[>]\z/;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    $readcursor |= $Indicators->{'deliverystatus'};
    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e eq $StartingOf->{'rfc822'}->[0] ) {
                $readcursor |= $Indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $Indicators->{'message-rfc822'} ) {
            # After "Original mail as follows:" line
            #
            #    From owner-2ndml@example.com  Mon Nov 20 18:10:11 2017
            #    Return-Path: <owner-2ndml@example.com>
            #    ...
            unless( length $e ) {
                $blanklines++;
                last if $blanklines > 1;
                next;
            }
            substr($e, 0, 3, '') if substr($e, 0, 3) eq '   ';
            push @$rfc822list, $e;

        } else {
            # Before "message/rfc822"
            next unless $readcursor & $Indicators->{'deliverystatus'};
            next unless length $e;

            # Duplicated Message-ID in <2ndml@example.com>.
            # Original mail as follows:
            $v = $dscontents->[-1];

            if( $e =~ /[<]([^ ]+?[@][^ ]+?)[>][.]\z/ ) {
                # Duplicated Message-ID in <2ndml@example.com>.
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $v->{'diagnosis'} = $e;
                $recipients++;

            } else {
                # If you know the general guide of this list, please send mail with
                # the mail body 
                $v->{'diagnosis'} .= $e;
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;

        for my $f ( keys %$ErrorTable ) {
            # Try to match with error messages defined in $ErrorTable
            next unless $e->{'diagnosis'} =~ $ErrorTable->{ $f };
            $e->{'reason'} = $f;
            last;
        }

        unless( $e->{'reason'} ) {
            # Error messages in the message body did not matched
            for my $f ( keys %$ErrorTitle ) {
                # Try to match with the Subject string
                next unless $mhead->{'subject'} =~ $ErrorTitle->{ $f };
                $e->{'reason'} = $f;
                last;
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

Sisimai::Bite::Email::FML - bounce mail parser class for FML (fml.org).

=head1 SYNOPSIS

    use Sisimai::Bite::Email::FML;

=head1 DESCRIPTION

Sisimai::Bite::Email::FML parses a bounce email which created by C<fml mailing
list server/manager>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::FML->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::FML->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

