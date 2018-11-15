package Sisimai::Bite::Email::mFILTER;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'command'  => ['-------SMTP command'],
    'rfc822'   => ['-------original message', '-------original mail info'],
    'error'    => ['-------server message'],
};
my $MarkingsOf = { 'message' => qr/\A[^ ]+[@][^ ]+[.][a-zA-Z]+\z/ };

# X-Mailer: m-FILTER
sub headerlist  { return ['X-Mailer'] }
sub description { 'Digital Arts m-FILTER' }
sub scan {
    # Detect an error from DigitalArts m-FILTER
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

    # 'from'     => qr/\AMailer Daemon [<]MAILER-DAEMON[@]/,
    return undef unless defined $mhead->{'x-mailer'};
    return undef unless $mhead->{'x-mailer'} eq 'm-FILTER';
    return undef unless $mhead->{'subject'}  eq 'failure notice';

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
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $Indicators->{'deliverystatus'} if $e =~ $MarkingsOf->{'message'};
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e eq $StartingOf->{'rfc822'}->[0] || $e eq $StartingOf->{'rfc822'}->[1] ) {
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

            if( $e =~ /\A([^ ]+[@][^ ]+)\z/ ) {
                # 以下のメールアドレスへの送信に失敗しました。
                # kijitora@example.jp
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\A[A-Z]{4}/ ) {
                # -------SMTP command
                # DATA
                next if $v->{'command'};
                $v->{'command'} = $e if $markingset->{'command'};

            } else {
                # Get error message and SMTP command
                if( $e eq $StartingOf->{'error'}->[0] ) {
                    # -------server message
                    $markingset->{'diagnosis'} = 1;

                } elsif( $e eq $StartingOf->{'command'}->[0] ) {
                    # -------SMTP command
                    $markingset->{'command'} = 1;

                } else {
                    # 550 5.1.1 unknown user <kijitora@example.jp>
                    next if index($e, '-') == 0;
                    next if $v->{'diagnosis'};
                    $v->{'diagnosis'} = $e;
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        if( scalar @{ $mhead->{'received'} } ) {
            # Get localhost and remote host name from Received header.
            my $rheads = $mhead->{'received'};
            my $rhosts = Sisimai::RFC5322->received($rheads->[-1]);

            $e->{'lhost'} ||= shift @{ Sisimai::RFC5322->received($rheads->[0]) };
            while( my $ee = shift @$rhosts ) {
                # Avoid "... by m-FILTER"
                next unless rindex($ee, '.') > -1;
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

Sisimai::Bite::Email::mFILTER - bounce mail parser class for C<Digital Arts m-FILTER>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::mFILTER;

=head1 DESCRIPTION

Sisimai::Bite::Email::mFILTER parses a bounce email which created by
C<Digital Arts m-FILTER>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::mFILTER->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::mFILTER->smtpagent;

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

