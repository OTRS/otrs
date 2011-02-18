# --
# Webservice.t - Webservice tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Webservice.t,v 1.11 2011-02-18 10:37:42 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
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
                Provider    => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Operation => [
                        {
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
                        {
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
                    ],
                },
                Requester => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::SOAP',
                        Config => {
                            NameSpace  => '',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint   => '',
                        },
                    },
                    Invokers => [
                        {
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
                        {
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
                    ],
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
                Provider    => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::SOAP',
                        Config => {
                            NameSpace  => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
                            SOAPAction => '',
                            Encoding   => '',
                            Endpoint =>
                                'iojfoiwjeofjweoj ojerojgv oiaejroitjvaioejhtioja viorjhiojgijairogj aiovtq348tu 08qrujtio juortu oquejrtwoiajdoifhaois hnaeruoigbo eghjiob jaer89ztuio45u603u4i9tj340856u903 jvipojziopeji',
                        },
                    },
                    Operation => [
                        {
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
                        {
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
                    ],
                },
                Requester => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::REST',
                        Config => {
                            NameSpace => '',
                            Encoding  => '',
                            Endpoint  => '',
                        },
                    },
                    Invokers => [
                        {
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
                    ],
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
                Provider  => {},
                Requester => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::REST',
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
                Provider    => {},
                Requester   => {
                    Transport => {
                        Module => 'Kernel::GenericInterface::Transport::HTTP::REST',
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
        $Test->{Add}->{Config},
        $Webservice->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
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
            "$Test->{Name} - WebserviceUpdate()",
        );
        next;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - WebserviceUpdate()",
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
        $Test->{Update}->{Config},
        $Webservice->{Config},
        "$Test->{Name} - WebserviceGet() - Config",
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
                $Test->{Add}->{Config},
                $WebserviceHistoryGet->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
        else {
            $Self->IsDeeply(
                $Test->{Update}->{Config},
                $WebserviceHistoryGet->{Config},
                "$Test->{Name} - WebserviceHistoryGet() - Config",
            );
        }
    }
}

# list check
my $List = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->True(
        scalar $List->{$WebserviceID},
        "WebserviceList() found Webservice $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->True(
        scalar @WebserviceHistoryList > 0,
        "WebserviceHistoryList() found entries for Webservice $WebserviceID",
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

# list check
$List = $WebserviceObject->WebserviceList( Valid => 0 );
for my $WebserviceID (@WebserviceIDs) {
    $Self->False(
        scalar $List->{$WebserviceID},
        "WebserviceList() did not find webservice $WebserviceID",
    );

    my @WebserviceHistoryList = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
    );

    $Self->True(
        scalar @WebserviceHistoryList == 0,
        "WebserviceHistoryList() found entries for Webservice $WebserviceID",
    );
    my @History = $WebserviceHistoryObject->WebserviceHistoryList(
        WebserviceID => $WebserviceID,
        UserID       => 1,
    );
    $Self->Is(
        scalar @History,
        0,
        'WebserviceHistoryList()',
    );
}

1;
