# --
# SOAP.t - GenericInterface transport interface tests for SOAP backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.t,v 1.5 2011-03-09 12:39:40 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Requester;
use Kernel::GenericInterface::Transport;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);

# add webservice to be used (empty config)
my $WebserviceObject = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create webservice object",
);
my $WebserviceName = 'SOAPTest' . $HelperObject->GetRandomID();
my $WebserviceID   = $WebserviceObject->WebserviceAdd(
    Name    => $WebserviceName,
    Config  => {},
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    "Added Webservice",
);

# prepare webservice config
my $RemoteSystem =
    $Self->{ConfigObject}->Get('HttpType')
    . '://'
    . $Self->{ConfigObject}->Get('FQDN')
    . '/'
    . $Self->{ConfigObject}->Get('ScriptAlias')
    . '/nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;
my $WebserviceConfig = {
    Name        => 'SOAPTest1',
    Description => 'Basic test for provider and requester using SOAP transport backend.',
    Debugger    => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otrs.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            PriorityIDName => {
                MappingInbound => {
                    Type   => 'Simple',
                    Config => {
                        KeyMapExact => {
                            PriorityID => 'PriorityName',
                            Data       => 'DataOut',
                        },
                        KeyMapDefault => {
                            MapType => 'Ignore',
                        },
                        ValueMap => {
                            PriorityName => {
                                ValueMapExact => {
                                    1 => '1 sehr niedrig',
                                    2 => '2 niedrig',
                                    3 => '3 normal',
                                    4 => '4 hoch',
                                    5 => '5 sehr hoch',
                                },
                            },
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                    },
                },
                MappingOutbound => {
                    Type   => 'Simple',
                    Config => {
                        KeyMapDefault => {
                            MapType => 'Keep',
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                        }
                },
                Type => 'Test::Test',
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
            PriorityIDName => {
                MappingInbound => {
                    Type   => 'Simple',
                    Config => {
                        KeyMapDefault => {
                            MapType => 'Keep',
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                    },
                },
                MappingOutbound => {
                    Type   => 'Simple',
                    Config => {
                        KeyMapExact => {
                            PriorityName => 'PriorityID',
                            DataIn       => 'Data',
                        },
                        KeyMapDefault => {
                            MapType => 'Ignore',
                        },
                        ValueMap => {
                            PriorityID => {
                                ValueMapExact => {
                                    '1 very low'  => 1,
                                    '2 low'       => 2,
                                    '3 normal'    => 3,
                                    '4 high'      => 4,
                                    '5 very high' => 5,
                                },
                            },
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                    },
                },
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update webservice with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceUpdate,
    "Updated Webservice $WebserviceID",
);

# add debugging
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    CommunicationType => 'Provider',
    WebserviceID      => $WebserviceID,
);
$Self->Is(
    'Kernel::GenericInterface::Debugger',
    ref $DebuggerObject,
    "Create debugger object",
);

my $RequestData = {
    PriorityName => '5 very high',
    DataIn       => {
        Blah => 'Fasel',
    },
};
my $ExpectedReturnData = {
    Success => 1,
    Data    => {
        PriorityName => '5 sehr hoch',
        DataOut      => {
            Blah => 'Fasel',
        },
    },
};

# create requester object
my $RequesterObject = Kernel::GenericInterface::Requester->new( %{$Self} );
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterObject,
    "Create requester object",
);

# start requester with our webservice
my $RequesterResult = $RequesterObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'PriorityIDName',
    Data         => $RequestData,
);

# check result
$Self->Is(
    'HASH',
    ref $RequesterResult,
    "Requester result structure is valid",
);
$Self->IsDeeply(
    $RequesterResult,
    $ExpectedReturnData,
    "Requester success status (needs configured and running webserver)",
);

# clean up webservice
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
$Self->True(
    $WebserviceDelete,
    "Deleted Webservice $WebserviceID",
);

1;
