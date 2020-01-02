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

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);

my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

my $TestSet = sub {

    # Try to set lookup without passing any parameter.
    my $Result = $CommunicationLogObject->ObjectLookupSet();
    $Self->False(
        $Result,
        'Communication log lookup missing required params.'
    );

    # Test a successful create and update.
    for my $Idx ( 0 .. 1 ) {
        $CommunicationLogObject->ObjectLogStart(
            ObjectLogType => 'Message',
        );

        # Create lookup information.
        my $Result = $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType    => 'Message',
            TargetObjectType => 'Test',
            TargetObjectID   => 1,
        );

        $Self->True(
            $Result,
            sprintf(
                'Communication log lookup successfully %s.',
                ( $Idx ? 'updated' : 'created' ),
            ),
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
    }

    # Delete all communication log data.
    $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );

    return;
};

my $TestSearch = sub {

    # Insert some communication log messages.
    my %ComLogLookupInfo = ();
    for my $Idx ( 1 .. 5 ) {
        my $MessageID = $CommunicationLogObject->ObjectLogStart(
            ObjectLogType => 'Message',
        );

        $ComLogLookupInfo{$Idx} = {
            ObjectLogID      => $MessageID,
            TargetObjectType => 'Test',
            TargetObjectID   => $Idx,
            CommunicationID  => $CommunicationLogObject->CommunicationIDGet(),
        };

        $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType => 'Message',
            %{ $ComLogLookupInfo{$Idx} },
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
    }

    my @Tests = (
        {
            Name     => 'Communication log lookup search by CommunicationID',
            SearchBy => {
                CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
            },
            Expected => [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } values %ComLogLookupInfo ],
        },
        {
            Name     => 'Communication log lookup search by TargetObjectType',
            SearchBy => {
                CommunicationID  => $CommunicationLogObject->CommunicationIDGet(),
                TargetObjectType => 'Test',
            },
            Expected => [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } values %ComLogLookupInfo ],
        },
        {
            Name     => 'Communication log lookup search by TargetObjectID',
            SearchBy => {
                CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
                TargetObjectID  => $ComLogLookupInfo{2}->{TargetObjectID},
            },
            Expected => [ $ComLogLookupInfo{2} ],
        },
        {
            Name     => 'Communication log lookup search by ObjectLogType',
            SearchBy => {
                CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
                ObjectLogType   => 'Message',
            },
            Expected => [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } values %ComLogLookupInfo ],
        },
        {
            Name     => 'Communication log lookup search by TargetObjectType and TargtObjectID',
            SearchBy => {
                CommunicationID  => $CommunicationLogObject->CommunicationIDGet(),
                TargetObjectType => $ComLogLookupInfo{3}->{TargetObjectType},
                TargetObjectID   => $ComLogLookupInfo{3}->{TargetObjectID},
            },
            Expected => [ $ComLogLookupInfo{3} ],
        },
    );

    for my $Test (@Tests) {
        my $List = $CommunicationLogDBObj->ObjectLookupSearch(
            %{ $Test->{SearchBy} },
        );
        $List = [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } @{$List} ];
        $Self->IsDeeply( $Test->{Expected}, $List, $Test->{Name}, );
    }

    # Delete all communication log data.
    $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );

    return;
};

my $TestGet = sub {

    # Insert some communication log messages.
    my %ComLogLookupInfo = ();
    for my $Idx ( 1 .. 2 ) {
        my $MessageID = $CommunicationLogObject->ObjectLogStart(
            ObjectLogType => 'Message',
        );

        $ComLogLookupInfo{$Idx} = {
            ObjectLogID      => $MessageID,
            TargetObjectType => 'Test',
            TargetObjectID   => $Idx,
            CommunicationID  => $CommunicationLogObject->CommunicationIDGet(),
        };

        $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType => 'Message',
            %{ $ComLogLookupInfo{$Idx} },
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
    }

    # Try to get lookup without passing any parameter.
    my $Result = $CommunicationLogDBObj->ObjectLookupGet();
    $Self->False(
        $Result,
        'Communication log get lookup missing required params.'
    );

    my @Tests = (
        {
            Name     => 'Communication log lookup get by ObjectLogID and TargetObjectType ',
            SearchBy => {
                ObjectLogID      => $ComLogLookupInfo{1}->{ObjectLogID},
                TargetObjectType => $ComLogLookupInfo{1}->{TargetObjectType},
            },
            Expected => $ComLogLookupInfo{1},
        },
        {
            Name     => 'Communication log lookup get by TargetObjectID and TargetObjectType ',
            SearchBy => {
                TargetObjectID   => $ComLogLookupInfo{2}->{TargetObjectID},
                TargetObjectType => $ComLogLookupInfo{2}->{TargetObjectType},
            },
            Expected => $ComLogLookupInfo{2},
        },
    );

    for my $Test (@Tests) {
        my $Result = $CommunicationLogObject->ObjectLookupGet( %{ $Test->{SearchBy} } );
        $Self->IsDeeply( $Test->{Expected}, $Result, $Test->{Name}, );
    }

    # Delete all communication log data.
    $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );

    return;
};

# START THE TESTS

$TestSet->();
$TestSearch->();
$TestGet->();

# restore to the previous state is done by RestoreDatabase

1;
