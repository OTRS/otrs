# --
# SLA.t - SLA tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: SLA.t,v 1.1 2007-03-16 10:02:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::SLA;

$Self->{SLAObject} = Kernel::System::SLA->new(%{$Self});

my $SLARand = 'SomeSLA'.int(rand(1000000));
my $SLAID = $Self->{SLAObject}->SLAAdd(
    Name => $SLARand,
    ServiceID => 1,
    Calendar => '',
    FirstResponseTime => 30,
    UpdateTime => 240,
    SolutionTime => 2440,
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
$Self->True(
    $SLAGet{FirstResponseTime} eq 30,
    'SLAGet() - FirstResponseTime',
);

$Self->True(
    $SLAGet{UpdateTime} eq 240,
    'SLAGet() - EscalationUpdateTime',
);

$Self->True(
    $SLAGet{SolutionTime} eq 2440,
    'SLAGet() - SolutionTime',
);

my $SLAUpdate = $Self->{SLAObject}->SLAUpdate(
    SLAID => $SLAID,
    ServiceID => 1,
    Name => $SLARand."1",
    Calendar => 1,
    FirstResponseTime => 60,
    UpdateTime => 480,
    SolutionTime => 4880,
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

$Self->True(
    $SLAGet{Name} eq $SLARand."1",
    'SLAGet() - Name',
);
$Self->True(
    $SLAGet{ValidID} eq 2,
    'SLAGet() - ValidID',
);
$Self->True(
    $SLAGet{Calendar} eq 1,
    'SLAGet() - Calendar',
);
$Self->True(
    $SLAGet{Comment} eq 'Some Comment1',
    'SLAGet() - Comment',
);

$Self->True(
    $SLAGet{FirstResponseTime} eq 60,
    'SLAGet() - FirstResponseTime',
);

$Self->True(
    $SLAGet{UpdateTime} eq 480,
    'SLAGet() - UpdateTime',
);

$Self->True(
    $SLAGet{SolutionTime} eq 4880,
    'SLAGet() - SolutionTime',
);

my $SLA = $Self->{SLAObject}->SLALookup(SLAID => $SLAID);

$Self->True(
    $SLA eq $SLARand."1",
    'SLALookup() by ID',
);

my $SLAIDLookup = $Self->{SLAObject}->SLALookup(Name => $SLA);

$Self->True(
    $SLAID eq $SLAIDLookup,
    'SLALookup() by Name',
);

1;
