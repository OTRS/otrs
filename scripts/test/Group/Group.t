# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::Time',
);

# get needed objects
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
my $TimeObject  = $Kernel::OM->Get('Kernel::System::Time');

#
# Group tests
#
my $GroupNameRandomPartBase = $TimeObject->SystemTime();
my %GroupIDByGroupName      = (
    'test-group-' . $GroupNameRandomPartBase . '-1' => undef,
    'test-group-' . $GroupNameRandomPartBase . '-2' => undef,
    'test-group-' . $GroupNameRandomPartBase . '-3' => undef,
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
my $GroupNameToChange = 'test-group-' . $GroupNameRandomPartBase . '-1';
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
my $GroupID = $GroupObject->GroupAdd(
    Name    => $GroupNameToChange,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    'GroupAdd() for new group ' . $GroupNameToChange,
);

if ($GroupID) {
    $GroupIDByGroupName{$GroupNameToChange} = $GroupID;
}

# try to add group with changed name
$GroupID = $GroupObject->GroupAdd(
    Name    => $ChangedGroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->False(
    $GroupID,
    'GroupAdd() for new group ' . $ChangedGroupName,
);

# set created groups to invalid
GROUPNAME:
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    next GROUPNAME if !$GroupIDByGroupName{$GroupName};

    my $GroupUpdate = $GroupObject->GroupUpdate(
        ID      => $GroupIDByGroupName{$GroupName},
        Name    => $GroupName,
        ValidID => 2,
        UserID  => 1,
    );

    $Self->True(
        $GroupUpdate,
        'GroupUpdate() to set group ' . $GroupName . ' to invalid',
    );
}

1;
