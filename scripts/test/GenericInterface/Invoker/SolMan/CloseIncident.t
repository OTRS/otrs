# --
# CloseIncident.t - CloseIncident Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: CloseIncident.t,v 1.6 2011-04-15 23:23:46 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::CustomerUser;
use Kernel::System::UnitTest::Helper;
use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Invoker::SolMan::Common;
use Kernel::System::GenericInterface::ObjectLockState;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $TicketObject          = Kernel::System::Ticket->new( %{$Self} );
my $UserObject            = Kernel::System::User->new( %{$Self} );
my $CustomerUserObject    = Kernel::System::CustomerUser->new( %{$Self} );
my $WebserviceObject      = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $ObjectLockStateObject = Kernel::System::GenericInterface::ObjectLockState->new( %{$Self} );

my $RandomID = $HelperObject->GetRandomID();

my $Home = $Self->{ConfigObject}->Get('Home');

my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
}

# get scheduler status
my $PreviousSchedulerStatus = `$Scheduler -a status`;

# stop scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    `$Scheduler -a stop`;
}

sleep 1;

# start the scheduler again to refresh all objects
`$Scheduler -a start -f 1`;

# remember all webservices
my $WebserviceList = $WebserviceObject->WebserviceList();

# is needed to set all webservices to invalid or ticket events will be fired on those webservices
# loop trought all configured webservices
WEBSERVICEID:
for my $WebserviceID ( keys %{$WebserviceList} ) {

    # get webservice data
    my $Webservice = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    if ( $Webservice->{ValidID} ne 1 ) {
        delete $WebserviceList->{$WebserviceID};
        next WEBSERVICEID;
    }

    # set webservice to invalid
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $Webservice->{Name},
        Config  => $Webservice->{Config},
        ValidID => 2,
        UserID  => 1,
    );

    $Self->True(
        $Success,
        "Webservice $WebserviceID is set to invalid",
    );
}

# webservice confuration
my $WebserviceConfig = {
    Debugger => {
        DebugThreshold => 'debug',
    },
    Requester => {
        Transport => {
            Type => 'HTTP::Test',
        },
        Invoker => {
            CloseIncident => {
                Type             => 'SolMan::CLoseIncident',
                RemoteSystemGuid => '123ABC123ABC123ABC'
            },
        },
    },
};

# add a webservice
my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config  => $WebserviceConfig,
    Name    => "ReplicateIncidentInvokerTest - . $RandomID",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

# remember used ticketIDs
my @TicketIDs;

# create a new ticket
my $OpenTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->IsNot(
    $OpenTicketID,
    undef,
    "TicketCreate() Ticket with state open ID $OpenTicketID",
);

push @TicketIDs, $OpenTicketID;

# create a new closed ticket
my $ClosedTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->IsNot(
    $ClosedTicketID,
    undef,
    "TicketCreate() Ticket wiith state closed ID $ClosedTicketID",
);

push @TicketIDs, $ClosedTicketID;

# get ticket data
my %ClosedTicket = $TicketObject->TicketGet(
    TicketID => $ClosedTicketID,
    UserID   => 1,
);

$Self->Is(
    $ClosedTicket{StateType},
    'closed',
    "Closed Ticket StateType",
);

# create a new ticket to simulate that overpased the maximum ticket sync attempts
my $CantSyncTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->IsNot(
    $CantSyncTicketID,
    undef,
    "TicketCreate() Ticket to test Sync Attempts $CantSyncTicketID",
);

push @TicketIDs, $CantSyncTicketID;

# get Maximum number of Sync Attempts
my $MaxSyncAttempts
    = $Self->{ConfigObject}->Get('GenericInterface::Invoker::SolMan::MaxSyncAttempts') || 5;

# simultate that the ticket can't sync
my $SuccessTicketLock = $ObjectLockStateObject->ObjectLockStateSet(
    WebserviceID     => $WebserviceID,
    ObjectType       => 'Ticket',
    ObjectID         => $CantSyncTicketID,
    LockState        => 'CloseIncident',
    LockStateCounter => $MaxSyncAttempts,
);

$Self->True(
    $SuccessTicketLock,
    'Tikcet is set as can\'t sync',
);

