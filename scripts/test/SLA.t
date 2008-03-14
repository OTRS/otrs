# --
# SLA.t - SLA tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SLA.t,v 1.3.2.1 2008-03-14 13:59:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::User;

$Self->{ServiceObject} = Kernel::System::Service->new( %{$Self} );
$Self->{SLAObject}     = Kernel::System::SLA->new( %{$Self} );
$Self->{UserObject}    = Kernel::System::User->new( %{$Self} );

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create new users for the tests
my $UserID1 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'SLA1',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-SLA-1' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-SLA-1@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);
my $UserID2 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'SLA2',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-SLA-2' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-SLA-2@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# create on test service
my $ServiceID = $Self->{ServiceObject}->ServiceAdd(
    Name    => 'UnitTest-SLA' . int( rand(1_000_000) ),
    ValidID => 1,
    UserID  => 1,
);

# get original sla list for later checks
my %SLAListOriginal = $Self->{SLAObject}->SLAList(
    Valid  => 0,
    UserID => 1,
);

# create some random numbers for the sla name
my $SLARand1 = 'UnitTest' . int( rand(1_000_000) );
my $SLARand2 = 'UnitTest' . int( rand(1_000_000) );
my $SLARand3 = 'UnitTest' . int( rand(1_000_000) );
my $SLARand4 = 'UnitTest' . int( rand(1_000_000) );
my $SLARand5 = 'UnitTest' . int( rand(1_000_000) );

