# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my %List;
if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') ) {
    %List = %{ $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') };
}
%List = ( %List, $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineRepositories() );

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::RepositoryList');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    %List ? 0 : 1,
    "Admin::Package::RepositoryList exit code without arguments",
);

# cleanup cache is done by RestoreDatabase

1;
