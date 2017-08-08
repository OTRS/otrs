package Sisimai::MTA;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::RFC5322;
use Sisimai::Skeleton;

sub DELIVERYSTATUS { return Sisimai::Skeleton->DELIVERYSTATUS }
sub INDICATORS     { return Sisimai::Skeleton->INDICATORS     }
sub smtpagent      { my $v = shift; $v =~ s/\ASisimai:://; return $v }
sub description    { return '' }
sub headerlist     { return [] }
sub pattern        { return {} }

sub index {
    # MTA list
    # @return   [Array] MTA list with order
    my $class = shift;
    my $index = [
        'Sendmail', 'Postfix', 'qmail', 'Exim', 'Courier', 'OpenSMTPD', 
        'Exchange2007', 'Exchange2003', 'MessagingServer', 'Domino', 'Notes',
        'ApacheJames', 'McAfee', 'MXLogic', 'MailFoundry', 'IMailServer', 
        'mFILTER', 'Activehunter', 'InterScanMSS', 'SurfControl', 'MailMarshalSMTP',
        'X1', 'X2', 'X3', 'X4', 'X5', 'V5sendmail', 
    ];
    return $index;
}

sub scan {
    # @abstract      Detect an error
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
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MTA - Base class for Sisimai::MTA::*

=head1 SYNOPSIS

Do not use this class directly, use Sisimai::MTA::*, such as Sisimai::MTA::Sendmail,
instead.

=head1 DESCRIPTION

Sisimai::MTA is a base class for Sisimai::MTA::*.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
