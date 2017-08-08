package Sisimai::Order::Email;
use parent 'Sisimai::Order';
use feature ':5.10';
use strict;
use warnings;
use Module::Load '';
use Sisimai::MTA;
use Sisimai::MSP;
use Sisimai::CED;

my $DefaultOrder = __PACKAGE__->default;
my $EngineOrder1 = [
    # These modules have many subject patterns or have MIME encoded subjects
    # which is hard to code as regular expression
    'Sisimai::MTA::Exim',
    'Sisimai::MTA::Exchange2003',
];
my $EngineOrder2 = [
    # These modules have no MTA specific header and did not listed in the 
    # following subject header based regular expressions.
    'Sisimai::MTA::Exchange2007',
    'Sisimai::MSP::US::Facebook',
    'Sisimai::MSP::JP::KDDI',
];
my $EngineOrder3 = [
    # These modules have no MTA specific header but listed in the following
    # subject header based regular expressions.
    'Sisimai::MTA::qmail',
    'Sisimai::MTA::Notes',
    'Sisimai::MTA::MessagingServer',
    'Sisimai::MTA::Domino',
    'Sisimai::MSP::DE::EinsUndEins',
    'Sisimai::MTA::OpenSMTPD',
    'Sisimai::MTA::MXLogic',
    'Sisimai::MTA::Postfix',
    'Sisimai::MTA::Sendmail',
    'Sisimai::MTA::Courier',
    'Sisimai::MTA::IMailServer',
    'Sisimai::MSP::US::SendGrid',
    'Sisimai::MSP::US::Bigfoot',
    'Sisimai::MTA::X4',
];
my $EngineOrder4 = [
    # These modules have no MTA specific headers and there are few samples or
    # too old MTA
    'Sisimai::MSP::US::Verizon',
    'Sisimai::MTA::InterScanMSS',
    'Sisimai::MTA::MailFoundry',
    'Sisimai::MTA::ApacheJames',
    'Sisimai::MSP::JP::Biglobe',
    'Sisimai::MSP::JP::EZweb',
    'Sisimai::MTA::X5',
    'Sisimai::MTA::X3',
    'Sisimai::MTA::X2',
    'Sisimai::MTA::X1',
    'Sisimai::MTA::V5sendmail',
];
my $EngineOrder5 = [
    # These modules have one or more MTA specific headers but other headers
    # also required for detecting MTA name
    'Sisimai::MSP::US::Google',
    'Sisimai::MSP::US::Outlook',
    'Sisimai::MSP::RU::MailRu',
    'Sisimai::MSP::UK::MessageLabs',
    'Sisimai::MTA::MailMarshalSMTP',
    'Sisimai::MTA::mFILTER',
];
my $EngineOrder9 = [
    # These modules have one or more MTA specific headers
    'Sisimai::MSP::US::Aol',
    'Sisimai::MSP::US::Yahoo',
    'Sisimai::MSP::US::AmazonSES',
    'Sisimai::MSP::DE::GMX',
    'Sisimai::MSP::RU::Yandex',
    'Sisimai::MSP::US::ReceivingSES',
    'Sisimai::MSP::US::Office365',
    'Sisimai::MSP::US::AmazonWorkMail',
    'Sisimai::MSP::US::Zoho',
    'Sisimai::MTA::McAfee',
    'Sisimai::CED::US::AmazonSES',
    'Sisimai::MTA::Activehunter',
    'Sisimai::MTA::SurfControl',
];

