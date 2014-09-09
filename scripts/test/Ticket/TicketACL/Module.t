# --
# TicketACL/Module.t - Test TicketACL modules
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'Ticket::Acl::Module',
    Value => {
        DummyModule => {
            Module        => 'scripts::test::Ticket::TicketACL::DummyModule',
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Checks        => ['Ticket'],
        },
    },
);

# get needed objects
my $ValidObject    = $Kernel::OM->Get('Kernel::System::Valid');
my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
my $StateObject    = $Kernel::OM->Get('Kernel::System::State');
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');

# set valid options
my %ValidList = $ValidObject->ValidList();
%ValidList = reverse %ValidList;

# set user options
my $UserLogin = $HelperObject->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

my $UserID = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);

# set helper options
my $RandomID = $HelperObject->GetRandomID();

# set queue options
my $QueueName = 'Queue_' . $RandomID;
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => $ValidList{'valid'},
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

# sanity check
$Self->True(
    $QueueID,
    "QueueAdd() ID ($QueueID) added successfully"
);

# set state options
my $StateName = 'State_' . $RandomID;
my $StateID   = $StateObject->StateAdd(
    Name    => $StateName,
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateID,
    "StateAdd() ID ($StateID) added successfully"
);

# set priority options
my $PriorityName = 'Priority_' . $RandomID;
my $PriorityID   = $PriorityObject->PriorityAdd(
    Name    => $PriorityName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $PriorityID,
    "PriorityAdd() ID ($PriorityID) added successfully"
);

my $TicketID = $TicketObject->TicketCreate(
    Title      => 'Test Ticket for TicketACL Module tests',
    QueueID    => $QueueID,
    Lock       => 'lock',
    StateID    => $StateID,
    OwnerID    => $UserID,
    UserID     => 1,
    PriorityID => $PriorityID,
);

$Self->True(
    $TicketID,
    "Ticket ID ($TicketID) successfully created",
);

my $AclSuccess = $TicketObject->TicketAcl(
    TicketID      => $TicketID,
    ReturnType    => 'Ticket',
    ReturnSubType => 'State',
    UserID        => $UserID,
    Data          => {
        1 => 'new',
        2 => 'open',
    },
);

$Self->True(
    $AclSuccess,
    'ACL from module matched',
);

my %ACLData = $TicketObject->TicketAclData();

$Self->IsDeeply(
    \%ACLData,
    { 1 => 'new' },
    'AclData from module',
);

$AclSuccess = $TicketObject->TicketAcl(
    TicketID      => $TicketID,
    ReturnType    => 'Ticket',
    ReturnSubType => 'Service',
    UserID        => $UserID,
    Data          => {
        1 => 'new',
    },
);

$Self->False(
    $AclSuccess,
    'Non-matching ACL from module',
);

# clean tickets
my $TicketDeleteSuccess = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDeleteSuccess,
    "TicketDelete ID ($TicketID) deleted successfully"
);

# clean the system
# clean queues
my $QueueUpdateSuccess = $QueueObject->QueueUpdate(
    $QueueObject->QueueGet(
        ID     => $QueueID,
        UserID => 1,
    ),
    ValidID => $ValidList{'invalid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $QueueUpdateSuccess,
    "QueueUpdate() ID ($QueueID) invalidated successfully"
);
