# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use utf8;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);

$Self->True(
    $Success,
    "Enable RichText",
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

# set restore configuration param
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @UserIDs;

# create a new user User
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => ['users'],
);

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my %UserData = $UserObject->GetUserData(
    User => $UserLogin,
);

my $UserID1 = $UserData{UserID};

# store ID for use it later
push @UserIDs, $UserID1;

# create a new user User2
my $UserLogin2 = $HelperObject->TestUserCreate(
    Groups => ['users'],
);

my %UserData2 = $UserObject->GetUserData(
    User => $UserLogin2,
);

my $UserID2 = $UserData2{UserID};

# store ID for use it later
push @UserIDs, $UserID2;

# create a new user User3
my $UserLogin3 = $HelperObject->TestUserCreate(
    Groups => ['users'],
);

my %UserData3 = $UserObject->GetUserData(
    User => $UserLogin3,
);

my $UserID3 = $UserData3{UserID};

# store ID for use it later
push @UserIDs, $UserID3;

# get a random id
my $RandomID = int rand 1_000_000_000;

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# add group
my $GID = $GroupObject->GroupAdd(
    Name    => "example-group$RandomID",
    Comment => 'comment describing the group',
    ValidID => 1,
    UserID  => 1,
);

$Self->IsNot(
    $GID,
    undef,
    "GroupAdd() should not be undef",
);

# add role
my $RoleID = $GroupObject->RoleAdd(
    Name    => "example-role$RandomID",
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);

$Self->IsNot(
    $RoleID,
    undef,
    "RoleAdd() should not be undef",
);

for my $UserID (@UserIDs) {

    # add users to groups
    $Success = $GroupObject->PermissionGroupUserAdd(
        GID        => $GID,
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
        "Added User ID $UserID to Group ID $GID",
    );

    # add user to role
    $Success = $GroupObject->PermissionRoleUserAdd(
        RID    => $RoleID,
        UID    => $UserID,
        Active => 1,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "Added User ID $UserID to Role ID $RoleID",
    );
}

# get queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# get queue data
my %Queue = $QueueObject->QueueGet(
    ID => 1,
);

# set queue to special group
$Success = $QueueObject->QueueUpdate(
    QueueID => 1,
    %Queue,
    GroupID => $GID,
    UserID  => 1,
);

$Self->True(
    $Success,
    "Set Queue ID 1 to Group ID $GID",
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Ticket One Title',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'new',
    CustomerID    => 'example.com',
    CustomerUser  => 'customerOne@example.com',
    OwnerID       => $UserID1,
    ResponsibleID => $UserID2,
    UserID        => $UserID3,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

# get dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

# define params for sending as CustomerMessageParams
my $CustomerMessageParams = {
    A => 'AAAAA',
    B => 'BBBBB',
    C => 'CCCCC',
};

my %OriginalCustomerMessageParams = %{$CustomerMessageParams};

my @Tests = (
    {
        Name => 'Single RecipientAgent',
        Data => {
            Events => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],

            # RecipientAgents => [$UserID],
        },
        Config => {
            Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
            Data  => {
                TicketID              => $TicketID,
                Recipients            => \@UserIDs,
                CustomerMessageParams => $CustomerMessageParams,
            },
            Config => {},
            UserID => 1,
        },
        ExpectedResults => {
            '0' => 'text/plain; charset="utf-8"',
            '1' => 'text/html; charset="utf-8"'
        },
        Success => 1,
    },

);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

my $Count = 0;
my $NotificationID;
TEST:
for my $Test (@Tests) {

    # add transport setting
    $Test->{Data}->{Transports} = ['Email'];

    $NotificationID = $NotificationEventObject->NotificationAdd(
        Name    => "JobName$Count-$RandomID",
        Comment => 'An optional comment',
        Data    => $Test->{Data},
        Message => {
            en => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
            de => {
                Subject     => 'JobName',
                Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
                ContentType => 'text/plain',
            },
        },
        ValidID => 1,
        UserID  => 1,
    );

    # sanity check
    $Self->IsNot(
        $NotificationID,
        undef,
        "$Test->{Name} - NotificationAdd() should not be undef",
    );

    my $Result = $EventNotificationEventObject->Run( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Result,
            "$Test->{Name} - NotificationEvent Run() with false",
        );

        # notification will be deleted in "continue" statement
        next TEST;
    }

    $Self->True(
        $Result,
        "$Test->{Name} - NotificationEvent Run() with true",
    );

    my $Emails = $TestEmailObject->EmailsGet();

    # remove not needed data
    for my $Email ( @{$Emails} ) {

        my $Counter = 0;
        my %Result;
        for my $Header ( split '\n', ${ $Email->{Body} } ) {

            if ( $Header =~ /^Content\-Type\:\ (.*?)\;.*?\"(.*?)\"/x ) {
                $Result{$Counter} = ( split ': ', $Header )[1];
                $Counter++;
            }
        }

        $Self->Is(
            $Counter,
            2,
            "Attachment number should be 2, plain and html.",
        );

        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResults},
            "$Test->{Name} - Attachments",
        );

    }

}
continue {
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
    undef $NotificationID;
}

# verify CustomerMessageParams reference have
# the same content as the beginning of this test
$Self->IsDeeply(
    $CustomerMessageParams,
    \%OriginalCustomerMessageParams,
    "CustomerMessageParams didn't grow after sending emails.",
);

# cleanup

# revert queue to original group
$QueueObject->QueueUpdate(
    QueueID => 1,
    %Queue,
    UserID => 1,
);

$Self->True(
    $Success,
    "Set Queue ID 1 to Group ID $Queue{GroupID}",
);

# delete the dynamic field
my $DFDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID      => $FieldID,
    UserID  => 1,
    Reorder => 0,
);

# sanity check
$Self->True(
    $DFDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

# delete the ticket
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => $UserID1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

for my $UserID (@UserIDs) {

    # delete group
    $Success = $GroupObject->PermissionGroupUserAdd(
        GID        => $GID,
        UID        => $UserID,
        Permission => {
            ro        => 0,
            move_into => 0,
            create    => 0,
            owner     => 0,
            priority  => 0,
            rw        => 0,
        },
        UserID => 1,
    );

    $Self->True(
        $Success,
        "Removed User ID $UserID from Group ID $GID",
    );
}

# get db object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# remove new group manually
$Success = $DBObject->Do(
    SQL => 'DELETE FROM groups
        WHERE id = ?',
    Bind => [
        \$GID,
    ],
);

$Self->True(
    $Success,
    "Deleted Group ID $GID",
);

for my $UserID (@UserIDs) {

    # remove role
    $Success = $GroupObject->PermissionRoleUserAdd(
        RID    => $RoleID,
        UID    => $UserID,
        Active => 0,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "Removed User ID $UserID from Role ID $RoleID",
    );
}

# remove new role manually
$Success = $DBObject->Do(
    SQL => 'DELETE FROM roles
        WHERE id = ?',
    Bind => [
        \$RoleID,
    ],
);

$Self->True(
    $Success,
    "Deleted Role ID $RoleID",
);

1;