# create a new closed ticket
my $NoIncidnetGuidTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->IsNot(
    $NoIncidnetGuidTicketID,
    undef,
    "TicketCreate() Ticket to test no IncientGuid $NoIncidnetGuidTicketID",
);

push @TicketIDs, $NoIncidnetGuidTicketID;

# create a new closed ticket
my $SyncedTicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->IsNot(
    $SyncedTicketID,
    undef,
    "TicketCreate() Ticket to test correct Sync $SyncedTicketID",
);

push @TicketIDs, $SyncedTicketID;

# create a new article
my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $SyncedTicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <agentl@localunittest.com>',
    To             => 'Some Customer <customer@localunittest.com',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->IsNot(
    $ArticleID,
    undef,
    "ArticleCreate()",
);

my $TimeStamp = $Self->{TimeObject}->SystemTime();

# simulate ticket is synced
my $SuccessTicketFlagSet = $TicketObject->TicketFlagSet(
    TicketID => $NoIncidnetGuidTicketID,
    Key      => "GI_" . $WebserviceID . "_SolMan_SyncTimestamp",
    Value    => $TimeStamp,
    UserID   => 1,
);

$Self->True(
    $SuccessTicketFlagSet,
    "Ticket $NoIncidnetGuidTicketID has succesfuly set as synced",
);

# simulate ticket is synced
$SuccessTicketFlagSet = $TicketObject->TicketFlagSet(
    TicketID => $SyncedTicketID,
    Key      => "GI_" . $WebserviceID . "_SolMan_SyncTimestamp",
    Value    => $TimeStamp,
    UserID   => 1,
);

$Self->True(
    $SuccessTicketFlagSet,
    "Ticket $SyncedTicketID has succesfuly set as synced",
);

# wait a second so the new article will get a diferent timestamp
sleep 1;

# create a new article this article was not synced
my $SecondArticleID = $TicketObject->ArticleCreate(
    TicketID       => $SyncedTicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <agentl@localunittest.com>',
    To             => 'Some Customer <customer@localunittest.com',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->IsNot(
    $SecondArticleID,
    undef,
    "ArticleCreate()",
);

# get users data
my %User = $UserObject->GetUserData(
    UserID => 1,
);
my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
    User => 'customer@localunittest.com',
);

# get ticket data
my %Ticket = $TicketObject->TicketGet(
    TicketID => $SyncedTicketID,
    UserID   => 1,
);
my %NoIncidentGuidTicket = $TicketObject->TicketGet(
    TicketID => $NoIncidnetGuidTicketID,
    UserID   => 1,
);

my %CantSyncTicket = $TicketObject->TicketGet(
    TicketID => $CantSyncTicketID,
    UserID   => 1,
);

# simulate that the ticket was opened before
$Ticket{State}                   = 'open';
$Ticket{StateType}               = 'open';
$NoIncidentGuidTicket{State}     = 'open';
$NoIncidentGuidTicket{StateType} = 'open';
$CantSyncTicket{State}           = 'open';
$CantSyncTicket{StateType}       = 'open';

# simulate that the ticket IncidentGuid is set
$SuccessTicketFlagSet = $TicketObject->TicketFlagSet(
    TicketID => $SyncedTicketID,
    Key      => "GI_" . $WebserviceID . "_SolMan_IncidentGuid",
    Value    => $Ticket{TicketNumber},
    UserID   => 1,
);

$SuccessTicketFlagSet = $TicketObject->TicketFlagSet(
    TicketID => $CantSyncTicketID,
    Key      => "GI_" . $WebserviceID . "_SolMan_IncidentGuid",
    Value    => $CantSyncTicket{TicketNumber},
    UserID   => 1,
);

