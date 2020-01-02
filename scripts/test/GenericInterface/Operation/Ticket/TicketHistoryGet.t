# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use MIME::Base64;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::GenericInterface::Operation::Ticket::TicketHistoryGet;

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# disable SessionCheckRemoteIP setting
$ConfigObject->Set(
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# Skip SSL certificate verification.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get a random number
my $RandomID = $Helper->GetRandomNumber();

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password = $UserLogin;

my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $UserLogin,
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => 'Raw' );
my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateLookup( State => 'new' );

# Disable service and type
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Service',
    Value => 0,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Type',
    Value => 0,
);

# create ticket
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    StateID      => $StateID,
    CustomerID   => '123465',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID1,
    "TicketCreate() successful for Ticket ID $TicketID1",
);

# create ticket
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    StateID      => $StateID,
    CustomerID   => '123465',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket ID $TicketID2",
);

my $TimeString = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

my $Success = $TicketObject->TicketPendingTimeSet(
    String   => $TimeString,
    TicketID => $TicketID2,
    UserID   => 1,
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $ArticleID1           = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID2,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'first article',
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'PhoneCallCustomer',
    HistoryComment       => '%%',
    UserID               => 1,
    NoAgentNotify        => 1,
);

# set web-service name
my $WebserviceName = '-Test-' . $RandomID;

# create web-service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added Web Service",
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web-service config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {

    #    Name => '',
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketHistoryGet => {
                Type => 'Ticket::TicketHistoryGet',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
                Timeout   => 120,
            },
        },
        Invoker => {
            TicketHistoryGet => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web-service with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
$Self->True(
    $WebserviceUpdate,
    "Updated Web Service $WebserviceID - $WebserviceName",
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# start requester with our web-service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};

my @Tests = (
    {
        Name                    => 'Empty Request',
        SuccessRequest          => 1,
        RequestData             => {},
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketHistoryGet.MissingParameter',
                    ErrorMessage => 'TicketHistoryGet: TicketID parameter is missing!'
                }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketHistoryGet.MissingParameter',
                    ErrorMessage => 'TicketHistoryGet: TicketID parameter is missing!'
                }
            },
            Success => 1
        },
        Operation => 'TicketHistoryGet',
    },
    {
        Name           => 'Wrong TicketID',
        SuccessRequest => 1,
        RequestData    => {
            TicketID => 'NotTicketID',
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketHistoryGet.AccessDenied',
                    ErrorMessage =>
                        'TicketHistoryGet: User does not have access to the ticket NotTicketID!'
                }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketHistoryGet.AccessDenied',
                    ErrorMessage =>
                        'TicketHistoryGet: User does not have access to the ticket NotTicketID!'
                }
            },
            Success => 1
        },
        Operation => 'TicketHistoryGet',
    },
    {
        Name           => 'Test Ticket 1',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
        },
        ExtraParams => {
            Queue        => 'Raw',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customerOne@example.com',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketHistory => [
                    {
                        TicketID => $TicketID1,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                        ],
                    },
                ],
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketHistory => [
                    {
                        TicketID => $TicketID1,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                        ],
                    },
                ],
            },
        },
        Operation => 'TicketHistoryGet',
    },

    {
        Name           => 'Test Ticket 2',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID2,
        },
        ExtraParams => {
            Queue        => 'Raw',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customerOne@example.com',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketHistory => [
                    {
                        TicketID => $TicketID2,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'SetPendingTime',
                                HistoryTypeID => 26,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'PhoneCallCustomer',
                                HistoryTypeID => 14,
                                TicketID      => $TicketID2,
                                ArticleID     => $ArticleID1,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'Misc',
                                HistoryTypeID => 25,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                        ],
                    },
                ],
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketHistory => [
                    {
                        TicketID => $TicketID2,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'SetPendingTime',
                                HistoryTypeID => 26,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'PhoneCallCustomer',
                                HistoryTypeID => 14,
                                TicketID      => $TicketID2,
                                ArticleID     => $ArticleID1,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'Misc',
                                HistoryTypeID => 25,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                        ],
                    },
                ],
            },
        },
        Operation => 'TicketHistoryGet',
    },

    {
        Name           => 'Multiple Tickets',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1 . ',' . $TicketID2,
        },
        ExtraParams => {
            Queue        => 'Raw',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customerOne@example.com',
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketHistory => [

                    {
                        TicketID => $TicketID1,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                        ],
                    },

                    {
                        TicketID => $TicketID2,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'SetPendingTime',
                                HistoryTypeID => 26,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'PhoneCallCustomer',
                                HistoryTypeID => 14,
                                TicketID      => $TicketID2,
                                ArticleID     => $ArticleID1,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'Misc',
                                HistoryTypeID => 25,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                        ],

                    },
                ],
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketHistory => [

                    {
                        TicketID => $TicketID1,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID1,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                        ],

                    },

                    {
                        TicketID => $TicketID2,
                        History  => [
                            {
                                HistoryType   => 'NewTicket',
                                HistoryTypeID => 1,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'CustomerUpdate',
                                HistoryTypeID => 21,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                OwnerID       => 1,
                                PriorityID    => 3,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'SetPendingTime',
                                HistoryTypeID => 26,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'PhoneCallCustomer',
                                HistoryTypeID => 14,
                                TicketID      => $TicketID2,
                                ArticleID     => $ArticleID1,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                            {
                                HistoryType   => 'Misc',
                                HistoryTypeID => 25,
                                TicketID      => $TicketID2,
                                ArticleID     => 0,
                                TypeID        => 1,
                                QueueID       => 2,
                                StateID       => 1,
                                PriorityID    => 3,
                                OwnerID       => 1,
                                CreateBy      => 1,
                            },
                        ],
                    },
                ],
            },
        },
        Operation => 'TicketHistoryGet',
    },

);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instantiate correctly',
);

