# --
# Attachment.t - email attachments tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Attachment.t,v 1.1.4.3 2012-06-20 12:48:00 alm Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# Email Attachments test purpose:
# 1) Create email
# 2) Add attachments
# 3) Verify Content-Type
# This UT referrer to Bug #7879, perldoc MIME::Entity, rfc2045.
#
# Correct:
# ----------------------------------------------------------------------------------------
# Content-Type: application/octet-stream; name="TESTBUILD-OTRSAdminTypeServices-1.1.1.opm"
# Content-Disposition: inline; filename="TESTBUILD-OTRSAdminTypeServices-1.1.1.opm"
# Content-Transfer-Encoding: base64
# ----------------------------------------------------------------------------------------
#
# Incorrect:
# ----------------------------------------------------------------------------------------
# Content-Type: application/octet-stream;
# name="TESTBUILD-OTRSAdminTypeServices-1.1.1.opm"
# name="TESTBUILD-OTRSAdminTypeServices-1.1.1.opm";
# Content-Disposition: inline; filename="TESTBUILD-OTRSAdminTypeServices-1.1.1.opm"
# Content-Transfer-Encoding: base64
# ----------------------------------------------------------------------------------------

use strict;
use warnings;
use vars (qw($Self));
use utf8;
use Kernel::Config;
use Kernel::System::Email;
use Kernel::System::EmailParser;

# Constants for test(s): 1 - enabled, 0 - disabled.
# SEND - check sending body. PARSE - check parsed body.

my $SEND  = 1;
my $PARSE = 1;

# create local object
my $ConfigObject = Kernel::Config->new();

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# test scenarios. added only one attachment.
my @Tests = (
    {
        Name => 'HTML email.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            Type       => 'text/html',
            Charset    => 'utf8',
            Attachment => [
                {
                    Filename    => 'csvfile.csv',
                    Content     => 'empty',
                    ContentType => 'text/csv',
                },
                {
                    Filename    => 'pngfile.png',
                    Content     => 'empty',
                    ContentType => 'image/png; name=pngfile.png',
                },
                {
                    Filename    => 'utf-8',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="utf-8"',
                },
                {
                    Filename    => 'dos',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="dos"; name="utf"',
                },
                {
                    Filename    => 'cp121',
                    Content     => 'empty',
                    ContentType => 'text/html; name="utf-7"; charset="cp121"',
                },
            ],
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
            }
    },
    {
        Name => 'Text/plain email.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            Type       => 'text/plain',
            Charset    => 'utf8',
            Attachment => [
                {
                    Filename    => 'csvfile.csv',
                    Content     => 'empty',
                    ContentType => 'text/csv',
                },
                {
                    Filename    => 'pngfile.png',
                    Content     => 'empty',
                    ContentType => 'image/png; name=pngfile.png',
                },
                {
                    Filename    => 'utf-8',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="utf-8"',
                },
                {
                    Filename    => 'dos',
                    Content     => 'empty',
                    ContentType => 'text/html; charset="dos"; name="utf"',
                },
                {
                    Filename    => 'cp121',
                    Content     => 'empty',
                    ContentType => 'text/html; name="utf-7"; charset="cp121"',
                },
            ],
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
            }
    }

);

my $Count = 0;

# Testing loop
for my $Test (@Tests) {

    $Count++;

    my $Name = "#$Count $Test->{Name}";

    # generate email
    my $EmailObject = Kernel::System::Email->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    # call Send and get results
    my ( $Header, $Body ) = $EmailObject->Send(
        %{ $Test->{Data} },
    );

    # some MIME::Tools workaround
    my $Email = ${$Header} . "\n" . ${$Body};
    my @Array = split '\n', $Email;

    # Processing with Send headersif constant SEND set to 1
    if ($SEND) {
        my %Result;
        for my $header ( split '\n', ${$Body} ) {
            if ( $header =~ /^Content\-Type\:\ (.*?)\;.*?\"(.*?)\"/x ) {
                $Result{$2} = ( split ': ', $header )[1];
            }
        }

        # Final check Content-Type from Email Send
        for my $Name (@Tests) {
            for my $Attach ( @{ $Name->{Data}->{Attachment} } ) {
                $Self->Is(
                    $Result{ $Attach->{Filename} },
                    $Name->{ExpectedResults}->{ $Attach->{Filename} }
                        . '; name="' . $Attach->{Filename} . '"',
                    "EmailSend: $Name->{Name} ",
                );
            }
        }
    }

    # No need test below is constant PARSE set to 0
    next if ( !$PARSE );

    # parse email
    my $ParserObject = Kernel::System::EmailParser->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        Email        => \@Array,
    );

    my %Result;

    my $Headers = $ParserObject->{Email}->{'mail_inet_body'};

    for my $header ( @{$Headers} ) {
        if ( $header =~ /^Content\-Type\:\ (.*?)\;.*?\"(.*?)\"/x ) {
            $Result{$2} = ( split ': ', $header )[1];
        }
    }

    # Final check Content-Type from EmailParser
    for my $Name (@Tests) {
        for my $Attach ( @{ $Name->{Data}->{Attachment} } ) {
            $Self->Is(
                $Result{ $Attach->{Filename} },
                $Name->{ExpectedResults}->{ $Attach->{Filename} }
                    . '; name="' . $Attach->{Filename} . '"',
                "EmailParser: $Name->{Name} ",
            );
        }
    }

}

1;