# This variable don't hold MTA/MSP name which have one or more MTA specific
# header such as X-AWS-Outgoing, X-Yandex-Uniq.
my $PatternTable = {
    'subject' => {
        qr/delivery/i => [
            'Sisimai::MTA::Exim',
            'Sisimai::MTA::Courier',
            'Sisimai::MSP::US::Google',
            'Sisimai::MSP::US::Outlook',
            'Sisimai::MTA::Domino',
            'Sisimai::MTA::OpenSMTPD',
            'Sisimai::MSP::DE::EinsUndEins',
            'Sisimai::MTA::InterScanMSS',
            'Sisimai::MTA::MailFoundry',
            'Sisimai::MTA::X4',
            'Sisimai::MTA::X3',
            'Sisimai::MTA::X2',
        ],
        qr/noti(?:ce|fi)/i => [
            'Sisimai::MTA::qmail',
            'Sisimai::MTA::Sendmail',
            'Sisimai::MSP::US::Google',
            'Sisimai::MSP::US::Outlook',
            'Sisimai::MTA::Courier',
            'Sisimai::MTA::MessagingServer',
            'Sisimai::MTA::OpenSMTPD',
            'Sisimai::CED::US::AmazonSES',
            'Sisimai::MTA::X4',
            'Sisimai::MTA::X3',
            'Sisimai::MTA::mFILTER',
        ],
        qr/return/i => [
            'Sisimai::MTA::Postfix',
            'Sisimai::MTA::Sendmail',
            'Sisimai::MSP::US::SendGrid',
            'Sisimai::MSP::US::Bigfoot',
            'Sisimai::MTA::X1',
            'Sisimai::MSP::DE::EinsUndEins',
            'Sisimai::MSP::JP::Biglobe', 
            'Sisimai::MTA::V5sendmail',
        ],
        qr/undeliver/i => [
            'Sisimai::MTA::Postfix',
            'Sisimai::MTA::Exchange2007',
            'Sisimai::MTA::Exchange2003',
            'Sisimai::MTA::Notes',
            'Sisimai::MSP::US::Office365',
            'Sisimai::MSP::US::Verizon',
            'Sisimai::MSP::US::SendGrid',
            'Sisimai::MTA::IMailServer',
            'Sisimai::MTA::MailMarshalSMTP',
        ],
        qr/failure/i => [
            'Sisimai::MTA::qmail',
            'Sisimai::MTA::Domino',
            'Sisimai::MSP::US::Google',
            'Sisimai::MSP::US::Outlook',
            'Sisimai::MSP::RU::MailRu',
            'Sisimai::MTA::X4',
            'Sisimai::MTA::X2',
            'Sisimai::MTA::mFILTER',
        ],
        qr/warning/i => [
            'Sisimai::MTA::Postfix',
            'Sisimai::MTA::Sendmail',
            'Sisimai::MTA::Exim',
        ],
    },
};

sub by {
    # Get regular expression patterns for specified field
    # @param    [String] group  Group name for "ORDER BY"
    # @return   [Hash]          Pattern table for the group
    # @since v4.13.2
    my $class = shift;
    my $group = shift || return undef;

    return $PatternTable->{ $group } if exists $PatternTable->{ $group };
    return {};
}

sub default {
    # Make default order of MTA, MSP, and CED modules to be loaded
    # @return   [Array] Default order list of MTA, MSP, and CED modules
    # @since v4.13.1
    my $class = shift;
    my $order = [];

    return $DefaultOrder if ref $DefaultOrder eq 'ARRAY';
    push @$order, map { 'Sisimai::MTA::'.$_ } @{ Sisimai::MTA->index() };
    push @$order, map { 'Sisimai::MSP::'.$_ } @{ Sisimai::MSP->index() };
    push @$order, map { 'Sisimai::CED::'.$_ } @{ Sisimai::CED->index() };
    return $order;
}

sub another {
    # Make MTA,MSP, and CED module list as a spare
    # @return   [Array] Ordered module list
    # @since v4.13.1
    return [
        @$EngineOrder1, @$EngineOrder2, @$EngineOrder3, 
        @$EngineOrder4, @$EngineOrder5, @$EngineOrder9,
    ];
};

sub headers {
    # Make email header list in each MTA, MSP, CED module
    # @return   [Hash] Header list to be parsed
    # @since v4.13.1
    my $class = shift;
    my $order = __PACKAGE__->default;
    my $table = {};
    my $skips = { 'return-path' => 1, 'x-mailer' => 1 };

    LOAD_MODULES: for my $e ( @$order ) {
        # Load email headers from each MTA, MSP module
        eval { Module::Load::load $e };
        next if $@;

        for my $v ( @{ $e->headerlist } ) {
            # Get header name which required each MTA,MSP, and CED module
            my $q = lc $v;
            next if exists $skips->{ $q };
            $table->{ $q }->{ $e } = 1;
        }
    }
    return $table;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Order::Email - Make optimized order list for calling MTA/MSP modules

=head1 SYNOPSIS

    use Sisimai::Order::Email

=head1 DESCRIPTION

Sisimai::Order::Email makes optimized order list which include MTA, MSP, and CED
modules to be loaded on first from MTA/MSP/CED specific headers in the bounce
mail headers such as X-Failed-Recipients. 
This module are called from only Sisimai::Message::Email.

=head1 CLASS METHODS

=head2 C<B<default()>>

C<default()> returns default order of MTA, MSP, and CED modules

    print for @{ Sisimai::Order::Email->default };

=head2 C<B<headers()>>

C<headers()> returns MTA, MSP, or CED specific header table

    print keys %{ Sisimai::Order::Email->headers };

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

