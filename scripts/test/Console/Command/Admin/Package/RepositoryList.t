# --
# Admin/Package/RepositoryList.t - command tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
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

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    %List ? 0 : 1,
    "Admin::Package::RepositoryList exit code without arguments",
);

1;
