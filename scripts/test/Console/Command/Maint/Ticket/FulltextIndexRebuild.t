# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::FulltextIndexRebuild');

# tests for article search index modules
for my $Module (qw(StaticDB RuntimeDB)) {

    # Make sure that the ticket and article objects get recreated for each loop.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::Ticket',
            'Kernel::System::Ticket::Article',
        ],
    );

    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );

    my $ExitCode = $CommandObject->Execute();

    # just check exit code
    $Self->Is(
        $ExitCode,
        0,
        "Maint::Ticket::FulltextIndexRebuild exit code for backend $Module",
    );
}

# cleanup cache is done by RestoreDatabase

1;
