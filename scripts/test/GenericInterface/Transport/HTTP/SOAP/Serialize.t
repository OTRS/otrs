# --
# Serialize.t - SOAP Serialize tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use SOAP::Lite;
use XML::TreePP;
use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport::HTTP::SOAP;
use Kernel::System::UnitTest::Helper;

# helper object
# skip SSL certiciate verification
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
    SkipSSLVerify              => 1,
);

# create soap object to use the soap output recursion
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'error',
        TestMode       => 1,
    },
    CommunicationType => 'requester',
    WebserviceID      => 1,             # not used
);
my $SOAPObject = Kernel::GenericInterface::Transport::HTTP::SOAP->new(
    %{$Self},
    DebuggerObject  => $DebuggerObject,
    TransportConfig => {
        Config => undef,
    },
);

# create needed objects
my $XMLObject = XML::TreePP->new();

my $SOAPHeader = '<?xml version="1.0" encoding="UTF-8"?>'
    . '<soap:Envelope '
    . 'soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" '
    . 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" '
    . 'xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" '
    . 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
    . 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
    . '<soap:Body>';

my $SOAPFooter = '</soap:Body>'
    . '</soap:Envelope>';

my @SoapTests = (
    {
        Name      => 'Undefined data Fail',
        Operation => 'MyOperation',
        Data      => undef,
        XML       => '',
        Success   => 0,
    },
    {
        Name      => 'Empty',
        Operation => 'MyOperation',
        Data      => {},
        XML       => '',
        Success   => 1,
        IsEmpty   => 1
    },
    {
        Name      => 'Scalar',
        Operation => 'MyOperation',
        Data      => {
            Var => 1,
        },
        XML     => '<Var>1</Var>',
        Success => 1,
    },
    {
        Name      => 'Scalar Unicode',
        Operation => 'MyOperation',
        Data      => {
            Var => 'äöüß€ис',
        },
        XML     => '<Var>äöüß€ис</Var>',
        Success => 1,
    },
    {
        Name      => 'Hash',
        Operation => 'MyOperation',
        Data      => {
            Var => {
                Number => 2,
                String => 'foo',
                Hash   => {
                    Key1 => 1,
                    Key2 => 2,
                },
            },
        },
        XML => '<Var>'
            . '<Hash>'
            . '<Key1>1</Key1>'
            . '<Key2>2</Key2>'
            . '</Hash>'
            . '<Number>2</Number>'
            . '<String>foo</String>'
            . '</Var>',
        Success => 1,
    },
    {
        Name      => 'Hash Unicode',
        Operation => 'MyOperation',
        Data      => {
            PriorityName => '5 sehr hoch',
            DataOut      => {
                Blah   => 'Fasel',
                Umlaut => 'äöüßÄÖÜ€ис',
            },
        },
        XML => '<DataOut>'
            . '<Blah>Fasel</Blah>'
            . '<Umlaut>äöüßÄÖÜ€ис</Umlaut>'
            . '</DataOut>'
            . '<PriorityName>5 sehr hoch</PriorityName>',
        Success => 1,
    },
    {
        Name      => 'Custom sorted hash',
        Operation => 'MyOperation',
        Data      => {
            Var => {
                String => 'foo',
                Hash   => {
                    Key1 => 1,
                    Key2 => 2,
                },
                Number => 2,
            },
        },
        Sort => [
            {
                Var => [
                    {
                        Number => undef,
                    },
                    {
                        String => undef,
                    },
                    {
                        Hash => [
                            {
                                Key2 => undef,
                            },
                            {
                                Key1 => undef,
                            },
                        ],
                    },
                ],
            },
        ],
        XML => '<Var>'
            . '<Number>2</Number>'
            . '<String>foo</String>'
            . '<Hash>'
            . '<Key2>2</Key2>'
            . '<Key1>1</Key1>'
            . '</Hash>'
            . '</Var>',
        Success => 1,
    },
    {
        Name      => 'Array',
        Operation => 'MyOperation',
        Data      => {
            Var => [ 1, 2, 3 ],
        },
        XML => '<Var>1</Var>'
            . '<Var>2</Var>'
            . '<Var>3</Var>',
        Success => 1,
    },
    {
        Name      => 'Complex',
        Operation => 'MyOperation',
        Data      => {
            Var => [
                1,
                {
                    Hash => {
                        Key1 => [ 1, 2 ],
                        Key3 => 1,
                        Key4 => {
                            Key5 => 'Hash',
                        },
                    },
                },
            ],
        },
        XML => '<Var>1</Var>'
            . '<Var>'
            . '<Hash>'
            . '<Key1>1</Key1>'
            . '<Key1>2</Key1>'
            . '<Key3>1</Key3>'
            . '<Key4>'
            . '<Key5>Hash</Key5>'
            . '</Key4>'
            . '</Hash>'
            . '</Var>',
        Success => 1,
    },
    {
        Name      => 'Complex sorted',
        Operation => 'MyOperation',
        Data      => {
            Var => [
                1,
                {
                    Hash => {
                        Key1 => [ 1, 2 ],
                        Key3 => 1,
                        Key4 => {
                            Key5 => 'Hash',
                        },
                    },
                },
            ],
        },
        Sort => [
            {
                Var => [
                    1,
                    [
                        {
                            Hash => [
                                {
                                    Key3 => 1,
                                },
                                {
                                    Key4 => [
                                        {
                                            Key5 => 'Hash',
                                        },
                                    ],
                                },
                                {
                                    Key1 => [ 1, 2 ],
                                },
                            ],
                        },
                    ],
                ],
            },
        ],
        XML => '<Var>1</Var>'
            . '<Var>'
            . '<Hash>'
            . '<Key3>1</Key3>'
            . '<Key4>'
            . '<Key5>Hash</Key5>'
            . '</Key4>'
            . '<Key1>1</Key1>'
            . '<Key1>2</Key1>'
            . '</Hash>'
            . '</Var>',
        Success => 1,
    },
    {
        Name      => 'ArrayRef inside ArrayRef Fail',
        Operation => 'MyOperation',
        Data      => {
            Var => [
                1,
                Hash => {
                    Key1 => [ 1, 2 ],
                    Key3 => 1,
                    Key4 => {
                        Key5 => 'Hash',
                    },
                },
                [
                    1,
                    2,
                    3
                ],
            ],
        },
        XML     => ' ',
        Success => 0,
    },
);

