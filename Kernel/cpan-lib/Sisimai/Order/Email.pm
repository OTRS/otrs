package Sisimai::Order::Email;
use parent 'Sisimai::Order';
use feature ':5.10';
use strict;
use warnings;
use Sisimai::Bite::Email;

my $EngineOrder1 = [
    # These modules have many subject patterns or have MIME encoded subjects
    # which is hard to code as regular expression
    'Sisimai::Bite::Email::Exim',
    'Sisimai::Bite::Email::Exchange2003',
];
my $EngineOrder2 = [
    # These modules have no MTA specific header and did not listed in the 
    # following subject header based regular expressions.
    'Sisimai::Bite::Email::Exchange2007',
    'Sisimai::Bite::Email::Facebook',
    'Sisimai::Bite::Email::KDDI',
];
my $EngineOrder3 = [
    # These modules have no MTA specific header but listed in the following
    # subject header based regular expressions.
    'Sisimai::Bite::Email::qmail',
    'Sisimai::Bite::Email::Notes',
    'Sisimai::Bite::Email::MessagingServer',
    'Sisimai::Bite::Email::Domino',
    'Sisimai::Bite::Email::EinsUndEins',
    'Sisimai::Bite::Email::OpenSMTPD',
    'Sisimai::Bite::Email::MXLogic',
    'Sisimai::Bite::Email::Postfix',
    'Sisimai::Bite::Email::Sendmail',
    'Sisimai::Bite::Email::Courier',
    'Sisimai::Bite::Email::IMailServer',
    'Sisimai::Bite::Email::SendGrid',
    'Sisimai::Bite::Email::Bigfoot',
    'Sisimai::Bite::Email::X4',
];
my $EngineOrder4 = [
    # These modules have no MTA specific headers and there are few samples or
    # too old MTA
    'Sisimai::Bite::Email::Verizon',
    'Sisimai::Bite::Email::InterScanMSS',
    'Sisimai::Bite::Email::MailFoundry',
    'Sisimai::Bite::Email::ApacheJames',
    'Sisimai::Bite::Email::Biglobe',
    'Sisimai::Bite::Email::EZweb',
    'Sisimai::Bite::Email::X5',
    'Sisimai::Bite::Email::X3',
    'Sisimai::Bite::Email::X2',
    'Sisimai::Bite::Email::X1',
    'Sisimai::Bite::Email::V5sendmail',
];
my $EngineOrder5 = [
    # These modules have one or more MTA specific headers but other headers
    # also required for detecting MTA name
    'Sisimai::Bite::Email::Google',
    'Sisimai::Bite::Email::Outlook',
    'Sisimai::Bite::Email::MailRu',
    'Sisimai::Bite::Email::MessageLabs',
    'Sisimai::Bite::Email::MailMarshalSMTP',
    'Sisimai::Bite::Email::mFILTER',
];
my $EngineOrder9 = [
    # These modules have one or more MTA specific headers
    'Sisimai::Bite::Email::Aol',
    'Sisimai::Bite::Email::Yahoo',
    'Sisimai::Bite::Email::AmazonSES',
    'Sisimai::Bite::Email::GMX',
    'Sisimai::Bite::Email::Yandex',
    'Sisimai::Bite::Email::ReceivingSES',
    'Sisimai::Bite::Email::Office365',
    'Sisimai::Bite::Email::AmazonWorkMail',
    'Sisimai::Bite::Email::Zoho',
    'Sisimai::Bite::Email::McAfee',
    'Sisimai::Bite::Email::Activehunter',
    'Sisimai::Bite::Email::SurfControl',
];

