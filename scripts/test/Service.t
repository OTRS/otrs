# --
# Service.t - Service tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Service.t,v 1.8 2008-05-15 07:29:42 mh Exp $
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
use Kernel::System::User;

$Self->{ServiceObject} = Kernel::System::Service->new( %{$Self} );
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
            UserFirstname => 'Service' . $Counter,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-Service-' . $Counter . int rand 1_000_000,
            UserEmail     => 'UnitTest-Service-' . $Counter . '@localhost',
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
my @ServiceName;
for my $Counter ( 1 .. 11 ) {
    push @ServiceName, 'UnitTest' . int rand 1_000_000;
}

# get original service list for later checks
my %ServiceListOriginal = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);

# ------------------------------------------------------------ #
# define general tests
# ------------------------------------------------------------ #

my $ItemData = [

    # this service is NOT complete and must not be added
    {
        Add => {
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service is NOT complete and must not be added
    {
        Add => {
            Name   => $ServiceName[0],
            UserID => 1,
        },
    },

    # this service is NOT complete and must not be added
    {
        Add => {
            Name    => $ServiceName[0],
            ValidID => 1,
        },
    },

    # this service must be inserted sucessfully
    {
        Add => {
            Name    => $ServiceName[0],
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceName[0],
            NameShort => $ServiceName[0],
            ValidID   => 1,
            Comment   => '',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service have the same name as one test before and must not be added
    {
        Add => {
            Name    => $ServiceName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the service one add-test before must be NOT updated (service is NOT complete)
    {
        Update => {
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the service one add-test before must be NOT updated (service is NOT complete)
    {
        Update => {
            Name   => $ServiceName[0] . 'UPDATE1',
            UserID => 1,
        },
    },

    # the service one add-test before must be NOT updated (service is NOT complete)
    {
        Update => {
            Name    => $ServiceName[0] . 'UPDATE1',
            ValidID => 1,
        },
    },

    # this service must be inserted sucessfully
    {
        Add => {
            Name    => $ServiceName[1],
            ValidID => 1,
            Comment => 'TestComment2',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceName[1],
            NameShort => $ServiceName[1],
            ValidID   => 1,
            Comment   => 'TestComment2',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be NOT updated (service update arguments NOT complete)
    {
        Update => {
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the service one add-test before must be NOT updated (service update arguments NOT complete)
    {
        Update => {
            Name   => $ServiceName[1] . 'UPDATE2',
            UserID => 1,
        },
    },

    # the service one add-test before must be NOT updated (service update arguments NOT complete)
    {
        Update => {
            Name    => $ServiceName[1] . 'UPDATE2',
            ValidID => 1,
        },
    },

    # the service one add-test before must be updated (service update arguments are complete)
    {
        Update => {
            Name    => $ServiceName[1] . 'UPDATE2',
            ValidID => 2,
            Comment => 'TestComment2UPDATE2',
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceName[1] . 'UPDATE2',
            NameShort => $ServiceName[1] . 'UPDATE2',
            ValidID   => 2,
            Comment   => 'TestComment2UPDATE2',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[0],
        },
    },

    # the service one add-test before must be updated (service update arguments are complete)
    {
        Update => {
            Name    => $ServiceName[1] . 'UPDATE3',
            ValidID => 1,
            Comment => 'TestComment2UPDATE3',
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceName[1] . 'UPDATE3',
            NameShort => $ServiceName[1] . 'UPDATE3',
            ValidID   => 1,
            Comment   => 'TestComment2UPDATE3',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $ServiceName[1] . '::UPDATE4',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $ServiceName[1] . '::Test::UPDATE4',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $ServiceName[2] . '::Test',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => '::Test' . $ServiceName[2],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $ServiceName[2] . '::Test::Test',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $ServiceName[2] . 'Test::',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Name    => " \t \n \r " . $ServiceName[3] . " \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceName[3],
            NameShort => $ServiceName[3],
            ValidID   => 1,
            Comment   => 'Test Comment',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $ServiceName[3] . " UPDATE1 \t \n \r ",
            ValidID => 2,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceName[3] . ' UPDATE1',
            NameShort => $ServiceName[3] . ' UPDATE1',
            ValidID   => 2,
            Comment   => 'Test Comment',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this service must be inserted sucessfully (unicode checks)
    {
        Add => {
            Name    => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ ',
            ValidID => 1,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ',
            NameShort => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ',
            ValidID   => 1,
            Comment   => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            Name    => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID => 2,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            NameShort => $ServiceName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID   => 2,
            Comment   => 'Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[0],
        },
    },

    # this service must be inserted sucessfully (special character checks)
    {
        Add => {
            Name    => ' [test]%*\\ ' . $ServiceName[8] . ' [test]%*\\ ',
            ValidID => 1,
            Comment => ' [test]%*\\ Test Comment [test]%*\\ ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $ServiceName[8] . ' [test]%*\\',
            NameShort => '[test]%*\\ ' . $ServiceName[8] . ' [test]%*\\',
            ValidID   => 1,
            Comment   => '[test]%*\\ Test Comment [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (special character checks)
    {
        Update => {
            Name    => ' [test]%*\\ ' . $ServiceName[8] . ' UPDATE1 [test]%*\\ ',
            ValidID => 2,
            Comment => ' [test]%*\\ Test Comment UPDATE1 [test]%*\\ ',
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $ServiceName[8] . ' UPDATE1 [test]%*\\',
            NameShort => '[test]%*\\ ' . $ServiceName[8] . ' UPDATE1 [test]%*\\',
            ValidID   => 2,
            Comment   => '[test]%*\\ Test Comment UPDATE1 [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this service must be inserted sucessfully (used for the following tests)
    {
        Add => {
            Name    => $ServiceName[5],
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceName[5],
            NameShort => $ServiceName[5],
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be inserted sucessfully (parent service check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => $ServiceName[6],
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $ServiceName[5] . '::' . $ServiceName[6],
            NameShort => $ServiceName[6],
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be inserted sucessfully (parent service check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => " \n \t " . $ServiceName[7] . " \n \t ",
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $ServiceName[5] . '::' . $ServiceName[6] . '::' . $ServiceName[7],
            NameShort => $ServiceName[7],
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service must be NOT updated (parent service id and parent id are identical)
    {
        Update => {
            ParentID => 'LASTADDID',
            Name     => $ServiceName[7] . 'UPDATE1',
            ValidID  => 1,
            UserID   => 1,
        },
    },

    # this service must be updated sucessfully (move service to the higherst level)
    {
        Update => {
            ParentID => '',
            Name     => $ServiceName[7] . ' UPDATE1',
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceName[7] . ' UPDATE1',
            NameShort => $ServiceName[7] . ' UPDATE1',
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be updated sucessfully (move service back with the old parent service)
    {
        Update => {
            ParentID => 'LASTLASTADDID',
            Name     => $ServiceName[7] . ' UPDATE(2)',
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID => 'LASTLASTADDID',
            Name => $ServiceName[5] . '::' . $ServiceName[6] . '::' . $ServiceName[7] . ' UPDATE(2)',
            NameShort => $ServiceName[7] . ' UPDATE(2)',
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },
];

# ------------------------------------------------------------ #
# run general tests
# ------------------------------------------------------------ #

my $TestCount = 1;
my $LastAddedServiceID;
my $LastLastAddedServiceID;
my $AddedCounter = 0;

for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # prepare parent id
        if ( $Item->{Add}->{ParentID} && $Item->{Add}->{ParentID} eq 'LASTADDID' ) {
            $Item->{Add}->{ParentID} = $LastAddedServiceID;
        }
        elsif ( $Item->{Add}->{ParentID} && $Item->{Add}->{ParentID} eq 'LASTLASTADDID' ) {
            $Item->{Add}->{ParentID} = $LastLastAddedServiceID;
        }
        else {
            delete $Item->{Add}->{ParentID};
        }

        # add new service
        my $ServiceID = $Self->{ServiceObject}->ServiceAdd(
            %{ $Item->{Add} },
        );

        # check if service was added successfully or not
        if ( $Item->{AddGet} ) {

            # prepare parent id
            if ( $Item->{AddGet}->{ParentID} && $Item->{AddGet}->{ParentID} eq 'LASTADDID' ) {
                $Item->{AddGet}->{ParentID} = $LastAddedServiceID;
            }
            elsif ( $Item->{AddGet}->{ParentID} && $Item->{AddGet}->{ParentID} eq 'LASTLASTADDID' )
            {
                $Item->{AddGet}->{ParentID} = $LastLastAddedServiceID;
            }

            $Self->True(
                $ServiceID,
                "Test $TestCount: ServiceAdd() - ServiceID: $ServiceID",
            );

            if ($ServiceID) {

                # lookup service name
                my $ServiceName = $Self->{ServiceObject}->ServiceLookup(
                    ServiceID => $ServiceID,
                );

                # lookup test
                $Self->Is(
                    $ServiceName || '',
                    $Item->{AddGet}->{Name} || '',
                    "Test $TestCount: ServiceLookup() - lookup",
                );

                # reverse lookup the service id
                my $ServiceIDNew = $Self->{ServiceObject}->ServiceLookup(
                    Name => $ServiceName || '',
                );

                # reverse lookup test
                $Self->Is(
                    $ServiceIDNew || '',
                    $ServiceID    || '',
                    "Test $TestCount: ServiceLookup() - reverse lookup",
                );

                # set last service id variable
                $LastLastAddedServiceID = $LastAddedServiceID;
                $LastAddedServiceID     = $ServiceID;

                # increment the added counter
                $AddedCounter++;
            }
        }
        else {
            $Self->False(
                $ServiceID,
                "Test $TestCount: ServiceAdd()",
            );
        }

        # get service data to check the values after creation of the service
        my %ServiceGet = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => $Item->{Add}->{UserID},
        );

        # check service data after creation of the service
        for my $ServiceAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $ServiceGet{$ServiceAttribute} || '',
                $Item->{AddGet}->{$ServiceAttribute} || '',
                "Test $TestCount: ServiceGet() - $ServiceAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last service id varaible
        if ( !$LastAddedServiceID ) {
            $Self->False(
                1,
                "Test $TestCount: NO LAST SERVICE ID GIVEN",
            );
        }

        # prepare parent id
        if ( $Item->{Update}->{ParentID} && $Item->{Update}->{ParentID} eq 'LASTADDID' ) {
            $Item->{Update}->{ParentID} = $LastAddedServiceID;
        }
        elsif ( $Item->{Update}->{ParentID} && $Item->{Update}->{ParentID} eq 'LASTLASTADDID' ) {
            $Item->{Update}->{ParentID} = $LastLastAddedServiceID;
        }
        else {
            delete $Item->{Update}->{ParentID};
        }

        # update the service
        my $UpdateSucess = $Self->{ServiceObject}->ServiceUpdate(
            %{ $Item->{Update} },
            ServiceID => $LastAddedServiceID,
        );

        # check if service was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "Test $TestCount: ServiceUpdate() - ServiceID: $LastAddedServiceID",
            );
        }
        else {
            $Self->False(
                $UpdateSucess,
                "Test $TestCount: ServiceUpdate()",
            );
        }

        # prepare parent id
        if ( $Item->{UpdateGet}->{ParentID} && $Item->{UpdateGet}->{ParentID} eq 'LASTADDID' ) {
            $Item->{UpdateGet}->{ParentID} = $LastAddedServiceID;
        }
        elsif (
            $Item->{UpdateGet}->{ParentID}
            && $Item->{UpdateGet}->{ParentID} eq 'LASTLASTADDID'
            )
        {
            $Item->{UpdateGet}->{ParentID} = $LastLastAddedServiceID;
        }

        # get service data to check the values after the update
        my %ServiceGet2 = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $LastAddedServiceID,
            UserID    => $Item->{Update}->{UserID},
        );

        # check service data after update
        for my $ServiceAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $ServiceGet2{$ServiceAttribute} || '',
                $Item->{UpdateGet}->{$ServiceAttribute} || '',
                "Test $TestCount: ServiceGet() - $ServiceAttribute",
            );
        }

        # lookup service name
        my $ServiceName = $Self->{ServiceObject}->ServiceLookup(
            ServiceID => $ServiceGet2{ServiceID},
        );

        # lookup test
        $Self->Is(
            $ServiceName || '',
            $ServiceGet2{Name} || '',
            "Test $TestCount: ServiceLookup() - lookup",
        );

        # reverse lookup the service id
        my $ServiceIDNew = $Self->{ServiceObject}->ServiceLookup(
            Name => $ServiceName || '',
        );

        # reverse lookup test
        $Self->Is(
            $ServiceIDNew || '',
            $ServiceGet2{ServiceID} || '',
            "Test $TestCount: ServiceLookup() - reverse lookup",
        );
    }

    $TestCount++;
}

# ------------------------------------------------------------ #
# ServiceList test 1 (check general functionality)
# ------------------------------------------------------------ #

my %ServiceList1 = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);
my %ServiceList1Org = %ServiceListOriginal;

SERVICEID:
for my $ServiceID ( keys %ServiceList1Org ) {

    if ( $ServiceList1{$ServiceID} && $ServiceList1Org{$ServiceID} eq $ServiceList1{$ServiceID} ) {
        delete $ServiceList1{$ServiceID};
    }
    else {
        $ServiceList1{Dummy} = 1;
    }
}

my $ServiceList1Count = scalar keys %ServiceList1;

$Self->Is(
    $ServiceList1Count || '',
    $AddedCounter      || '',
    "Test $TestCount: ServiceList()",
);

$TestCount++;

# ------------------------------------------------------------ #
# ServiceList test 2 (check cache)
# ------------------------------------------------------------ #

my %ServiceList2 = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);

my $ServiceList2ServiceID = $Self->{ServiceObject}->ServiceAdd(
    Name    => $ServiceName[9],
    ValidID => 1,
    UserID  => 1,
);

my %ServiceList2b = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);

SERVICEID:
for my $ServiceID ( keys %ServiceList2 ) {

    if ( $ServiceList2b{$ServiceID} && $ServiceList2{$ServiceID} eq $ServiceList2b{$ServiceID} ) {
        delete $ServiceList2b{$ServiceID};
    }
    else {
        $ServiceList2b{Dummy} = 1;
    }
}

my @ServiceList2IDs   = keys %ServiceList2b;
my $ServiceList2Count = scalar @ServiceList2IDs;

$Self->Is(
    $ServiceList2Count || '',
    1,
    "Test $TestCount: ServiceList() - check number of services",
);

$Self->Is(
    $ServiceList2IDs[0] || '',
    $ServiceList2ServiceID || '',
    "Test $TestCount: ServiceList() - check id of last service",
);

$TestCount++;

# ------------------------------------------------------------ #
# ServiceSearch test 1 (check general functionality)
# ------------------------------------------------------------ #

my @ServiceSearch1Search = $Self->{ServiceObject}->ServiceSearch(
    UserID => 1,
);

my %ServiceSearch1List = $Self->{ServiceObject}->ServiceList(
    UserID => 1,
);

SERVICEID:
for my $ServiceID (@ServiceSearch1Search) {

    if ( $ServiceSearch1List{$ServiceID} ) {
        delete $ServiceSearch1List{$ServiceID};
    }
    else {
        $ServiceSearch1List{Dummy} = 1;
    }
}

my $ServiceSearch1Count = scalar keys %ServiceSearch1List;

$Self->Is(
    $ServiceSearch1Count,
    0,
    "Test $TestCount: ServiceSearch()",
);

$TestCount++;

# ------------------------------------------------------------ #
# make preparations for later tests
# ------------------------------------------------------------ #

# add some needed services for later tests
my @ServiceNames = ( $ServiceName[10] . 'Normal', $ServiceName[10] . 'Ԉ Ӵ Ϫ Ͼ' );
my %ServiceSearch2ServiceID;

my $Counter1 = 0;
for my $ServiceName (@ServiceNames) {

    $ServiceSearch2ServiceID{$Counter1} = $Self->{ServiceObject}->ServiceAdd(
        Name    => $ServiceName,
        ValidID => 1,
        UserID  => 1,
    );

    $Counter1++;
}

# ------------------------------------------------------------ #
# ServiceSearch test 2 (general name checks)
# ------------------------------------------------------------ #

my $Counter2 = 0;
for my $ServiceName (@ServiceNames) {

    my @PreparedNames = (
        $ServiceName,
        '*' . $ServiceName,
        $ServiceName . '*',
        '*' . $ServiceName . '*',
        '**' . $ServiceName,
        $ServiceName . '**',
        '**' . $ServiceName . '**',
    );

    for my $PreparedName (@PreparedNames) {

        my @ServiceList = $Self->{ServiceObject}->ServiceSearch(
            Name   => $ServiceName,
            UserID => 1,
        );

        $Self->Is(
            $ServiceList[0] || '',
            $ServiceSearch2ServiceID{$Counter2} || '',
            "Test $TestCount: ServiceSearch() - general name check",
        );

        $TestCount++;
    }

    $Counter2++;
}

1;
