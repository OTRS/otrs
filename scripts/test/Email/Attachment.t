# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
use utf8;

use vars (qw($Self));

use Kernel::System::EmailParser;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Constants for test(s): 1 - enabled, 0 - disabled.
# SEND - check sending body. PARSE - check parsed body.

my $SEND  = 1;
my $PARSE = 1;

my $AttachmentReference = [
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
];

my $AttachmentNumber = scalar @{$AttachmentReference};

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
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
            MimeType   => 'text/html',
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
        },
    },
    {
        Name => 'Text/plain email.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/plain',
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
        },
    },

    {
        Name => 'HTML email - Attachments grow up one.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/html',
            Charset    => 'utf8',
            Attachment => $AttachmentReference,
            MimeType   => 'text/html',
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
        CheckAttachmentsSize => '1',
    },
    {
        Name => 'HTML email - Attachments grow up two.',
        Data => {
            From       => 'john.smith@example.com',
            To         => 'john.smith2@example.com',
            Subject    => 'some subject',
            Body       => 'Some Body',
            MimeType   => 'text/html',
            Charset    => 'utf8',
            Attachment => $AttachmentReference,
            MimeType   => 'text/html',
        },
        ExpectedResults => {
            'csvfile.csv' => 'text/csv',
            'pngfile.png' => 'image/png',
            'utf-8'       => 'text/html; charset="utf-8"',
            'dos'         => 'text/html; charset="dos"',
            'cp121'       => 'text/html; charset="cp121"',
        },
        CheckAttachmentsSize => '1',
    },

);

# get email object
my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

my $SendEmail = sub {
    my %Param = @_;

    # Delete mail queue
    $MailQueueObject->Delete();

    # Generate the mail and queue it
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();
    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    my $Result = $MailQueueObject->Send( %{$LastItem} );

    return ( \$LastItem->{Message}->{Header}, \$LastItem->{Message}->{Body}, );
};

# testing loop
my $Count = 0;
TEST:
for my $Test (@Tests) {

    $Count++;

    my $Name = "#$Count $Test->{Name}";

    # Send mail and get results.
    my ( $Header, $Body ) = $SendEmail->( %{ $Test->{Data} } );

    # check reference attachment size
    if ( $Test->{CheckAttachmentsSize} ) {

        my $CurrentAttachmentNumber = scalar @{$AttachmentReference};
        $Self->Is(
            $AttachmentNumber,
            $CurrentAttachmentNumber,
            "AttachmentsSize: $Test->{Name} ",
        );
    }

    if ( !$Header || ref $Header ne 'SCALAR' ) {

        my $String = '';
        $Header = \$String;
    }

    if ( !$Body || ref $Body ne 'SCALAR' ) {

        my $String = '';
        $Body = \$String;
    }

    # some MIME::Tools workaround
    my $Email = ${$Header} . "\n" . ${$Body};
    my @Array = split '\n', $Email;

    # Processing with Send headersif constant SEND set to 1
    if ($SEND) {
        my %Result;
        for my $Header ( split '\n', ${$Body} ) {
            if ( $Header =~ /^Content\-Type\:\ (.*?)\;.*?\"(.*?)\"/x ) {
                $Result{$2} = ( split ': ', $Header )[1];
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
    next TEST if ( !$PARSE );

    # parse email
    my $ParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    my %Result;

    my $Headers = $ParserObject->{Email}->{'mail_inet_body'};

    for my $Header ( @{$Headers} ) {
        if ( $Header =~ /^Content\-Type\:\ (.*?)\;.*?\"(.*?)\"/x ) {
            $Result{$2} = ( split ': ', $Header )[1];
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
