# --
# TaskHandler.t - TaskHandler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TaskHandler.t,v 1.2 2011-02-17 12:21:36 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::Scheduler::TaskHandler;

my @Tests = (
    {
        Name               => 'Normal, success',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success => 1
        },
        Result => 1,
    },
    {
        Name               => 'Normal, fail',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success => 0
        },
        Result => undef,
    },
    {
        Name               => 'Nonexisting backend',
        TaskHandlerType    => 'TestNotExisting',
        ConstructorSuccess => 0,
        TaskData           => {
            Success => 1
        },
        Result => undef,
    },
    {
        Name               => 'Empty backend',
        TaskHandlerType    => '',
        ConstructorSuccess => 0,
        TaskData           => {
            Success => 1
        },
        Result => undef,
    },
);

for my $Test (@Tests) {

    my $Object = Kernel::Scheduler::TaskHandler->new(
        %{$Self},
        TaskHandlerType => $Test->{TaskHandlerType},
    );

    $Self->Is(
        $Object ? 1 : 0,
        $Test->{ConstructorSuccess},
        "$Test->{Name} - Kernel::Scheduler::TaskHandler->new()",
    );

    next if !$Object;

    my $Result = $Object->Run( Data => $Test->{TaskData} );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - Kernel::Scheduler::TaskHandler->Run() - false",
    );
}

1;
