package Sisimai::Bite;
use feature ':5.10';
use strict;
use warnings;

sub DELIVERYSTATUS {
    # Data structure for parsed bounce messages
    # @private
    # @return [Hash] Data structure for delivery status
    return {
        'spec'         => '',   # Protocl specification
        'date'         => '',   # The value of Last-Attempt-Date header
        'rhost'        => '',   # The value of Remote-MTA header
        'lhost'        => '',   # The value of Received-From-MTA header
        'alias'        => '',   # The value of alias entry(RHS)
        'agent'        => '',   # MTA name
        'action'       => '',   # The value of Action header
        'status'       => '',   # The value of Status header
        'reason'       => '',   # Temporary reason of bounce
        'command'      => '',   # SMTP command in the message body
        'replycode',   => '',   # SMTP Reply Code
        'diagnosis'    => '',   # The value of Diagnostic-Code header
        'recipient'    => '',   # The value of Final-Recipient header
        'softbounce'   => '',   # Soft bounce or not
        'feedbacktype' => '',   # Feedback Type
    };
}

sub smtpagent   { my $v = shift; $v =~ s/\ASisimai::Bite:://; return $v }
sub description { return '' }

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite - Base class for Sisimai::Bite::*

=head1 SYNOPSIS

Sisimai::Bite is a base class for keeping all the MTA modules. Do not use this
class and child classes of Sisimai::Bite::* directly. Use Sisimai::Bite::*::*,
such as Sisimai::Bite::Email::Sendmail, instead.

=head1 DESCRIPTION

Sisimai::Bite is a base class for keeping all the MTA modules.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
