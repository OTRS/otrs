# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::SOAP;

use strict;
use warnings;

use HTTP::Status;
use SOAP::Lite;
use Kernel::System::VariableCheck qw(:all);
use Encode;
use PerlIO;

=head1 NAME

Kernel::GenericInterface::Transport::SOAP - GenericInterface network transport interface for HTTP::SOAP

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

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
    for my $Needed (qw(MainObject EncodeObject DebuggerObject TransportConfig ConfigObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # set binary mode for STDIN and STDOUT (normally is the same as :raw)
    binmode STDIN;
    binmode STDOUT;

    return $Self;
}

=item ProviderProcessRequest()

Process an incoming web service request. This function has to read the request data
from from the web server process.

Based on the request the Operation to be used is determined.

No outbound communication is done here, except from continue requests.

In case of an error, the resulting http error code and message are remembered for the response.

    my $Result = $TransportObject->ProviderProcessRequest();

    $Result = {
        Success      => 1,                  # 0 or 1
        ErrorMessage => '',                 # in case of error
        Operation    => 'DesiredOperation', # name of the operation to perform
        Data         => {                   # data payload of request
            ...
        },
    };

=cut

sub ProviderProcessRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace config
    if ( !IsStringWithData( $Config->{NameSpace} ) ) {
        return $Self->_Error(
            Summary   => 'HTTP::SOAP Have no NameSpace in config',
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

    # check if we have content
    if ( !IsStringWithData($Content) ) {
        return $Self->_Error(
            Summary   => 'Could not read input data',
            HTTPError => 500,
        );
    }

    # convert charset if necessary
    my $ContentCharset;
    if ( $ENV{'CONTENT_TYPE'} =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi ) {
        $ContentCharset = $1;
    }
    if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
        $Content = $Self->{EncodeObject}->Convert2CharsetInternal(
            Text => $Content,
            From => $ContentCharset,
        );
    }
    else {
        $Self->{EncodeObject}->EncodeInput( \$Content );
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
    my $Operation = ( sort keys %{$Body} )[0];

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

    my $OperationData = $Body->{$Operation};

    # all ok - return data
    return {
        Success   => 1,
        Operation => $Operation,
        Data      => $OperationData || undef,
    };
}

=item ProviderGenerateResponse()

Generates response for an incoming web service request.

In case of an error, error code and message are taken from environment
(previously set on request processing).

The HTTP code is set accordingly
- 200 for (syntactically) correct messages
- 4xx for http errors
- 500 for content syntax errors

    my $Result = $TransportObject->ProviderGenerateResponse(
        Success => 1
        Data    => { # data payload for response, optional
            ...
        },
    );

    $Result = {
        Success      => 1,   # 0 or 1
        ErrorMessage => '',  # in case of error
    };

=cut

sub ProviderGenerateResponse {
    my ( $Self, %Param ) = @_;

    # do we have a http error message to return
    if ( IsStringWithData( $Self->{HTTPError} ) && IsStringWithData( $Self->{HTTPMessage} ) ) {
        return $Self->_Output(
            HTTPCode => $Self->{HTTPError},
            Content  => $Self->{HTTPMessage},
        );
    }

    # check data param
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Invalid data',
        );
    }

    my $OperationResponse = $Self->{Operation} . 'Response';
    my $HTTPCode          = 200;

    # check success param
    if ( !$Param{Success} ) {

        # create SOAP Fault structure
        my $FaultString = $Param{ErrorMessage} || 'Unknown';
        $Param{Data} = {
            faultcode   => 'Server',
            faultstring => $FaultString,
        };

        # override OperationResponse string to Fault to make the corect SOAP envelope
        $OperationResponse = 'Fault';

        # overide HTTPCode to 500
        $HTTPCode = 500;
    }

    # prepare data
    my $SOAPResult;
    if ( defined $Param{Data} && IsHashRefWithData( $Param{Data} ) ) {
        my $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
        );

        # check output of recursion
        if ( !$SOAPData->{Success} ) {
            return $Self->_Output(
                HTTPCode => 500,
                Content  => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            );
        }
        $SOAPResult = SOAP::Data->value( @{ $SOAPData->{Data} } );

        if ( ref $SOAPResult ne 'SOAP::Data' ) {
            return $Self->_Output(
                HTTPCode => 500,
                Content  => 'Error in SOAP result',
            );
        }
    }

    # create return structure
    my @CallData = ( 'response', $OperationResponse );
    if ($SOAPResult) {
        push @CallData, $SOAPResult;
    }
    my $Serialized = SOAP::Serializer
        ->autotype(0)
        ->default_ns( $Self->{TransportConfig}->{Config}->{NameSpace} )
        ->envelope(@CallData);
    my $SerializedFault = $@ || '';
    if ($SerializedFault) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Error serializing message:' . $SerializedFault,
        );
    }

    # no error - return output
    return $Self->_Output(
        HTTPCode => $HTTPCode,
        Content  => $Serialized,
    );
}

