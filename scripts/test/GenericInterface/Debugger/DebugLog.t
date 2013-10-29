# --
# DebugLog.t - DebugLog tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::GenericInterface::DebugLog;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
            TestMode       => 1,
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    Name    => "$RandomID webservice",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# provide no objects

my $DebugLogObject;

# with just objects
$DebugLogObject = Kernel::System::GenericInterface::DebugLog->new( %{$Self} );
$Self->Is(
    ref $DebugLogObject,
    'Kernel::System::GenericInterface::DebugLog',
    'DebugLog::new() constructor failure, just objects.',
);

my @Tests = (

    {
        Name   => 'Without WebserviceID',
        Config => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Provider',       # 'Provider' or 'Requester'
            RemoteIP          => '192.168.0.1',    # optional
            DebugLevel        => 'info',
            Summary           => 'log Summary',
        },
        ArrayData => {
            {
                Data => 'specific information',
            },
        },
        SuccessAdd => 0,
    },
    {
        Name   => 'Without CommunicationID',
        Config => {
            WebserviceID      => $WebserviceID,
            CommunicationType => 'Provider',       # 'Provider' or 'Requester'
            RemoteIP          => '192.168.0.1',    # optional
            DebugLevel        => 'info',
            Summary           => 'log Summary',
        },
        ArrayData => {
            {
                Data => 'specific information',
            },
        },
        SuccessAdd => 0,
    },
    {
        Name   => 'Without CommunicationType',
        Config => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            WebserviceID => $WebserviceID,
            RemoteIP     => '192.168.0.1',
            DebugLevel   => 'info',
            Summary      => 'log Summary',
        },
        ArrayData => {
            {
                Data => 'specific information',
            },
        },
        SuccessAdd => 0,
    },
    {
        Name   => 'Without RemoteIP',
        Config => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            WebserviceID      => $WebserviceID,
            CommunicationType => 'Provider',
            DebugLevel        => 'info',
            Summary           => 'log Summary',
        },
        ArrayData => {
            {
                Data => 'specific information',
            },
        },
        SuccessAdd => 1,
    },
    {
        Name       => 'With empty data',
        SuccessAdd => '1',
        Config     => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Provider',
            RemoteIP          => '192.168.0.1',
            WebserviceID      => $WebserviceID,
            DebugLevel        => 'info',
            Summary           => 'log Summary',
        },
        ArrayData => {
            Data => '',
        },
    },
    {
        Name       => 'Complete params',
        SuccessAdd => '1',
        Config     => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Provider',
            RemoteIP          => '192.168.0.1',
            WebserviceID      => $WebserviceID,
            DebugLevel        => 'debug',
            Summary           => 'log Summary for DebugLevel - debug',
        },
        ArrayData => {
            Data1 => 'something to write here',
            Data2 => 'a nice data structure',
            Data3 => 'specific information',
        },
    },
    {
        Name       => 'Complete params',
        SuccessAdd => '1',
        Config     => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Provider',
            RemoteIP          => '',
            WebserviceID      => $WebserviceID,
            DebugLevel        => 'info',
            Summary           => 'log Summary for DebugLevel - info',
        },
        ArrayData => {
            Value1 => 'this shoud be a string',
            Value2 => 'later I will check this string',
        },
    },
    {
        Name       => 'Complete params',
        SuccessAdd => '1',
        Config     => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Requester',
            RemoteIP          => '192.168.0.1',
            WebserviceID      => $WebserviceID,
            DebugLevel        => 'notice',
            Summary           => 'log Summary for DebugLevel - notice',
        },
        ArrayData => {
            Data1 => 'nothing special here',
            Data3 => 'now is a requester',
        },
    },
    {
        Name       => 'Complete params',
        SuccessAdd => '1',
        Config     => {
            CommunicationID => $Self->{MainObject}->MD5sum(
                String => $Self->{TimeObject}->SystemTime() . int( rand(1000000) ),
            ),
            CommunicationType => 'Requester',
            RemoteIP          => '',
            WebserviceID      => $WebserviceID,
            DebugLevel        => 'error',
            Summary           => 'log Summary for DebugLevel - error',
        },
        ArrayData => {
            Entrie1 => 'something to write here',
            Entrie2 => '',
            Entrie3 => 'a new entrie',
            Entrie4 => 'more words for test',
            Entrie5 => 'maybe in another time',
            Entrie6 => 'sunny day',
            Entrie7 => 'last comment',
        },
    },
);

