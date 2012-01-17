# --
# TicketGet.t - TicketConnector interface tests for TicketConnector backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: TicketGet.t,v 1.8 2012-01-17 18:24:18 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Requester;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;
use Kernel::GenericInterface::Operation::Ticket::TicketGet;
use Kernel::GenericInterface::Operation::Ticket::SessionIDGet;
use Kernel::System::VariableCheck qw(:all);

# helper object
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);

#get a random id
my $RandomID = $HelperObject->GetRandomID();

# create local config object
my $ConfigObject = Kernel::Config->new();

# disable CheckEmailInvalidAddress setting
$ConfigObject->Set(
    Key   => 'CheckEmailInvalidAddress',
    Value => 0,
);

# new user object
my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create a new user for current test
$Self->{UserID} = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $Self->{UserID},
    'User Add ()',
);

# create ticket object
my $TicketObject = Kernel::System::Ticket->new( %{$Self} );

# create 3 tickets

# create ticket 1
my $TicketIDOne = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketIDOne,
    "TicketCreate() successful for Ticket One ID $TicketIDOne",
);

# get the Ticket entry
my %TicketEntryOne = $TicketObject->TicketGet(
    TicketID      => $TicketIDOne,
    DynamicFields => 0,
    UserID        => $Self->{UserID},
);

$Self->True(
    IsHashRefWithData( \%TicketEntryOne ),
    "TicketGet() successful for Local TicketGet One ID $TicketIDOne",
);

for my $Key ( keys %TicketEntryOne ) {
    if ( !$TicketEntryOne{$Key} ) {
        $TicketEntryOne{$Key} = '';
    }
    if ( $Key eq 'Age' ) {
        delete $TicketEntryOne{$Key};
    }
}

# create ticket 2
my $TicketIDTwo = $TicketObject->TicketCreate(
    Title        => 'Ticket Two Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerTwo@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketIDTwo,
    "TicketCreate() successful for Ticket Two ID $TicketIDTwo",
);

# get the Ticket entry
my %TicketEntryTwo = $TicketObject->TicketGet(
    TicketID      => $TicketIDTwo,
    DynamicFields => 0,
    UserID        => $Self->{UserID},
);

$Self->True(
    IsHashRefWithData( \%TicketEntryTwo ),
    "TicketGet() successful for Local TicketGet Two ID $TicketIDTwo",
);

for my $Key ( keys %TicketEntryTwo ) {
    if ( !$TicketEntryTwo{$Key} ) {
        $TicketEntryTwo{$Key} = '';
    }
    if ( $Key eq 'Age' ) {
        delete $TicketEntryTwo{$Key};
    }
}

# create ticket 3
my $TicketIDThree = $TicketObject->TicketCreate(
    Title        => 'Ticket Three Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customerThree@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketIDThree,
    "TicketCreate() successful for Ticket Three ID $TicketIDThree",
);

# get the Ticket entry
my %TicketEntryThree = $TicketObject->TicketGet(
    TicketID      => $TicketIDThree,
    DynamicFields => 0,
    UserID        => $Self->{UserID},
);

$Self->True(
    IsHashRefWithData( \%TicketEntryThree ),
    "TicketGet() successful for Local TicketGet Three ID $TicketIDThree",
);

for my $Key ( keys %TicketEntryThree ) {
    if ( !$TicketEntryThree{$Key} ) {
        $TicketEntryThree{$Key} = '';
    }
    if ( $Key eq 'Age' ) {
        delete $TicketEntryThree{$Key};
    }
}

# set webservice name
my $WebserviceName = '-Test-' . $RandomID;

# create webservice object
my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create webservice object",
);

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name    => $WebserviceName,
    Config  => {},
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added Webservice",
);

# get remote host with some precautions for certain unit test systems
my $Host;
my $FQDN = $Self->{ConfigObject}->Get('FQDN');

# try to resolve fqdn host
if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
    $Host = $FQDN;
}

# try to resolve localhost instead
if ( !$Host && gethostbyname('localhost') ) {
    $Host = 'localhost';
}

# use hardcoded localhost ip address
if ( !$Host ) {
    $Host = '127.0.0.1';
}

# prepare webservice config
my $RemoteSystem =
    $Self->{ConfigObject}->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $Self->{ConfigObject}->Get('ScriptAlias')
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
            TicketGet => {
                Type => 'Ticket::TicketGet',
            },
            SessionIDGet => {
                Type => 'Ticket::SessionIDGet',
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
            },
        },
        Invoker => {
            TicketGet => {
                Type => 'Test::TestSimple',
            },
            SessionIDGet => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update webservice with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $Self->{UserID},
);
$Self->True(
    $WebserviceUpdate,
    "Updated Webservice $WebserviceID - $WebserviceName",
);

# Get SessionID
# create requester object
my $RequesterSessionObject = Kernel::GenericInterface::Requester->new( %{$Self} );
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterSessionObject,
    "SessionID - Create requester object",
);