=item RequesterPerformRequest()

Prepare data payload as xml structure, generate an outgoing web service request,
receive the response and return its data.

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'remote_op', # name of remote operation to perform
        Data      => {            # data payload for request
            ...
        },
    );

    $Result = {
        Success      => 1,        # 0 or 1
        ErrorMessage => '',       # in case of error
        Data         => {
            ...
        },
    };

=cut

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Have no TransportConfig',
        };
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace and endpoint config
    NEEDED:
    for my $Needed (qw(Endpoint NameSpace)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "SOAP Transport: Have no $Needed in config",
        };
    }

    # check data param
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Invalid Data',
        };
    }

    # check operation param
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Need Operation',
        };
    }

    # prepare data if we have any
    my $SOAPData;
    if ( defined $Param{Data} && IsHashRefWithData( $Param{Data} ) ) {
        $SOAPData = $Self->_SOAPOutputRecursion(
            Data => $Param{Data},
        );

        # check output of recursion
        if ( !$SOAPData->{Success} ) {
            return {
                Success      => 0,
                ErrorMessage => "Error in SOAPOutputRecursion: " . $SOAPData->{ErrorMessage},
            };
        }
    }

    # prepare method
    my $SOAPMethod = SOAP::Data
        ->name( $Param{Operation} )
        ->uri( $Config->{NameSpace} );
    if ( ref $SOAPMethod ne 'SOAP::Data' ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Error preparing used method',
        };
    }

    # add authentication if configured
    my $URL = $Config->{Endpoint};
    if ( IsHashRefWithData( $Config->{Authentication} ) ) {

        # basic authentication
        if (
            IsStringWithData( $Config->{Authentication}->{Type} )
            && $Config->{Authentication}->{Type} eq 'BasicAuth'
            )
        {
            my $User     = $Config->{Authentication}->{User};
            my $Password = $Config->{Authentication}->{Password};
            if ( IsStringWithData($User) && IsStringWithData($Password) ) {
                $URL =~ s{ ( http s? :// ) }{$1\Q$User\E:\Q$Password\E@}xmsi;
            }
        }
    }

    # add SSL options if configured
    if ( IsHashRefWithData( $Config->{SSL} ) ) {

        # use SSL options
        if (
            IsStringWithData( $Config->{SSL}->{UseSSL} )
            && $Config->{SSL}->{UseSSL} eq 'Yes'
            )
        {

            # force Net::SSL instead of IO::Socket::SSL, otherwise GI can't connect to certificate
            # authentication restricted servers
            my $SSLModule = 'Net::SSL';
            if ( !$Self->{MainObject}->Require($SSLModule) ) {
                return {
                    Success      => 0,
                    ErrorMessage => "The perl module \"$SSLModule\" needed to manage SSL"
                        . " connections with certificates is missing!",
                };
            }

            $ENV{HTTPS_PKCS12_FILE}     = $Config->{SSL}->{SSLP12Certificate};
            $ENV{HTTPS_PKCS12_PASSWORD} = $Config->{SSL}->{SSLP12Password};

            # add certificate authority
            if ( IsStringWithData( $Config->{SSL}->{SSLCAFile} ) ) {
                $ENV{HTTPS_CA_FILE} = $Config->{SSL}->{SSLCAFile};
            }
            if ( IsStringWithData( $Config->{SSL}->{SSLCADir} ) ) {
                $ENV{HTTPS_CA_DIR} = $Config->{SSL}->{SSLCADir};
            }

            # add proxy
            if ( IsStringWithData( $Config->{SSL}->{SSLProxy} ) ) {
                $ENV{HTTPS_PROXY} = $Config->{SSL}->{SSLProxy};
            }

            # add proxy basic authentication
            if ( IsStringWithData( $Config->{SSL}->{SSLProxyUser} ) ) {
                $ENV{HTTPS_PROXY_USERNAME} = $Config->{SSL}->{SSLProxyUser};
            }
            if ( IsStringWithData( $Config->{SSL}->{SSLProxyPassword} ) ) {
                $ENV{HTTPS_PROXY_PASSWORD} = $Config->{SSL}->{SSLProxyPassword};
            }
        }
    }

    # prepare connect
    my $SOAPHandle = eval {
        SOAP::Lite
            ->autotype(0)
            ->default_ns( $Config->{NameSpace} )
            ->proxy(
            $URL,
            timeout => 60,
            );
    };
    my $SOAPHandleFault = $@ || '';
    if ($SOAPHandleFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error creating SOAPHandle: ' . $SOAPHandleFault,
        };
    }

    # check if needed to modify the SOAPAction header
    if ( IsStringWithData( $Config->{SOAPAction} ) ) {

        if ( $Config->{SOAPAction} eq 'No' ) {

            # send empty header
            $SOAPHandle->on_action( sub {'""'} );
        }

        elsif ( $Config->{SOAPActionSeparator} eq '/' ) {

            # change separator (like for .net web services)
            $SOAPHandle->on_action(
                sub { '"' . $Config->{NameSpace} . '/' . $Param{Operation} . '"' }
            );
        }
    }

    # send request to server
    # for SOAP::Lite version > .712 if $SOAPData->{Data} is an array and is sent directly the
    # result is that the data is surrounded by <soapenc:Array>, to avoid this is necessary to
    # pass each part of the $SOAPData->{Data} Array one by one
    my @CallData = ($SOAPMethod);
    if ($SOAPData) {

        # check if $SOAPData->{Data} is an array reference
        if ( IsArrayRefWithData( $SOAPData->{Data} ) ) {

            # push array element ($DataPart) one by one
            for my $DataPart ( @{ $SOAPData->{Data} } ) {
                push @CallData, $DataPart;
            }
        }

        # otherwise use the same method as before
        else {
            push @CallData, $SOAPData->{Data};
        }
    }
    my $SOAPResult = eval {
        $SOAPHandle->call(@CallData);
    };
    my $SOAPResultFault = $@ || '';
    if ($SOAPResultFault) {
        return {
            Success      => 0,
            ErrorMessage => 'Error in SOAP call: ' . $SOAPResultFault,
        };
    }

    # check if the soap result is there
    if ( !defined $SOAPResult || !$SOAPResult->body() ) {
        return {
            Success      => 0,
            ErrorMessage => 'Got no result body from soap call',
        };
    }

    # send sent data to debugger
    if ( !$SOAPResult->context()->transport()->proxy()->http_response()->request()->content() ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Could not get xml data sent to remote system',
        };
    }
    my $XMLRequest
        = $SOAPResult->context()->transport()->proxy()->http_response()->request()->content();
    $Self->{EncodeObject}->EncodeInput( \$XMLRequest );
    $Self->{DebuggerObject}->Debug(
        Summary => 'Xml data sent to remote system',
        Data    => $XMLRequest,
    );

    # check received data
    if ( !$SOAPResult->context()->transport()->proxy()->http_response()->content() ) {
        return {
            Success      => 0,
            ErrorMessage => 'Could not get xml data received from remote system',
        };
    }
    my $XMLResponse = $SOAPResult->context()->transport()->proxy()->http_response()->content();

    # convert charset if necessary
    if ( $Config->{Encoding} && $Config->{Encoding} !~ m{ \A utf -? 8 \z }xmsi ) {
        $XMLResponse = $Self->{EncodeObject}->Convert(
            Text => $XMLResponse,
            From => $Config->{Encoding},
            To   => 'utf-8',
        );
    }
    else {
        $Self->{EncodeObject}->EncodeInput( \$XMLResponse );
    }

    # send processed data to debugger
    $Self->{DebuggerObject}->Debug(
        Summary => 'Xml data received from remote system',
        Data    => $XMLResponse,
    );

    # deserialize response
    my $Deserialized = eval {
        SOAP::Deserializer->deserialize($XMLResponse);
    };

    # check if deserializing was successful
    if ( !defined $Deserialized || !$Deserialized->body() ) {
        return {
            Success      => 0,
            ErrorMessage => 'SOAP Transport: Could not deserialize received xml data',
        };
    }

    my $Body = $Deserialized->body();

    # check if we got a SOAP Fault message
    if ( exists $Body->{'Fault'} ) {
        my $ErrorMessage = '';
        for my $Key ( sort keys %{ $Body->{Fault} } ) {
            $ErrorMessage .= "$Key: $Body->{Fault}->{$Key}, ";
        }
        $ErrorMessage = substr $ErrorMessage, 0, -2;
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # check if we have response data for the specified operation in the soap result
    if ( !exists $Body->{ $Param{Operation} . 'Response' } ) {
        return {
            Success => 0,
            ErrorMessage =>
                "No response data found for specified operation '$Param{Operation}'"
                . " in soap response",
        };
    }

    # all ok - return result
    return {
        Success => 1,
        Data => $Body->{ $Param{Operation} . 'Response' } || undef,
    };
}

