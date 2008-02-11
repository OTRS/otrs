# --
# SLA.t - SLA tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SLA.t,v 1.4 2008-02-11 12:18:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::SLA;

$Self->{SLAObject} = Kernel::System::SLA->new(%{$Self});

my $SLARand = 'SomeSLA'.int(rand(1000000));
my $SLAID = $Self->{SLAObject}->SLAAdd(
    Name => $SLARand,
    ServiceID => 1,
    Calendar => '',
    FirstResponseTime => 30,
    FirstResponseNotify => 60,
    UpdateTime => 240,
    UpdateNotify => 70,
    SolutionTime => 2440,
    SolutionNotify => 80,
    Comment => 'Some Comment',
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $SLAID,
    'SLAAdd()',
);

my %SLAGet = $Self->{SLAObject}->SLAGet(
    SLAID => $SLAID,
    UserID => 1,
);

$Self->Is(
    $SLAGet{Name} || '',
    $SLARand,
    'SLAGet() - Name',
);
$Self->Is(
    $SLAGet{ValidID} || '',
    1,
    'SLAGet() - ValidID',
);
$Self->Is(
    $SLAGet{Calendar} || '',
    '',
    'SLAGet() - Calendar',
);
$Self->Is(
    $SLAGet{Comment} || '',
    'Some Comment',
    'SLAGet() - Comment',
);
$Self->Is(
    $SLAGet{FirstResponseTime} || '',
    30,
    'SLAGet() - FirstResponseTime',
);
$Self->Is(
    $SLAGet{FirstResponseNotify} || '',
    60,
    'SLAGet() - FirstResponseNotify',
);

$Self->Is(
    $SLAGet{UpdateTime} || '',
    240,
    'SLAGet() - EscalationUpdateTime',
);
$Self->Is(
    $SLAGet{UpdateNotify} || '',
    70,
    'SLAGet() - EscalationUpdateNotify',
);

$Self->Is(
    $SLAGet{SolutionTime} || '',
    2440,
    'SLAGet() - SolutionTime',
);
$Self->Is(
    $SLAGet{SolutionNotify} || '',
    80,
    'SLAGet() - SolutionNotify',
);

my $SLAUpdate = $Self->{SLAObject}->SLAUpdate(
    SLAID => $SLAID,
    ServiceID => 1,
    Name => $SLARand."1",
    Calendar => 1,
    FirstResponseTime => 60,
    FirstResponseNotify => 70,
    UpdateTime => 480,
    UpdateNotify => 80,
    SolutionTime => 4880,
    SolutionNotify => 90,
    ValidID => 2,
    UserID => 1,
    Comment => 'Some Comment1',
);

$Self->True(
    $SLAUpdate,
    'SLAUpdate()',
);

%SLAGet = $Self->{SLAObject}->SLAGet(
    SLAID => $SLAID,
    UserID => 1,
);

$Self->Is(
    $SLAGet{Name} || '',
    $SLARand."1",
    'SLAGet() - Name',
);
$Self->Is(
    $SLAGet{ValidID} || '',
    2,
    'SLAGet() - ValidID',
);
$Self->Is(
    $SLAGet{Calendar} || '',
    1,
    'SLAGet() - Calendar',
);
$Self->Is(
    $SLAGet{Comment} || '',
    'Some Comment1',
    'SLAGet() - Comment',
);

$Self->Is(
    $SLAGet{FirstResponseTime} || '',
    60,
    'SLAGet() - FirstResponseTime',
);
$Self->Is(
    $SLAGet{FirstResponseNotify} || '',
    70,
    'SLAGet() - FirstResponseNotify',
);

$Self->Is(
    $SLAGet{UpdateTime} || '',
    480,
    'SLAGet() - UpdateTime',
);
$Self->Is(
    $SLAGet{UpdateNotify} || '',
    80,
    'SLAGet() - UpdateNotify',
);

$Self->Is(
    $SLAGet{SolutionTime} || '',
    4880,
    'SLAGet() - SolutionTime',
);
$Self->Is(
    $SLAGet{SolutionNotify} || '',
    90,
    'SLAGet() - SolutionNotify',
);

my $SLA = $Self->{SLAObject}->SLALookup(SLAID => $SLAID);

$Self->Is(
    $SLA || '',
    $SLARand."1",
    'SLALookup() by ID',
);

my $SLAIDLookup = $Self->{SLAObject}->SLALookup(Name => $SLA);

$Self->Is(
    $SLAID || '',
    $SLAIDLookup,
    'SLALookup() by Name',
);

my $SLARand2 = 'SomeSLA'.int(rand(1000000));
my $SLAID2 = $Self->{SLAObject}->SLAAdd(
    Name => $SLARand2,
    ValidID => 1,
    UserID => 1,
);

$Self->False(
    $SLAID2,
    'SLAAdd2()',
);

my $SLAID3 = $Self->{SLAObject}->SLAAdd(
    ServiceID => 1,
    ValidID => 1,
    UserID => 1,
);

$Self->False(
    $SLAID3,
    'SLAAdd3()',
);

my $SLARand4 = 'SomeSLA'.int(rand(1000000));
my $SLAID4 = $Self->{SLAObject}->SLAAdd(
    Name => $SLARand4,
    ServiceID => 1,
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $SLAID4,
    'SLAAdd4()',
);

my $SLAUpdate2 = $Self->{SLAObject}->SLAUpdate(
    ServiceID => 1,
    Name => $SLARand4."1",
    ValidID => 2,
    UserID => 1,
);

$Self->False(
    $SLAUpdate2,
    'SLAUpdate2()',
);

my $SLAUpdate3 = $Self->{SLAObject}->SLAUpdate(
    SLAID => $SLAID4,
    Name => $SLARand4."1",
    ValidID => 2,
    UserID => 1,
);

$Self->False(
    $SLAUpdate3,
    'SLAUpdate3()',
);

my $SLAUpdate4 = $Self->{SLAObject}->SLAUpdate(
    SLAID => $SLAID4,
    ServiceID => 1,
    ValidID => 2,
    UserID => 1,
);

$Self->False(
    $SLAUpdate4,
    'SLAUpdate4()',
);

my $SLAUpdate5 = $Self->{SLAObject}->SLAUpdate(
    SLAID => $SLAID4,
    ServiceID => 1,
    Name => $SLARand4."1",
    ValidID => 2,
    UserID => 1,
);

$Self->True(
    $SLAUpdate5,
    'SLAUpdate5()',
);

1;
