# --
# PID.t - PID tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: PID.t,v 1.8 2010-10-29 22:16:59 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PID;

my $PIDObject = Kernel::System::PID->new( %{$Self} );

my $PIDCreate = $PIDObject->PIDCreate( Name => 'Test' );
$Self->True(
    $PIDCreate,
    'PIDCreate()',
);

my $PIDCreate2 = $PIDObject->PIDCreate( Name => 'Test' );
$Self->False(
    $PIDCreate2,
    'PIDCreate2()',
);

my $PIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->True(
    $PIDGet,
    'PIDGet()',
);

my $PIDCreateForce = $PIDObject->PIDCreate(
    Name  => 'Test',
    Force => 1,
);
$Self->True(
    $PIDCreateForce,
    'PIDCreate() - Force',
);

my $PIDDelete = $PIDObject->PIDDelete( Name => 'Test' );

$Self->True(
    $PIDDelete,
    'PIDDelete()',
);

1;