=begin Internal:

=item _Error()

Take error parameters from request processing.
Error message is written to debugger, written to environment for response.
Error is generated to be passed to provider/requester.

    my $Result = $TransportObject->_Error(
        Summary   => 'Message',    # error message
        HTTPError => 500,          # http error code, optional
    );

    $Result = {
        Success      => 0,
        ErrorMessage => 'Message', # error message from given summary
    };

=cut

sub _Error {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !IsString( $Param{Summary} ) ) {
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

=item _Output()

Generate http response for provider and send it back to remote system.
Environment variables are checked for potential error messages.
Returns structure to be passed to provider.

    my $Result = $TransportObject->_Output(
        HTTPCode => 200,           # http code to be returned, optional
        Content  => 'response',    # message content, xml response on normal execution
    );

    $Result = {
        Success      => 0,
        ErrorMessage => 'Message', # error message from given summary
    };

=cut

sub _Output {
    my ( $Self, %Param ) = @_;

    # check params
    my $Success = 1;
    my $ErrorMessage;
    if ( defined $Param{HTTPCode} && !IsInteger( $Param{HTTPCode} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid internal HTTPCode';
        $Success         = 0;
        $ErrorMessage    = 'Invalid internal HTTPCode';
    }
    elsif ( defined $Param{Content} && !IsString( $Param{Content} ) ) {
        $Param{HTTPCode} = 500;
        $Param{Content}  = 'Invalid Content';
        $Success         = 0;
        $ErrorMessage    = 'Invalid Content';
    }

    # prepare protocol
    my $Protocol = defined $ENV{SERVER_PROTOCOL} ? $ENV{SERVER_PROTOCOL} : 'HTTP/1.0';

    # FIXME
    # according to SOAP::Transport::HTTP the previous should only be used
    # for IIS to imitate nph- behaviour
    # for all other browser 'Status:' should be used here
    # this breaks apache though

    # prepare data
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 500;
    my $ContentType;
    if ( $Param{HTTPCode} eq 200 ) {
        $ContentType = 'text/xml';
    }
    else {
        $ContentType = 'text/plain';
    }

    # calculate content length (based on the bytes length not on the characters length)
    my $ContentLength = bytes::length( $Param{Content} );

    # log to debugger
    my $DebugLevel;
    if ( $Param{HTTPCode} eq 200 ) {
        $DebugLevel = 'debug';
    }
    else {
        $DebugLevel = 'error';
    }
    $Self->{DebuggerObject}->DebugLog(
        DebugLevel => $DebugLevel,
        Summary    => "Returning provider data to remote system (HTTP Code: $Param{HTTPCode})",
        Data       => $Param{Content},
    );

    # set keep-alive
    my $ConfigKeepAlive = $Self->{ConfigObject}->Get('SOAP::Keep-Alive');
    my $Connection = $ConfigKeepAlive ? 'Keep-Alive' : 'close';

    # in the constructor of this module STDIN and STDOUT are set to binmode without any additional
    # layer (according to the documentation this is the same as set :raw). Previous solutions for
    # binary responses requires the set of :raw or :utf8 according to IO layers.
    # with that solution Windows OS requires to set the :raw layer in binmode, see #bug#8466.
    # while in *nix normally was better to set :utf8 layer in binmode, see bug#8558, otherwise
    # XML parser complains about it... ( but under special circumstances :raw layer was needed
    # instead ).
    # this solution to set the binmode in the constructor and then :utf8 layer before the response
    # is sent  apparently works in all situations. ( linux circumstances to requires :raw was no
    # reproducible, and not tested in this solution).
    binmode STDOUT, ':utf8';    ## no critic

    # print data to http - '\r' is required according to HTTP RFCs
    my $StatusMessage = HTTP::Status::status_message( $Param{HTTPCode} );
    print STDOUT "$Protocol $Param{HTTPCode} $StatusMessage\r\n";
    print STDOUT "Content-Type: $ContentType; charset=UTF-8\r\n";
    print STDOUT "Content-Length: $ContentLength\r\n";
    print STDOUT "Connection: $Connection\r\n";
    print STDOUT "\r\n";
    print STDOUT $Param{Content};

    return {
        Success      => $Success,
        ErrorMessage => $ErrorMessage,
    };
}

=item _SOAPOutputRecursion()

Turn perl data structure to a structure usable for SOAP::Lite.
The structure may contain multiple levels with scalars, array refs and hash refs.
Empty array refs, empty hash refs and array refs directly within array refs
are not permitted as they don't have a valid xml representation.
Undefined data is treated as empty string.

Because some systems require data in a specific order,
the sort order of hash ref entries (and only those) can be specified optionally.
The sorting structure has to be equal to the data structure
with hash refs replaced by an array ref and its elements wrapped in individual hash refs.
Values in the sorting structure are ignored but have to be specified
(at least 'undef') for correct type detection.
If entries exist that are not mentioned in sorting config,
they will be added after the sorted entries in ascending alphanumerical order.

Example:
$Data = {
    Key1 => 'Value',
    Key2 => {
        Key3 => 'Value',
        Key4 => [
            'Value',
            'Value',
            {
                Key5 => 'Value',
            },
        ],
    },
};
$Sort = [                                  # wrapper for level 1
    {                                      # first entry for level 1
        Key2 => [                          # wrapper for level 2
            {                              # first entry for level 2
                Key4 => [
                    undef,
                    undef,
                    [                      # wrapper for level 3
                        {
                            Key5 => undef, # first entry for level 3
                        },
                    ],                     # wrapper for level 3
                ],
            },                             # first entry for level 2
            {                              # second entry for level 2
                Key3 => undef,
            },                             # second entry for level 2
        ],                                 # wrapper for level 2
    }                                      # first entry for level 1
    {                                      # second entry for level 1
        Key1 => undef,
    }                                      # second entry for level 1
];                                         # wrapper for level 1

    my $Result = $TransportObject->_SOAPOutputRecursion(
        Data => {           # data payload
            ...
        },
        Sort => {           # sorting instructions, optional
            ...
        },
    );

    $Result = {
        Success      => 1,  # 0 or 1
        ErrorMessage => '', # in case of error
        Data         => {   # data payload in SOAP::Data format
            ...
        },
    };

=cut

sub _SOAPOutputRecursion {
    my ( $Self, %Param ) = @_;

    # check types
    my %Type;
    KEY:
    for my $Key (qw(Data Sort)) {

        # those are valid
        if ( !defined $Param{$Key} ) {
            $Type{$Key} = 'UNDEFINED';
            next KEY;
        }
        my $Ref = ref $Param{$Key};
        if ( !$Ref ) {
            $Type{$Key} = 'STRING';
            next KEY;
        }
        if ( IsArrayRefWithData( $Param{$Key} ) ) {
            $Type{$Key} = 'ARRAYREF';
            next KEY;
        }

        # hash ref is only allowed for data
        if ( IsHashRefWithData( $Param{$Key} ) ) {
            $Type{$Key} = 'HASHREF';
            next KEY;
        }

        # everything else is invalid - throw error
        if ( $Ref =~ m{ \A (?: ARRAY | HASH ) \z }xms ) {
            $Ref .= ' (empty)';
        }
        return {
            Success      => 0,
            ErrorMessage => "$Key type '$Ref' is invalid",
        };
    }

    # types of data and sort must match if sorting is used (=is defined)
    # if data is hash ref sort must be array ref
    if (
        $Type{Sort} ne 'UNDEFINED'
        && $Type{Data} ne $Type{Sort}
        && !(
            $Type{Data} eq 'HASHREF'
            && $Type{Sort} eq 'ARRAYREF'
        )
        )
    {
        return {
            Success      => 0,
            ErrorMessage => "Types of Data '$Type{Data}' and Sort '$Type{Sort}' don't match",
        };
    }

    # undefined variables are processed as empty string
    if ( $Type{Data} eq 'UNDEFINED' ) {
        $Param{Data} = '';
        $Type{Data}  = 'STRING';
    }

    # process string
    if ( $Type{Data} eq 'STRING' ) {
        $Param{Data} = $Self->_SOAPOutputProcessString( Data => $Param{Data} );
        return {
            Success => 1,
            Data    => SOAP::Data->value( $Param{Data} ),
        };
    }

    # process array ref
    if ( $Type{Data} eq 'ARRAYREF' ) {
        my @Result;
        my @Sort = $Param{Sort} ? @{ $Param{Sort} } : ();
        KEY:
        for my $Key ( @{ $Param{Data} } ) {

            # process key
            my $RecurseResult = $Self->_SOAPOutputRecursion(
                Data => $Key,
                Sort => @Sort ? shift @Sort : undef,
            );

            # return on error
            return $RecurseResult if !$RecurseResult->{Success};

            # treat result of strings differently
            if ( !defined $Key || IsString($Key) ) {
                push @Result, SOAP::Data->value( $RecurseResult->{Data} );
                next KEY;
            }
            push @Result, \SOAP::Data->value( @{ $RecurseResult->{Data} } );
        }

        # return result of successful recursion
        return {
            Success => 1,
            Data    => \@Result,
            }
    }

    # process hash ref - sorted entries first
    my %Data = %{ $Param{Data} };
    my @Result;
    if ( $Type{Sort} eq 'ARRAYREF' ) {
        ELEMENT:
        for my $SortArrayElement ( @{ $Param{Sort} } ) {

            # content check
            if ( !IsHashRefWithData($SortArrayElement) ) {
                return {
                    Success      => 0,
                    ErrorMessage => 'Element of sort array is not a hash ref',
                };
            }
            my @SortArrayElementKeys = keys %{$SortArrayElement};
            if ( scalar @SortArrayElementKeys != 1 ) {
                return {
                    Success => 0,
                    ErrorMessage =>
                        'Sort array element hash ref must contain exactly one key/value pair',
                };
            }
            if ( !IsStringWithData( $SortArrayElementKeys[0] ) ) {
                return {
                    Success => 0,
                    ErrorMessage =>
                        'Key of sort array element hash ref must be a non zero-length string',
                };
            }

            # for easier reading
            my $SortKey = $SortArrayElementKeys[0];

            # missing data elements are ok, then we just skip this
            next ELEMENT if !$Data{$SortKey};

            # process element
            my $RecurseResult = $Self->_SOAPOutputHashRecursion(
                Data => $Data{$SortKey},
                Sort => $SortArrayElement->{$SortKey},
            );

            # return on error
            return $RecurseResult if !$RecurseResult->{Success};

            # process key and add key/value pair to result
            $SortKey = $Self->_SOAPOutputProcessString( Data => $SortKey );
            push @Result, SOAP::Data->name($SortKey)->value( $RecurseResult->{Data} );

            # delete affected data entry so we don't process it twice
            delete $Data{$SortKey};
        }
    }

    # process remaining hash ref entries
    for my $Key ( sort keys %Data ) {

        # process element
        my $RecurseResult = $Self->_SOAPOutputHashRecursion(
            Data => $Data{$Key},
        );

        # return on error
        return $RecurseResult if !$RecurseResult->{Success};

        # process key and add key/value pair to result
        $Key = $Self->_SOAPOutputProcessString( Data => $Key );
        push @Result, SOAP::Data->name($Key)->value( $RecurseResult->{Data} );
    }

    # return result of successful recursion
    return {
        Success => 1,
        Data    => \@Result,
    };
}

=item _SOAPOutputHashRecursion()

This is a part of _SOAPOutputRecursion.
It contains the functions to process a hash key/value pair.

    my $Result = $TransportObject->_SOAPOutputHashRecursion(
        Data => { # data payload
            ...
        },
        Sort => { # sort data payload
            ...
        },
    );

    $Result = {
        Success      => 1,  # 0 or 1
        ErrorMessage => '', # in case of error
        Data         => (   # data payload in SOAP::Data format
            ...
        ),
    };

=cut

sub _SOAPOutputHashRecursion {
    my ( $Self, %Param ) = @_;

    # process data
    my $RecurseResult = $Self->_SOAPOutputRecursion(%Param);

    # return on error
    return $RecurseResult if !$RecurseResult->{Success};

    # set result based on data type
    my $Result;
    if ( !defined $Param{Data} || IsString( $Param{Data} ) ) {
        $Result = $RecurseResult->{Data};
    }
    elsif ( IsArrayRefWithData( $Param{Data} ) ) {
        $Result = SOAP::Data->value( @{ $RecurseResult->{Data} } );
    }
    elsif ( IsHashRefWithData( $Param{Data} ) ) {
        $Result = \SOAP::Data->value( @{ $RecurseResult->{Data} } );
    }

    # this should have caused an error before, but just in case
    else {
        return {
            Success      => 0,
            ErrorMessage => 'Unexpected problem - data value is invalid',
        };
    }

    # return result of successful recursion
    return {
        Success => 1,
        Data    => $Result,
    };
}

=item _SOAPOutputProcessString()

This is a part of _SOAPOutputRecursion.
It contains functions to quote invalid XML characters and encode the string

    my $Result = $TransportObject->_SOAPOutputProcessString(
        Data => 'a <string> & more',
    );

    $Result = 'a &lt;string> &amp; more';

=cut

sub _SOAPOutputProcessString {
    my ( $Self, %Param ) = @_;

    return '' if !defined $Param{Data};

    # escape characters that are invalid in XML
    $Param{Data} =~ s{ & }{&amp;}xmsg;
    $Param{Data} =~ s{ < }{&lt;}xmsg;

    return $Param{Data};
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
