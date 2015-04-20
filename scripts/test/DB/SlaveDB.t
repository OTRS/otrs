# --
# SlaveDB.t - database version
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
# Only if a slave DB is configured it is possible to read with two prepared statements at the
#   same time.

SLAVEACTIVE:
for my $SlaveActive (0, 1) {

    $Kernel::OM->ObjectsDiscard();

    if ($SlaveActive) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::DSN',
            # add space character so that DSN strings seem to be different, otherwise slave is not used
            Value => $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN') . ' ',
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::User',
            Value => $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser'),
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::Password',
            Value => $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw'),
        );
    }
    else {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::DSN',
            Value => undef,
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::User',
            Value => undef,
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key => 'Core::MirrorDB::Password',
            Value => undef,
        );
    }

    {
        # Regular fetch from master
        my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
        my @ValidIDs;
        my $TestPrefix = "SlaveActive $SlaveActive UseSlaveDB 0: ";
        $DBObject->Prepare(
            SQL => "\nSELECT id\nFROM valid", # simulate indentation
        );
        while (my @Row = $DBObject->FetchrowArray()) {
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

        my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
        my @ValidIDs = ();
        my $TestPrefix = "SlaveActive $SlaveActive UseSlaveDB 1: ";

        $DBObject->Prepare(
            SQL => "\nSELECT id\nFROM valid", # simulate indentation
        );
        while (my @Row = $DBObject->FetchrowArray()) {
            push @ValidIDs, $Row[0];
        }
        $Self->True(
            scalar @ValidIDs,
            "$TestPrefix valid ids were found",
        );

        if (!$SlaveActive) {
            $Self->True(
                $DBObject->{Cursor},
                "$TestPrefix statement handle active on master",
            );
            $Self->False(
                $DBObject->{SlaveDBObject},
                "$TestPrefix SlaveDB not connected",
            );
            next SLAVEACTIVE;
        }

        $Self->False(
            $DBObject->{Cursor},
            "$TestPrefix statement handle inactive on master",
        );
        $Self->True(
            $DBObject->{SlaveDBObject}->{Cursor},
            "$TestPrefix statement handle active on slave",
        );

        $Self->True(
            $DBObject->{dbh}->ping(),
            "$TestPrefix master object is connected",
        );

        $Self->True(
            $DBObject->{SlaveDBObject}->{dbh}->ping(),
            "$TestPrefix slave object is connected",
        );

        $DBObject->Disconnect();

        $Self->False(
            $DBObject->{dbh}->ping(),
            "$TestPrefix master object is disconnected",
        );

        $Self->False(
            $DBObject->{SlaveDBObject}->{dbh}->ping(),
            "$TestPrefix slave object is disconnected",
        );

        $DBObject->Connect();

        $Self->True(
            $DBObject->{dbh}->ping(),
            "$TestPrefix master object is reconnected",
        );

        $Self->True(
            $DBObject->{SlaveDBObject}->{dbh}->ping(),
            "$TestPrefix slave object is reconnected",
        );
    }
}

1;
