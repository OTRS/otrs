# --
# Kernel/GenericInterface/Transport/HTTP/SolManMock.pm - GenericInterface network transport mock interface for SolMan webservice
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SolManMock.pm,v 1.6 2011-03-16 04:19:26 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SolManMock;

use strict;
use warnings;

use Kernel::System::Web::Request;

use HTTP::Status;
use HTTP::Response;
use SOAP::Lite;
use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (
        qw(LogObject EncodeObject ConfigObject MainObject DebuggerObject TransportConfig)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!"
        };
    }

    return $Self;
}

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return $Self->_Error(
            Summary   => 'Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace config
    if ( !IsStringWithData( $Config->{NameSpace} ) ) {
        return $Self->_Error(
            Summary   => 'Have no NameSpace in config',
            HTTPError => 500,
        );
    }

    # check basic stuff
    my $Length = $ENV{'CONTENT_LENGTH'};

    # no length provided
    if ( !$Length ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(411),
            HTTPError => 411,
        );
    }

    # request bigger than allowed
    if ( IsInteger( $Config->{MaxLength} ) && $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(413),
            HTTPError => 413,
        );
    }

    # in case client requests to continue submission, tell it to continue
    if ( IsStringWithData( $ENV{EXPECT} ) && $ENV{EXPECT} =~ m{ \b 100-Continue \b }xmsi ) {
        $Self->_Output(
            HTTPCode => 100,
            Content  => '',
        );
    }

    # do we have a soap action header?
    my $NameSpaceFromHeader;
    my $OperationFromHeader;
    if ( $ENV{'HTTP_SOAPACTION'} ) {
        my ($SOAPAction) = $ENV{'HTTP_SOAPACTION'} =~ m{ \A ["'] ( .+ ) ["'] \z }xms;

        # get namespace and operation from soap action
        if ( IsStringWithData($SOAPAction) ) {
            my ( $NameSpaceFromHeader, $OperationFromHeader ) = $ENV{'HTTP_SOAPACTION'} =~ m{
                \A
                ( .+? )
                [#/]
                ( [^#/]+ )
                \z
            }xms;
            if ( !$NameSpaceFromHeader || !$OperationFromHeader ) {
                return $Self->_Error(
                    Summary   => "Invalid SOAPAction '$SOAPAction'",
                    HTTPError => 500,
                );
            }
        }
    }

    # check namespace for match to configuration
    if ( $NameSpaceFromHeader && $NameSpaceFromHeader ne $Config->{NameSpace} ) {
        $Self->{DebuggerObject}->Notice(
            Summary =>
                "Namespace from SOAPAction '$NameSpaceFromHeader' does not match namespace"
                . " from configuration '$Config->{NameSpace}'",
        );
    }

    # read request
    my $Content;
    read STDIN, $Content, $Length;

    # convert charset if necessary
    my $ContentCharset = $1
        if $ENV{'CONTENT_TYPE'} =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi;
    if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
        $Content = $Self->{EncodeObject}->Convert2CharsetInternal(
            Text => $Content,
            From => $ContentCharset,
        );
    }

    # check if we have a content
    if ( !IsStringWithData($Content) ) {
        return $Self->_Error(
            Summary   => 'Could not read input data',
            HTTPError => 500,
        );
    }

    # send received data to debugger
    $Self->{DebuggerObject}->Debug(
        Summary => 'Received data by provider from remote system',
        Data    => $Content,
    );

    # deserialize
    my $Deserialized = eval { SOAP::Deserializer->deserialize($Content); };
    my $DeserializedFault = $@ || '';
    if ($DeserializedFault) {
        return $Self->_Error(
            Summary   => 'Error deserializing message:' . $DeserializedFault,
            HTTPError => 500,
        );
    }

    # check if the deserialized result is there
    if ( !defined $Deserialized || !$Deserialized->body() ) {
        return $Self->_Error(
            Summary   => 'Got no result body from deserialized content',
            HTTPError => 500,
        );
    }

    # get body for request
    my $Body = $Deserialized->body();

    # get operation from soap data
    my $Operation = ( keys %{$Body} )[0];

    # check operation against header
    if ( $OperationFromHeader && $Operation ne $OperationFromHeader ) {
        $Self->{DebuggerObject}->Notice(
            Summary =>
                "Operation from SOAP data '$Operation' does not match operation"
                . " from SOAPAction '$OperationFromHeader'",
        );
    }

    # remember operation for response
    $Self->{Operation} = $Operation;

    # all ok - return data
    return {
        Success   => 1,
        Operation => $Operation,
        Data      => $Body->{$Operation},
    };
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    my $MockResponse = $Self->_MockResponse;

    my $Response;
    $Response = HTTP::Response->new( 200 => "OK" );
    $Response->protocol('HTTP/1.0');
    $Response->content_type("text/xml; charset=UTF-8");
    $Response->add_content_utf8($MockResponse);
    $Response->date(time);

    $Self->{DebuggerObject}->Debug(
        Summary => 'Sending HTTP response',
        Data    => $Response->as_string(),
    );

    # now send response to client
    print STDOUT $Response->as_string();

    return {
        Success => 1,
    };
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # TODO: Not implemented

}

sub _MockResponse {
    my ( $Self, %Param ) = @_;

    my $Response;

    if ( $Self->{Operation} eq 'RequestSystemGuid' ) {
        $Response = '<soapenv:Envelope '
            . 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '
            . 'xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style">'
            . '<soapenv:Header/>'
            . '<soapenv:Body>'
            . '<urn:RequestSystemGuidResponse>'
            . '<Errors>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<ErrorCode>?</ErrorCode>'
            . '<Val1>?</Val1>'
            . '<Val2>?</Val2>'
            . '<Val3>?</Val3>'
            . '<Val4>?</Val4>'
            . '</item>'
            . '</Errors>'
            . '<SystemGuid>?</SystemGuid>'
            . '</urn:RequestSystemGuidResponse>'
            . '</soapenv:Body>'
            . '</soapenv:Envelope>';
    }
    elsif ( $Self->{Operation} eq 'RequestGuid' ) {
        $Response = '<soapenv:Envelope '
            . 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '
            . 'xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style">'
            . '<soapenv:Header/>'
            . '<soapenv:Body>'
            . '<urn:RequestGuidResponse>'
            . '<Errors>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<ErrorCode>?</ErrorCode>'
            . '<Val1>?</Val1>'
            . '<Val2>?</Val2>'
            . '<Val3>?</Val3>'
            . '<Val4>?</Val4>'
            . '</item>'
            . '</Errors>'
            . '<Guid>?</Guid>'
            . '</urn:RequestGuidResponse>'
            . '</soapenv:Body>'
            . '</soapenv:Envelope>';
    }
    elsif ( $Self->{Operation} eq 'ReadCompleteIncident' ) {
        $Response = '<soapenv:Envelope '
            . 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '
            . 'xmlns:urn="urn:sap-com:document:sap:soap:functions:mc-style">'
            . '<soapenv:Header/>'
            . '<soapenv:Body>'
            . '<urn:ReadCompleteIncidentResponse>'
            . '<Errors>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<ErrorCode>?</ErrorCode>'
            . '<Val1>?</Val1>'
            . '<Val2>?</Val2>'
            . '<Val3>?</Val3>'
            . '<Val4>?</Val4>'
            . '</item>'
            . '</Errors>'
            . '<IctAdditionalInfos>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<Guid>?</Guid>'
            . '<ParentGuid>?</ParentGuid>'
            . '<AddInfoAttribute>?</AddInfoAttribute>'
            . '<AddInfoValue>?</AddInfoValue>'
            . '</item>'
            . '</IctAdditionalInfos>'
            . '<IctAttachments>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<AttachmentGuid>?</AttachmentGuid>'
            . '<Filename>?</Filename>'
            . '<MimeType>?</MimeType>'
            . '<Data>cid:1020512061966</Data>'
            . '<Timestamp>?</Timestamp>'
            . '<PersonId>?</PersonId>'
            . '<Url>?</Url>'
            . '<Language>?</Language>'
            . '</item>'
            . '</IctAttachments>'
            . '<IctHead>'
            . '<IncidentGuid>?</IncidentGuid>'
            . '<RequesterGuid>?</RequesterGuid>'
            . '<ProviderGuid>?</ProviderGuid>'
            . '<AgentId>?</AgentId>'
            . '<ReporterId>?</ReporterId>'
            . '<ShortDescription>?</ShortDescription>'
            . '<Priority>?</Priority>'
            . '<Language>?</Language>'
            . '<RequestedBegin>?</RequestedBegin>'
            . '<RequestedEnd>?</RequestedEnd>'
            . '</IctHead>'
            . '<IctPersons>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<PersonId>?</PersonId>'
            . '<PersonIdExt>?</PersonIdExt>'
            . '<Sex>?</Sex>'
            . '<FirstName>?</FirstName>'
            . '<LastName>?</LastName>'
            . '<Telephone>'
            . '<PhoneNo>?</PhoneNo>'
            . '<PhoneNoExtension>?</PhoneNoExtension>'
            . '</Telephone>'
            . '<MobilePhone>?</MobilePhone>'
            . '<Fax>'
            . '<FaxNo>?</FaxNo>'
            . '<FaxNoExtension>?</FaxNoExtension>'
            . '</Fax>'
            . '<Email>?</Email>'
            . '</item>'
            . '</IctPersons>'
            . '<IctSapNotes>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<NoteId>?</NoteId>'
            . '<NoteDescription>?</NoteDescription>'
            . '<Timestamp>?</Timestamp>'
            . '<PersonId>?</PersonId>'
            . '<Url>?</Url>'
            . '<Language>?</Language>'
            . '</item>'
            . '</IctSapNotes>'
            . '<IctSolutions>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<SolutionId>?</SolutionId>'
            . '<SolutionDescription>?</SolutionDescription>'
            . '<Timestamp>?</Timestamp>'
            . '<PersonId>?</PersonId>'
            . '<Url>?</Url>'
            . '<Language>?</Language>'
            . '</item>'
            . '</IctSolutions>'
            . '<IctStatements>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<TextType>?</TextType>'
            . '<Texts>'
            . '<!--Zero or more repetitions:-->'
            . '<item>?</item>'
            . '</Texts>'
            . '<Timestamp>?</Timestamp>'
            . '<PersonId>?</PersonId>'
            . '<Language>?</Language>'
            . '</item>'
            . '</IctStatements>'
            . '<IctStatus>?</IctStatus>'
            . '<IctUrls>'
            . '<!--Zero or more repetitions:-->'
            . '<item>'
            . '<UrlGuid>?</UrlGuid>'
            . '<Url>?</Url>'
            . '<UrlName>?</UrlName>'
            . '<UrlDescription>?</UrlDescription>'
            . '<Timestamp>?</Timestamp>'
            . '<PersonId>?</PersonId>'
            . '<Language>?</Language>'
            . '</item>'
            . '</IctUrls>'
            . '</urn:ReadCompleteIncidentResponse>'
            . '</soapenv:Body>'
            . '</soapenv:Envelope>';
    }
    return $Response;
}

sub _Error {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !defined $Param{Summary} || !IsString( $Param{Summary} ) ) {
        return $Self->_Error(
            Summary   => 'Need Summary!',
            HTTPError => 500,
        );
    }

    # log to debugger
    $Self->{DebuggerObject}->Error(
        Summary => $Param{Summary},
    );

    # remember data for response
    if ( IsStringWithData( $Param{HTTPError} ) ) {
        $Self->{HTTPError}   = $Param{HTTPError};
        $Self->{HTTPMessage} = $Param{Summary};
    }

    # return to provider/requester
    return {
        Success      => 0,
        ErrorMessage => $Param{Summary},
    };
}

1;
