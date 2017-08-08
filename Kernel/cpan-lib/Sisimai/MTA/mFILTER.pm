package Sisimai::MTA::mFILTER;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'from'     => qr/\AMailer Daemon [<]MAILER-DAEMON[@]/,
    'subject'  => qr/\Afailure notice\z/,
    'x-mailer' => qr/\Am-FILTER\z/,
};
my $Re1 = {
    'begin'    => qr/\A[^ ]+[@][^ ]+[.][a-zA-Z]+\z/,
    'error'    => qr/\A-------server message\z/,
    'command'  => qr/\A-------SMTP command\z/,
    'rfc822'   => qr/\A-------original (?:message|mail info)\z/,
    'endof'    => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $Indicators = __PACKAGE__->INDICATORS;

# X-Mailer: m-FILTER
sub headerlist  { return ['X-Mailer'] }
sub pattern     { return $Re0 }
sub description { 'Digital Arts m-FILTER' }

sub scan {
    # Detect an error from DigitalArts m-FILTER
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

    return undef unless defined $mhead->{'x-mailer'};
    return undef unless $mhead->{'x-mailer'} =~ $Re0->{'x-mailer'};
    return undef unless $mhead->{'subject'}  =~ $Re0->{'subject'};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $markingset = { 'diagnosis' => 0, 'command' => 0 };
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between $Re1->{'begin'} and $Re1->{'rfc822'}.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $Indicators->{'deliverystatus'} if $e =~ $Re1->{'begin'};
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

            # このメールは「m-FILTER」が自動的に生成して送信しています。
            # メールサーバーとの通信中、下記の理由により
            # このメールは送信できませんでした。
            #
            # 以下のメールアドレスへの送信に失敗しました。
            # kijitora@example.jp
            #
            #
            # -------server message
            # 550 5.1.1 unknown user <kijitora@example.jp>
            #
            # -------SMTP command
            # DATA
            #
            # -------original message
            $v = $dscontents->[-1];

            if( $e =~ m/\A([^ ]+[@][^ ]+)\z/ ) {
                # 以下のメールアドレスへの送信に失敗しました。
                # kijitora@example.jp
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ m/\A[A-Z]{4}/ ) {
                # -------SMTP command
                # DATA
                next if $v->{'command'};
                $v->{'command'} = $e if $markingset->{'command'};

            } else {
                # Get error message and SMTP command
                if( $e =~ $Re1->{'error'} ) {
                    # -------server message
                    $markingset->{'diagnosis'} = 1;

                } elsif( $e =~ $Re1->{'command'} ) {
                    # -------SMTP command
                    $markingset->{'command'} = 1;

                } else {
                    # 550 5.1.1 unknown user <kijitora@example.jp>
                    next if $e =~ m/\A[-]+/;
                    next if $v->{'diagnosis'};
                    $v->{'diagnosis'} = $e;
                }
            }
        } # End of if: rfc822
    }

    return undef unless $recipients;
    require Sisimai::String;

    for my $e ( @$dscontents ) {
        if( scalar @{ $mhead->{'received'} } ) {
            # Get localhost and remote host name from Received header.
            my $rheads = $mhead->{'received'};
            my $rhosts = Sisimai::RFC5322->received($rheads->[-1]);

            $e->{'lhost'} ||= shift @{ Sisimai::RFC5322->received($rheads->[0]) };
            for my $ee ( @$rhosts ) {
                # Avoid "... by m-FILTER"
                next unless $ee =~ m/[.]/;
                $e->{'rhost'} = $ee;
            }
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MTA::mFILTER - bounce mail parser class for C<Digital Arts m-FILTER>.

=head1 SYNOPSIS

    use Sisimai::MTA::mFILTER;

=head1 DESCRIPTION

Sisimai::MTA::mFILTER parses a bounce email which created by C<Digital Arts 
m-FILTER>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MTA::mFILTER->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MTA::mFILTER->smtpagent;

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

