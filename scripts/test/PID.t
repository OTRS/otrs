# --
# PID.t - PID tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PID.t,v 1.6 2009-02-16 12:41:12 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::PID;

$Self->{PIDObject} = Kernel::System::PID->new( %{$Self} );

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
$Self->False(
    $PIDCreate2,
    'PIDCreate2()',
);

my $PIDGet = $Self->{PIDObject}->PIDGet(
    Name => 'Test',
);
$Self->True(
    $PIDGet,
    'PIDGet()',
);

my $PIDCreateForce = $Self->{PIDObject}->PIDCreate(
    Name  => 'Test',
    Force => 1,
);
$Self->True(
    $PIDCreateForce,
    'PIDCreate() - Force',
);

my $PIDDelete = $Self->{PIDObject}->PIDDelete(
    Name => 'Test',
);

$Self->True(
    $PIDDelete,
    'PIDDelete()',
);

1;
