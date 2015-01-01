# --
# CloseParentAfterCloseChilds.t - CloseParentAfterCloseChilds ACL module tests
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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @BlackListedStates = ( 'closed successful', 'closed unsuccessful' );

# enable feature
$ConfigObject->Set(
    Key   => 'Ticket::Acl::Module###1-Ticket::Acl::Module',
    Value => {
        Module => 'Kernel::System::Ticket::Acl::CloseParentAfterClosedChilds',
        State  => \@BlackListedStates,
    },
);

# prevent otrs ACLs to be running
$ConfigObject->Set(
    Key   => 'TicketAcl',
    Value => {},
);

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID     = $HelperObject->GetRandomID();

my $TestUserLogin = $HelperObject->TestUserCreate();
my $TestUserID    = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Parent Ticket' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID1,
    "TicketCreate() for parent ticket: $TicketID1",
);

my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Child Ticket' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID2,
    "TicketCreate() for child ticket: $TicketID2",
);

# get link object
my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

# create link between tickets
{
    my $Success = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $TicketID1,
        TargetObject => 'Ticket',
        TargetKey    => $TicketID2,
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

    $Self->True(
        $Success,
        "LinkAdd() for TicketID: $TicketID1 and TicketID: $TicketID2",
    );
}

my $CheckACLs = sub {
    my %Param = @_;

    my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => 1,
    );

    my $Success = $TicketObject->TicketAcl(
        Data          => \%StateList,
        TicketID      => $TicketID1,
        ReturnType    => 'Ticket',
        ReturnSubType => 'State',
        UserID        => $TestUserID,
    );

    if ( $Param{Success} ) {
        $Self->True(
            $Success,
            "$Param{TestName} - State ACL executed with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Param{TestName} - State ACL executed with false",
        );
    }

    my %Acl = %StateList;
    if ($Success) {
        %Acl = $TicketObject->TicketAclData();
    }

    for my $StateID ( sort keys %StateList ) {
        if ( ( grep { $_ eq $StateList{$StateID} } @BlackListedStates ) && $Param{Success} ) {
            $Self->Is(
                $Acl{$StateID},
                undef,
                "$Param{TestName} - State: '$StateList{$StateID}' should be undefined in the ACL",
            );
        }
        else {
            $Self->IsNot(
                $Acl{$StateID},
                undef,
                "$Param{TestName} - State: '$StateList{$StateID}' should not be undefined in the ACL",
            );
        }
    }

    # get ACL restrictions
    my %PossibleActions;
    my $Counter;

    # get all registered Actions
    if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

        my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

        # only use those Actions that stats with Agent
        %PossibleActions
            = map { ++$Counter => $_ } grep { substr( $_, 0, length 'Agent' ) eq 'Agent' } sort keys %Actions;
    }

    $Success = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        TicketID      => $TicketID1,
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $TestUserID,
    );

    if ( $Param{Success} ) {
        $Self->True(
            $Success,
            "$Param{TestName} - Action ACL executed with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Param{TestName} - Action ACL executed with false",
        );
    }

    my %AclAction = %PossibleActions;
    if ($Success) {
        %AclAction = $TicketObject->TicketAclActionData();
    }

    my @BlackListedActions = ('AgentTicketClose');

    for my $ActionCounter ( sort keys %PossibleActions ) {
        if ( ( grep { $_ eq $PossibleActions{$ActionCounter} } @BlackListedActions ) && $Param{Success} ) {
            $Self->Is(
                $AclAction{$ActionCounter},
                undef,
                "$Param{TestName} - Action: '$PossibleActions{$ActionCounter}' should be undefined in the ACL",
            );
        }
        else {
            $Self->IsNot(
                $AclAction{$ActionCounter},
                undef,
                "$Param{TestName} - Action: '$PossibleActions{$ActionCounter}' should not be undefined in the ACL",
            );
        }
    }
};

# check ACLs with both tickets open
$CheckACLs->(
    TestName => 'Open Child',
    Success  => 1,
);

# close child ticket
my $Success = $TicketObject->TicketStateSet(
    State    => 'closed successful',
    TicketID => $TicketID2,
    UserID   => 1,
);

$Self->True(
    $Success,
    "TicketStateSet() Closed for child ticket: $TicketID2 with true",
);

# check ACLs with with child closed
$CheckACLs->(
    TestName => 'Closed Child',
    Success  => 0,
);

# cleanup the system
{
    my $Success = $LinkObject->LinkDelete(
        Object1 => 'Ticket',
        Key1    => $TicketID1,
        Object2 => 'Ticket',
        Key2    => $TicketID2,
        Type    => 'ParentChild',
        UserID  => 1,
    );

    $Self->True(
        $Success,
        "LinkDelete() for TicketID: $TicketID1 and TicketID: $TicketID2",
    );

}

for my $TicketID ( $TicketID1, $TicketID2 ) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success,
        "TicketDelete() for TicketID: $TicketID",
    );
}

1;
