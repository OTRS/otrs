# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

#
# Group tests
#
my $GroupNameRandom    = $Helper->GetRandomID();
my %GroupIDByGroupName = (
    'test-group-' . $GroupNameRandom . '-1' => undef,
    'test-group-' . $GroupNameRandom . '-2' => undef,
    'test-group-' . $GroupNameRandom . '-3' => undef,
);

# try to add groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $GroupID,
        'GroupAdd() for new group ' . $GroupName,
    );

    if ($GroupID) {
        $GroupIDByGroupName{$GroupName} = $GroupID;
    }
}

# try to add already added groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->False(
        $GroupID,
        'GroupAdd() for already existing group ' . $GroupName,
    );
}

# try to fetch data of existing groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};
    my %Group = $GroupObject->GroupGet( ID => $GroupID );

    $Self->Is(
        $Group{Name},
        $GroupName,
        'GroupGet() for group ' . $GroupName,
    );
}

# look up existing groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    my $FetchedGroupID = $GroupObject->GroupLookup( Group => $GroupName );
    $Self->Is(
        $FetchedGroupID,
        $GroupID,
        'GroupLookup() for group name ' . $GroupName,
    );

    my $FetchedGroupName = $GroupObject->GroupLookup( GroupID => $GroupID );
    $Self->Is(
        $FetchedGroupName,
        $GroupName,
        'GroupLookup() for group ID ' . $GroupID,
    );
}

# list groups
my %Groups = $GroupObject->GroupList();
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    $Self->True(
        exists $Groups{$GroupID} && $Groups{$GroupID} eq $GroupName,
        'GroupList() contains group ' . $GroupName . ' with ID ' . $GroupID,
    );
}

# group data list
my %GroupDataList = $GroupObject->GroupDataList();
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    $Self->True(
        exists $GroupDataList{$GroupID} && $GroupDataList{$GroupID}->{Name} eq $GroupName,
        'GroupDataList() contains group ' . $GroupName . ' with ID ' . $GroupID,
    );
}

# change name of a single group
my $GroupNameToChange = 'test-group-' . $GroupNameRandom . '-1';
my $ChangedGroupName  = $GroupNameToChange . '-changed';
my $GroupIDToChange   = $GroupIDByGroupName{$GroupNameToChange};

my $GroupUpdateResult = $GroupObject->GroupUpdate(
    ID      => $GroupIDToChange,
    Name    => $ChangedGroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupUpdateResult,
    'GroupUpdate() for changing name of group ' . $GroupNameToChange . ' to ' . $ChangedGroupName,
);

$GroupIDByGroupName{$ChangedGroupName} = $GroupIDToChange;
delete $GroupIDByGroupName{$GroupNameToChange};

# try to add group with previous name
my $GroupID1 = $GroupObject->GroupAdd(
    Name    => $GroupNameToChange,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID1,
    'GroupAdd() add the first test group ' . $GroupNameToChange,
);

if ($GroupID1) {
    $GroupIDByGroupName{$GroupNameToChange} = $GroupID1;
}

# try to add group with changed name
my $GroupWrong = $GroupObject->GroupAdd(
    Name    => $ChangedGroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->False(
    $GroupWrong,
    'GroupAdd() add group with existing name ' . $ChangedGroupName,
);

my $GroupName2 = $GroupNameToChange . 'update';
my $GroupID2   = $GroupObject->GroupAdd(
    Name    => $GroupName2,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID2,
    'GroupAdd() add the second test group ' . $ChangedGroupName,
);

# try to update group with the name of existing group
my $GroupUpdateWrong = $GroupObject->GroupUpdate(
    ID      => $GroupID2,
    Name    => $GroupNameToChange,
    ValidID => 2,
    UserID  => 1,
);

$Self->False(
    $GroupUpdateWrong,
    'GroupUpdate() update group with existing name ' . $ChangedGroupName,
);

# cleanup is done by RestoreDatabase

1;
