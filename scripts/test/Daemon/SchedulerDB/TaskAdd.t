# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

my $NumberOfTasks = 2_500;

my %TaskIDs;

COUNTER:
for my $Counter ( 1 .. $NumberOfTasks ) {
    my $TaskID = $SchedulerDBObject->TaskAdd(
        Type     => 'Unittest',
        Name     => 'TestTask1',
        Attempts => 2,
        Data     => {
            TestData => 12345,
        },
    );

    next COUNTER if !$TaskID;

    $TaskIDs{$TaskID} = 1;
}

$Self->Is(
    scalar keys %TaskIDs,
    $NumberOfTasks,
    "All tasks where created successfully",
);

1;
