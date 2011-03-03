# --
# Serialize.t - SOAP Serialize tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Serialize.t,v 1.2 2011-03-03 15:48:25 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use SOAP::Lite;
use XML::TreePP;
use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Transport::HTTP::SOAP;

# create needed objects
my $XMLObject = XML::TreePP->new();

my @SoapTests = (
    {
        Name      => 'Scalar',
        Operation => 'MyOperation',
        Data      => {
            Var => 1,
        },
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
    },

    # TODO check why arrays are not working
    #    {
    #        Name      => 'Array',
    #        Operation => 'MyOperation',
    #        Data      => {
    #            Var => [1,2,3],
    #        },
    #    },
);

# loop trough the tests
for my $Test (@SoapTests) {

    # prepare data
    my @SOAPData = Kernel::GenericInterface::Transport::HTTP::SOAP->_SOAPOutputRecursion(
        Data => $Test->{Data},
    );

    # create return structure
    my $SOAPResult = SOAP::Data->value(@SOAPData);
    my $Content    = SOAP::Serializer
        ->autotype(0)
        ->readable(1)
        ->envelope( response => $Test->{Operation} . 'Response', $SOAPResult, );

    # convert soap XML back to perl structure for easy handling
    $XMLObject->set( attr_prefix => '' );
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
    $Self->Is(
        ref $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
        'HASH',
        "Test $Test->{Name}: SOAP Response structure",
    );

    $Self->True(
        IsHashRefWithData( $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' } ),
        "Test $Test->{Name}: SOAP Response structure have content",
    );

    # check for other soap components
    $Self->IsNot(
        $SoapEnvelope->{'xmlns:xsi'},
        '' || undef,
        "Test $Test->{Name}: SOAP Envelope component xmlns:xsi is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:soapenc'},
        '' || undef,
        "Test $Test->{Name}: SOAP Envelope component xmlns:soapenc is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:xsd'},
        '' || undef,
        "Test $Test->{Name}: SOAP Envelope component xmlns:xsd is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'soap:encodingStyle'},
        '' || undef,
        "Test $Test->{Name}: SOAP Envelope component soap:encodingStyle is not empty",
    );

    $Self->IsNot(
        $SoapEnvelope->{'xmlns:soap'},
        '' || undef,
        "Test $Test->{Name}: SOAP Envelope component xmlns:soap is not empty",
    );

    $Self->IsDeeply(
        $SoapEnvelope->{'soap:Body'}->{ $Test->{Operation} . 'Response' },
        $Test->{Data},
        "Test $Test->{Name}: SOAP Response data parsed as normal XML",
    );

    # deserialize with SOAP::Lite
    my $SOAPObject = eval { SOAP::Deserializer->deserialize($Content); };

    my $SOAPError = $@;
    $Self->False(
        $SOAPError,
        "Test $Test->{Name}: SOAP::Lite Deserialize",
    );

    my $SOAPBody = $SOAPObject->body();
    $Self->IsDeeply(
        $SOAPBody->{ $Test->{Operation} . 'Response' },
        $Test->{Data},
        "Test $Test->{Name}: SOAP Response data parsed as normal SOAP message",
    );
}

1;
