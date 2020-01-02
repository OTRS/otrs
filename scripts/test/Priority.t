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

# get priority object
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add priority names
my $PriorityRand = 'priority' . $Helper->GetRandomID();

# Tests for Priority encode method
my @Tests = (
    {
        Input => {
            Name    => $PriorityRand,
            ValidID => 1,
            UserID  => 1,
        },
        Result => '',
        Name   => 'Priority - ',
    },
);

my %FirstPriorityList;
my %CompletePriorityList;
my %AddedPriorities;

%FirstPriorityList = $PriorityObject->PriorityList( Valid => 0 );

TEST:
for my $Test (@Tests) {

    # add
    my $PriorityID = $PriorityObject->PriorityAdd(
        Name    => $Test->{Input}->{Name},
        ValidID => $Test->{Input}->{ValidID},
        UserID  => $Test->{Input}->{UserID},
    );

    $Self->IsNot(
        $PriorityID,
        $Test->{Result},
        $Test->{Name} . 'Add',
    ) || next TEST;

    $FirstPriorityList{$PriorityID} = $Test->{Input}->{Name};

    # lookup
    my $LookupID = $PriorityObject->PriorityLookup(
        Priority => $Test->{Input}->{Name},
    );

    my $LookupName = $PriorityObject->PriorityLookup(
        PriorityID => $PriorityID,
    );

    $Self->Is(
        $LookupID,
        $PriorityID,
        $Test->{Name} . 'Lookup Same ID',
    ) || next TEST;

    $Self->Is(
        $LookupName,
        $Test->{Input}->{Name},
        $Test->{Name} . 'Lookup Same Name',
    ) || next TEST;

    # get
    my %ResultGet = $PriorityObject->PriorityGet(
        PriorityID => $PriorityID,
        UserID     => 1,
    );

    # compare results
    $Self->Is(
        $ResultGet{ID},
        $PriorityID,
        $Test->{Name} . 'Get Correct ID',
    ) || next TEST;

    $Self->Is(
        $ResultGet{ValidID},
        $Test->{Input}->{ValidID},
        $Test->{Name} . 'Get Correct ValidID',
    ) || next TEST;

    $Self->Is(
        $ResultGet{Name},
        $Test->{Input}->{Name},
        $Test->{Name} . 'Get Correct Name',
    ) || next TEST;

    # change data
    my $NewName = $Test->{Input}->{Name} . ' - update';

    my $Valid = {
        '1' => '2',
        '2' => '3',
        '3' => '1',
    };

    my $NewValidID = $Valid->{ $ResultGet{ValidID} };

    # update data
    my $Update = $PriorityObject->PriorityUpdate(
        PriorityID => $PriorityID,
        Name       => $NewName,
        ValidID    => $NewValidID,
        UserID     => 1,
    );

    $Self->Is(
        $Update,
        1,
        $Test->{Name} . 'Update - Final result',
    ) || next TEST;

    my %UpdatedPrio = $PriorityObject->PriorityGet(
        PriorityID => $PriorityID,
        UserID     => 1,
    );

    $Self->Is(
        $UpdatedPrio{Name},
        $NewName,
        $Test->{Name} . 'Update - get after update',
    ) || next TEST;

    $FirstPriorityList{$PriorityID} = $NewName;
}

# list
%CompletePriorityList = ( %FirstPriorityList, %AddedPriorities );
my %LastPriorityList = $PriorityObject->PriorityList( Valid => 0 );

$Self->IsDeeply(
    \%CompletePriorityList,
    \%LastPriorityList,
    'List - Compare complete priority list',
);

# cleanup is done by RestoreDatabase

1;
