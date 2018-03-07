package Sisimai::Bite::Email::UserDefined;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

# $StartingOf, and $MarkingsOf are delimiter set of these sections:
#   message: The first line of a bounce message to be parsed.
#   error:   The first line of an error message to get an error reason, recipient
#            addresses, or other bounce information.
#   rfc822:  The first line of the original message.
#   endof:   Fixed string ``__END_OF_EMAIL_MESSAGE__''
my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = { 'rfc822' => ['Content-Type: message/rfc822', 'Content-Type: text/rfc822-headers'] };
my $MarkingsOf = {
    'message' => qr/\A[ \t]+[-]+ Transcript of session follows [-]+\z/,
    'error'   => qr/\A[.]+ while talking to .+[:]\z/,
    'endof'   => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};

sub headerlist  { return ['X-Some-UserDefined-Header'] }
sub description { 'Module decription' }
sub scan {
    # Template for User-Defined MTA module
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
    # @since v4.1.28
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # 1. Check some value in $mhead using regular expression or "eq" operator
    #    whether the bounce message should be parsed by this module or not.
    #   - Matched 1 or more values: Proceed to the step 2.
    #   - Did not matched:          return undef;
    #
    MATCH: {
        $match ||= 1 if index($mhead->{'subject'}, 'Error Mail Report') == 0;
        $match ||= 1 if index($mhead->{'from'}, 'Mail Sysmet') == 0;
        $match ||= 1 if $mhead->{'x-some-userdefined-header'};
    }
    return undef unless $match;

    # 2. Parse message body($mbody) of the bounce message. See some modules in
    #    lib/Sisimai/Bite/Email or lib/Sisimai/Bite/JSON directory to implement
    #    codes.
    #
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header

    # The following code is dummy to be passed "make test".
    $recipients = 1;
    $dscontents->[0]->{'recipient'} = 'kijitora@example.jp';
    $dscontents->[0]->{'diagnosis'} = '550 something wrong';
    $dscontents->[0]->{'status'}    = '5.1.1';
    $dscontents->[0]->{'spec'}      = 'SMTP';
    $dscontents->[0]->{'date'}      = 'Thu 29 Apr 2010 23:34:45 +0900';
    $dscontents->[0]->{'agent'}     = __PACKAGE__->smtpagent();

    $rfc822part .= 'From: shironeko@example.org'."\n";
    $rfc822part .= 'Subject: Nyaaan'."\n";
    $rfc822part .= 'Message-Id: 000000000000@example.jp'."\n";

    # 3. Return undef when there is no recipient address which is failed to
    #    delivery in the bounce message
    return undef unless $recipients;

    # 4. Return the following variable.
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::UserDefined - User defined MTA module as an example

=head1 SYNOPSIS

    use lib '/path/to/your/lib/dir';
    use Your::Custom::Bite::Email::Module;
    use Sisimai::Mail;
    use Sisimai::Data;
    use Sisimai::Message;

    my $file = '/path/to/mailbox';
    my $mail = Sisimai::Mail->new($file);
    my $mesg = undef;
    my $data = undef;

    while( my $r = $mail->read ){ 
        $mesg = Sisimai::Message->new( 
                    'data' => $r,
                    'load' => ['Your::Custom::Bite::Email::Module']
                ); 
        $data = Sisimai::Data->make('data' => $mesg); 
        ...
    }

=head1 DESCRIPTION

Sisimai::Bite::Email::UserDefined is an example module as a template to implement
your custom MTA module.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Your::Custom::Bite::Email::Module->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Your::Custom::Bite::Email::Module->smtpagent;

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
