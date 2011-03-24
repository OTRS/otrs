# --
# ReplicateIncident.t - RequestSystemGuid Operation tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ReplicateIncident.t,v 1.1 2011-03-24 10:03:26 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

my @Tests = (
    {
        Name    => 'No data',
        Success => 0,
    },
    {
        Name    => 'Wrong data (arrayref)',
        Success => 0,
        Data    => [],
    },
);

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create object
my $OperationObject = Kernel::GenericInterface::Operation->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    OperationType  => 'SolMan::ReplicateIncident',
);

$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() success',
);

TEST:
for my $Test (@Tests) {
    my $Result = $OperationObject->Run(
        Data => $Test->{Data},
    );

    $Self->Is(
        $Result->{Success},
        $Test->{Success},
        "$Test->{Name} success status",
    );
}
1;