# loop trough the tests
TEST:
for my $Test (@SoapTests) {

    my $SOAPResult;

    # prepare data
    if ( defined $Test->{Data} && IsHashRefWithData( $Test->{Data} ) ) {
        my $SOAPData = $SOAPObject->_SOAPOutputRecursion(
            Data => $Test->{Data},
            Sort => $Test->{Sort},
        );
        if ( $SOAPData->{Success} ) {
            $SOAPResult = SOAP::Data->value( @{ $SOAPData->{Data} } );
        }
        else {
            $Self->Is(
                $SOAPData->{ErrorMessage},
                undef,
                "Test $Test->{Name}: soap output recursion failure",
            );
            next TEST;
        }
    }

    # create return structure
    my @CallData = ( 'response', $Test->{Operation} . 'Response' );
    if ($SOAPResult) {
        push @CallData, $SOAPResult;
    }
    my $Content = SOAP::Serializer
        ->autotype(0)
        ->envelope(@CallData);
    my $SerializedFault = $@ || '';
    $Self->Is(
        $SerializedFault,
        '',
        "Test $Test->{Name}: Serializer success",
    );

    # create an XML file to compare the expected results
    my $SOAPRawContent;
    if ( $Test->{XML} ) {
        $SOAPRawContent = $SOAPHeader
            . '<' . $Test->{Operation} . 'Response' . '>'
            . $Test->{XML}
            . '</' . $Test->{Operation} . 'Response' . '>'
            . $SOAPFooter;
    }
    else {
        $SOAPRawContent = $SOAPHeader
            . '<' . $Test->{Operation} . 'Response' . '/>'
            . $SOAPFooter;
    }

    # convert soap XML back to perl structure for easy handling
    $XMLObject->set( attr_prefix => '' );
    if ( $Test->{IsEmpty} ) {

        # clean xml ('null' tag is interpreted by xml parser)
        $Content =~ s{ [ ] xsi:nil="true" [ ] }{}xms;
    }
    my $XMLContent = $XMLObject->parse($Content);

    # check soap message
    $Self->Is(
        ref $XMLContent,
        'HASH',
        "Test $Test->{Name}: SOAP Message structure",
    );

    $Self->True(
        IsHashRefWithData($XMLContent),
        "Test $Test->{Name}: SOAP Message structure have content",
    );

    my $SoapEnvelope = $XMLContent->{'soap:Envelope'};

    # check soap envelope
    $Self->Is(
        ref $SoapEnvelope,
        'HASH',
        "Test $Test->{Name}: SOAP Envelope structure",
    );

    $Self->True(
        IsHashRefWithData($SoapEnvelope),
        "Test $Test->{Name}: SOAP Envelope structure have content",
    );

    # check soap:Body
    $Self->Is(
        ref $SoapEnvelope->{'soap:Body'},
        'HASH',
        "Test $Test->{Name}: SOAP Body structure",
    );

    $Self->True(
        IsHashRefWithData( $SoapEnvelope->{'soap:Body'} ),
        "Test $Test->{Name}: SOAP Body structure have content",
    );

    # check soap:Body Response
    if ( $Test->{IsEmpty} ) {
        $Self->True(
            exists $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
            "Test $Test->{Name}: SOAP Response structure (exists)",
        );
        $Self->False(
            defined $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
            "Test $Test->{Name}: SOAP Response structure (defined)",
        );
    }
    else {
        $Self->Is(
            ref $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
            'HASH',
            "Test $Test->{Name}: SOAP Response structure",
        );

        $Self->True(
            IsHashRefWithData( $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' } ),
            "Test $Test->{Name}: SOAP Response structure have content",
        );
    }

    # check for other soap components
    $Self->IsNot(
        $SoapEnvelope->{'xmlns:xsi'},
        '',
        "Test $Test->{Name}: SOAP Envelope component xmlns:xsi is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:soapenc'},
        '',
        "Test $Test->{Name}: SOAP Envelope component xmlns:soapenc is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:xsd'},
        '',
        "Test $Test->{Name}: SOAP Envelope component xmlns:xsd is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'soap:encodingStyle'},
        '',
        "Test $Test->{Name}: SOAP Envelope component soap:encodingStyle is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:soap'},
        '',
        "Test $Test->{Name}: SOAP Envelope component xmlns:soap is not empty",
    );

    # deserialize with SOAP::Lite
    my $SOAPObject = eval { SOAP::Deserializer->deserialize($Content); };
    my $SOAPError = $@;

    $Self->Is(
        $SOAPError,
        '',
        "Test $Test->{Name}: SOAP::Lite Deserialize with no errors",
    );

    if ( $Test->{Success} ) {
        $Self->Is(
            $Content,
            $SOAPRawContent,
            "Test $Test->{Name}: SOAP Response data raw as normal XML IsDeeply",
        );

        if ( $Test->{IsEmpty} ) {
            $Self->True(
                exists $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
                "Test $Test->{Name}: SOAP Response data parsed as normal XML True (exists)",
            );
            $Self->False(
                defined $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
                "Test $Test->{Name}: SOAP Response data parsed as normal XML True (defined)",
            );
        }
        elsif ( !$Test->{Sort} ) {
            $Self->IsDeeply(
                $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
                $Test->{Data},
                "Test $Test->{Name}: SOAP Response data parsed as normal XML IsDeeply",
            );
        }

        my $SOAPBody = $SOAPObject->body();
        if ( $Test->{IsEmpty} ) {
            $Self->IsDeeply(
                $SOAPBody->{ $Test->{Operation} . 'Response' },
                '',
                "Test $Test->{Name}: SOAP Response data parsed as SOAP message IsDeeply (emptystring)",
            );
        }
        elsif ( !$Test->{Sort} ) {
            $Self->IsDeeply(
                $SOAPBody->{ $Test->{Operation} . 'Response' },
                $Test->{Data},
                "Test $Test->{Name}: SOAP Response data parsed as SOAP message IsDeeply",
            );
        }
    }
    else {
        if ( $Test->{IsEmpty} ) {
            $Self->IsDeeply(
                $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
                $Test->{Data},
                "Test $Test->{Name}: Special case when Data is empty "
                    . "SOAP Response data parsed as normal XML IsDeeply",
            );
        }
        else {
            $Self->IsNotDeeply(
                $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
                $Test->{Data},
                "Test $Test->{Name}: SOAP Response data parsed as normal XML IsNotDeeply",
            );
        }

        my $SOAPBody = $SOAPObject->body();
        if ( !defined $Test->{Data} ) {
            $Self->True(
                exists $SOAPBody->{ $Test->{Operation} . 'Response' },
                "Test $Test->{Name}: SOAP Response data parsed as SOAP message True (exists)",
            );
            $Self->False(
                defined $SOAPBody->{ $Test->{Operation} . 'Response' },
                "Test $Test->{Name}: SOAP Response data parsed as SOAP message False (defined)",
            );
        }
        else {
            $Self->IsNotDeeply(
                $SOAPBody->{ $Test->{Operation} . 'Response' },
                $Test->{Data},
                "Test $Test->{Name}: SOAP Response data parsed as SOAP message IsNotDeeply",
            );
        }
    }
}

1;