# define tests
my $ItemData = [

    # this sla is NOT complete and must not be added
    {
        Add => {
            Name    => $SLARand1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this sla is NOT complete and must not be added
    {
        Add => {
            ServiceID => $ServiceID,
            ValidID   => 1,
            UserID    => 1,
        },
    },

    # this sla is NOT complete and must not be added
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => $SLARand1,
            UserID    => 1,
        },
    },

    # this sla is NOT complete and must not be added
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => $SLARand1,
            ValidID   => 1,
        },
    },

    # this sla must be inserted sucessfully
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => $SLARand1,
            ValidID   => 1,
            UserID    => 1,
        },
        AddGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand1,
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 1,
            Comment           => '',
            CreateBy          => 1,
            ChangeBy          => 1,
        },
    },

    # this sla have the same name as one test before and must not be added
    {
        Add => {
            Name    => $SLARand1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            ValidID   => 1,
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => $SLARand1 . 'UPDATE1',
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => $SLARand1 . 'UPDATE1',
            ValidID   => 1,
        },
    },

    # this sla must be inserted sucessfully
    {
        Add => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2,
            Calendar          => '1',
            FirstResponseTime => 10,
            UpdateTime        => 20,
            SolutionTime      => 30,
            ValidID           => 1,
            Comment           => 'TestComment2',
            UserID            => 1,
        },
        AddGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2,
            Calendar          => '1',
            FirstResponseTime => 10,
            UpdateTime        => 20,
            SolutionTime      => 30,
            ValidID           => 1,
            Comment           => 'TestComment2',
            CreateBy          => 1,
            ChangeBy          => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            Name    => $SLARand2 . 'UPDATE1',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            ValidID   => 1,
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => $SLARand2 . 'UPDATE1',
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => $SLARand2 . 'UPDATE1',
            ValidID   => 1,
        },
    },

    # the sla one add-test before must be updated (sla update arguments are complete)
    {
        Update => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2 . 'UPDATE2',
            Calendar          => '1',
            FirstResponseTime => 20,
            UpdateTime        => 30,
            SolutionTime      => 40,
            ValidID           => 1,
            Comment           => 'TestComment2UPDATE2',
            UserID            => $UserID1,
        },
        UpdateGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2 . 'UPDATE2',
            Calendar          => '1',
            FirstResponseTime => 20,
            UpdateTime        => 30,
            SolutionTime      => 40,
            ValidID           => 1,
            Comment           => 'TestComment2UPDATE2',
            CreateBy          => 1,
            ChangeBy          => $UserID1,
        },
    },

    # the sla one add-test before must be updated (sla update arguments are complete)
    {
        Update => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2 . 'UPDATE3',
            Calendar          => '2',
            FirstResponseTime => 30,
            UpdateTime        => 40,
            SolutionTime      => 50,
            ValidID           => 2,
            Comment           => 'TestComment2UPDATE3',
            UserID            => $UserID2,
        },
        UpdateGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand2 . 'UPDATE3',
            Calendar          => '2',
            FirstResponseTime => 30,
            UpdateTime        => 40,
            SolutionTime      => 50,
            ValidID           => 2,
            Comment           => 'TestComment2UPDATE3',
            CreateBy          => 1,
            ChangeBy          => $UserID2,
        },
    },

    # this sla must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => " \t \n \r " . $SLARand3 . " \t \n \r ",
            ValidID   => 1,
            Comment   => " \t \n \r Test Comment \t \n \r ",
            UserID    => 1,
        },
        AddGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand3,
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 1,
            Comment           => 'Test Comment',
            CreateBy          => 1,
            ChangeBy          => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => " \t \n \r " . $SLARand3 . " UPDATE1 \t \n \r ",
            ValidID   => 2,
            Comment   => " \t \n \r Test Comment UPDATE1 \t \n \r ",
            UserID    => $UserID2,
        },
        UpdateGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand3 . ' UPDATE1',
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 2,
            Comment           => 'Test Comment UPDATE1',
            CreateBy          => 1,
            ChangeBy          => $UserID2,
        },
    },

    # this sla must be inserted sucessfully (unicode checks)
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => $SLARand4 . ' ϒ ϡ Ʃ Ϟ ',
            ValidID   => 1,
            Comment   => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID    => 1,
        },
        AddGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand4 . ' ϒ ϡ Ʃ Ϟ',
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 1,
            Comment           => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy          => 1,
            ChangeBy          => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => $SLARand4 . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID   => 2,
            Comment   => ' Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            UserID    => $UserID1,
        },
        UpdateGet => {
            ServiceID         => $ServiceID,
            Name              => $SLARand4 . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 2,
            Comment           => 'Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            CreateBy          => 1,
            ChangeBy          => $UserID1,
        },
    },

    # this sla must be inserted sucessfully (special character checks)
    {
        Add => {
            ServiceID => $ServiceID,
            Name      => ' [test]%*\\ ' . $SLARand5 . ' [test]%*\\ ',
            ValidID   => 1,
            Comment   => ' [test]%*\\ Test Comment [test]%*\\ ',
            UserID    => 1,
        },
        AddGet => {
            ServiceID         => $ServiceID,
            Name              => '[test]%*\\ ' . $SLARand5 . ' [test]%*\\',
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 1,
            Comment           => '[test]%*\\ Test Comment [test]%*\\',
            CreateBy          => 1,
            ChangeBy          => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (special character checks)
    {
        Update => {
            ServiceID => $ServiceID,
            Name      => ' [test]%*\\ ' . $SLARand5 . ' UPDATE1 [test]%*\\ ',
            ValidID   => 2,
            Comment   => ' [test]%*\\ Test Comment UPDATE1 [test]%*\\ ',
            UserID    => $UserID2,
        },
        UpdateGet => {
            ServiceID         => $ServiceID,
            Name              => '[test]%*\\ ' . $SLARand5 . ' UPDATE1 [test]%*\\',
            Calendar          => '',
            FirstResponseTime => 0,
            UpdateTime        => 0,
            SolutionTime      => 0,
            ValidID           => 2,
            Comment           => '[test]%*\\ Test Comment UPDATE1 [test]%*\\',
            CreateBy          => 1,
            ChangeBy          => $UserID2,
        },
    },
];

my $TestCount = 1;
my $LastAddedSLAID;
my $AddedCounter = 0;

for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # add new sla
        my $SLAID = $Self->{SLAObject}->SLAAdd(
            %{ $Item->{Add} },
        );

        # check if sla was added successfully or not
        if ( $Item->{AddGet} ) {

            $Self->True(
                $SLAID,
                "Test $TestCount: SLAAdd() - SLAID: $SLAID",
            );

            if ($SLAID) {

                # lookup sla name
                my $SLAName = $Self->{SLAObject}->SLALookup(
                    SLAID => $SLAID,
                );

                # lookup test
                $Self->Is(
                    $SLAName || '',
                    $Item->{AddGet}->{Name} || '',
                    "Test $TestCount: SLALookup() - lookup",
                );

                # reverse lookup the sla id
                my $SLAIDNew = $Self->{SLAObject}->SLALookup(
                    Name => $SLAName || '',
                );

                # reverse lookup test
                $Self->Is(
                    $SLAIDNew || '',
                    $SLAID    || '',
                    "Test $TestCount: SLALookup() - reverse lookup",
                );

                # set last sla id variable
                $LastAddedSLAID = $SLAID;

                # increment the added counter
                $AddedCounter++;
            }
        }
        else {
            $Self->False(
                $SLAID,
                "Test $TestCount: SLAAdd()",
            );
        }

        # get sla data to check the values after creation of the sla
        my %SLAGet = $Self->{SLAObject}->SLAGet(
            SLAID  => $SLAID,
            UserID => $Item->{Add}->{UserID},
            Cache  => 1,
        );

        # check sla data after creation of the sla
        for my $SLAAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $SLAGet{$SLAAttribute} || '',
                $Item->{AddGet}->{$SLAAttribute} || '',
                "Test $TestCount: SLAGet() - $SLAAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last sla id varaible
        if ( !$LastAddedSLAID ) {
            $Self->False(
                1,
                "Test $TestCount: NO LAST SERVICE ID GIVEN",
            );
        }

        # update the sla
        my $UpdateSucess = $Self->{SLAObject}->SLAUpdate(
            %{ $Item->{Update} },
            SLAID => $LastAddedSLAID,
        );

        # check if sla was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "Test $TestCount: SLAUpdate() - SLAID: $LastAddedSLAID",
            );
        }
        else {
            $Self->False(
                $UpdateSucess,
                "Test $TestCount: SLAUpdate()",
            );
        }

        # get sla data to check the values after the update
        my %SLAGet2 = $Self->{SLAObject}->SLAGet(
            SLAID  => $LastAddedSLAID,
            UserID => $Item->{Update}->{UserID},
            Cache  => 1,
        );

        # check sla data after update
        for my $SLAAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $SLAGet2{$SLAAttribute} || '',
                $Item->{UpdateGet}->{$SLAAttribute} || '',
                "Test $TestCount: SLAGet() - $SLAAttribute",
            );
        }

        # lookup sla name
        my $SLAName = $Self->{SLAObject}->SLALookup(
            SLAID => $SLAGet2{SLAID},
        );

        # lookup test
        $Self->Is(
            $SLAName || '',
            $SLAGet2{Name} || '',
            "Test $TestCount: SLALookup() - lookup",
        );

        # reverse lookup the sla id
        my $SLAIDNew = $Self->{SLAObject}->SLALookup(
            Name => $SLAName || '',
        );

        # reverse lookup test
        $Self->Is(
            $SLAIDNew || '',
            $SLAGet2{SLAID} || '',
            "Test $TestCount: SLALookup() - reverse lookup",
        );
    }

    $TestCount++;
}

