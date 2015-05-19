# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# This test checks the slave handling features in DB.pm

my $MasterDSN      = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');
my $MasterUser     = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
my $MasterPassword = $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');

my @Tests = (
    {
        Name   => "No slave configured",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        SlaveDBAvailable => 0,
        TestIterations   => 1,
    },
    {
        Name   => "First slave configured",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => $MasterUser,
            'Core::MirrorDB::Password'          => $MasterPassword,
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        SlaveDBAvailable => 1,
        TestIterations   => 1,
    },
    {
        Name   => "First slave configured as invalid",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => 'wrong_user',
            'Core::MirrorDB::Password'          => 'wrong_password',
            'Core::MirrorDB::AdditionalMirrors' => undef,
        },
        SlaveDBAvailable => 0,
        TestIterations   => 1,
    },
    {
        Name   => "Additional slave configured",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => $MasterUser,
                    Password => $MasterPassword,
                },
            },
        },
        SlaveDBAvailable => 1,
        TestIterations   => 1,
    },
    {
        Name   => "Additional slave configured as invalid",
        Config => {
            'Core::MirrorDB::DSN'               => undef,
            'Core::MirrorDB::User'              => undef,
            'Core::MirrorDB::Password'          => undef,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => 'wrong_user',
                    Password => 'wrong_password',
                },
            },
        },
        SlaveDBAvailable => 0,
        TestIterations   => 1,
    },
    {
        Name   => "Full config with valid first slave and invalid additional",
        Config => {
            'Core::MirrorDB::DSN'               => $MasterDSN,
            'Core::MirrorDB::User'              => $MasterUser,
            'Core::MirrorDB::Password'          => $MasterPassword,
            'Core::MirrorDB::AdditionalMirrors' => {
                1 => {
                    DSN      => $MasterDSN,
                    User     => 'wrong_user',
                    Password => 'wrong_password',
                },
                2 => {
                    DSN      => $MasterDSN,
                    User     => $MasterUser,
                    Password => $MasterPassword,
                },
            },
        },
        SlaveDBAvailable => 1,

        # Use many iterations so that also the invalid mirrir will be tried first at some point, probably.
        TestIterations => 10,
    },
);

TEST:
for my $Test (@Tests) {

    for my $TestIteration ( 1 .. $Test->{TestIterations} ) {

        $Kernel::OM->ObjectsDiscard();

        for my $ConfigKey ( sort keys %{ $Test->{Config} } ) {
            $Kernel::OM->Get('Kernel::Config')->Set(
                Key   => $ConfigKey,
                Value => $Test->{Config}->{$ConfigKey},
            );
        }

        {
            # Regular fetch from master
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my @ValidIDs;
            my $TestPrefix = "$Test->{Name} - $TestIteration - UseSlaveDB 0: ";
            $DBObject->Prepare(
                SQL => "\nSELECT id\nFROM valid",    # simulate indentation
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @ValidIDs, $Row[0];
            }
            $Self->True(
                scalar @ValidIDs,
                "$TestPrefix valid ids were found",
            );
            $Self->True(
                $DBObject->{Cursor},
                "$TestPrefix statement handle active on master",
            );
            $Self->False(
                $DBObject->{SlaveDBObject},
                "$TestPrefix SlaveDB not connected",
            );

            $Kernel::OM->ObjectsDiscard(
                Objects => ['Kernel::System::DB'],
            );
        }

        {
            local $Kernel::System::DB::UseSlaveDB = 1;

            my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
            my @ValidIDs   = ();
            my $TestPrefix = "$Test->{Name} - $TestIteration - UseSlaveDB 1: ";

            $DBObject->Prepare(
                SQL => "\nSELECT id\nFROM valid",    # simulate indentation
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @ValidIDs, $Row[0];
            }
            $Self->True(
                scalar @ValidIDs,
                "$TestPrefix valid ids were found",
            );

            if ( !$Test->{SlaveDBAvailable} ) {
                $Self->True(
                    $DBObject->{Cursor},
                    "$TestPrefix statement handle active on master",
                );
                $Self->False(
                    $DBObject->{SlaveDBObject},
                    "$TestPrefix SlaveDB not connected",
                );
                next TEST;
            }

            $Self->False(
                $DBObject->{Cursor},
                "$TestPrefix statement handle inactive on master",
            );
            $Self->True(
                $DBObject->{SlaveDBObject}->{Cursor},
                "$TestPrefix statement handle active on slave",
            );

            $Self->False(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is not connected automatically",
            );

            $Self->True(
                scalar $DBObject->{SlaveDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix slave object is connected",
            );

            $DBObject->Disconnect();

            $Self->False(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is disconnected",
            );

            $Self->False(
                scalar $DBObject->{SlaveDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix slave object is disconnected",
            );

            $DBObject->Connect();

            $Self->True(
                scalar $DBObject->Ping( AutoConnect => 0 ),
                "$TestPrefix master object is reconnected",
            );

            $Self->True(
                scalar $DBObject->{SlaveDBObject}->Ping( AutoConnect => 0 ),
                "$TestPrefix slave object is not reconnected automatically",
            );
        }
    }
}

1;
