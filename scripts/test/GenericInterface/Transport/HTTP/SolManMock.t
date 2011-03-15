# --
# SolManMock.t - GenericInterface transport interface tests for SolMan mock webservice
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SolManMock.t,v 1.4 2011-03-15 12:18:13 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
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
my $WebserviceName = 'SolManMock' . $HelperObject->GetRandomID();
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
    Name        => 'SolManMock',
    Description => 'Webservice mock for SolMan.',
    Debugger    => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SolManMock',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'urn:sap-com:document:sap:soap:functions:mc-style',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            RequestSystemGuid => {
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
            RequestGuid => {
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
            ReadCompleteIncident => {
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
                NameSpace => 'urn:sap-com:document:sap:soap:functions:mc-style',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
            },
        },
        Invoker => {
            RequestSystemGuid => {
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
                        KeyMapDefault => {
                            MapType => 'Keep',
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                    },
                },
                Type => 'Test::TestSimple',
            },
            RequestGuid => {
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
                        KeyMapDefault => {
                            MapType => 'Keep',
                        },
                        ValueMapDefault => {
                            MapType => 'Keep',
                        },
                    },
                },
                Type => 'Test::TestSimple',
            },
            ReadCompleteIncident => {
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
                        KeyMapDefault => {
                            MapType => 'Keep',
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

my @Tests = (
    {
        Name        => 'RequestSystemGuid',
        Invoker     => 'RequestSystemGuid',
        RequestData => {
            Dummy => 'Dummy',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Errors => {
                    item => {
                        ErrorCode => '?',
                        Val1      => '?',
                        Val2      => '?',
                        Val3      => '?',
                        Val4      => '?'
                    },
                },
                SystemGuid => '?',
            },
        },
    },
    {
        Name        => 'RequestGuid',
        Invoker     => 'RequestGuid',
        RequestData => {
            Dummy => 'Dummy',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Errors => {
                    item => {
                        ErrorCode => '?',
                        Val1      => '?',
                        Val2      => '?',
                        Val3      => '?',
                        Val4      => '?'
                    },
                },
                Guid => '?',
            },
        },
    },
    {
        Name        => 'ReadCompleteIncident',
        Invoker     => 'ReadCompleteIncident',
        RequestData => {
            Dummy => 'Dummy',
        },
        ExpectedReturnData => {
            Success => 1,
            Data    => {
                Errors => {
                    item => {
                        ErrorCode => '?',
                        Val1      => '?',
                        Val2      => '?',
                        Val3      => '?',
                        Val4      => '?'
                    },
                },
                IctAdditionalInfos => {
                    item => {
                        Guid             => '?',
                        ParentGuid       => '?',
                        AddInfoAttribute => '?',
                        AddInfoValue     => '?',
                    },
                },
                IctAttachments => {
                    item => {
                        AttachmentGuid => '?',
                        Filename       => '?',
                        MimeType       => '?',
                        Data           => 'cid:1020512061966',
                        Timestamp      => '?',
                        PersonId       => '?',
                        Url            => '?',
                        Language       => '?',
                    },
                },
                IctHead => {
                    IncidentGuid     => '?',
                    RequesterGuid    => '?',
                    ProviderGuid     => '?',
                    AgentId          => '?',
                    ReporterId       => '?',
                    ShortDescription => '?',
                    Priority         => '?',
                    Language         => '?',
                    RequestedBegin   => '?',
                    RequestedEnd     => '?',
                },
                IctPersons => {
                    item => {
                        PersonId    => '?',
                        PersonIdExt => '?',
                        Sex         => '?',
                        FirstName   => '?',
                        LastName    => '?',
                        Telephone   => {
                            PhoneNo          => '?',
                            PhoneNoExtension => '?',
                        },
                        MobilePhone => '?',
                        Fax         => {
                            FaxNo          => '?',
                            FaxNoExtension => '?',
                        },
                        Email => '?',
                    },
                },
                IctSapNotes => {
                    item => {
                        NoteId          => '?',
                        NoteDescription => '?',
                        Timestamp       => '?',
                        PersonId        => '?',
                        Url             => '?',
                        Language        => '?',
                    },
                },
                IctSolutions => {
                    item => {
                        SolutionId          => '?',
                        SolutionDescription => '?',
                        Timestamp           => '?',
                        PersonId            => '?',
                        Url                 => '?',
                        Language            => '?',
                    },
                },
                IctStatements => {
                    item => {
                        TextType => '?',
                        Texts    => {
                            item => '?',
                        },
                        Timestamp => '?',
                        PersonId  => '?',
                        Language  => '?',
                    },
                },
                IctStatus => '?',
                IctUrls   => {
                    item => {
                        UrlGuid        => '?',
                        Url            => '?',
                        UrlName        => '?',
                        UrlDescription => '?',
                        Timestamp      => '?',
                        PersonId       => '?',
                        Language       => '?',
                    },
                },
            },
        },

        # TODO: Inplement all Operations and Invokers?
    },
);

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

# create requester object
my $RequesterObject = Kernel::GenericInterface::Requester->new( %{$Self} );
$Self->Is(
    'Kernel::GenericInterface::Requester',
    ref $RequesterObject,
    "Create requester object",
);

for my $Test (@Tests) {

    # start requester with our webservice
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Invoker},
        Data         => $Test->{RequestData},
    );

    # check result
    $Self->Is(
        'HASH',
        ref $RequesterResult,
        "Test $Test->{Name}: Requester result structure is valid",
    );
    $Self->IsDeeply(
        $RequesterResult,
        $Test->{ExpectedReturnData},
        "Test $Test->{Name}: Requester success status (needs configured and running webserver)",
    );
}

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
