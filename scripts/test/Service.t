# --
# Service.t - Service tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Service.t,v 1.1 2007-05-07 17:22:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
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

1;
