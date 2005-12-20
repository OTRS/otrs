# --
# Queue.t - Queue tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Queue.t,v 1.1 2005-12-20 22:53:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Queue;

$Self->{QueueObject} = Kernel::System::Queue->new(%{$Self});

my $QueueRand = 'Some::Queue'.int(rand(1000000));
my $QueueID = $Self->{QueueObject}->QueueAdd(
    Name            => $QueueRand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    MoveNotify      => 0,
    StateNotify     => 0,
    LockNotify      => 0,
    OwnerNotify     => 0,
);

$Self->True(
    $QueueID,
    'QueueAdd()',
);

my $QueueUpdate = $Self->{QueueObject}->QueueUpdate(
    QueueID         => $QueueID,
    Name            => $QueueRand."1",
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    MoveNotify      => 0,
    StateNotify     => 0,
    LockNotify      => 0,
    OwnerNotify     => 0,
);

$Self->True(
    $QueueUpdate,
    'QueueUpdate()',
);

my %QueueGet = $Self->{QueueObject}->QueueGet(
    ID => $QueueID,
);

$Self->True(
    $QueueGet{Name} eq $QueueRand."1",
    'QueueGet()',
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
