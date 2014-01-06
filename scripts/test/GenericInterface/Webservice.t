# --
# Webservice.t - Webservice tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Webservice.t,v 1.15 2011-03-18 12:57:24 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::WebserviceHistory;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

my $WebserviceObject        = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $WebserviceHistoryObject = Kernel::System::GenericInterface::WebserviceHistory->new( %{$Self} );

my @Tests = (
    {
        Name          => 'test 1',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Operation => {
                        Operation1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                        Operation2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Invokers => {
                        Invoker1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                        Invoker2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 1,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type   => 'HTTP::SOAP',
                        Config => {
                            NameSpace  => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint =>
                                'iojfoiwjeofjweoj ojerojgv oiaejroitjvaioejhtioja viorjhiojgijairogj aiovtq348tu 08qrujtio juortu oquejrtwoiajdoifhaois hnaeruoigbo eghjiob jaer89ztuio45u603u4i9tj340856u903 jvipojziopeji',
                        },
                    },
                    Operation => {
                        Operation1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                        Operation2 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                        },
                    },
                },
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                    Invokers => {
                        Invoker1 => {
                            Mapping => {
                                Inbound => {
                                    1 => 2,
                                    2 => 4,
                                },
                                Outbound => {
                                    1 => 2,
                                    2 => 5,
                                },
                            },
                            Type => 'Test::Test',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 3',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        HistoryCount  => 2,
        Add           => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => { 1 => 1 },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 4',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        HistoryCount  => 2,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.'
                    . "\nasdkaosdkoa\tsada\n",
                Debugger => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider  => {},
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 4',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 0,
        Add           => {
            Config => {
                Name        => 'Nagios',
                Description => 'Connector to send and receive date from Nagios 2.',
                Debugger    => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider  => {},
                Requester => {
                    Transport => {
                        Type   => 'HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                },
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 5',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        HistoryCount  => 0,
        Add           => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
);

my @WebserviceIDs;
for my $Test (@Tests) {

    # add config
    my $WebserviceID = $WebserviceObject->WebserviceAdd(
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Add} }
    );
    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $WebserviceID,
            "$Test->{Name} - WebserviceAdd()",
        );
        next;
    }
    else {
        $Self->True(
            $WebserviceID,
            "$Test->{Name} - WebserviceAdd()",
        );
    }

    # remember id to delete it later
    push @WebserviceIDs, $WebserviceID;

    # get config
    my $Webservice = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $Webservice->{Name},
        "$Test->{Name} - WebserviceGet()",
    );
    $Self->IsDeeply(
        $Webservice->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
    );

    my $WebserviceByName = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByName,
        \$Webservice,
        "$Test->{Name} - WebserviceGet() with Name parameter result",
    );

    # get config from cache
    my $WebserviceFromCache = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # verify config from cache
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $WebserviceFromCache->{Name},
        "$Test->{Name} - WebserviceGet() from cache",
    );
    $Self->IsDeeply(
        $WebserviceFromCache->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - WebserviceGet() from cache- Config",
    );

    $Self->IsDeeply(
        $Webservice,
        $WebserviceFromCache,
        "$Test->{Name} - WebserviceGet() - Cache and DB",
    );

    my $WebserviceByNameFromCache = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByNameFromCache,
        \$WebserviceFromCache,
        "$Test->{Name} - WebserviceGet() with Name parameter result from cache",
    );

    # update config with a modification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID   => $WebserviceID,
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Update} }
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - WebserviceUpdate() False",
        );
        next;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - WebserviceUpdate() True",
        );
    }

    # get config
    $Webservice = $WebserviceObject->WebserviceGet(
        ID     => $WebserviceID,
        UserID => 1,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $Webservice->{Name},
        "$Test->{Name} - WebserviceGet()",
    );
    $Self->IsDeeply(
        $Webservice->{Config},
        $Test->{Update}->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
    );

    $WebserviceByName = $WebserviceObject->WebserviceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$WebserviceByName,
        \$Webservice,
        "$Test->{Name} - WebserviceGet() with Name parameter result",
    );

    # history check
    my @History = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
        UserID       => 1,
    );
    $Self->Is(
        scalar @History,
        $Test->{HistoryCount},
        "$Test->{Name} - WebserviceHistoryList()",
    );

    for my $Count ( 0 .. 1 ) {
        next if !$History[$Count];
        my $WebserviceHistoryGet = $WebserviceHistoryObject->WebserviceHistoryGet(
            ID => $History[$Count],
        );
        if ( $Count == 1 ) {
            $Self->IsDeeply(
                $WebserviceHistoryGet->{Config},
                $Test->{Add}->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
        else {
            $Self->IsDeeply(
                $WebserviceHistoryGet->{Config},
                $Test->{Update}->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
    }

    # verify if cache was also updated
    if ( $Test->{SuccessUpdate} ) {
        my $WebserviceUpdateFromCache = $WebserviceObject->WebserviceGet(
            ID     => $WebserviceID,
            UserID => 1,
        );

        # verify config from cache
        $Self->Is(
            $Test->{Name} . ' ' . $RandomID,
            $WebserviceUpdateFromCache->{Name},
            "$Test->{Name} - WebserviceGet() from cache",
        );
        $Self->IsDeeply(
            $WebserviceUpdateFromCache->{Config},
            $Test->{Update}->{Config},
            "$Test->{Name} - WebserviceGet() from cache- Config",
        );
    }
}

# list check from DB
my $WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->True(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from DB found Webservice $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->True(
        scalar @WebserviceHistoryList > 0,
        "WebserviceHistoryList() found entries for Webservice $WebserviceID",
    );
}

# list check from cache
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->True(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from Cache found Webservice $WebserviceID",
    );
}

# delete config
for my $WebserviceID (@WebserviceIDs) {
    my $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "WebserviceDelete() deleted Webservice $WebserviceID",
    );
    $Success = $WebserviceObject->WebserviceDelete(
        ID     => $WebserviceID,
        UserID => 1,
    );
    $Self->False(
        $Success,
        "WebserviceDelete() deleted Webservice $WebserviceID",
    );
}

# list check from DB
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->False(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() did not find webservice $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->False(
        scalar @WebserviceHistoryList,
        "WebserviceHistoryList() from DB found entries for Webservice $WebserviceID",
    );
    my @History = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
        UserID       => 1,
    );
    $Self->False(
        scalar @History,
        'WebserviceHistoryList()',
    );
}

# list check from cache
$WebserviceList = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->False(
        scalar $WebserviceList->{$WebserviceID},
        "WebserviceList() from cache did not find webservice $WebserviceID",
    );
}

1;