# This variable don't hold MTA module name which have one or more MTA specific
# header such as X-AWS-Outgoing, X-Yandex-Uniq.
my $PatternTable = {
    'subject' => {
        'delivery' => [
            'Sisimai::Bite::Email::Exim',
            'Sisimai::Bite::Email::Courier',
            'Sisimai::Bite::Email::Google',
            'Sisimai::Bite::Email::Outlook',
            'Sisimai::Bite::Email::Domino',
            'Sisimai::Bite::Email::OpenSMTPD',
            'Sisimai::Bite::Email::EinsUndEins',
            'Sisimai::Bite::Email::InterScanMSS',
            'Sisimai::Bite::Email::MailFoundry',
            'Sisimai::Bite::Email::X4',
            'Sisimai::Bite::Email::X3',
            'Sisimai::Bite::Email::X2',
        ],
        'noti' => [
            'Sisimai::Bite::Email::qmail',
            'Sisimai::Bite::Email::Sendmail',
            'Sisimai::Bite::Email::Google',
            'Sisimai::Bite::Email::Outlook',
            'Sisimai::Bite::Email::Courier',
            'Sisimai::Bite::Email::MessagingServer',
            'Sisimai::Bite::Email::OpenSMTPD',
            'Sisimai::Bite::Email::X4',
            'Sisimai::Bite::Email::X3',
            'Sisimai::Bite::Email::mFILTER',
        ],
        'return' => [
            'Sisimai::Bite::Email::Postfix',
            'Sisimai::Bite::Email::Sendmail',
            'Sisimai::Bite::Email::SendGrid',
            'Sisimai::Bite::Email::Bigfoot',
            'Sisimai::Bite::Email::X1',
            'Sisimai::Bite::Email::EinsUndEins',
            'Sisimai::Bite::Email::Biglobe', 
            'Sisimai::Bite::Email::V5sendmail',
        ],
        'undeliver' => [
            'Sisimai::Bite::Email::Postfix',
            'Sisimai::Bite::Email::Exchange2007',
            'Sisimai::Bite::Email::Exchange2003',
            'Sisimai::Bite::Email::Notes',
            'Sisimai::Bite::Email::Office365',
            'Sisimai::Bite::Email::Verizon',
            'Sisimai::Bite::Email::SendGrid',
            'Sisimai::Bite::Email::IMailServer',
            'Sisimai::Bite::Email::MailMarshalSMTP',
        ],
        'failure' => [
            'Sisimai::Bite::Email::qmail',
            'Sisimai::Bite::Email::Domino',
            'Sisimai::Bite::Email::Google',
            'Sisimai::Bite::Email::Outlook',
            'Sisimai::Bite::Email::MailRu',
            'Sisimai::Bite::Email::X4',
            'Sisimai::Bite::Email::X2',
            'Sisimai::Bite::Email::mFILTER',
        ],
        'warning' => [
            'Sisimai::Bite::Email::Postfix',
            'Sisimai::Bite::Email::Sendmail',
            'Sisimai::Bite::Email::Exim',
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
    # Make default order of MTA modules to be loaded
    # @return   [Array] Default order list of MTA modules
    # @since v4.13.1
    return [map { 'Sisimai::Bite::Email::'.$_ } @{ Sisimai::Bite::Email->index() }];
}

sub another {
    # Make MTA modules list as a spare
    # @return   [Array] Ordered module list
    # @since v4.13.1
    return [
        @$EngineOrder1, @$EngineOrder2, @$EngineOrder3, 
        @$EngineOrder4, @$EngineOrder5, @$EngineOrder9,
    ];
};

sub headers {
    # Make email header list in each MTA module
    # @return   [Hash] Header list to be parsed
    # @since v4.13.1
    my $class = shift;
    my $table = {};
    my $skips = { 'return-path' => 1, 'x-mailer' => 1 };
    my $order = [map { 'Sisimai::Bite::Email::'.$_ } @{ Sisimai::Bite::Email->heads }];

    LOAD_MODULES: for my $e ( @$order ) {
        # Load email headers from each MTA module
        (my $p = $e) =~ s|::|/|g; 
        require $p.'.pm';

        for my $v ( @{ $e->headerlist } ) {
            # Get header name which required each MTA module
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

Sisimai::Order::Email - Make optimized order list for calling MTA modules

=head1 SYNOPSIS

    use Sisimai::Order::Email

=head1 DESCRIPTION

Sisimai::Order::Email makes optimized order list which include MTA modules to
be loaded on first from MTA specific headers in the bounce mail headers such as
X-Failed-Recipients.  This module are called from only Sisimai::Message::Email.

=head1 CLASS METHODS

=head2 C<B<default()>>

C<default()> returns default order of MTA modules

    print for @{ Sisimai::Order::Email->default };

=head2 C<B<headers()>>

C<headers()> returns MTA specific header table

    print keys %{ Sisimai::Order::Email->headers };

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

