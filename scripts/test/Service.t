# --
# Service.t - Service tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Service.t,v 1.5 2008-03-14 14:32:26 mh Exp $
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

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create new users for the tests
my $UserID1 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'Service1',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-Service-1' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-Service-1@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);
my $UserID2 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'Service2',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-Service-2' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-Service-2@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# create some random numbers for the service name
my $ServiceRand1  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand2  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand3  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand4  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand5  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand6  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand7  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand8  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand9  = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand10 = 'UnitTest' . int( rand(1_000_000) );
my $ServiceRand11 = 'UnitTest' . int( rand(1_000_000) );

# get original service list for later checks
my %ServiceListOriginal = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);

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
            Name   => $ServiceRand1,
            UserID => 1,
        },
    },

    # this service is NOT complete and must not be added
    {
        Add => {
            Name    => $ServiceRand1,
            ValidID => 1,
        },
    },

    # this service must be inserted sucessfully
    {
        Add => {
            Name    => $ServiceRand1,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceRand1,
            NameShort => $ServiceRand1,
            ValidID   => 1,
            Comment   => '',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service have the same name as one test before and must not be added
    {
        Add => {
            Name    => $ServiceRand1,
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
            Name   => $ServiceRand1 . 'UPDATE1',
            UserID => 1,
        },
    },

    # the service one add-test before must be NOT updated (service is NOT complete)
    {
        Update => {
            Name    => $ServiceRand1 . 'UPDATE1',
            ValidID => 1,
        },
    },

    # this service must be inserted sucessfully
    {
        Add => {
            Name    => $ServiceRand2,
            ValidID => 1,
            Comment => 'TestComment2',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceRand2,
            NameShort => $ServiceRand2,
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
            Name   => $ServiceRand2 . 'UPDATE2',
            UserID => 1,
        },
    },

    # the service one add-test before must be NOT updated (service update arguments NOT complete)
    {
        Update => {
            Name    => $ServiceRand2 . 'UPDATE2',
            ValidID => 1,
        },
    },

    # the service one add-test before must be updated (service update arguments are complete)
    {
        Update => {
            Name    => $ServiceRand2 . 'UPDATE2',
            ValidID => 2,
            Comment => 'TestComment2UPDATE2',
            UserID  => $UserID1,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceRand2 . 'UPDATE2',
            NameShort => $ServiceRand2 . 'UPDATE2',
            ValidID   => 2,
            Comment   => 'TestComment2UPDATE2',
            CreateBy  => 1,
            ChangeBy  => $UserID1,
        },
    },

    # the service one add-test before must be updated (service update arguments are complete)
    {
        Update => {
            Name    => $ServiceRand2 . 'UPDATE3',
            ValidID => 1,
            Comment => 'TestComment2UPDATE3',
            UserID  => $UserID2,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceRand2 . 'UPDATE3',
            NameShort => $ServiceRand2 . 'UPDATE3',
            ValidID   => 1,
            Comment   => 'TestComment2UPDATE3',
            CreateBy  => 1,
            ChangeBy  => $UserID2,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $ServiceRand2 . '::UPDATE4',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $ServiceRand2 . '::Test::UPDATE4',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $ServiceRand3 . '::Test',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $ServiceRand3 . '::Test::Test',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this service must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Name    => " \t \n \r " . $ServiceRand4 . " \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceRand4,
            NameShort => $ServiceRand4,
            ValidID   => 1,
            Comment   => 'Test Comment',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $ServiceRand4 . " UPDATE1 \t \n \r ",
            ValidID => 2,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => $UserID2,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceRand4 . ' UPDATE1',
            NameShort => $ServiceRand4 . ' UPDATE1',
            ValidID   => 2,
            Comment   => 'Test Comment',
            CreateBy  => 1,
            ChangeBy  => $UserID2,
        },
    },

    # this service must be inserted sucessfully (unicode checks)
    {
        Add => {
            Name    => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ ',
            ValidID => 1,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ',
            NameShort => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ',
            ValidID   => 1,
            Comment   => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            Name    => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID => 2,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            UserID  => $UserID1,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            NameShort => $ServiceRand5 . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            ValidID   => 2,
            Comment   => 'Ѡ Ѥ TestComment5 Ϡ Ω UPDATE1',
            CreateBy  => 1,
            ChangeBy  => $UserID1,
        },
    },

    # this service must be inserted sucessfully (special character checks)
    {
        Add => {
            Name    => ' [test]%*\\ ' . $ServiceRand9 . ' [test]%*\\ ',
            ValidID => 1,
            Comment => ' [test]%*\\ Test Comment [test]%*\\ ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $ServiceRand9 . ' [test]%*\\',
            NameShort => '[test]%*\\ ' . $ServiceRand9 . ' [test]%*\\',
            ValidID   => 1,
            Comment   => '[test]%*\\ Test Comment [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service one add-test before must be updated sucessfully (special character checks)
    {
        Update => {
            Name    => ' [test]%*\\ ' . $ServiceRand9 . ' UPDATE1 [test]%*\\ ',
            ValidID => 2,
            Comment => ' [test]%*\\ Test Comment UPDATE1 [test]%*\\ ',
            UserID  => $UserID2,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $ServiceRand9 . ' UPDATE1 [test]%*\\',
            NameShort => '[test]%*\\ ' . $ServiceRand9 . ' UPDATE1 [test]%*\\',
            ValidID   => 2,
            Comment   => '[test]%*\\ Test Comment UPDATE1 [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => $UserID2,
        },
    },

    # this service must be inserted sucessfully (used for the following tests)
    {
        Add => {
            Name    => $ServiceRand6,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $ServiceRand6,
            NameShort => $ServiceRand6,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be inserted sucessfully (parent service check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => $ServiceRand7,
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $ServiceRand6 . '::' . $ServiceRand7,
            NameShort => $ServiceRand7,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be inserted sucessfully (parent service check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => " \n \t " . $ServiceRand8 . " \n \t ",
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $ServiceRand6 . '::' . $ServiceRand7 . '::' . $ServiceRand8,
            NameShort => $ServiceRand8,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the service must be NOT updated (parent service id and parent id are identical)
    {
        Update => {
            ParentID => 'LASTADDID',
            Name     => $ServiceRand8 . 'UPDATE1',
            ValidID  => 1,
            UserID   => 1,
        },
    },

    # this service must be updated sucessfully (move service to the higherst level)
    {
        Update => {
            ParentID => '',
            Name     => $ServiceRand8 . ' UPDATE1',
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $ServiceRand8 . ' UPDATE1',
            NameShort => $ServiceRand8 . ' UPDATE1',
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this service must be updated sucessfully (move service back with the old parent service)
    {
        Update => {
            ParentID => 'LASTLASTADDID',
            Name     => $ServiceRand8 . ' UPDATE2',
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID  => 'LASTLASTADDID',
            Name      => $ServiceRand6 . '::' . $ServiceRand7 . '::' . $ServiceRand8 . ' UPDATE2',
            NameShort => $ServiceRand8 . ' UPDATE2',
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },
];

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

# ServiceList test 1 (check general functionality)
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

# ServiceList test 2 (check cache)
my %ServiceList2 = $Self->{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);

my $ServiceList2ServiceID = $Self->{ServiceObject}->ServiceAdd(
    Name    => $ServiceRand10,
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

# ServiceSearch test 1 (check general functionality)
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

# add some needed services
my @ServiceNames = ( $ServiceRand11 . 'Normal', $ServiceRand11 . 'Ԉ Ӵ Ϫ Ͼ' );
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

# ServiceSearch test 2 (general name checks)
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

# clean the service table
$Self->{DBObject}->Do(
    SQL => "DELETE FROM service WHERE name LIKE '%UnitTest%'",
);

# clean the system user table
my $UserTable = $Self->{ConfigObject}->Get('DatabaseUserTable') || 'system_user';

$Self->{DBObject}->Do(
    SQL => "DELETE FROM $UserTable WHERE login LIKE 'UnitTest-Service-%'",
);

1;
