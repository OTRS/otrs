package Sisimai::Skeleton;
use feature ':5.10';
use strict;
use warnings;

sub INDICATORS {
    # Flags for position variable for
    # @private
    # @return   [Hash] Position flag data
    # @since    v4.13.0
    return {
        'deliverystatus' => (1 << 1),
        'message-rfc822' => (1 << 2),
    };
}

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

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Skeleton - Class for basic data structure of Sisimai

=head1 SYNOPSIS

    use Sisimai::Skeleton;
    my $i = Sisimai::Skeleton->INDICATORS;
    my $d = Sisimai::Skeleton->DELIVERYSTATUS;

=head1 DESCRIPTION

Sisimai::Skeleton keep some methods that returns a base structure of Sisimai.
The methods previously defined at Sisimai::MTA class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
