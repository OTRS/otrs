# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

# get needed objects
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

# add SystemAddress
my $SystemAddressEmail    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = "OTRS-Team";

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my $SystemAddressIDWrong = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->False(
    $SystemAddressIDWrong,
    'SystemAddressAdd() - Try to add new system address with existing system address name',
);

# add SystemAddress
my $SystemAddressEmail2    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname2 = "OTRS-Team2";
my $SystemAddressID2       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail2,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $SystemAddressID2,
    'SystemAddressAdd()',
);

# try to update SystemAddress with existing name
my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID2,
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
$Self->False(
    $SystemAddressUpdate,
    'SystemAddressUpdate() - Try to update new system address with existing system address name',
);

my %SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    2,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    1,
    'SystemAddressGet() - ValidID',
);

# caching
%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    2,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    1,
    'SystemAddressGet() - ValidID',
);

my %SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 0 );
my $Hit = 0;
for ( sort keys %SystemAddressList ) {
    if ( $_ eq $SystemAddressID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'SystemAddressList()',
);

# caching
%SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 0 );
$Hit = 0;
for ( sort keys %SystemAddressList ) {
    if ( $_ eq $SystemAddressID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'SystemAddressList()',
);

my @Tests = (
    {
        Address => uc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => lc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => $SystemAddressEmail,
        QueueID => 2,
    },
    {
        Address => '2' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ', ' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ')' . $SystemAddressEmail,
        QueueID => undef,
    },
);
for my $Test (@Tests) {
    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    $Self->Is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );

    # cached
    $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    $Self->Is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );
}

$SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID,
    Name     => '2' . $SystemAddressEmail,
    Realname => '2' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
$Self->True(
    $SystemAddressUpdate,
    'SystemAddressUpdate()',
);

%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    '2' . $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    '2' . $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment 1',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    1,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    2,
    'SystemAddressGet() - ValidID',
);

# Test SystemAddressIsUsed() function if available.
if ( $SystemAddressObject->can('SystemAddressIsUsed') ) {
    my $SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
        SystemAddressID => 1,
    );
    $Self->True(
        $SystemAddressIsUsed,
        "SystemAddressIsUsed() - Correctly detected system address in use"
    );

    $SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
        SystemAddressID => $SystemAddressID2,
    );
    $Self->False(
        $SystemAddressIsUsed,
        "SystemAddressIsUsed() - Correctly detected system address not in use"
    );
}

# Cleanup is done by RestoreDatabase.

1;
