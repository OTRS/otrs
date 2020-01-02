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

use Kernel::System::PostMaster;

# get needed objects
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $CommandObject      = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::Read');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $UserObject      = $Kernel::OM->Get('Kernel::System::User');

my $RandomID = $Helper->GetRandomID();

my $MailQueueSend = sub {

    # Send
    my $Items = $MailQueueObject->List();
    for my $Item ( @{$Items} ) {
        $MailQueueObject->Send( %{$Item}, );
    }

    return;
};

my $GenerateEmail = sub {
    my %Data = @_;

    my $Body = delete $Data{Body};
    my $From = delete $Data{From};
    my $To   = delete $Data{To};

    my @Email = (
        'From: ' . $From,
        'To:' . $To,
        'Message-ID: <original@mail.com>',
    );

    for my $Key ( sort keys %Data ) {
        push @Email, $Key . ': ' . $Data{$Key};
    }

    push @Email, "\n" . $Body . "\n";

    return join "\n", @Email;
};

# do not check email addresses
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$Helper->ConfigSettingChange(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# change the notification events to not transaction (it means send the notification right away)
$Helper->ConfigSettingChange(
    Key   => 'Ticket::EventModulePost###7000-NotificationEvent',
    Value => {
        Module      => 'Kernel::System::Ticket::Event::NotificationEvent',
        Event       => '.*',
        Transaction => 0,
    },
);

# clear email queue
$MailQueueObject->Delete();

# create test user
my $TestUserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);

# add queue
my $QueueNameRand = 'Queue' . $RandomID;
my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name         => $QueueNameRand,
    ValidID      => 1,
    GroupID      => 1,
    SalutationID => 1,
    SignatureID  => 1,
    Comment      => 'Unit test queue',
    UserID       => 1,
);
$Self->True(
    $QueueID,
    "QueueAdd() - $QueueNameRand, $QueueID",
);

# subscribe to ticket create notification
my $SetPreferences = $UserObject->SetPreferences(
    Key => 'NotificationTransport',
    Value =>
        '{"Notification-2-Email":0,"Notification-3-Email":0,"Notification-1-Email":"1","Notification-13-Email":0,"Notification-4-Email":0,"Notification-8-Email":"0"}',
    UserID => 1,
);

# add notification
my $NotificationName = 'Notification' . $RandomID;
my $NotificationID   = $Kernel::OM->Get('Kernel::System::NotificationEvent')->NotificationAdd(
    Name    => $NotificationName,
    Comment => 'Unit Test Notification <OTRS_CUSTOMER_BODY> tag',
    Data    => {
        Transports => ['Email'],
        Events     => ['NotificationNewTicket'],
        Recipients => ['AgentWritePermissions'],
    },
    Message => {
        en => {
            Subject     => 'Notification subject',
            Body        => 'OTRS_CUSTOMER_BODY tag: <OTRS_CUSTOMER_BODY>',
            ContentType => 'text/plain',
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $NotificationID,
    "NotificationAdd() - $NotificationName, $NotificationID",
);

my %EmailData = (
    From    => 'TestFrom@home.com',
    To      => 'TestTo@home.com',
    Subject => 'Email without Reply-To tag',
    Body    => 'Test Body Email',
);

# import ticket
my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Trusted                => 1,
    Email                  => $GenerateEmail->( %EmailData, ),
);

my @Return   = $PostMasterObject->Run( Queue => $QueueNameRand );
my $TicketID = $Return[1];

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# get test ticket ID
$Self->True(
    $TicketID,
    "TicketID $TicketID - created from email",
);

# Send emails
$MailQueueSend->();

# get emails
my $EmailBackend = $Kernel::OM->Get('Kernel::System::Email::Test');
my $Emails       = $EmailBackend->EmailsGet();

# check if any notification email as the tag
my $Found = 0;
my $Match = 'OTRS_CUSTOMER_BODY tag: ' . $EmailData{Body};
EMAIL:
for my $Email ( @{$Emails} ) {
    $Found = ( ${ $Email->{Body} } =~ m/$Match/ ? 1 : 0 );
    last EMAIL if $Found;
}

$Self->True(
    $Found,
    'OTRS_CUSTOMER_BODY found and translated in the notification!'
);

1;
