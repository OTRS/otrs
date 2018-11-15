package Sisimai::Bite::Email::V5sendmail;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = { 'message' => ['----- Transcript of session follows -----'] };
my $MarkingsOf = {
    # Error text regular expressions which defined in src/savemail.c
    #   savemail.c:485| (void) fflush(stdout);
    #   savemail.c:486| p = queuename(e->e_parent, 'x');
    #   savemail.c:487| if ((xfile = fopen(p, "r")) == NULL)
    #   savemail.c:488| {
    #   savemail.c:489|   syserr("Cannot open %s", p);
    #   savemail.c:490|   fprintf(fp, "  ----- Transcript of session is unavailable -----\n");
    #   savemail.c:491| }
    #   savemail.c:492| else
    #   savemail.c:493| {
    #   savemail.c:494|   fprintf(fp, "   ----- Transcript of session follows -----\n");
    #   savemail.c:495|   if (e->e_xfp != NULL)
    #   savemail.c:496|       (void) fflush(e->e_xfp);
    #   savemail.c:497|   while (fgets(buf, sizeof buf, xfile) != NULL)
    #   savemail.c:498|       putline(buf, fp, m);
    #   savemail.c:499|   (void) fclose(xfile);
    'error'   => qr/\A[.]+ while talking to .+[:]\z/,
    'rfc822'  => qr{\A[ \t]+-----[ \t](?:
         Unsent[ ]message[ ]follows
        |No[ ]message[ ]was[ ]collected
        )[ \t]-----
    }x,
};

sub description { 'Sendmail version 5' }
sub scan {
    # Detect an error from V5sendmail
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
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # 'from'    => qr/\AMail Delivery Subsystem/,
    return undef unless $mhead->{'subject'} =~ /\AReturned mail: [A-Z]/;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my @responding = ();    # (Array) Responses from remote server
    my @commandset = ();    # (Array) SMTP command which is sent to remote server
    my $anotherset = {};    # (Ref->Hash) Another error information
    my $errorindex = -1;
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( rindex($e, $StartingOf->{'message'}->[0]) > -1 ) {
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

            #    ----- Transcript of session follows -----
            # While talking to smtp.example.com:
            # >>> RCPT To:<kijitora@example.org>
            # <<< 550 <kijitora@example.org>, User Unknown
            # 550 <kijitora@example.org>... User unknown
            # 421 example.org (smtp)... Deferred: Connection timed out during user open with example.org
            $v = $dscontents->[-1];

            if( $e =~ /\A\d{3}[ \t]+[<]([^ ]+[@][^ ]+)[>][.]{3}[ \t]*(.+)\z/ ) {
                # 550 <kijitora@example.org>... User unknown
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $v->{'diagnosis'} = $2;

                if( $responding[ $recipients ] ) {
                    # Concatenate the response of the server and error message
                    $v->{'diagnosis'} .= ': '.$responding[$recipients];
                }
                $recipients++;

            } elsif( $e =~ /\A[>]{3}[ \t]*([A-Z]{4})[ \t]*/ ) {
                # >>> RCPT To:<kijitora@example.org>
                $commandset[ $recipients ] = $1;

            } elsif( $e =~ /\A[<]{3}[ ]+(.+)\z/ ) {
                # <<< Response
                # <<< 501 <shironeko@example.co.jp>... no access from mail server [192.0.2.55] which is an open relay.
                # <<< 550 Requested User Mailbox not found. No such user here.
                $responding[ $recipients ] = $1;

            } else {
                # Detect SMTP session error or connection error
                next if $v->{'sessionerr'};
                if( $e =~ $MarkingsOf->{'error'} ) { 
                    # ----- Transcript of session follows -----
                    # ... while talking to mta.example.org.:
                    $v->{'sessionerr'} = 1;
                    next;
                }

                # 421 example.org (smtp)... Deferred: Connection timed out during user open with example.org
                $anotherset->{'diagnosis'} = $1 if $e =~ /\A\d{3}[ \t]+.+[.]{3}[ \t]*(.+)\z/;
            }
        } # End of if: rfc822
    }
    return undef unless $readcursor & $Indicators->{'message-rfc822'};

    unless( $recipients ) {
        # Get the recipient address from the original message
        for my $e ( @$rfc822list ) {
            if( $e =~ /^To: (.+)$/ ) {
                # The value of To: header in the original message
                $dscontents->[0]->{'recipient'} = Sisimai::Address->s3s4($1);
                $recipients = 1;
                last;
            }
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $errorindex++;
        $e->{'agent'}   = __PACKAGE__->smtpagent;
        $e->{'command'} = $commandset[$errorindex] || '';

        if( exists $anotherset->{'diagnosis'} && $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $anotherset->{'diagnosis'};

        } else {
            # Set server response as a error message
            $e->{'diagnosis'} ||= $responding[$errorindex];
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        unless( $e->{'recipient'} =~ /\A[^ ]+[@][^ ]+\z/ ) {
            # @example.jp, no local part
            # Get email address from the value of Diagnostic-Code header
            $e->{'recipient'} = $1 if $e->{'diagnosis'} =~ /[<]([^ ]+[@][^ ]+)[>]/;
        }
        delete $e->{'sessionerr'};
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::V5sendmail - bounce mail parser class for C<V5 Sendmail>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::V5sendmail;

=head1 DESCRIPTION

Sisimai::Bite::Email::V5sendmail parses a bounce email which created by
C<Sendmail version 5> or any email appliances based on C<Sendmail version 5>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::V5sendmail->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::V5sendmail->smtpagent;

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
