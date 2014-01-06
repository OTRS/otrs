# --
# scripts/test/Priority.t - Priority module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Priority.t,v 1.3 2012-03-29 11:38:29 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use utf8;

use Kernel::System::Priority;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );

my $PriorityObject = Kernel::System::Priority->new( %{$Self} );

# add priority names
my $PriorityRand = int( rand(1000000) ) . ' - example-priority';

# Tests for Priority encode method
my @Tests = (

    #    {
    #        Input  => {
    #            Name    => '',
    #            ValidID => '',
    #            UserID  => '', },
    #        Result  => '',
    #        Name   => 'Priority - Undef',
    #    },

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
    ) || next;

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
    ) || next;

    $Self->Is(
        $LookupName,
        $Test->{Input}->{Name},
        $Test->{Name} . 'Lookup Same Name',
    ) || next;

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
    ) || next;

    $Self->Is(
        $ResultGet{ValidID},
        $Test->{Input}->{ValidID},
        $Test->{Name} . 'Get Correct ValidID',
    ) || next;

    $Self->Is(
        $ResultGet{Name},
        $Test->{Input}->{Name},
        $Test->{Name} . 'Get Correct Name',
    ) || next;

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
        PriorityID     => $PriorityID,
        Name           => $NewName,
        ValidID        => $NewValidID,
        CheckSysConfig => 0,             # (optional) default 1
        UserID         => 1,
    );

    $Self->Is(
        $Update,
        1,
        $Test->{Name} . 'Update - Final result',
    ) || next;

    my %UpdatedPrio = $PriorityObject->PriorityGet(
        PriorityID => $PriorityID,
        UserID     => 1,
    );

    $Self->Is(
        $UpdatedPrio{Name},
        $NewName,
        $Test->{Name} . 'Update - get after update',
    ) || next;

    $FirstPriorityList{$PriorityID} = "$NewName";

}    # for Normal +

# list

%CompletePriorityList = ( %FirstPriorityList, %AddedPriorities );
my %LastPriorityList = $PriorityObject->PriorityList( Valid => 0 );

$Self->IsDeeply(
    \%CompletePriorityList,
    \%LastPriorityList,
    'List - Compare complete priority list',
);

1;
