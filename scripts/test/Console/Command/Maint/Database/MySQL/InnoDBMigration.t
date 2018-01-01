# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Database::MySQL::InnoDBMigration');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    ( $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type') eq 'mysql' ) ? 0 : 1,
    "Maint::Database::MySQL::InnoDBMigration exit code",
);

1;
