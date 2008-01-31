# --
# Service.t - Service tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Service.t,v 1.3 2008-01-31 06:20:20 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::Service;

$Self->{ServiceObject} = Kernel::System::Service->new(%{$Self});

my $ServiceRand = 'SomeService'.int(rand(1000000));
my $ServiceID = $Self->{ServiceObject}->ServiceAdd(
    Name => $ServiceRand,
    Comment => 'Some Comment',
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $ServiceID,
    'ServiceAdd()',
);

my %ServiceGet = $Self->{ServiceObject}->ServiceGet(
    ServiceID => $ServiceID,
    UserID => 1,
);

$Self->Is(
    $ServiceGet{Name} || '',
    $ServiceRand,
    'ServiceGet() - Name',
);
$Self->Is(
    $ServiceGet{ValidID} || '',
    1,
    'ServiceGet() - ValidID',
);
$Self->Is(
    $ServiceGet{Comment} || '',
    'Some Comment',
    'ServiceGet() - Comment',
);

my $ServiceUpdate = $Self->{ServiceObject}->ServiceUpdate(
    ServiceID => $ServiceID,
    Name => $ServiceRand."1",
    ValidID => 2,
    UserID => 1,
    Comment => 'Some Comment1',
);

$Self->True(
    $ServiceUpdate,
    'ServiceUpdate()',
);

%ServiceGet = $Self->{ServiceObject}->ServiceGet(
    ServiceID => $ServiceID,
    UserID => 1,
);

$Self->Is(
    $ServiceGet{Name} || '',
    $ServiceRand."1",
    'ServiceGet() - Name',
);
$Self->Is(
    $ServiceGet{ValidID} || '',
    2,
    'ServiceGet() - ValidID',
);
$Self->Is(
    $ServiceGet{Comment} || '',
    'Some Comment1',
    'ServiceGet() - Comment',
);

my $Service = $Self->{ServiceObject}->ServiceLookup(ServiceID => $ServiceID);

$Self->Is(
    $Service || '',
    $ServiceRand."1",
    'ServiceLookup() by ID',
);

my $ServiceIDLookup = $Self->{ServiceObject}->ServiceLookup(Name => $Service);

$Self->Is(
    $ServiceID || '',
    $ServiceIDLookup,
    'ServiceLookup() by Name',
);

my $ServiceID2 = $Self->{ServiceObject}->ServiceAdd(
    ValidID => 1,
    UserID => 1,
);

$Self->False(
    $ServiceID2,
    'ServiceAdd2()',
);

my $ServiceRand3 = 'SomeService'.int(rand(1000000));
my $ServiceID3 = $Self->{ServiceObject}->ServiceAdd(
    Name => $ServiceRand3,
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $ServiceID3,
    'ServiceAdd3()',
);

my $ServiceUpdate2 = $Self->{ServiceObject}->ServiceUpdate(
    ServiceID => $ServiceID3,
    ValidID => 2,
    UserID => 1,
);

$Self->False(
    $ServiceUpdate2,
    'ServiceUpdate2()',
);

my $ServiceUpdate3 = $Self->{ServiceObject}->ServiceUpdate(
    ServiceID => $ServiceID3,
    Name => $ServiceRand3."1",
    ValidID => 2,
    UserID => 1,
);

$Self->True(
    $ServiceUpdate3,
    'ServiceUpdate3()',
);

1;
