# --
# SLA.t - SLA tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SLA.t,v 1.8 2008-05-10 09:37:14 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::User;

$Self->{ServiceObject} = Kernel::System::Service->new( %{$Self} );
$Self->{SLAObject}     = Kernel::System::SLA->new( %{$Self} );
$Self->{UserObject}    = Kernel::System::User->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create needed users
my @UserIDs;
{

    # disable email checks to create new user
    my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    for my $Counter ( 1 .. 2 ) {

        # create new users for the tests
        my $UserID = $Self->{UserObject}->UserAdd(
            UserFirstname => 'SLA' . $Counter,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-SLA-' . $Counter . int rand 1_000_000,
            UserEmail     => 'UnitTest-SLA-' . $Counter . '@localhost',
            ValidID       => 1,
            ChangeUserID  => 1,
        );

        push @UserIDs, $UserID;
    }

    # restore original email check param
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => $CheckEmailAddressesOrg,
    );
}

# create needed random service names
my @SLAName;
for my $Counter ( 1 .. 10 ) {
    push @SLAName, 'UnitTest' . int rand 1_000_000;
}

# create some test services
my @ServiceIDs;
for my $Counter ( 1 .. 3 ) {

    # add a service
    my $ServiceID = $Self->{ServiceObject}->ServiceAdd(
        Name    => 'UnitTest-SLA' . int rand 1_000_000,
        ValidID => 1,
        UserID  => 1,
    );

    push @ServiceIDs, $ServiceID;
}

# get original sla list for later checks
my %SLAListOriginal = $Self->{SLAObject}->SLAList(
    Valid  => 0,
    UserID => 1,
);

# ------------------------------------------------------------ #
# define general tests
# ------------------------------------------------------------ #