# start requester with our webservice
my $UserLogin              = 'TestUser' . $RandomID;
my $Password               = 'some-pass';
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionIDGet',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};
my @Tests        = (
    {
        Name                    => 'Test 1',
        SuccessRequest          => 1,
        RequestData             => {},
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketGet.MissingParameter',
                    ErrorMessage => 'TicketGet: TicketID parameter is missing!'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketGet.MissingParameter',
                    ErrorMessage => 'TicketGet: TicketID parameter is missing!'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test 2',
        SuccessRequest => 1,
        RequestData    => {
            TicketID => 'NotTicketID',
        },
        ExpectedReturnLocalData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.NotValidTicketID',
                    ErrorMessage =>
                        'TicketGet: Could not get Ticket data in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()'
                    }
            },
            Success => 1
        },
        ExpectedReturnRemoteData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketGet.NotValidTicketID',
                    ErrorMessage =>
                        'TicketGet: Could not get Ticket data in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()'
                    }
            },
            Success => 1
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test 3',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketIDOne,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Item => {
                    Ticket => {%TicketEntryOne},
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Item => [
                    {
                        Ticket => {%TicketEntryOne},
                    }
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test 4',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketIDTwo,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Item => {
                    Ticket => {%TicketEntryTwo},
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Item => [
                    {
                        Ticket => {%TicketEntryTwo},
                    }
                ],
            },
        },
        Operation => 'TicketGet',
    },
    {
        Name           => 'Test 4',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketIDThree,
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                Item => {
                    Ticket => {%TicketEntryThree},
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                Item => [
                    {
                        Ticket => {%TicketEntryThree},
                    }
                ],
            },
        },
        Operation => 'TicketGet',
    },

);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
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
    'DebuggerObject instanciate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        %{$Self},
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
    );

    $Self->Is(
        "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}",
        ref $LocalObject,
        "$Test->{Name} - Create local object",
    );

    # start requester with our webservice
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            UserLogin => $UserLogin,
            Password  => $Password,
            %{ $Test->{RequestData} },
            }
    );

    # check result
    $Self->Is(
        'HASH',
        ref $LocalResult,
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = Kernel::GenericInterface::Requester->new( %{$Self} );
    $Self->Is(
        'Kernel::GenericInterface::Requester',
        ref $RequesterObject,
        "$Test->{Name} - Create requester object",
    );

    # start requester with our webservice
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            SessionID => $NewSessionID,
            %{ $Test->{RequestData} },
            }
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

    # workaround because results from direct call and
    # from SOAP call are a little bit different
    if ( $Test->{Operation} eq 'TicketGet' ) {

        if ( ref $LocalResult->{Data}->{Item} eq 'ARRAY' ) {
            for my $Item ( @{ $LocalResult->{Data}->{Item} } ) {
                for my $Key ( keys %{ $Item->{Ticket} } ) {
                    if ( !$Item->{Ticket}->{$Key} ) {
                        $Item->{Ticket}->{$Key} = '';
                    }
                    if ( $Key eq 'Age' ) {
                        delete $Item->{Ticket}->{$Key};
                    }
                }
            }
        }

        if (
            defined $RequesterResult->{Data}
            && defined $RequesterResult->{Data}->{Item}
            )
        {
            if ( ref $RequesterResult->{Data}->{Item} eq 'ARRAY' ) {
                for my $Item ( @{ $RequesterResult->{Data}->{Item} } ) {
                    for my $Key ( keys %{ $Item->{Ticket} } ) {
                        if ( !$Item->{Ticket}->{$Key} ) {
                            $Item->{Ticket}->{$Key} = '';
                        }
                        if ( $Key eq 'Age' ) {
                            delete $Item->{Ticket}->{$Key};
                        }
                    }
                }
            }
            elsif ( ref $RequesterResult->{Data}->{Item} eq 'HASH' ) {
                for my $Key ( keys %{ $RequesterResult->{Data}->{Item}->{Ticket} } ) {
                    if ( !$RequesterResult->{Data}->{Item}->{Ticket}->{$Key} ) {
                        $RequesterResult->{Data}->{Item}->{Ticket}->{$Key} = '';
                    }
                    if ( $Key eq 'Age' ) {
                        delete $RequesterResult->{Data}->{Item}->{Ticket}->{$Key};
                    }
                }
            }
        }

    }

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnRemoteData},
        "$Test->{Name} - Requester success status (needs configured and running webserver)",
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

}    #end loop

# clean up webservice
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $Self->{UserID},
);
$Self->True(
    $WebserviceDelete,
    "Deleted Webservice $WebserviceID",
);

# delete the ticket One
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketIDOne,
    UserID   => $Self->{UserID},
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket One ID $TicketIDOne",
);

# delete the ticket Two
$TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketIDTwo,
    UserID   => $Self->{UserID},
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket Two ID $TicketIDTwo",
);

# delete the ticket Three
$TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketIDThree,
    UserID   => $Self->{UserID},
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket Three ID $TicketIDThree",
);

1;
