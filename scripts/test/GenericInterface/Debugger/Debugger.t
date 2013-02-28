# --
# Debugger.t - GenericInterface debugger tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config  => {},
    Name    => "$RandomID webservice",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# first test the debugger in general

my $DebuggerObject;

# a few tests to instanciate incorrectly
eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new();
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate no objects',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate with objects, no options',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            DebugThreshold => 'debug',
            TestMode       => 1,
        },
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate without WebserviceID',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        WebserviceID => $WebserviceID,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate without DebuggerConfig',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            TestMode => 1,
        },
        CommunicationType => 'Provider',
        WebserviceID      => $WebserviceID,
    );
};
$Self->True(
    ref $DebuggerObject,
    'DebuggerObject instanciate without DebugThreshold',
);

eval {
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            DebugThreshold => 'nonexistinglevel',
            TestMode       => 1,
        },
        CommunicationType => 'Provider',
        WebserviceID      => $WebserviceID,
    );
};
$Self->False(
    ref $DebuggerObject,
    'DebuggerObject instanciate with non existing DebugThreshold',
);

# correctly now
$DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'notice',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instanciate correctly',
);

my $Result;

# log without Summary
eval {
    $Result = $DebuggerObject->DebugLog() || 0;
};
$Self->False(
    $Result,
    'DebuggerObject call without summary',
);

# log with incorrect debug level
eval {
    $Result = $DebuggerObject->DebugLog(
        Summary    => 'an entry with incorrect debug level',
        DebugLevel => 'notexistingdebuglevel',
    ) || 0;
};
$Self->False(
    $Result,
    'DebuggerObject call with invalid debug level',
);

# log correctly
$Result = $DebuggerObject->DebugLog(
    Summary    => 'a correct entry',
    DebugLevel => 'debug',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject correct call',
);

# log with custom functions -debug level should be overwritten by function
$Result = $DebuggerObject->Error(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function error, debug level should be overwritten',
);
$Result = $DebuggerObject->Debug(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);
$Result = $DebuggerObject->Info(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);
$Result = $DebuggerObject->Notice(
    Summary    => 'a correct entry',
    DebugLevel => 'notexistingbutshouldnotbeused',
) || 0;
$Self->True(
    $Result,
    'DebuggerObject call to custom function debug',
);

# delete config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

# Extra tests for check values in DB
#debug|info|notice|error
my @Tests = (
    {
        Name              => 'Test 1',
        DebugThreshold    => 'debug',
        CommunicationType => 'Provider',
        SuccessDebug      => '1',
        SuccessInfo       => '1',
        SuccessNotice     => '1',
        SuccessError      => '1',
        Summary           => 'log Summary',
        Data              => 'specific information',
    },
    {
        Name              => 'Test 2',
        DebugThreshold    => 'info',
        CommunicationType => 'Provider',
        SuccessDebug      => '0',
        SuccessInfo       => '1',
        SuccessNotice     => '1',
        SuccessError      => '1',
        Summary           => 'log Summary',
        Data              => 'specific information',
    },
    {
        Name              => 'Test 3',
        DebugThreshold    => 'notice',
        CommunicationType => 'Provider',
        SuccessDebug      => '0',
        SuccessInfo       => '0',
        SuccessNotice     => '1',
        SuccessError      => '1',
        Summary           => 'log Summary',
        Data              => 'specific information',
    },
    {
        Name              => 'Test 4',
        DebugThreshold    => 'error',
        CommunicationType => 'Provider',
        SuccessDebug      => '0',
        SuccessInfo       => '0',
        SuccessNotice     => '0',
        SuccessError      => '1',
        Summary           => 'log Summary',
        Data              => 'specific information',
    },
);

#my @DebugLogIDs;
for my $Test (@Tests) {
    my $SuccessCounter = 0;

    # create a Webservice
    my $RandomID         = $HelperObject->GetRandomID();
    my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Config  => {},
        Name    => "$RandomID webservice",
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $WebserviceID,
        "WebserviceAdd()",
    );

    # debugger object
    $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig => {
            DebugThreshold => $Test->{DebugThreshold},
            TestMode       => 0,
        },
        WebserviceID      => $WebserviceID,
        CommunicationType => $Test->{CommunicationType},
    );

    for my $DebugLevel (qw( Debug Info Notice Error )) {
        $Result = $DebuggerObject->$DebugLevel(
            Summary => $Test->{Summary} . $DebugLevel,
            Data    => $Test->{Data} . $DebugLevel,
        ) || 0;
        $SuccessCounter++ if $Test->{"Success$DebugLevel"};
    }

    # test LogGetWithData
    my $LogData = $DebuggerObject->{DebugLogObject}->LogGetWithData(
        CommunicationID => $DebuggerObject->{CommunicationID},
    );
    $Self->Is(
        ref $LogData,
        'HASH',
        "$Test->{Name} - LogGetWithData()",
    );
    $Self->Is(
        ref $LogData->{Data},
        'ARRAY',
        "$Test->{Name} - LogGetWithData() - Data",
    );

    $Self->Is(
        $LogData->{CommunicationID},
        $DebuggerObject->{CommunicationID},
        "$Test->{Name} - LogGet() - CommunicationID",
    );
    $Self->Is(
        $LogData->{WebserviceID},
        $WebserviceID,
        "$Test->{Name} - LogGet() - WebserviceID",
    );
    $Self->Is(
        $LogData->{CommunicationType},
        $Test->{CommunicationType},
        "$Test->{Name} - LogGet() - CommunicationType",
    );

    my $Counter = 0;
    for my $DebugLevel (qw( Debug Info Notice Error )) {
        my $AuxData        = $Test->{Data} . $DebugLevel,
            my $AuxSummary = $Test->{Summary} . $DebugLevel;
        my $AuxDebugLevel = $DebugLevel;
        for my $DataFromDB ( @{ $LogData->{Data} } ) {
            if (
                $DataFromDB->{Data} eq $AuxData       &&
                $DataFromDB->{Summary} eq $AuxSummary &&
                $DataFromDB->{DebugLevel} eq lc $AuxDebugLevel
                )
            {
                $Counter++;
            }
        }
    }

    $Self->Is(
        scalar @{ $LogData->{Data} },
        $SuccessCounter,
        "$Test->{Name} - Expected entries compared with entries from DB.",
    );

    $Self->Is(
        scalar @{ $LogData->{Data} },
        $Counter,
        "$Test->{Name} - Compare entries from DB with expected data.",
    );

    # delete config
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "WebserviceDelete()",
    );

}

# end tests

1;