# tests for PrepareRequest and HandleResponse
my @Tests = (

    {
        Name           => 'Empty data',
        PrepareRequest => {
            Data    => {},
            Success => 0,
        },
    },
    {
        Name           => 'Wrong TicketID',
        PrepareRequest => {
            Data => {
                TicketID => -999,
            },
            Success => 0,
        },
    },
    {
        Name           => 'Invalid OldTicketData',
        PrepareRequest => {
            Data => {
                TicketID => $OpenTicketID,
            },
            Success => 0,
        },
    },
    {
        Name           => 'Not Closed Ticket',
        PrepareRequest => {
            Data => {
                TicketID      => $OpenTicketID,
                OldTicketData => \%Ticket,
            },
            Success => 0,
        },
    },
    {
        Name           => 'Closed Ticket already closed',
        PrepareRequest => {
            Data => {
                TicketID      => $ClosedTicketID,
                OldTicketData => \%ClosedTicket,
            },
            Success => 0,
        },
    },
    {
        Name           => 'Can\'t sync Ticket',
        PrepareRequest => {
            Data => {
                TicketID      => $CantSyncTicketID,
                OldTicketData => \%CantSyncTicket,
            },
            Success => 0,
        },
    },
    {
        Name           => 'Not\'t synced Ticket',
        PrepareRequest => {
            Data => {
                TicketID      => $ClosedTicketID,
                OldTicketData => \%Ticket,
            },
            Success => 0,
        },
    },
    {
        Name           => 'No IncidentGuid Ticket',
        PrepareRequest => {
            Data => {
                TicketID      => $NoIncidnetGuidTicketID,
                OldTicketData => \%NoIncidentGuidTicket,
            },
            Success => 0,
        },
    },

    {
        Name           => 'Correct Ticket',
        PrepareRequest => {
            Data => {
                TicketID      => $SyncedTicketID,
                OldTicketData => \%Ticket,
            },
            ResponseData => {

            },
            Success => 1,
        },
    },
    {
        Name           => 'Server Error',
        HandleResponse => {
            ResponseSuccess => 0,
            Data            => {},
            Success         => 0,
        },
    },
    {
        Name           => 'Empty Response Data',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {},
            Success         => 0,
        },
    },
    {
        Name           => 'No Errors parameter',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                PersonMaps => '',
                PrdIctId   => '',
            },
            Success => 0,
        },
    },
    {
        Name           => 'Incomplete error parameter',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => {
                    ErrorCode => '03',
                },
            },
            Success => 1,
        },
    },
    {
        Name           => 'Complete error parameter No ReSchedule',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => {
                    item => {
                        ErrorCode => '03',
                        Val1      => 'Description',
                        Val2      => 'Deatil1',
                        Val3      => 'Detail2',
                        Val4      => 'Detail3',
                        }
                },
            },
            Success      => 1,
            ReSchedule   => undef,
            ErrorMessage => 'Error Code 03 Description Details: Detail1 Detail2 Detail3 |',
        },
    },
    {
        Name           => 'Complete error parameter ReSchedule',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => {
                    item => {
                        ErrorCode => '0999',
                        Val1      => 'Description',
                        Val2      => 'Deatil1',
                        Val3      => 'Detail2',
                        Val4      => 'Detail3',
                        }
                },
            },
            Success      => 1,
            ReSchedule   => 1,
            ErrorMessage => 'Error Code 0999 Description Details: Detail1 Detail2 Detail3 |',
        },
    },

    {
        Name           => 'No PersonMaps',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors   => '',
                PrdIctId => '0001',
            },
            Success => 0,
        },
    },
    {
        Name           => 'No PrdIctId',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                },
            },
            Success => 0,
        },
    },
    {
        Name           => 'Empty PrdIctId',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                },
                PrdIctId => '',
            },
            Success => 0,
        },
    },
    {
        Name           => 'Wrong PersonMaps (without Item)',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    PersonId    => '0001',
                    PersonIdExt => '5050',
                },
                PrdIctId => '10001',
            },
            Success => 0,
        },
    },
    {
        Name           => 'Wrong PersonMaps (without PersonId)',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => {
                        PersonIdExt => '5050',
                    },
                },
                PrdIctId => '10001',
            },
            Success => 0,
        },
    },
    {
        Name           => 'Wrong PersonMaps (without PersonIdExt)',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => {
                        PersonId => '0001',
                    },
                },
                PrdIctId => '10001',
            },
            Success => 0,
        },
    },
    {
        Name           => 'One Person Map',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                },
                PrdIctId => '10001',
            },
            Success          => 1,
            ExpectedResponse => {
                PersonMaps => [
                    {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                ],
                PrdIctId => '10001',
                }
        },
    },
    {
        Name           => 'Two Persons Map',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                PersonMaps => {
                    item => [
                        {
                            PersonId    => '0001',
                            PersonIdExt => '5050',
                        },
                        {
                            PersonId    => '8080',
                            PersonIdExt => '1024',
                        },
                    ],
                },
                PrdIctId => '10001',
            },
            Success          => 1,
            ExpectedResponse => {
                PersonMaps => [
                    {
                        PersonId    => '0001',
                        PersonIdExt => '5050',
                    },
                    {
                        PersonId    => '8080',
                        PersonIdExt => '1024',
                    },
                ],
                PrdIctId => '10001',
                }
        },
    },
);

