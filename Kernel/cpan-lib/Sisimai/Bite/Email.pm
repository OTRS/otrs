package Sisimai::Bite::Email;
use feature ':5.10';
use parent 'Sisimai::Bite';
use strict;
use warnings;

sub INDICATORS {
    # Flags for position variables
    # @private
    # @return   [Hash] Position flag data
    # @since    v4.13.0
    return {
        'deliverystatus' => (1 << 1),
        'message-rfc822' => (1 << 2),
    };
}
sub headerlist { return [] }
sub index {
    # MTA list
    # @return   [Array] MTA list with order
    return [qw|
        Sendmail Postfix qmail Exim Courier OpenSMTPD Exchange2007 Exchange2003
        Google Yahoo GSuite Aol Outlook Office365 SendGrid AmazonSES MailRu
        Yandex MessagingServer Domino Notes ReceivingSES AmazonWorkMail Verizon
        GMX Bigfoot Facebook Zoho EinsUndEins MessageLabs EZweb KDDI Biglobe
        ApacheJames McAfee MXLogic MailFoundry IMailServer 
        mFILTER Activehunter InterScanMSS SurfControl MailMarshalSMTP
        X1 X2 X3 X4 X5 V5sendmail FML
    |];
}

sub heads {
    # MTA list which have one or more extra headers
    # @return   [Array] MTA list (have extra headers)
    return [qw|
        Exim Exchange2007 Exchange2003 Google GSuite Office365 Outlook SendGrid
        AmazonSES ReceivingSES AmazonWorkMail Aol GMX MailRu MessageLabs Yahoo
        Yandex Zoho EinsUndEins MXLogic McAfee mFILTER EZweb Activehunter IMailServer
        SurfControl FML
    |];
}

sub scan {
    # Method of a parent class to parse a bounce message of each MTA
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
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email - Base class for Sisimai::Bite::Email::*

=head1 SYNOPSIS

Do not use or require this class directly, use Sisimai::Bite::Email::*, such as
Sisimai::Bite::Email::Sendmail, instead.

=head1 DESCRIPTION

Sisimai::Bite::Email is a base class for Sisimai::Bite::Email::*.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

