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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $HelperObject          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommandObject         = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Log::CommunicationLog');
my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');

# Set Database to an initial clean state.
$CommunicationDBObject->CommunicationDelete();

my @Communications = (
    {
        Transport => 'Email',
        Direction => 'Incoming',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => '2017-02-07',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Failed',
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Failed',
        Date      => '2011-02-07',
    },
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

for my $TestCommunication (@Communications) {

    if ( $TestCommunication->{Date} ) {
        my $TestDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $TestCommunication->{Date}
            }
        );
        $HelperObject->FixedTimeSet($TestDateTimeObject);
    }

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $TestCommunication->{Transport},
            Direction => $TestCommunication->{Direction},
        }
    );

    if ( $TestCommunication->{Status} ) {
        $CommunicationLogObject->CommunicationStop( Status => $TestCommunication->{Status} );
    }

    $TestCommunication->{ID} = $CommunicationLogObject->CommunicationIDGet();

    $HelperObject->FixedTimeUnset();
}

my $RunTest = sub {
    my $Test = shift;
    my ( $ExitCode, $Result );

    if ( $Test->{Output} && $Test->{Output} eq 'STDOUT' ) {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }
    else {
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( @{ $Test->{Params} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExpectedExitCode},
        "$Test->{Name} Exit Code: $Test->{ExpectedExitCode}",
    );

    if ( $Test->{ExpectedResult} ) {
        if ( 'ARRAY' eq ref $Test->{ExpectedResult} ) {
            for my $ExpectedResult ( @{ $Test->{ExpectedResult} } ) {
                $Self->True(
                    index( $Result, $ExpectedResult ) > -1,
                    "$Test->{Name} expected result: '$ExpectedResult'",
                );
            }
        }
        else {
            $Self->True(
                index( $Result, $Test->{ExpectedResult} ) > -1,
                "$Test->{Name} expected result: '$Test->{ExpectedResult}'",
            );
        }
    }

    if ( $Test->{ExpectedDeleted} ) {
        my $ExpectedDeletedCommunications = $Test->{ExpectedDeleted};
        for my $CommunicationID ( @{$ExpectedDeletedCommunications} ) {
            my $CommunicationData = $CommunicationDBObject->CommunicationGet(
                CommunicationID => $CommunicationID,
            );

            $Self->False(
                scalar( %{$CommunicationData} ),
                "$Test->{Name} communication ${ CommunicationID } deleted!",
            );
        }
    }
};

my @Tests = (
    {
        Name             => 'No arguments given',
        ExpectedResult   => 'Either --purge, --delete-by-id',
        ExpectedExitCode => 1,
        Output           => 'STDERR',
        Params           => undef,
    },
    {
        Name             => 'Invalid combination 1',
        ExpectedResult   => 'Only one type of action allowed per execution',
        ExpectedExitCode => 1,
        Params           => [ '--delete-by-id', '123', '--delete-by-date', '2017-01-01' ],
    },
    {
        Name             => 'Can delete by id processing communication with force.',
        ExpectedDeleted  => [ $Communications[0]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-id', $Communications[0]->{ID}, '--force-delete' ],
    },
    {
        Name             => 'Can delete by date finished communication without force.',
        ExpectedDeleted  => [ $Communications[1]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-date', $Communications[1]->{Date} ],
    },
    {
        Name             => 'Purge.',
        ExpectedDeleted  => [ $Communications[3]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => ['--purge'],
    },
    {
        Name             => 'Delete NOT purged communication.',
        ExpectedDeleted  => [ $Communications[2]->{ID} ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => [ '--delete-by-id', $Communications[2]->{ID}, '--force-delete' ],
    },
);

for my $Test (@Tests) {
    $RunTest->($Test);
}

# test accurate purge hours

my $SuccessHours = $ConfigObject->Get('CommunicationLog::PurgeAfterHours::SuccessfulCommunications');
my $AllHours     = $ConfigObject->Get('CommunicationLog::PurgeAfterHours::AllCommunications');

my @CommunicationsToTestPurge = (
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => {
            Hours => ( $SuccessHours + 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Status    => 'Successful',
        Date      => {
            Hours => ( $SuccessHours - 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Date      => {
            Hours => ( $AllHours + 1 ),
        },
    },
    {
        Transport => 'Email',
        Direction => 'Outgoing',
        Date      => {
            Hours => ( $AllHours - 1 ),
        },
    },
);

for my $CommunicationToTestPurge (@CommunicationsToTestPurge) {
    my $TestDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $TestDateTimeObject->Subtract( Hours => $CommunicationToTestPurge->{Date}->{Hours} );

    $HelperObject->FixedTimeSet($TestDateTimeObject);

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $CommunicationToTestPurge->{Transport},
            Direction => $CommunicationToTestPurge->{Direction},
        },
    );

    if ( $CommunicationToTestPurge->{Status} ) {
        $CommunicationLogObject->CommunicationStop( Status => $CommunicationToTestPurge->{Status} );
    }
    $CommunicationToTestPurge->{ID} = $CommunicationLogObject->CommunicationIDGet();
    $HelperObject->FixedTimeUnset();

}

$RunTest->(
    {
        Name            => 'Purge.',
        ExpectedDeleted => [
            $CommunicationsToTestPurge[0]->{ID},
            $CommunicationsToTestPurge[2]->{ID},
        ],
        ExpectedExitCode => 0,
        Output           => 'STDOUT',
        Params           => ['--purge'],
    }
);

my $CommunicationsList = $CommunicationDBObject->CommunicationList();

for my $CommunicationListItem (@$CommunicationsList) {
    my ($Found) = grep {
        $_->{ID} == $CommunicationListItem->{CommunicationID}
        }
        ( $CommunicationsToTestPurge[1], $CommunicationsToTestPurge[3] );

    $Self->True(
        $Found,
        "Not to be deleted $CommunicationListItem->{CommunicationID} found.",
    );

}

# cleanup is done by RestoreDatabase

1;
