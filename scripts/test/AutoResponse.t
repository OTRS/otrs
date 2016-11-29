# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $AutoResponseObject  = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get random id
my $RandomID = $HelperObject->GetRandomID();

# set queue name
my $QueueName = 'Some::Queue' . $RandomID;

# create new queue
my $QueueID = $QueueObject->QueueAdd(
    Name                => $QueueName,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => 'Some Comment',
    UserID              => 1,
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueName, $QueueID",
);

# use Test email backend
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John',
    UserLastname   => 'Doe',
    UserCustomerID => "Customer#$RandomID",
    UserLogin      => "CustomerLogin#$RandomID",
    UserEmail      => "customer$RandomID\@example.com",
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUserID,
    "Customer created."
);

# add system address
my $SystemAddressNameRand = 'SystemAddress' . $HelperObject->GetRandomID();
my $SystemAddressID       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressNameRand . '@example.com',
    Realname => $SystemAddressNameRand,
    ValidID  => 1,
    QueueID  => $QueueID,
    Comment  => 'Some Comment',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my %AutoResponseType = $AutoResponseObject->AutoResponseTypeList(
    Valid => 1,
);

for my $TypeID ( sort keys %AutoResponseType ) {

    my $AutoResponseNameRand = 'SystemAddress' . $HelperObject->GetRandomID();

    my %Tests = (
        Created => {
            Name        => $AutoResponseNameRand,
            Subject     => 'Some Subject - updated',
            Response    => 'Some Response - updated',
            Comment     => 'Some Comment - updated',
            AddressID   => $SystemAddressID,
            TypeID      => $TypeID,
            ContentType => 'text/plain',
            ValidID     => 1,
        },
        Updated => {
            Name        => $AutoResponseNameRand . ' - updated',
            Subject     => 'Some Subject - updated',
            Response    => 'Some Response - updated',
            Comment     => 'Some Comment - updated',
            AddressID   => $SystemAddressID,
            TypeID      => $TypeID,
            ContentType => 'text/html',
            ValidID     => 2,
        },
        ExpextedData => {
            AutoResponseID => '',
            Address        => $SystemAddressNameRand . '@example.com',
            Realname       => $SystemAddressNameRand,
            }
    );

    # add auto response
    my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
        UserID => 1,
        %{ $Tests{Created} },
    );

    # this will be used later to test function AutoResponseGetByTypeQueueID()
    $Tests{ExpextedData}{AutoResponseID} = $AutoResponseID;

    $Self->True(
        $AutoResponseID,
        "AutoResponseAdd() - AutoResponseType: $AutoResponseType{$TypeID}",
    );

    my %AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

    for my $Item ( sort keys %{ $Tests{Created} } ) {
        $Self->Is(
            $AutoResponse{$Item} || '',
            $Tests{Created}{$Item},
            "AutoResponseGet() - $Item",
        );
    }

    my %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 0 );
    my $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list.',
    );

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 1 );
    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list.',
    );

    # get a list of the queues that do not have auto response
    my %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();

    $Self->True(
        exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
        'AutoResponseWithoutQueue() contains queue ' . $QueueName . ' with ID ' . $QueueID,
    );

    my %AutoResponseListByType = $AutoResponseObject->AutoResponseList(
        TypeID => $TypeID,
        Valid  => 1,
    );
    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() by AutoResponseTypeID (AutoResponseTypeID) - test Auto Response is in the list.',
    );

    my $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
        QueueID         => $QueueID,
        AutoResponseIDs => [$AutoResponseID],
        UserID          => 1,
    );
    $Self->True(
        $AutoResponseQueue,
        'AutoResponseQueue()',
    );

    # check again after assigning auto response to queue
    %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();
    $Self->False(
        exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
        'AutoResponseWithoutQueue() does not contain queue ' . $QueueName . ' with ID ' . $QueueID,
    );

    my %AutoResponseData = $AutoResponseObject->AutoResponseGetByTypeQueueID(
        QueueID => $QueueID,
        Type    => $AutoResponseType{$TypeID},
    );

    for my $Item (qw/AutoResponseID Address Realname/) {
        $Self->Is(
            $AutoResponseData{$Item} || '',
            $Tests{ExpextedData}{$Item},
            "AutoResponseGetByTypeQueueID() - $Item",
        );
    }

    $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
        QueueID         => $QueueID,
        AutoResponseIDs => [],
        UserID          => 1,
    );

    my $AutoResponseUpdate = $AutoResponseObject->AutoResponseUpdate(
        ID     => $AutoResponseID,
        UserID => 1,
        %{ $Tests{Updated} },
    );

    $Self->True(
        $AutoResponseUpdate,
        'AutoResponseUpdate()',
    );

    %AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

    for my $Item ( sort keys %{ $Tests{Created} } ) {
        $Self->Is(
            $AutoResponse{$Item} || '',
            $Tests{Updated}{$Item},
            "AutoResponseGet() - $Item",
        );
    }

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 1 );
    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->False(
        $List,
        'AutoResponseList() - test Auto Response is not in the list of valid Auto Responses.',
    );

    %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 0 );

    $List = grep { $_ eq $AutoResponseID } keys %AutoResponseList;
    $Self->True(
        $List,
        'AutoResponseList() - test Auto Response is in the list of all Auto Responses.',
    );
}

# cleanup is done by RestoreDatabase

1;
