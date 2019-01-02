# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CacheType = 'UnitTestRebuildConfig';

my $ChildCount = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::TicketCreateNumber::ChildCount') || 5;

for my $ChildIndex ( 1 .. $ChildCount ) {

    # Disconnect database before fork.
    $DBObject->Disconnect();

    # Create a fork of the current process
    #   parent gets the PID of the child
    #   child gets PID = 0
    my $PID = fork;
    if ( !$PID ) {

        # Destroy objects.
        $Kernel::OM->ObjectsDiscard();

        my $ExitCode = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild')->Execute();

        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $CacheType,
            Key   => "$ChildIndex",
            Value => {
                ExitCode => $ExitCode,
            },
            TTL => 60 * 10,
        );

        exit 0;
    }
}

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my %ChildData;

my $Wait = 1;
while ($Wait) {
    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        next CHILDINDEX if $ChildData{$ChildIndex};

        my $Cache = $CacheObject->Get(
            Type => $CacheType,
            Key  => "$ChildIndex",
        );

        next CHILDINDEX if !$Cache;
        next CHILDINDEX if ref $Cache ne 'HASH';

        $ChildData{$ChildIndex} = $Cache;
    }
}
continue {
    my $GotDataCount = scalar keys %ChildData;
    if ( $GotDataCount == $ChildCount ) {
        $Wait = 0;
    }
    sleep 1;
}

my %DeploymentIDs;

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

CHILDINDEX:
for my $ChildIndex ( 1 .. $ChildCount ) {

    my %Data = %{ $ChildData{$ChildIndex} };

    $Self->Is(
        $ChildData{$ChildIndex}->{ExitCode},
        0,
        "RebuildConfig from child $ChildIndex exit correctly",
    );
}
$CacheObject->CleanUp(
    Type => $CacheType,
);

1;
