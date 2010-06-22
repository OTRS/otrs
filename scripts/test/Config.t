# --
# Config.t - ConfigObject tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Config.t,v 1.2 2010-06-22 22:00:51 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));
use utf8;
use Kernel::Config;

my $ConfigObject = Kernel::Config->new();

my $Value = 'Testvalue';
$ConfigObject->Set( Key => 'ConfigTestkey', Value => $Value );
my $Get = $ConfigObject->Get('ConfigTestkey');

$Self->Is(
    $Get,
    $Value,
    'Set() and Get()',
);

my $Home = $ConfigObject->Get('Home');
$Self->True(
    $Home,
    'check for configuration setting "Home"',
);

my $ConfigChecksum  = $ConfigObject->ConfigChecksum();
my $ConfigChecksum2 = $ConfigObject->ConfigChecksum();
$Self->True(
    $ConfigChecksum,
    'ConfigChecksum()',
);
$Self->Is(
    $ConfigChecksum,
    $ConfigChecksum2,
    'ConfigChecksum()',
);

1;