my $CheckHistoryName = sub {
    my %Param = @_;

    my $Success = 1;
    if ( $Param{HistoryType} eq 'NewTicket' ) {
        return if $Param{Name} !~ m{%%\d+%%$Param{Queue}%%$Param{Priority}%%$Param{State}%%$Param{TicketID}};
    }
    elsif ( $Param{HistoryType} eq 'CustomerUpdate' ) {
        return if $Param{Name} !~ m{%%CustomerID=$Param{CustomerID};CustomerUser=$Param{CustomerUser};};
    }
    elsif ( $Param{HistoryType} eq 'SetPendingTime' ) {
        return if $Param{Name} !~ m{%%\d{4}-\d{2}-\d{2} \d{2}:\d{2}};
    }
    elsif ( $Param{HistoryType} eq 'PhoneCallCustomer' ) {
        return if $Param{Name} !~ m{%%};
    }
    elsif ( $Param{HistoryType} eq 'Misc' ) {
        return if $Param{Name} !~ m{Reset of unlock time.};
    }

    else {
        $Success = 0;
    }
    return $Success;
};

TEST:
for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );
    if ( IsHashRefWithData( $Test->{Auth} ) ) {
        %Auth = %{ $Test->{Auth} };
    }

    # start requester with our web-service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object",
    );

    # start requester with our web-service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "$Test->{Name} - Requester result structure is valid",
    );

    $Self->Is(
        $RequesterResult->{Success},
        $Test->{SuccessRequest},
        "$Test->{Name} - Requester successful result",
    );

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    if ( !defined $LocalResult->{Data}->{Error} ) {

        if ( ref $LocalResult->{Data}->{TicketHistory} eq 'HASH' ) {
            my $TicketHistory = $LocalResult->{Data}->{TicketHistory};
            push @{ $LocalResult->{Data}->{TicketHistory} }, $TicketHistory;
        }
        for my $ResultEntry ( @{ $LocalResult->{Data}->{TicketHistory} } ) {
            for my $HistoryEntry ( @{ $ResultEntry->{History} } ) {
                delete $HistoryEntry->{CreateTime};

                my $NameCheck = $CheckHistoryName->( %{$HistoryEntry}, %{ $Test->{ExtraParams} } );
                $Self->True(
                    $NameCheck,
                    "$Test->{Name} - Local CheckHistory $HistoryEntry->{HistoryType} Name checked with Regex",
                );

                delete $HistoryEntry->{Name};
            }
        }

        use Data::Dumper;
        print STDERR "Debug - ModuleName - RequesterResult = "
            . Dumper($RequesterResult)
            . "\n";    # TODO: Delete developer comment

        if ( ref $RequesterResult->{Data}->{TicketHistory} eq 'HASH' ) {
            my $TicketHistory = $RequesterResult->{Data}->{TicketHistory};
            delete $RequesterResult->{Data}->{TicketHistory};
            push @{ $RequesterResult->{Data}->{TicketHistory} }, $TicketHistory;
        }
        for my $ResultEntry ( @{ $RequesterResult->{Data}->{TicketHistory} } ) {

            for my $HistoryEntry ( @{ $ResultEntry->{History} } ) {
                delete $HistoryEntry->{CreateTime};

                my $NameCheck = $CheckHistoryName->( %{$HistoryEntry}, %{ $Test->{ExtraParams} } );
                $Self->True(
                    $NameCheck,
                    "$Test->{Name} - Requester CheckHistory $HistoryEntry->{HistoryType} Name checked with Regex",
                );

                delete $HistoryEntry->{Name};
            }
        }
    }

    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnRemoteData},
        "$Test->{Name} - Requester success status (needs configured and running web server)",
    );

    if ( $Test->{ExpectedReturnLocalData} ) {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnLocalData},
            "$Test->{Name} - Local result matched with expected local call result.",
        );
    }
    else {
        $Self->IsDeeply(
            $LocalResult,
            $Test->{ExpectedReturnRemoteData},
            "$Test->{Name} - Local result matched with remote result.",
        );
    }

}

# delete web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Web Service $WebserviceID",
);

# delete tickets
for my $TicketID ( $TicketID1, $TicketID2 ) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

1;
