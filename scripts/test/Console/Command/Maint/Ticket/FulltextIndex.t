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
