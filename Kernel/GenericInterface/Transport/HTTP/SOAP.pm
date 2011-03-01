# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.pm,v 1.4 2011-03-01 03:43:13 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use strict;
use warnings;

use HTTP::Headers;
use HTTP::Request;
use HTTP::Response;
use HTTP::Status;
use Scalar::Util qw(blessed);
use SOAP::WSDL::Deserializer::Hash;
use SOAP::WSDL::Serializer::XSD;
use Kernel::System::VariableCheck qw(IsString IsStringWithData);

use base qw(SOAP::WSDL::Server);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::GenericInterface::Transport::SOAP - GenericInterface network transport interface for HTTP::SOAP

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Transport->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(
        MainObject ConfigObject LogObject EncodeObject TimeObject DBObject
        DebuggerObject TransportConfig
        )
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # check basic stuff
    my $Response;
    my $Length = $ENV{'CONTENT_LENGTH'};

    # no length provided
    if ( !$Length ) {
        return $Self->_Error(
            Summary   => 'HTTP 411 Length Required',
            HTTPError => 411,
        );
    }

    # request bigger than allowed
    # FIXME, use variable
    if ( $Length > 10000000 ) {
        return $Self->_Error(
            Summary   => 'HTTP 413 Request Entity Too Large',
            HTTPError => 413,
        );
    }

    # in case client requests to continue submission
    if ( IsStringWithData( $ENV{EXPECT} ) && $ENV{EXPECT} =~ m{ \b 100-Continue \b }xmsi ) {
        $Self->_Output(
            HTTPCode => 100,
            Content  => '',
        );
    }

    # read request
    my $Content;
    binmode(STDIN);
    read STDIN, $Content, $Length;

    # parse request
    my $Request = HTTP::Request->new(
        $ENV{'REQUEST_METHOD'} || '' => $ENV{'SCRIPT_NAME'},
        HTTP::Headers->new(
            map {
                (
                    /^HTTP_(.+)/i
                    ? ( $1 =~ m/SOAPACTION/ )
                            ? ('SOAPAction')
                            : ($1)
                    : $_
                    ) => $ENV{$_}
                } keys %ENV
        ),
        $Content,
    );

    # check if we have a soap action
    if ( !$Request->header('SOAPAction') ) {
        return $Self->_Error(
            Summary     => 'No SOAPAction given',
            HTTPError   => 500,
            HTTPMessage => 'No SOAPAction given',
        );
    }

    # check if soap action matches webservice
    my $SOAPAction = $Request->header('SOAPAction');
    $SOAPAction =~ s{ \A (?: " | ' ) ( .+ ) ( ?: " | ' ) \z }{$1}xms;
    if ( $SOAPAction ne $Self->{TransportConfig}->{Config}->{SOAPAction} ) {
        return $Self->_Error(
            Summary     => "No method found for the SOAPAction '$SOAPAction'",
            HTTPError   => 500,
            HTTPMessage => "No method found for the SOAPAction '$SOAPAction'",
        );
    }

    # deserialize
    my ( $Body, $Header ) = eval {
        SOAP::WSDL::Deserializer::Hash->deserialize( $Request->content() );
    };
    my $DeserializerError = $@;
    if ($DeserializerError) {
        return $Self->_Error(
            Summary     => "Error deserializing message: $DeserializerError",
            HTTPError   => 500,
            HTTPMessage => "Error deserializing message: $DeserializerError",
        );
    }

    # check if method matches soap action
    my $MethodFromSOAPAction = $1 if $SOAPAction =~ m{ ( [^/]+ ) \z }xms;
    my $MethodFromBody = ( keys %{ $Body->{Envelope}->{Body} } )[0];
    if ( $MethodFromSOAPAction ne $MethodFromBody ) {
        my $MethodError =
            "Method from SOAPAction '$MethodFromSOAPAction' does not match"
            . " Method from Body '$MethodFromBody'";
        return $Self->_Error(
            Summary     => $MethodError,
            HTTPError   => 500,
            HTTPMessage => $MethodError,
        );
    }

    return {
        Success => 1,

        # FIXME
        Operation => 'Operation1',
        Data      => $Body->{Envelope}->{Body}->{$MethodFromBody},
    };
}

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    my $Response;

    # if we have a http error message
    if ( IsStringWithData( $Self->{HTTPError} ) ) {
        return $Self->_Output(
            HTTPCode => $Self->{HTTPError},
            Content  => $Self->{HTTPMessage},
        );
    }

    # deserialize
    my $Content = SOAP::WSDL::Serializer::XSD->serialize(
        {

            # FIXME not working this way
            body      => $Param{Data},
            namespace => {
                'http://schemas.xmlsoap.org/soap/envelope/' =>
                    $Self->{TransportConfig}->{Config}->{NameSpace},
                'http://www.w3.org/2001/XMLSchema-instance' => 'xsi',
                'http://www.w3.org/2001/XMLSchema'          => 'xs',
            },
        },
    );

    return $Self->_Output(
        HTTPCode => 200,
        Content  => $Content,
    );
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    #TODO: implement
}

sub _Error {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(HTTPError Summary)) {
        next NEEDED if IsStringWithData( $Param{$Needed} );

        return $Self->{DebuggerObject}->Error(
            Summary => "Need $Needed!",
        );
    }

    # set error data and log error
    $Self->{DebuggerObject}->Error(
        Summary => $Param{Summary},
    );
    $Self->{HTTPError} = $Param{HTTPError};
    if ( IsString( $Param{HTTPMessage} ) ) {
        $Self->{HTTPMessage} = $Param{HTTPMessage};
    }
    return {
        Success => 0,
    };
}

sub _Output {
    my ( $Self, %Param ) = @_;

    # check needed params
    NEEDED:
    for my $Needed (qw(HTTPCode Content)) {
        next NEEDED if IsString( $Param{$Needed} );

        return $Self->{DebuggerObject}->Error(
            Summary => "Need $Needed!",
        );
    }

    # imitate nph- cgi for IIS
    my $Status;

   # FIXME is this correct? it seems to break things for apache
   #    if ( IsStringWithData($ENV{'SERVER_SOFTWARE'}) && $ENV{'SERVER_SOFTWARE'} =~ m{ IIS }xms ) {
    $Status = $ENV{SERVER_PROTOCOL} || 'HTTP/1.0';

    #    }
    #    else {
    #        $Status = 'Status:';
    #    }

    # prepare data
    my $ContentType;
    if ( $Param{HTTPCode} eq 200 ) {
        $ContentType = 'text/xml';
    }
    else {
        $ContentType = 'text/plain';
    }
    $Param{HTTPCode} ||= 200;
    my $Response = HTTP::Response->new( $Param{HTTPCode} );
    $Response->header( 'Content-Type' => $ContentType . '; charset=UTF-8' );
    $Response->content( $Param{Content} );
    {
        use bytes;
        $Response->header( 'Content-Length' => length $Param{Content} );
    }
    my $Code = $Response->code();

    # return data
    binmode(STDOUT);
    print STDOUT
        "$Status $Code ",
        HTTP::Status::status_message($Code),
        "\015\012", $Response->headers_as_string("\015\012"),
        "\015\012", $Response->content();

    return {
        Success => 1,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2011-03-01 03:43:13 $

=cut
