package Sisimai::RFC3834;
use feature ':5.10';
use strict;
use warnings;

# http://tools.ietf.org/html/rfc3834
my $MarkingsOf = { 'boundary' => qr/\A__SISIMAI_PSEUDO_BOUNDARY__\z/ };
my $AutoReply1 = {
    # http://www.iana.org/assignments/auto-submitted-keywords/auto-submitted-keywords.xhtml
    'auto-submitted' => qr/\Aauto-(?:generated|replied|notified)/,
    # https://msdn.microsoft.com/en-us/library/ee219609(v=exchg.80).aspx
    'x-auto-response-suppress' => qr/(?:oof|autoreply)/,
    'precedence' => qr/\Aauto_reply\z/,
    'subject' => qr/\A(?>
         auto:
        |auto[ ]response:
        |automatic[ ]reply:
        |out[ ]of[ ](?:the[ ])*office:
        )
    /x,
};
my $Excludings = {
    'subject' => qr{(?:
          security[ ]information[ ]for  # sudo
         |mail[ ]failure[ ][-]          # Exim
         )
    }x,
    'from'    => qr/(?:root|postmaster|mailer-daemon)[@]/,
    'to'      => qr/root[@]/,
};
my $SubjectSet = qr{\A(?>
     (?:.+?)?re:
    |auto(?:[ ]response):
    |automatic[ ]reply:
    |out[ ]of[ ]office:
    )
    [ ]*(.+)\z
}x;

sub description { 'Detector for auto replied message' }
sub smtpagent   { 'RFC3834' }
sub headerlist  { [qw|Auto-Submitted Precedence X-Auto-Response-Suppress|] }
sub scan {
    # Detect auto reply message as RFC3834
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
    # @since v4.1.28
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $leave = 0;
    my $match = 0;

    return undef unless keys %$mhead;
    return undef unless ref $mbody eq 'SCALAR';

    DETECT_EXCLUSION_MESSAGE: for my $e ( keys %$Excludings ) {
        # Exclude message from root@
        next unless exists $mhead->{ $e };
        next unless defined $mhead->{ $e };
        next unless lc($mhead->{ $e }) =~ $Excludings->{ $e };
        $leave = 1;
        last;
    }
    return undef if $leave;

    DETECT_AUTO_REPLY_MESSAGE: for my $e ( keys %$AutoReply1 ) {
        # RFC3834 Auto-Submitted and other headers
        next unless exists $mhead->{ $e };
        next unless defined $mhead->{ $e };
        next unless lc($mhead->{ $e }) =~ $AutoReply1->{ $e };
        $match++;
        last;
    }
    return undef unless $match;

    require Sisimai::Bite::Email;
    my $dscontents = [Sisimai::Bite::Email->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $maxmsgline = 5;     # (Integer) Max message length(lines)
    my $haveloaded = 0;     # (Integer) The number of lines loaded from message body
    my $blanklines = 0;     # (Integer) Counter for countinuous blank lines
    my $countuntil = 1;     # (Integer) Maximun value of blank lines in the body part
    my $v = $dscontents->[-1];

    RECIPIENT_ADDRESS: {
        # Try to get the address of the recipient
        for my $e ('from', 'return-path') {
            # Get the recipient address
            next unless exists  $mhead->{ $e };
            next unless defined $mhead->{ $e };

            $v->{'recipient'} = $mhead->{ $e };
            last;
        }

        if( $v->{'recipient'} ) {
            # Clean-up the recipient address
            $v->{'recipient'} = Sisimai::Address->s3s4($v->{'recipient'});
            $recipients++;
        }
    }
    return undef unless $recipients;

    if( $mhead->{'content-type'} ) {
        # Get the boundary string and set regular expression for matching with
        # the boundary string.
        my $b0 = Sisimai::MIME->boundary($mhead->{'content-type'}, 0);
        $MarkingsOf->{'boundary'} = qr/\A\Q$b0\E\z/ if length $b0;
    }

    BODY_PARSER: {
        # Get vacation message
        for my $e ( @hasdivided ) {
            # Read the first 5 lines except a blank line
            $countuntil += 1 if $e =~ $MarkingsOf->{'boundary'};

            unless( length $e ) {
                # Check a blank line
                $blanklines++;
                last if $blanklines > $countuntil;
                next;
            }
            next unless rindex($e, ' ') > -1;
            next if index($e, 'Content-Type') == 0;
            next if index($e, 'Content-Transfer') == 0;

            $v->{'diagnosis'} .= $e.' ';
            $haveloaded++;
            last if $haveloaded >= $maxmsgline;
        }
        $v->{'diagnosis'} ||= $mhead->{'subject'};
    }

    $v->{'diagnosis'} = Sisimai::String->sweep($v->{'diagnosis'});
    $v->{'reason'}    = 'vacation';
    $v->{'agent'}     = __PACKAGE__->smtpagent;
    $v->{'date'}      = $mhead->{'date'};
    $v->{'status'}    = '';

    # Get the Subject header from the original message
    $rfc822part = 'Subject: '.$1."\n" if lc($mhead->{'subject'}) =~ $SubjectSet;

    return { 'ds' => $dscontents, 'rfc822' => $rfc822part };
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::RFC3834 - RFC3834 auto reply message detector

=head1 SYNOPSIS

    use Sisimai::RFC3834;

=head1 DESCRIPTION

Sisimai::RFC3834 is a class which called from called from only Sisimai::Message
when other Sisimai::Bite::Email::* modules did not detected a bounce reason.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::RFC3834->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MDA name or string 'RFC3834'.

    print Sisimai::RFC3834->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses an auto replied message and return results as an array
reference. See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

