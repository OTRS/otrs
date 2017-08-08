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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
        Start     => 1,
    },
);

my $TestSet = sub {

    # Try to set lookup without passing any parameter.
    my $Result = $CommunicationLogObject->ObjectLookupSet();
    $Self->False(
        $Result,
        'Communication log lookup missing required params.'
    );

    # Test a successful create and update.
    for my $Idx ( 0 .. 1 ) {
        my $ComLogMessageID = $CommunicationLogObject->ObjectLogStart(
            ObjectType => 'Message',
        );

        # Create lookup information.
        my $Result = $CommunicationLogObject->ObjectLookupSet(
            ObjectID         => $ComLogMessageID,
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
    }

    # Delete all communication log data.
    $CommunicationLogObject->ObjectLogDelete();

    return;
};

my $TestSearch = sub {

    # Insert some communication log messages.
    my %ComLogLookupInfo = ();
    for my $Idx ( 1 .. 5 ) {
        my $MessageID = $CommunicationLogObject->ObjectLogStart(
            ObjectType => 'Message',
        );

        $ComLogLookupInfo{$Idx} = {
            ObjectID         => $MessageID,
            TargetObjectType => 'Test',
            TargetObjectID   => $Idx,
        };

        $CommunicationLogObject->ObjectLookupSet(
            %{ $ComLogLookupInfo{$Idx} },
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
                TargetObjectType => 'Test',
            },
            Expected => [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } values %ComLogLookupInfo ],
        },
        {
            Name     => 'Communication log lookup search by TargetObjectID',
            SearchBy => {
                TargetObjectID => $ComLogLookupInfo{2}->{TargetObjectID},
            },
            Expected => [ $ComLogLookupInfo{2} ],
        },
        {
            Name     => 'Communication log lookup search by ObjectType',
            SearchBy => {
                ObjectType => 'Message',
            },
            Expected => [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } values %ComLogLookupInfo ],
        },
        {
            Name     => 'Communication log lookup search by TargetObjectType and TargtObjectID',
            SearchBy => {
                TargetObjectType => $ComLogLookupInfo{3}->{TargetObjectType},
                TargetObjectID   => $ComLogLookupInfo{3}->{TargetObjectID},
            },
            Expected => [ $ComLogLookupInfo{3} ],
        },
    );

    for my $Test (@Tests) {
        my $List = $CommunicationLogObject->ObjectLookupSearch( %{ $Test->{SearchBy} } );
        $List = [ sort { $a->{TargetObjectID} <=> $b->{TargetObjectID} } @{$List} ];
        $Self->IsDeeply( $Test->{Expected}, $List, $Test->{Name}, );
    }

    # Delete all communication log data.
    $CommunicationLogObject->ObjectLogDelete();

    return;
};

my $TestGet = sub {

    # Insert some communication log messages.
    my %ComLogLookupInfo = ();
    for my $Idx ( 1 .. 2 ) {
        my $MessageID = $CommunicationLogObject->ObjectLogStart(
            ObjectType => 'Message',
        );

        $ComLogLookupInfo{$Idx} = {
            ObjectID         => $MessageID,
            TargetObjectType => 'Test',
            TargetObjectID   => $Idx,
        };

        $CommunicationLogObject->ObjectLookupSet(
            %{ $ComLogLookupInfo{$Idx} },
        );
    }

    # Try to get lookup without passing any parameter.
    my $Result = $CommunicationLogObject->ObjectLookupGet();
    $Self->False(
        $Result,
        'Communication log get lookup missing required params.'
    );

    my @Tests = (
        {
            Name     => 'Communication log lookup get by ObjectID and TargetObjectType ',
            SearchBy => {
                ObjectID         => $ComLogLookupInfo{1}->{ObjectID},
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
    $CommunicationLogObject->ObjectLogDelete();

    return;
};

# START THE TESTS

$TestSet->();
$TestSearch->();
$TestGet->();

# restore to the previous state is done by RestoreDatabase

1;
