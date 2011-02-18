# --
# DebugLog.t - DebugLog tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DebugLog.t,v 1.2 2011-02-18 08:59:08 mg Exp $
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
    Config  => {},
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
                Data => 'specific information',    # string or structure
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
                Data => 'specific information',    # string or structure
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
                Data => 'specific information',    # string or structure
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
                Data => 'specific information',    # string or structure
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
            DebugLevel        => 'info',
            Summary           => 'log Summary',
        },
        ArrayData => {
            Data1 => 'specific information',    # string or structure
            Data2 => 'specific information',    # string or structure
            Data3 => 'specific information',    # string or structure
        },
    },
);

my @DebugLogIDs;
KEY:
for my $Test (@Tests) {

    my $ErrorFlag = 1;
    for my $DataTest ( keys %{ $Test->{ArrayData} } ) {
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

    # remember id to delete it later
    push @DebugLogIDs, $Test->{Config}->{CommunicationID};

    # get record
    my $LogData = '';
    $LogData = $DebugLogObject->LogGet(
        CommunicationID => $Test->{Config}->{CommunicationID},
    );

    # verify new LogID
    $Self->True(
        $LogData->{LogID},
        "$Test->{Name} - LogGet() - LogID",
    );
    $Self->Is(
        $LogData->{CommunicationID},
        $Test->{Config}->{CommunicationID},
        "$Test->{Name} - LogGet() - CommunicationID",
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

    # test LogGetWithData
    $LogData = $DebugLogObject->LogGetWithData(
        CommunicationID => $Test->{Config}->{CommunicationID},
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

    # LogSearch
    $LogData = $DebugLogObject->LogSearch(
        CommunicationID => $Test->{Config}->{CommunicationID},
        WithData        => 0,                                    # optional
    );
    $Self->Is(
        ref $LogData,
        'ARRAY',
        "$Test->{Name} - LogSearch() - WithOutData",
    );

    $Self->Is(
        ref $LogData,
        'ARRAY',
        "$Test->{Name} - LogSearch() - WithOutData",
    );

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

# delete config
my $Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

1;