# SLAList test 1 (check general functionality)
my %SLAList1 = $Self->{SLAObject}->SLAList(
    Valid  => 0,
    UserID => 1,
);
my %SLAList1Org = %SLAListOriginal;

SERVICEID:
for my $SLAID ( keys %SLAList1Org ) {

    if ( $SLAList1{$SLAID} && $SLAList1Org{$SLAID} eq $SLAList1{$SLAID} ) {
        delete $SLAList1{$SLAID};
    }
    else {
        $SLAList1{Dummy} = 1;
    }
}

my $SLAList1Count = scalar keys %SLAList1;

$Self->Is(
    $SLAList1Count || '',
    $AddedCounter  || '',
    "Test $TestCount: SLAList()",
);

# clean the sla table
$Self->{DBObject}->Do(
    SQL => "DELETE FROM sla WHERE name LIKE '%UnitTest%'",
);

# clean the service table
$Self->{DBObject}->Do(
    SQL => "DELETE FROM service WHERE name LIKE '%UnitTest%'",
);

# clean the system user table
my $UserTable = $Self->{ConfigObject}->Get('DatabaseUserTable') || 'system_user';

$Self->{DBObject}->Do(
    SQL => "DELETE FROM $UserTable WHERE login LIKE 'UnitTest-SLA-%'",
);

1;
