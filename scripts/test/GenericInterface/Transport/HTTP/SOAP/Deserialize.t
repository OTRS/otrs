# --
# Deserialize.t - Deserialize tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Deserialize.t,v 1.2 2011-03-03 17:13:28 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use SOAP::Lite;
use Kernel::System::VariableCheck qw(:all);
use Kernel::GenericInterface::Transport::HTTP::SOAP;

my $SOAPTagIni = '<soap:Envelope ' .
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' .
    'xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" ' .
    'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' .
    'soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" ' .
    'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' .
    '<soap:Body>';
my $SOAPTagEnd = '</soap:Body></soap:Envelope>';

my @Tests = (
    {
        Name      => 'Test 1',
        Data      => '<Simple>Test</Simple>',
        Operation => 'Response',
        Success   => '1',
        Result    => {
            'Simple' => 'Test'
        },
    },
    {
        Name      => 'Test 2',
        Data      => '<fooResponse><bar>abcd</bar></fooResponse>',
        Operation => 'Response',
        Success   => '1',
        Result    => {
            'fooResponse' => {
                'bar' => 'abcd'
                }
        },
    },
);

for my $Test (@Tests) {
    my $SuccessCounter = 0;

    # deserialize
    my $Deserialized = eval {
        SOAP::Deserializer->deserialize(
            $SOAPTagIni . $Test->{Data} . $SOAPTagEnd
        );
    };
    my $DeserializerError = $@;
    if ( !$Test->{Success} ) {
        $Self->True(
            $DeserializerError,
            "$Test->{Name} - SOAP::Deserializer",
        );
        next;
    }
    else {
        $Self->False(
            $DeserializerError,
            "$Test->{Name} - SOAP::Deserializer",
        );
    }

    my $Body = $Deserialized->body();
    $Self->IsDeeply(
        \$Test->{Result},
        \$Body,
        "$Test->{Name} - Deserialize",
    );

    # serializer
    my @SOAPData = Kernel::GenericInterface::Transport::HTTP::SOAP->_SOAPOutputRecursion(
        Data => $Body,
    );

    # create return structure
    my $SOAPResult = SOAP::Data->value( \@SOAPData );
    my $Content    = SOAP::Serializer
        ->autotype(0)
        ->envelope( response => $Test->{Operation}, $SOAPResult, );

    my $ExpectedResult =
        '<?xml version="1.0" encoding="UTF-8"?>' .
        $SOAPTagIni . '<' . $Test->{Operation} . '>' .
        $Test->{Data} .
        '</' . $Test->{Operation} . '>' .
        $SOAPTagEnd;

    $Self->Is(
        $Content,
        $ExpectedResult,
        "$Test->{Name} - Deserialize",
    );

}

#sub _SOAPOutputRecursion {
#    my ( $Self, %Param ) = @_;
#
#    my @Result;
#    if ( IsArrayRefWithData( $Param{Data} ) ) {
#        for my $Key ( @{ $Param{Data} } ) {
#            push @Result, \SOAP::Data->value(
#                $Self->_SOAPOutputRecursion( Data => $Key )
#            );
#        }
#        return @Result;
#    }
#    if ( IsHashRefWithData( $Param{Data} ) ) {
#        for my $Key ( sort keys %{ $Param{Data} } ) {
#            my $Value;
#            if ( IsString( $Param{Data}->{$Key} ) ) {
#                $Value = $Param{Data}->{$Key} || '';
#            }
#            elsif ( IsHashRefWithData( $Param{Data}->{$Key} ) ) {
#                $Value = \SOAP::Data->value(
#                    $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} )
#                );
#            }
#            elsif ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {
#                $Value = SOAP::Data->value(
#                    $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} )
#                );
#            }
#            push @Result, SOAP::Data->name($Key)->value($Value);
#        }
#        return @Result;
#    }
#}

# end tests

1;