my @DebugLogIDs;
KEY:
for my $Test (@Tests) {

    my $ErrorFlag = 1;
    for my $DataTest ( sort keys %{ $Test->{ArrayData} } ) {
        my $DebugLogResult = $DebugLogObject->LogAdd(
            %{ $Test->{Config} },
            Data => $Test->{ArrayData}->{$DataTest},
        );
        if ( !$Test->{SuccessAdd} ) {
            $Self->False(
                $DebugLogResult,
                "$Test->{Name} - LogAdd()",
            );
        }
        else {
            $Self->True(
                $DebugLogResult,
                "$Test->{Name} - LogAdd()",
            );
        }
        next KEY if !$DebugLogResult;
        $ErrorFlag = 0;
    }
    next if $ErrorFlag;

    my $DebugLogIDsCommunicationID = $Test->{Config}->{CommunicationID};

    # remember id to delete it later
    push @DebugLogIDs, $DebugLogIDsCommunicationID;

    # get record
    my $LogData = '';
    $LogData = $DebugLogObject->LogGet(
        CommunicationID => $DebugLogIDsCommunicationID,
    );

    $Self->Is(
        ref $LogData,
        'HASH',
        "$Test->{Name} - LogGetWithData()",
    );

    $Self->IsNot(
        ref $LogData->{Data},
        'ARRAY',
        "$Test->{Name} - LogGetWithData() - Data",
    );

    # verify LogID
    $Self->True(
        $LogData->{LogID},
        "$Test->{Name} - LogGet() - LogID",
    );
    $Self->Is(
        $LogData->{CommunicationID},
        $DebugLogIDsCommunicationID,
        "$Test->{Name} - LogGet() - CommunicationID",
    );

    $Self->Is(
        $LogData->{WebserviceID},
        $WebserviceID,
        "$Test->{Name} - LogGet() - WebserviceID",
    );
    $Self->Is(
        $LogData->{CommunicationType},
        $Test->{Config}->{CommunicationType},
        "$Test->{Name} - LogGet() - CommunicationType",
    );

    my $DebugLogID = $LogData->{LogID};

    # test LogGetWithData
    $LogData = $DebugLogObject->LogGetWithData(
        CommunicationID => $DebugLogIDsCommunicationID,
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

    # verify LogID
    $Self->Is(
        $LogData->{LogID},
        $DebugLogID,
        "$Test->{Name} - LogGet() - LogID",
    );
    $Self->Is(
        $LogData->{CommunicationID},
        $DebugLogIDsCommunicationID,
        "$Test->{Name} - LogGet() - CommunicationID",
    );
    $Self->Is(
        $LogData->{WebserviceID},
        $WebserviceID,
        "$Test->{Name} - LogGet() - WebserviceID",
    );
    $Self->Is(
        $LogData->{CommunicationType},
        $Test->{Config}->{CommunicationType},
        "$Test->{Name} - LogGet() - CommunicationType",
    );

    my $Counter = 0;
    for my $DataTest ( sort keys %{ $Test->{ArrayData} } ) {
        my $AuxData       = $Test->{ArrayData}->{$DataTest};
        my $AuxSummary    = $Test->{Config}->{Summary};
        my $AuxDebugLevel = $Test->{Config}->{DebugLevel};
        for my $DataFromDB ( @{ $LogData->{Data} } ) {
            if (
                $DataFromDB->{Data}       eq $AuxData &&
                $DataFromDB->{Summary}    eq $AuxSummary &&
                $DataFromDB->{DebugLevel} eq $AuxDebugLevel
                )
            {

                $Counter++;
            }
        }
    }

    $Self->Is(
        scalar @{ $LogData->{Data} },
        $Counter,
        "$Test->{Name} - LogGet() - Compare Results",
    );

    # LogSearch
    $LogData = $DebugLogObject->LogSearch(
        CommunicationID => $DebugLogIDsCommunicationID,
        WithData        => 0,                             # optional
    );
    $Self->Is(
        ref $LogData,
        'ARRAY',
        "$Test->{Name} - LogSearch() - WithOutData",
    );

    for my $DataFromSearch ( @{$LogData} ) {

        # verify LogID
        $Self->Is(
            $DataFromSearch->{LogID},
            $DebugLogID,
            "$Test->{Name} - LogSearch() - LogID",
        );
        $Self->Is(
            $DataFromSearch->{CommunicationID},
            $DebugLogIDsCommunicationID,
            "$Test->{Name} - LogSearch() - CommunicationID",
        );
        $Self->Is(
            $DataFromSearch->{WebserviceID},
            $WebserviceID,
            "$Test->{Name} - LogSearch() - WebserviceID",
        );
        $Self->Is(
            $DataFromSearch->{CommunicationType},
            $Test->{Config}->{CommunicationType},
            "$Test->{Name} - LogSearch() - CommunicationType",
        );

    }

    # with data
    $LogData = $DebugLogObject->LogSearch(
        CommunicationID => $DebugLogIDsCommunicationID,
        WithData        => 1,                             # optional
    );
    $Self->Is(
        ref $LogData,
        'ARRAY',
        "$Test->{Name} - LogSearch() - WithData",
    );

    for my $DataFromSearch ( @{$LogData} ) {

        # verify LogID
        $Self->Is(
            $DataFromSearch->{LogID},
            $DebugLogID,
            "$Test->{Name} - LogSearch() - LogID",
        );
        $Self->Is(
            $DataFromSearch->{CommunicationID},
            $DebugLogIDsCommunicationID,
            "$Test->{Name} - LogSearch() - CommunicationID",
        );
        $Self->Is(
            $DataFromSearch->{WebserviceID},
            $WebserviceID,
            "$Test->{Name} - LogSearch() - WebserviceID",
        );
        $Self->Is(
            $DataFromSearch->{CommunicationType},
            $Test->{Config}->{CommunicationType},
            "$Test->{Name} - LogSearch() - CommunicationType",
        );

        $Counter = 0;
        for my $DataTest ( sort keys %{ $Test->{ArrayData} } ) {
            my $AuxData       = $Test->{ArrayData}->{$DataTest};
            my $AuxSummary    = $Test->{Config}->{Summary};
            my $AuxDebugLevel = $Test->{Config}->{DebugLevel};
            for my $DataFromDB ( @{ $DataFromSearch->{Data} } ) {
                if (
                    $DataFromDB->{Data}       eq $AuxData &&
                    $DataFromDB->{Summary}    eq $AuxSummary &&
                    $DataFromDB->{DebugLevel} eq $AuxDebugLevel
                    )
                {

                    $Counter++;
                }
            }
        }

        $Self->Is(
            scalar @{ $DataFromSearch->{Data} },
            $Counter,
            "$Test->{Name} - LogSearch() - Compare Results",
        );
    }

}

# end tests

# delete config
for my $DebugLogID (@DebugLogIDs) {
    my $LogData = $DebugLogObject->LogSearch(
        CommunicationID => $DebugLogID,
        WithData        => 0,             # optional
    );

    my $Success = $DebugLogObject->LogDelete(
        CommunicationID => $DebugLogID,
    );
    $Self->True(
        $Success,
        "LogDelete() deleted Log $DebugLogID",
    );

    $Success = $DebugLogObject->LogDelete(
        CommunicationID => $DebugLogID,
    );
    $Self->False(
        $Success,
        "LogDelete() deleted Log confirmation $DebugLogID",
    );
}

# delete webservice
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

1;