my $ItemData = [

    # this sla is NOT complete and must not be added
    {
        Add => {
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this sla is NOT complete and must not be added
    {
        Add => {
            Name   => $SLAName[0],
            UserID => 1,
        },
    },

    # this sla is NOT complete and must not be added
    {
        Add => {
            Name    => $SLAName[0],
            ValidID => 1,
        },
    },

    # service ids must be an array reference (check return false)
    {
        Add => {
            ServiceIDs => \do {'Dummy'},
            Name       => $SLAName[0],
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # service ids must be an array reference (check return false)
    {
        Add => {
            ServiceIDs => '',
            Name       => $SLAName[0],
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # service ids must be an array reference (check return false)
    {
        Add => {
            ServiceIDs => {},
            Name       => $SLAName[0],
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # this sla must be inserted sucessfully
    {
        Add => {
            Name    => $SLAName[0],
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ServiceIDs          => [ ],
            Name                => $SLAName[0],
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => '',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # this sla have the same name as one test before and must not be added
    {
        Add => {
            Name    => $SLAName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            ValidID   => 1,
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            Name      => $SLAName[0] . 'UPDATE1',
            UserID    => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla is NOT complete)
    {
        Update => {
            Name      => $SLAName[0] . 'UPDATE1',
            ValidID   => 1,
        },
    },

    # the sla one add-test before must be NOT updated (service ids must be an array reference)
    {
        Update => {
            ServiceIDs => \do {'Dummy'},
            Name       => $SLAName[0] . 'UPDATE1',
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # the sla one add-test before must be NOT updated (service ids must be an array reference)
    {
        Update => {
            ServiceIDs => '',
            Name       => $SLAName[0] . 'UPDATE1',
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # the sla one add-test before must be NOT updated (service ids must be an array reference)
    {
        Update => {
            ServiceIDs => {},
            Name       => $SLAName[0] . 'UPDATE1',
            ValidID    => 1,
            UserID     => 1,
        },
    },

    # this sla must be inserted sucessfully (check the returned service id array)
    {
        Add => {
            ServiceIDs => [ $ServiceIDs[0] ],
            Name       => $SLAName[1],
            ValidID    => 1,
            UserID     => 1,
        },
        AddGet => {
            ServiceIDs          => [ $ServiceIDs[0] ],
            Name                => $SLAName[1],
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => '',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # this sla must be inserted sucessfully (check the sorting of the returned service id array)
    {
        Add => {
            ServiceIDs => [ $ServiceIDs[1], $ServiceIDs[0] ],
            Name       => $SLAName[2],
            ValidID    => 1,
            UserID     => 1,
        },
        AddGet => {
            ServiceIDs          => [ $ServiceIDs[0], $ServiceIDs[1] ],
            Name                => $SLAName[2],
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => '',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # the same name already exists (check return false)
    {
        Update => {
            Name    => $SLAName[1],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this sla must be inserted sucessfully
    {
        Add => {
            ServiceIDs          => [ $ServiceIDs[1], $ServiceIDs[2], $ServiceIDs[0] ],
            Name                => $SLAName[3],
            Calendar            => '1',
            FirstResponseTime   => 10,
            FirstResponseNotify => 20,
            UpdateTime          => 30,
            UpdateNotify        => 40,
            SolutionTime        => 50,
            SolutionNotify      => 60,
            ValidID             => 1,
            Comment             => 'TestComment2',
            UserID              => 1,
        },
        AddGet => {
            ServiceIDs          => [ $ServiceIDs[0], $ServiceIDs[1], $ServiceIDs[2] ],
            Name                => $SLAName[3],
            Calendar            => '1',
            FirstResponseTime   => 10,
            FirstResponseNotify => 20,
            UpdateTime          => 30,
            UpdateNotify        => 40,
            SolutionTime        => 50,
            SolutionNotify      => 60,
            ValidID             => 1,
            Comment             => 'TestComment2',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            Name    => $SLAName[3] . 'UPDATE1',
            UserID  => 1,
        },
    },

    # the sla one add-test before must be NOT updated (sla update arguments NOT complete)
    {
        Update => {
            Name    => $SLAName[3] . 'UPDATE1',
            ValidID => 1,
        },
    },

    # the sla one add-test before must be updated (sla update arguments are complete)
    {
        Update => {
            ServiceIDs          => [ ],
            Name                => $SLAName[3] . 'UPDATE2',
            Calendar            => '1',
            FirstResponseTime   => 20,
            FirstResponseNotify => 30,
            UpdateTime          => 40,
            UpdateNotify        => 50,
            SolutionTime        => 60,
            SolutionNotify      => 70,
            ValidID             => 1,
            Comment             => 'TestComment2UPDATE2',
            UserID              => $UserIDs[0],
        },
        UpdateGet => {
            ServiceIDs          => [ ],
            Name                => $SLAName[3] . 'UPDATE2',
            Calendar            => '1',
            FirstResponseTime   => 20,
            FirstResponseNotify => 30,
            UpdateTime          => 40,
            UpdateNotify        => 50,
            SolutionTime        => 60,
            SolutionNotify      => 70,
            ValidID             => 1,
            Comment             => 'TestComment2UPDATE2',
            CreateBy            => 1,
            ChangeBy            => $UserIDs[0],
        },
    },

    # the sla one add-test before must be updated (sla update arguments are complete)
    {
        Update => {
            ServiceIDs          => [ $ServiceIDs[2] ],
            Name                => $SLAName[3] . 'UPDATE3',
            Calendar            => '2',
            FirstResponseTime   => 30,
            FirstResponseNotify => 40,
            UpdateTime          => 50,
            UpdateNotify        => 60,
            SolutionTime        => 70,
            SolutionNotify      => 80,
            ValidID             => 2,
            Comment             => 'TestComment2UPDATE3',
            UserID              => $UserIDs[1],
        },
        UpdateGet => {
            ServiceIDs          => [ $ServiceIDs[2] ],
            Name                => $SLAName[3] . 'UPDATE3',
            Calendar            => '2',
            FirstResponseTime   => 30,
            FirstResponseNotify => 40,
            UpdateTime          => 50,
            UpdateNotify        => 60,
            SolutionTime        => 70,
            SolutionNotify      => 80,
            ValidID             => 2,
            Comment             => 'TestComment2UPDATE3',
            CreateBy            => 1,
            ChangeBy            => $UserIDs[1],
        },
    },

    # this sla must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            ServiceIDs => [ $ServiceIDs[0] ],
            Name       => " \t \n \r " . $SLAName[4] . " \t \n \r ",
            ValidID    => 1,
            Comment    => " \t \n \r Test Comment \t \n \r ",
            UserID     => 1,
        },
        AddGet => {
            ServiceIDs          => [ $ServiceIDs[0] ],
            Name                => $SLAName[4],
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => 'Test Comment',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            ServiceIDs => [ $ServiceIDs[1] ],
            Name       => " \t \n \r " . $SLAName[4] . " UPDATE1 \t \n \r ",
            ValidID    => 2,
            Comment    => " \t \n \r Test Comment UPDATE1 \t \n \r ",
            UserID     => $UserIDs[1],
        },
        UpdateGet => {
            ServiceIDs          => [ $ServiceIDs[1] ],
            Name                => $SLAName[4] . ' UPDATE1',
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 2,
            Comment             => 'Test Comment UPDATE1',
            CreateBy            => 1,
            ChangeBy            => $UserIDs[1],
        },
    },

    # this sla must be inserted sucessfully (unicode checks)
    {
        Add => {
            Name       => $SLAName[5] . ' ϒ ϡ Ʃ Ϟ ',
            ValidID    => 1,
            Comment    => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID     => 1,
        },
        AddGet => {
            ServiceIDs          => [ ],
            Name                => $SLAName[5] . ' ϒ ϡ Ʃ Ϟ',
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            Name       => $SLAName[5] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID    => 2,
            Comment    => ' Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            UserID     => $UserIDs[0],
        },
        UpdateGet => {
            ServiceIDs          => [ ],
            Name                => $SLAName[5] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 2,
            Comment             => 'Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            CreateBy            => 1,
            ChangeBy            => $UserIDs[0],
        },
    },

    # this sla must be inserted sucessfully (special character checks)
    {
        Add => {
            ServiceIDs => [ ],
            Name       => ' [test]%*\\ ' . $SLAName[6] . ' [test]%*\\ ',
            ValidID    => 1,
            Comment    => ' [test]%*\\ Test Comment [test]%*\\ ',
            UserID     => 1,
        },
        AddGet => {
            ServiceIDs          => [ ],
            Name                => '[test]%*\\ ' . $SLAName[6] . ' [test]%*\\',
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 1,
            Comment             => '[test]%*\\ Test Comment [test]%*\\',
            CreateBy            => 1,
            ChangeBy            => 1,
        },
    },

    # the sla one add-test before must be updated sucessfully (special character checks)
    {
        Update => {
            ServiceIDs => [ ],
            Name       => ' [test]%*\\ ' . $SLAName[6] . ' UPDATE1 [test]%*\\ ',
            ValidID    => 2,
            Comment    => ' [test]%*\\ Test Comment UPDATE1 [test]%*\\ ',
            UserID     => $UserIDs[1],
        },
        UpdateGet => {
            ServiceIDs          => [ ],
            Name                => '[test]%*\\ ' . $SLAName[6] . ' UPDATE1 [test]%*\\',
            Calendar            => '',
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            ValidID             => 2,
            Comment             => '[test]%*\\ Test Comment UPDATE1 [test]%*\\',
            CreateBy            => 1,
            ChangeBy            => $UserIDs[1],
        },
    },
];

# ------------------------------------------------------------ #
# run general tests
# ------------------------------------------------------------ #

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

        # turn off all pretty print
        $Data::Dumper::Indent = 0;

        # check sla data after creation of the sla
        for my $SLAAttribute ( keys %{ $Item->{AddGet} } ) {

            # dump the given attribute
            if ( ref $SLAGet{$SLAAttribute} ) {
                $SLAGet{$SLAAttribute} = Data::Dumper::Dumper( $SLAGet{$SLAAttribute} );
            }

            # dump the reference string
            if ( ref $Item->{AddGet}->{$SLAAttribute} ) {
                $Item->{AddGet}->{$SLAAttribute} = Data::Dumper::Dumper(
                    $Item->{AddGet}->{$SLAAttribute},
                );
            }

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
        );

        # check sla data after update
        for my $SLAAttribute ( keys %{ $Item->{UpdateGet} } ) {

            # dump the given attribute
            if ( ref $SLAGet2{$SLAAttribute} ) {
                $SLAGet2{$SLAAttribute} = Data::Dumper::Dumper( $SLAGet2{$SLAAttribute} );
            }

            # dump the reference string
            if ( ref $Item->{UpdateGet}->{$SLAAttribute} ) {
                $Item->{UpdateGet}->{$SLAAttribute} = Data::Dumper::Dumper(
                    $Item->{UpdateGet}->{$SLAAttribute},
                );
            }

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

# ------------------------------------------------------------ #
# SLAList test 1 (check general functionality)
# ------------------------------------------------------------ #

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

1;
