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

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

my $RandomID = $Helper->GetRandomID();

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my @TitleData = (
    'Parent Ticket' . $RandomID,
    'Child Ticket' . $RandomID
);
my @TicketIDs;

for my $TitleDataItem (@TitleData) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => $TitleDataItem,
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
        $TicketID,
        "TicketCreate() for parent ticket: $TicketID",
    );

    push @TicketIDs, $TicketID;
}

# get link object
my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

# create link between tickets
{
    my $Success = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $TicketIDs[0],
        TargetObject => 'Ticket',
        TargetKey    => $TicketIDs[1],
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

    $Self->True(
        $Success,
        "LinkAdd() for TicketID: $TicketIDs[0] and TicketID: $TicketIDs[1]",
    );
}

my $CheckACLs = sub {
    my %Param = @_;

    my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => 1,
    );

    my $Success = $TicketObject->TicketAcl(
        Data          => \%StateList,
        TicketID      => $TicketIDs[0],
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
        TicketID      => $TicketIDs[0],
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
    TicketID => $TicketIDs[1],
    UserID   => 1,
);

$Self->True(
    $Success,
    "TicketStateSet() Closed for child ticket: $TicketIDs[1] with true",
);

# check ACLs with with child closed
$CheckACLs->(
    TestName => 'Closed Child',
    Success  => 0,
);

# cleanup is done by RestoreDatabase.

1;
