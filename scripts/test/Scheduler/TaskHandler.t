# --
# TaskHandler.t - TaskHandler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TaskHandler.t,v 1.1 2011-02-14 15:38:09 martin Exp $
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
        Name    => 'test 1',
        Type    => 'Test',
        Success => 1,
        Input   => { Success => 1 },
        Result  => 1,
    },
    {
        Name    => 'test 2',
        Type    => 'TestNotExisting',
        Success => 0,
        Input   => { Success => 1 },
        Result  => 0,
    },
    {
        Name    => 'test 3',
        Type    => 'Test',
        Success => 1,
        Input   => { Success => 0 },
        Result  => 0,
    },
);

for my $Test (@Tests) {

    my $Object = Kernel::Scheduler::TaskHandler->new(
        %{$Self},
        Type => $Test->{Type},
    );

    if ( !$Object ) {
        if ( $Test->{Success} ) {
            $Self->True(
                0,
                "$Test->{Name} - Kernel::Scheduler::TaskHandler->new() - object not created",
            );
            next;
        }
        else {
            $Self->True(
                1,
                "$Test->{Name} - Kernel::Scheduler::TaskHandler->new() - object not created",
            );
            next;
        }
    }
    $Self->True(
        $Object,
        "$Test->{Name} - Kernel::Scheduler::TaskHandler->new()",
    );
    my $Success = $Object->Run( Data => $Test->{Input} );
    if ( !$Test->{Input}->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - Kernel::Scheduler::TaskHandler->Run() - false",
        );
    }
    $Self->True(
        $Success,
        "$Test->{Name} - Kernel::Scheduler::TaskHandler->Run() - true",
    );
}

1;
