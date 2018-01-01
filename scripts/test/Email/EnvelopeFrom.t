# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# get test email backed object
my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# get email object
my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

my @Tests = (
    {
        Name     => 'No envelope from (fallback to email from)',
        Settings => {
            SendmailEnvelopeFrom                                    => '',
            SendmailNotificationEnvelopeFrom                        => '',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '0',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
        },
        Result => 'john.smith@example.com'
    },
    {
        Name     => 'With envelope from',
        Settings => {
            SendmailEnvelopeFrom                                    => 'envelope@sender.com',
            SendmailNotificationEnvelopeFrom                        => '',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '0',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
        },
        Result => 'envelope@sender.com'
    },
    {
        Name     => 'No envelope from, notification with empty envelope from',
        Settings => {
            SendmailEnvelopeFrom                                    => '',
            SendmailNotificationEnvelopeFrom                        => '',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '0',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
            Loop     => 1,
        },
        Result => '',
    },
    {
        Name     => 'No envelope from, notification with fallback envelope from',
        Settings => {
            SendmailEnvelopeFrom                                    => '',
            SendmailNotificationEnvelopeFrom                        => '',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '1',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
            Loop     => 1,
        },
        Result => 'john.smith@example.com',
    },
    {
        Name     => 'With envelope from, notification with configured envelope from',
        Settings => {
            SendmailEnvelopeFrom                                    => '',
            SendmailNotificationEnvelopeFrom                        => 'envelope@sender.com',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '0',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
            Loop     => 1,
        },
        Result => 'envelope@sender.com',
    },
    {
        Name     => 'With envelope from, notification with configured envelope from (fallback ignored)',
        Settings => {
            SendmailEnvelopeFrom                                    => '',
            SendmailNotificationEnvelopeFrom                        => 'envelope@sender.com',
            'SendmailNotificationEnvelopeFrom::FallbackToEmailFrom' => '1',
        },
        Params => {
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/plain',
            Charset  => 'utf8',
            Loop     => 1,
        },
        Result => 'envelope@sender.com',
    },
);

for my $Test (@Tests) {

    for my $Setting ( %{ $Test->{Settings} } ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => $Setting,
            Value => $Test->{Settings}->{$Setting},
        );
    }

    my ( $Header, $Body ) = $EmailObject->Send( %{ $Test->{Params} } );
    $Self->True(
        $Body,
        "Email delivered to backend",
    );

    my $Emails = $TestBackendObject->EmailsGet();

    $Self->Is(
        scalar $Emails->[0]->{From},
        $Test->{Result},
        "$Test->{Name} From"
    );

    my $Success = $TestBackendObject->CleanUp();
    $Self->True(
        $Success,
        "$Test->{Name} cleanup",
    );
}

1;
