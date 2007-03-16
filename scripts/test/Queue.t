# --
# Queue.t - Queue tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Queue.t,v 1.4 2007-03-16 09:59:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Queue;

$Self->{QueueObject} = Kernel::System::Queue->new(%{$Self});

my $QueueRand = 'Some::Queue'.int(rand(1000000));
my $QueueID = $Self->{QueueObject}->QueueAdd(
    Name => $QueueRand,
    ValidID => 1,
    GroupID => 1,
    FirstResponseTime => 30,
    UpdateTime => 240,
    SolutionTime => 2440,
    SystemAddressID => 1,
    SalutationID => 1,
    SignatureID => 1,
    UserID => 1,
    MoveNotify => 0,
    StateNotify => 0,
    LockNotify => 0,
    OwnerNotify => 0,
    Comment => 'Some Comment',
);

$Self->True(
    $QueueID,
    'QueueAdd()',
);

my %QueueGet = $Self->{QueueObject}->QueueGet(
    ID => $QueueID,
);

$Self->True(
    $QueueGet{Name} eq $QueueRand,
    'QueueGet() - Name',
);
$Self->True(
    $QueueGet{ValidID} eq 1,
    'QueueGet() - ValidID',
);
$Self->True(
    $QueueGet{Calendar} eq '',
    'QueueGet() - Calendar',
);
$Self->True(
    $QueueGet{Comment} eq 'Some Comment',
    'QueueGet() - Comment',
);
$Self->True(
    $QueueGet{FirstResponseTime} eq 30,
    'QueueGet() - FirstResponseTime',
);

$Self->True(
    $QueueGet{UpdateTime} eq 240,
    'QueueGet() - UpdateTime',
);

$Self->True(
    $QueueGet{SolutionTime} eq 2440,
    'QueueGet() - SolutionTime',
);

my $QueueUpdate = $Self->{QueueObject}->QueueUpdate(
    QueueID => $QueueID,
    Name => $QueueRand."1",
    ValidID => 2,
    GroupID => 1,
    Calendar => 1,
    FirstResponseTime => 60,
    UpdateTime => 480,
    SolutionTime => 4880,
    SystemAddressID => 1,
    SalutationID => 1,
    SignatureID => 1,
    FollowUpID => 1,
    UserID => 1,
    MoveNotify => 0,
    StateNotify => 0,
    LockNotify => 0,
    OwnerNotify => 0,
    Comment => 'Some Comment1',
);

$Self->True(
    $QueueUpdate,
    'QueueUpdate()',
);

%QueueGet = $Self->{QueueObject}->QueueGet(
    ID => $QueueID,
);

$Self->True(
    $QueueGet{Name} eq $QueueRand."1",
    'QueueGet() - Name',
);
$Self->True(
    $QueueGet{ValidID} eq 2,
    'QueueGet() - ValidID',
);
$Self->True(
    $QueueGet{Calendar} eq 1,
    'QueueGet() - Calendar',
);
$Self->True(
    $QueueGet{Comment} eq 'Some Comment1',
    'QueueGet() - Comment',
);

$Self->True(
    $QueueGet{FirstResponseTime} eq 60,
    'QueueGet() - FirstResponseTime',
);

$Self->True(
    $QueueGet{UpdateTime} eq 480,
    'QueueGet() - UpdateTime',
);

$Self->True(
    $QueueGet{SolutionTime} eq 4880,
    'QueueGet() - SolutionTime',
);

my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $QueueID);

$Self->True(
    $Queue eq $QueueRand."1",
    'QueueLookup() by ID',
);

my $QueueIDLookup = $Self->{QueueObject}->QueueLookup(Queue => $Queue);

$Self->True(
    $QueueID eq $QueueIDLookup,
    'QueueLookup() by Name',
);

1;
