# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::MailQueue;
use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
    'Kernel::System::MailQueue' => {
        CheckEmailAddresses => 0,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

my $SendEmails = sub {
    my %Param = @_;

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item->{Message};
    }

    # Clean the mail queue.
    $MailQueueObj->Delete();

    return @ToReturn;
};

# Ensure mail queue is empty before tests start.
$MailQueueObj->Delete();

# Enable email addresses checking.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# disable rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 0,
);

$Self->True(
    $Success,
    "Disable RichText with true",
);

# use Test email backend
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

$Self->True(
    $Success,
    "Set Email Test backend with true",
);

# set not self notify
$Success = $ConfigObject->Set(
    Key   => 'AgentSelfNotifyOnAction',
    Value => 0,
);

$Self->True(
    $Success,
    "Disable Agent Self Notify On Action",
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

$Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# create a new user for current test
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => ['users'],
);

my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $UserLogin,
);

my $UserID = $UserData{UserID};

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# create test group
my $GroupID = $GroupObject->GroupAdd(
    Name    => 'unittestgroup' . $HelperObject->GetRandomID(),
    Comment => 'comment describing the group',
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    'Group create',
);

$Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GroupID,
    UID        => $UserID,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);

$Self->True(
    $Success,
    'Group user add',
);

my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

# create calendar and appointment
my %Calendar = $CalendarObject->CalendarCreate(
    CalendarName => 'unittestcalendar' . $HelperObject->GetRandomID(),
    GroupID      => $GroupID,
    Color        => '#FF7700',
    UserID       => $UserID,
    ValidID      => 1,
);

my @Tests = (
    {
        Name => 'Single RecipientAgent',
        Data => {
            Events           => ['CalendarUpdate'],
            RecipientAgents  => [$UserID],
            NotificationType => ['Appointment'],
        },
        ExpectedResults => [
            {
                ToArray => [ $UserData{UserEmail} ],
                Body    => "Calender: $Calendar{CalendarName}=\n",
            },
        ],
    },
    {
        Name => 'Recipient Customer - JustToRealCustomer enabled',
        Data => {
            Events           => ['CalendarUpdate'],
            Recipients       => ['Customer'],
            NotificationType => ['Appointment'],
        },
        ExpectedResults    => [],
        JustToRealCustomer => 1,
    },
    {
        Name => 'Multiple valid RecipientEmail',
        Data => {
            Events           => ['CalendarUpdate'],
            RecipientEmail   => ['zz1test@otrsexample.com, zz2test@otrsexample.com; zz3test@otrsexample.com'],
            NotificationType => ['Appointment'],
        },
        ExpectedResults => [
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
            {
                ToArray => ['zz3test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid RecipientEmail not separated by space with additional commas and semmi-colons',
        Data => {
            Events           => ['CalendarUpdate'],
            RecipientEmail   => ['zz1test@otrsexample.com,;,zz2test@otrsexample.com;;zz3test@otrsexample.com'],
            NotificationType => ['Appointment'],
        },
        ExpectedResults => [
            {
                ToArray => ['zz1test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
            {
                ToArray => ['zz2test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
            {
                ToArray => ['zz3test@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
        ],
    },
    {
        Name => 'Multiple valid and invalid RecipientEmail',
        Data => {
            Events           => ['CalendarUpdate'],
            RecipientEmail   => ['aaatest@otrsexample.com, asdfqwe; zzztest@otrsexample.com; e212355qwe.com'],
            NotificationType => ['Appointment'],
        },
        ExpectedResults => [
            {
                ToArray => ['aaatest@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
            {
                ToArray => ['zzztest@otrsexample.com'],
                Body    => "Calender: -=\n",
            },
        ],
    },
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Calendar::Event::Notification');

my $Count = 0;
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

    # set just to real customer
    my $JustToRealCustomer = $Test->{JustToRealCustomer} || 0;
    $Success = $ConfigObject->Set(
        Key   => 'CustomerNotifyJustToRealCustomer',
        Value => $JustToRealCustomer,
    );

    $Self->True(
        $Success,
        "Set notifications just to real customer: $JustToRealCustomer.",
    );

    my $NotificationID = $NotificationEventObject->NotificationAdd(
        Name    => "JobName$Count",
        Data    => $Test->{Data},
        Message => {
            en => {
                Subject     => 'JobName',
                Body        => 'Calender: <OTRS_CALENDAR_CALENDARNAME>',
                ContentType => 'text/plain',
            },
        },
        Comment => 'An optional comment',
        ValidID => 1,
        UserID  => 1,
    );

    # sanity check
    $Self->IsNot(
        $NotificationID,
        undef,
        "$Test->{Name} - NotificationAdd() should not be undef",
    );

    my $Result = $EventNotificationEventObject->Run(
        Event => 'CalendarUpdate',
        Data  => {
            CalendarID => $Calendar{CalendarID},
        },
        Config => {},
        UserID => 1,
    );

    $SendEmails->();

    my $Emails = $TestEmailObject->EmailsGet();

    # remove not needed data
    for my $Email ( @{$Emails} ) {
        for my $Attribute (qw(From Header)) {
            delete $Email->{$Attribute};
        }

        # de-reference body
        $Email->{Body} = ${ $Email->{Body} };
    }

    # Sort emails.
    if ( @{$Emails} > 1 ) {
        my @Sorted = sort { $a->{ToArray}[0] cmp $b->{ToArray}[0] } @{$Emails};
        $Emails = \@Sorted;
    }

    $Self->IsDeeply(
        $Emails,
        $Test->{ExpectedResults},
        "$Test->{Name} - Recipients",
    );

    # delete notification event
    my $NotificationDelete = $NotificationEventObject->NotificationDelete(
        ID     => $NotificationID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $NotificationDelete,
        "$Test->{Name} - NotificationDelete() successful for Notification ID $NotificationID",
    );

    $TestEmailObject->CleanUp();

    $Count++;
}

1;

# cleanup is done by RestoreDatabase.
