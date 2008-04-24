# --
# PID.t - PID tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PID.t,v 1.3 2008-04-24 11:47:39 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::PID;

$Self->{PIDObject} = Kernel::System::PID->new(%{$Self});

my $PIDCreate = $Self->{PIDObject}->PIDCreate(
    Name => 'Test',
);

$Self->True(
    $PIDCreate,
    'PIDCreate()',
);

my $PIDCreate2 = $Self->{PIDObject}->PIDCreate(
    Name => 'Test',
);

$Self->True(
    (!$PIDCreate2),
    'PIDCreate2()',
);

my $PIDGet = $Self->{PIDObject}->PIDGet(
    Name => 'Test',
);

$Self->True(
    $PIDGet,
    'PIDGet()',
);

my $PIDDelete = $Self->{PIDObject}->PIDDelete(
    Name => 'Test',
);

$Self->True(
    $PIDDelete,
    'PIDDelete()',
);

1;
