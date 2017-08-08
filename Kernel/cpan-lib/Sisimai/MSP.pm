package Sisimai::MSP;
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
    # MSP list
    # @return   [Array] MSP list with order
    my $class = shift;
    my $index = [
        'US::Google', 'US::Yahoo', 'US::Aol', 'US::Outlook', 'US::AmazonSES', 
        'US::SendGrid', 'US::GSuite', 'US::Verizon', 'RU::MailRu', 'RU::Yandex',
        'DE::GMX', 'US::Bigfoot', 'US::Facebook', 'US::Zoho', 'DE::EinsUndEins',
        'UK::MessageLabs', 'JP::EZweb', 'JP::KDDI', 'JP::Biglobe',
        'US::ReceivingSES', 'US::AmazonWorkMail', 'US::Office365',
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

Sisimai::MSP - Base class for Sisimai::MSP::*, Mail Service Provider classes.

=head1 SYNOPSIS

Do not use this class directly, use Sisimai::MSP::*, such as Sisimai::MSP::Google,
instead.

=head1 DESCRIPTION

Sisimai::MSP is a base class for Sisimai::MSP::*.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
