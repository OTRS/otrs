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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::FulltextIndex');

for my $Argument (qw(--status --rebuild)) {

    my $ExitCode = $CommandObject->Execute($Argument);

    # Check the exit code.
    $Self->Is(
        $ExitCode,
        0,
        "Maint::Ticket::FulltextIndex exit code for argument $Argument",
    );
}

# Cleanup cache is done by RestoreDatabase

1;