# create debuger object
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Requester',
);

# create invokers SolManCommon Object
my $SolManCommonObject = Kernel::GenericInterface::Invoker::SolMan::Common->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => $WebserviceID,
    Invoker        => 'ReplicateIncident',
);

# get local SystemGud
my $OTRSystemGuid = $SolManCommonObject->GetSystemGuid();

# create invoker object without webservice
my $InvokerObject = Kernel::GenericInterface::Invoker->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    InvokerType    => 'SolMan::CloseIncident',
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() fail',
);

# create invoker object
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => $WebserviceID,
    InvokerType    => 'SolMan::CloseIncident',
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() success',
);

# Start invoker tests
for my $Test (@Tests) {
    if ( $Test->{PrepareRequest} ) {

        my $ResponseData = $Test->{PrepareRequest}->{ResponseData};

        # call PrerareRequest()
        my $Result = $InvokerObject->PrepareRequest(
            Data => $Test->{PrepareRequest}->{Data},
        );

        # check response format
        $Self->Is(
            ref $Result,
            'HASH',
            "Test $Test->{Name}: ReplicateIncident PrepareRequest response",
        );

        # check response success
        $Self->Is(
            $Result->{Success},
            $Test->{PrepareRequest}->{Success},
            "Test $Test->{Name}: ReplicateIncident PrepareRequest",
        );

        # check response data format
        $Self->Is(
            ref $Result->{Data},
            ref $ResponseData,
            "Test $Test->{Name}: ReplicateIncident PrepareRequest Data ref",
        );

        # if not succes check that there is an error message
        if ( !$Test->{PrepareRequest}->{Success} ) {
            $Self->IsNot(
                $Result->{ErrorMessage},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest ErrorMessage",
            );
        }

        else {

            # otherwise it should not be an error message
            $Self->Is(
                $Result->{ErrorMessage},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest ErrorMessage",
            );

            # check if data is what is expected

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctAdditionalInfos},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctAdditionalInfos",
            );

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctAttachments},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctAttachments",
            );

            $Self->Is(
                ref $Result->{Data}->{IctHead},
                'HASH',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead ref",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{AgentId},
                1,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead AgentId",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{IctId},
                $Ticket{TicketNumber},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead IctId",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{Language},
                $CustomerUser{UserLanguage} || 'en',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead Language",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{Priority},
                $Ticket{Priority},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead Priority",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{ProviderGuid},
                $WebserviceConfig->{Requester}->{Invoker}->{CloseIncident}->{RemoteSystemGuid},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead ProviderGuid",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{ReporterId},
                $Ticket{CustomerUserID},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead ReporterId",
            );

            $Self->IsNot(
                $Result->{Data}->{IctHead}->{RequestedBegin},
                '',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead RequestedBegin",
            );

            $Self->IsNot(
                $Result->{Data}->{IctHead}->{RequestedEnd},
                '',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead RequestedEnd",
            );

            $Self->True(
                $Result->{Data}->{IctHead}->{RequestedBegin}
                    lt $Result->{Data}->{IctHead}->{RequestedEnd},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead "
                    . 'RequestedBegin < RequestedEnd',
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{RequesterGuid},
                $OTRSystemGuid,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead RequesterGuid",
            );

            $Self->Is(
                $Result->{Data}->{IctHead}->{ShortDescription},
                $Ticket{Title},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctHead ShortDescription",
            );

            $Self->Is(
                $Result->{Data}->{IctId},
                $Ticket{TicketNumber},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctId",
            );

            $Self->Is(
                ref $Result->{Data}->{IctPersons},
                'HASH',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons ref",
            );

            $Self->Is(
                ref $Result->{Data}->{IctPersons}->{item},
                'ARRAY',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons item ref",
            );

            $Self->Is(
                scalar @{ $Result->{Data}->{IctPersons}->{item} },
                2,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons item count",
            );

            for my $ItemCounter ( 0 .. 1 ) {
                my %ItemUser;
                if ( $ItemCounter eq 0 ) {
                    %ItemUser = %CustomerUser;
                }
                else {
                    %ItemUser = %User;
                }

                $Self->Is(
                    ref $Result->{Data}->{IctPersons}->{item}[$ItemCounter],
                    'HASH',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] ref",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Email},
                    $ItemUser{UserEmail} || '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] EMail",
                );

                if ( $ItemUser{UserFax} ) {
                    $Self->Is(
                        ref $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Fax},
                        'HASH',
                        "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Fax ref",
                    );

                    $Self->Is(
                        $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Fax}->{FaxNo},
                        $ItemUser{UserFax} || '',
                        "Test $Test->{Name}: ReplicateIfncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Fax FaxNo",
                    );
                }
                else {
                    $Self->Is(
                        $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Fax},
                        '',
                        "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Fax",
                    );
                }

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{FirstName},
                    $ItemUser{UserFirstname} || '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] FirstName",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{LastName},
                    $ItemUser{UserLastname} || '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] LastName",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{MobilePhone},
                    $ItemUser{Mobile} || '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] MobilePhone",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{PersonId},
                    $ItemUser{UserID} || '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] PersonId",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{PersonIdExt},
                    '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] PersonIdExt",
                );

                $Self->Is(
                    $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Sex},
                    '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                        . "item [$ItemCounter] Sex",
                );

                if ( $ItemUser{UserPhone} ) {
                    $Self->Is(
                        ref $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Telephone},
                        'HASH',
                        "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Telephone ref",
                    );

                    $Self->Is(
                        $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Telephone}->{PhoneNo},
                        $ItemUser{UserPhone} || '',
                        "Test $Test->{Name}: ReplicateIfncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Telephone PhoneNo",
                    );
                }
                else {
                    $Self->Is(
                        $Result->{Data}->{IctPersons}->{item}[$ItemCounter]->{Telephone},
                        '',
                        "Test $Test->{Name}: ReplicateIncident PrepareRequest IctPersons "
                            . "item [$ItemCounter] Telephone",
                    );

                }
            }

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctSapNotes},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctSapNotes",
            );

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctSolutions},
                undef,
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctSolutions",
            );

            $Self->Is(
                ref $Result->{Data}->{IctStatements},
                'HASH',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements ref",
            );

            # TODO this test might need to be changed
            $Self->Is(
                ref $Result->{Data}->{IctStatements}->{item},
                'ARRAY',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item ref",
            );

            # TODO this test might need to be changed
            $Self->Is(
                ref $Result->{Data}->{IctStatements}->{item}[0],
                'HASH',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] ref",
            );

            $Self->Is(
                $Result->{Data}->{IctStatements}->{item}[0]->{Language},
                $CustomerUser{UserLanguage} || 'en',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "Language",
            );

            $Self->Is(
                $Result->{Data}->{IctStatements}->{item}[0]->{PersonId},
                $User{UserID},
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "PersonId",
            );

            # TODO this test might need to be changed
            $Self->Is(
                $Result->{Data}->{IctStatements}->{item}[0]->{TextType},
                'note-internal',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "TextType",
            );

            $Self->Is(
                ref $Result->{Data}->{IctStatements}->{item}[0]->{Texts},
                'HASH',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "Texts ref",
            );

            # TODO this test might need to be changed
            $Self->Is(
                ref $Result->{Data}->{IctStatements}->{item}[0]->{Texts}->{item},
                'ARRAY',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "Texts item ref",
            );

            for my $ItemLine ( @{ $Result->{Data}->{IctStatements}->{item}[0]->{Texts}->{item} } ) {
                $Self->IsNot(
                    $ItemLine,
                    '',
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                        . "Texts item line non empty",
                );
            }

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctStatements}->{item}[0]->{Timestamp},
                '',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctStatements item [0] "
                    . "Timestamp",
            );

            # TODO this test might need to be changed
            $Self->IsNot(
                $Result->{Data}->{IctTimestamp},
                '',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctTimestamp",
            );

            # TODO this test might need to be changed
            $Self->Is(
                $Result->{Data}->{IctUrls},
                '',
                "Test $Test->{Name}: ReplicateIncident PrepareRequest IctUrls",
            );
        }
    }

    # tests for handle response
    if ( $Test->{HandleResponse} ) {

        # execute HandleResponse() on invoker
        my $Result = $InvokerObject->HandleResponse(
            ResponseSuccess => $Test->{HandleResponse}->{ResponseSuccess},
            Data            => $Test->{HandleResponse}->{Data},
        );

        # check result estructure
        $Self->Is(
            ref $Result,
            'HASH',
            "Test $Test->{Name}: ReplicateIncident HandleResponse response",
        );

        # if tests should be corret
        if ( $Test->{HandleResponse}->{Success} ) {

            # check the success status
            $Self->Is(
                $Result->{Success},
                '1',
                "Test $Test->{Name}: ReplicateIncident HandleResponse success",
            );

            # check for errors
            if ( ref $Test->{HandleResponse}->{Data}->{Errors} eq 'HASH' ) {

                # if errors are sent then the result should contain errors
                $Self->IsNot(
                    $Result->{ErrorMessage},
                    '',
                    "Test $Test->{Name}: ReplicateIncident HandleResponse error message not empty",
                );

                # check reschedule status
                $Self->Is(
                    $Result->{ReSchedule},
                    $Test->{HandleResponse}->{ReSchedule},
                    "Test $Test->{Name}: ReplicateIncident PrepareRequest ReSchedule",
                );

                # should not be any PersonMaps
                $Self->Is(
                    $Result->{PersonMaps},
                    undef,
                    "Test $Test->{Name}: ReplicateIncident HandleResponse no PersonMaps",
                );

                # should not be any ProdIctId
                $Self->Is(
                    $Result->{PrdIctId},
                    undef,
                    "Test $Test->{Name}: ReplicateIncident HandleResponse no PrdIctId",
                );

            }
            else {

                # check for no errors
                $Self->Is(
                    $Result->{ErrorMessage},
                    undef,
                    "Test $Test->{Name}: ReplicateIncident HandleResponse error message not empty",
                );

                # check the response is what is was expected
                $Self->IsDeeply(
                    $Result->{Data},
                    $Test->{HandleResponse}->{ExpectedResponse},
                    "Test $Test->{Name}: ReplicateIncident HandleResponse Response",
                );
            }
        }
        else {

            # otherwise there test should fail
            $Self->Is(
                $Result->{Success},
                '0',
                "Test $Test->{Name}: ReplicateIncident HandleResponse not success",
            );

            # should be an error message
            $Self->IsNot(
                $Result->{ErrorMessage},
                undef,
                "Test $Test->{Name}: ReplicateIncident HandleResponse ErrorMessage",
            );
        }
    }
}

# remove Tickets
for my $TicketIDToDelete (@TicketIDs) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketIDToDelete,
        UserID   => 1,
    );

    $Self->True(
        $Success,
        "TicketDelete() $TicketIDToDelete",
    );
}

# remove Webservice
my $WsDeleteSuccess = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $WsDeleteSuccess,
    'WebserviceDelete()',
);

# is needed to set all reamining webservices to valid
# loop trought all configured webservices
WEBSERVICEID:
for my $WebserviceID ( keys %{$WebserviceList} ) {

    # get webservice data
    my $Webservice = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # set webservice to valid
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $Webservice->{Name},
        Config  => $Webservice->{Config},
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $Success,
        "Webservice $WebserviceID is set to valid",
    );
}

# wait until scheduler process tasks
my $SchedulerSleep = $Self->{ConfigObject}->Get('Scheduler::SleepTime');

$Self->True(
    1,
    'Waiting for scheduler to process tasks...'
);

sleep $SchedulerSleep + 5;

# stop scheduler if it was not running
if ( $PreviousSchedulerStatus !~ /^running/i ) {
    `$Scheduler -a stop`;
}

1;
