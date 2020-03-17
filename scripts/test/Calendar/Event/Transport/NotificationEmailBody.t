# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Enable rich text editor.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Frontend::RichText',
    Value => 1,
);

# Use Test email backend.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# Set not self notify.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'AgentSelfNotifyOnAction',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $MailQueueObject       = $Kernel::OM->Get('Kernel::System::MailQueue');
my %MailQueueCurrentItems = map { $_->{ID} => $_ } @{ $MailQueueObject->List() || [] };
my $MailQueueClean        = sub {
    my $Items = $MailQueueObject->List();
    MAIL_QUEUE_ITEM:
    for my $Item ( @{$Items} ) {
        next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
        $MailQueueObject->Delete(
            ID => $Item->{ID},
        );
    }

    return;
};

my $MailQueueProcess = sub {
    my %Param = @_;

    my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

    # Process all items except the ones already present before the tests.
    my $Items = $MailQueueObject->List();
    MAIL_QUEUE_ITEM:
    for my $Item ( @{$Items} ) {
        next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
        $MailQueueObject->Send( %{$Item} );
    }

    # Clean any garbage.
    $MailQueueClean->();

    return;
};

my $RandomID = $Helper->GetRandomID();

# Create a new user for current test.
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $UserObject = $Kernel::OM->Get('Kernel::System::User');
my %UserData   = $UserObject->GetUserData(
    User => $UserLogin,
);
my $UserID = $UserData{UserID};

# Verify Line breaks in <OTRS_APPOINTMENT_DESCRIPTION>. See bug#14948.
# Create Appointment notification with AppointmentDelete event.
my $AppointmentName = "AppointmetCreate$RandomID";
my $NotificationID  = $Kernel::OM->Get('Kernel::System::NotificationEvent')->NotificationAdd(
    Name       => $AppointmentName,
    Transports => 'Email',
    UserID     => $UserID,
    Data       => {
        LanguageID => [
            'en'
        ],
        NotificationType => [
            'Appointment'
        ],
        TransportEmailTemplate => [
            'Alert'
        ],
        Transports => [
            'Email'
        ],
        Events => [
            'AppointmentCreate'
        ],
        Recipients => [
            'AppointmentAgentWritePermissions',
            'All agents with (at least) read permission for the appointment (calendar)'
        ],
        AgentEnabledByDefault => [
            'Email'
        ],
    },
    ValidID => 1,
    Message => {
        en => {
            Body        => 'Description &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;',
            Subject     => 'Reminder: <OTRS_APPOINTMENT_TITLE> Create',
            ContentType => 'text/html'
        }
    },
);
$Self->True(
    $NotificationID,
    "Appointment Notification ID $NotificationID is created.",
);

# Freeze time.
$Helper->FixedTimeSet();

# Create test calendar.
my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
my %Calendar       = $CalendarObject->CalendarCreate(
    CalendarName => "Calendar-$RandomID",
    Color        => '#3A87AD',
    GroupID      => 1,
    UserID       => $UserID,
);
$Self->True(
    $Calendar{CalendarID},
    "CalendarCreate - $Calendar{CalendarID}.",
);

# Create test appointment.
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $AppointmentID     = $AppointmentObject->AppointmentCreate(
    CalendarID  => $Calendar{CalendarID},
    Title       => "Test Appointment $RandomID",
    Description => "Test
description
$RandomID",
    Location  => 'Germany',
    StartTime => '2016-09-01 00:00:00',
    EndTime   => '2016-09-01 01:00:00',
    UserID    => $UserID,
);
$Self->True(
    $AppointmentID,
    "AppointmentCreate successful for Appointment ID $AppointmentID.",
);

# Process mail queue items.
$MailQueueProcess->();
my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');
my $Emails          = $TestEmailObject->EmailsGet();

# Verify if notification body
# correctly represented description tag line breaks.
my $Match = '';
my $Body  = ${ $Emails->[0]{Body} };
if ( $Body =~ m/Description Test<br \/>\ndescription<br \/>\n$RandomID/g )
{
    $Match = 1;
}
$Self->True(
    $Match,
    "Notification email body contains correct html representation of description.",
);

# cleanup is done by RestoreDatabase

1;
