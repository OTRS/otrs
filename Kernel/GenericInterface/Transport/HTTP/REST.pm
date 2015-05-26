# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Transport::HTTP::REST;

use strict;
use warnings;

use HTTP::Status;
use MIME::Base64;
use REST::Client;
use URI::Escape;
use Kernel::Config;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Transport::REST - GenericInterface network transport interface for HTTP::REST

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
    for my $Needed (qw(DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

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
            Summary   => 'REST Transport: Have no TransportConfig',
            HTTPError => 500,
        );
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return $Self->_Error(
            Summary   => 'Rest Transport: Have no Config',
            HTTPError => 500,
        );
    }
    my $Config = $Self->{TransportConfig}->{Config};
    $Self->{KeepAlive} = $Config->{KeepAlive} || 0;

    if ( !IsHashRefWithData( $Config->{RouteOperationMapping} ) ) {
        return $Self->_Error(
            Summary   => "HTTP::REST Can't find RouteOperationMapping in Config",
            HTTPError => 500,
        );
    }

    my $Operation;
    my %URIData;
    my $RequestURI = $ENV{REQUEST_URI} || $ENV{PATH_INFO};
    $RequestURI =~ s{.*Webservice(?:ID)?\/[^\/]+(\/.*)$}{$1}xms;

    # remove any query parameter form the URL
    # e.g. from /Ticket/1/2?UserLogin=user&Password=secret
    # to /Ticket/1/2?
    $RequestURI =~ s{([^?]+)(.+)?}{$1};

    # remember the query parameters e.g. ?UserLogin=user&Password=secret
    my $QueryParamsStr = $2 || '';
    my %QueryParams;

    if ($QueryParamsStr) {

        # remove question mark '?' in the beginning
        substr $QueryParamsStr, 0, 1, '';

        # convert query parameters into a hash
        # e.g. from UserLogin=user&Password=secret
        # to (
        #       UserLogin => 'user',
        #       Password  => 'secret',
        #    );
        %QueryParams = split /[&=]/, $QueryParamsStr;

        # unscape URI strings in query parameters
        for my $Param ( sort keys %QueryParams ) {
            $QueryParams{$Param} = URI::Escape::uri_unescape( $QueryParams{$Param} );
        }
    }

    my $RequestMethod = $ENV{'REQUEST_METHOD'} || 'GET';
    ROUTE:
    for my $CurrentOperation ( sort keys %{ $Config->{RouteOperationMapping} } ) {

        next ROUTE if !IsHashRefWithData( $Config->{RouteOperationMapping}->{$CurrentOperation} );

        my %RouteMapping = %{ $Config->{RouteOperationMapping}->{$CurrentOperation} };

        if ( IsArrayRefWithData( $RouteMapping{RequestMethod} ) ) {
            next ROUTE if !grep { $RequestMethod eq $_ } @{ $RouteMapping{RequestMethod} };
        }

        # Convert the configured route with the help of extended regexp patterns
        # to a regexp. This generated regexp is used to:
        # 1.) Determine the Operation for the request
        # 2.) Extract additional parameters from the RequestURI
        # For further information: http://perldoc.perl.org/perlre.html#Extended-Patterns
        #
        # For example, from the RequestURI: /Ticket/1/2
        #     and the route setting:        /Ticket/:TicketID/:Other
        #     %URIData will then contain:
        #     (
        #         TicketID => 1,
        #         Other    => 2,
        #     );
        my $RouteRegEx = $RouteMapping{Route};
        $RouteRegEx =~ s{:([^\/]+)}{(?<$1>[^\/]+)}xmsg;

        next ROUTE if !( $RequestURI =~ m{^ $RouteRegEx $}xms );

        %URIData   = %+;
        $Operation = $CurrentOperation;

        # leave with the first matching regexp
        last ROUTE;
    }

    # combine query params with URIData params, URIData has more precedence
    if (%QueryParams) {
        %URIData = ( %QueryParams, %URIData, );
    }

    if ( !$Operation ) {
        return $Self->_Error(
            Summary   => "HTTP::REST Error while determine Operation for request URI '$RequestURI'.",
            HTTPError => 500,
        );
    }

    my $Length = $ENV{'CONTENT_LENGTH'};

    # no length provided, return the information we have
    if ( !$Length ) {
        return {
            Success   => 1,
            Operation => $Operation,
            Data      => {
                %URIData,
                RequestMethod => $RequestMethod,
            },
        };
    }

    # request bigger than allowed
    if ( IsInteger( $Config->{MaxLength} ) && $Length > $Config->{MaxLength} ) {
        return $Self->_Error(
            Summary   => HTTP::Status::status_message(413),
            HTTPError => 413,
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

    # convert char-set if necessary
    my $ContentCharset;
    if ( $ENV{'CONTENT_TYPE'} =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi ) {
        $ContentCharset = $1;
    }
    if ( $ContentCharset && $ContentCharset !~ m{ \A utf [-]? 8 \z }xmsi ) {
        $Content = $Kernel::OM->Get('Kernel::System::Encode')->Convert2CharsetInternal(
            Text => $Content,
            From => $ContentCharset,
        );
    }
    else {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Content );
    }

    # send received data to debugger
    $Self->{DebuggerObject}->Debug(
        Summary => 'Received data by provider from remote system',
        Data    => $Content,
    );

    my $ContentDecoded = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $Content,
    );

    if ( !$ContentDecoded ) {
        return $Self->_Error(
            Summary   => 'Error while decoding request content.',
            HTTPError => 500,
        );
    }

    my $ReturnData;
    if ( IsHashRefWithData($ContentDecoded) ) {

        $ReturnData = $ContentDecoded;
        @{$ReturnData}{ keys %URIData } = values %URIData;
    }
    elsif ( IsArrayRefWithData($ContentDecoded) ) {

        ELEMENT:
        for my $CurrentElement ( @{$ContentDecoded} ) {

            if ( IsHashRefWithData($CurrentElement) ) {
                @{$CurrentElement}{ keys %URIData } = values %URIData;
            }

            push @{$ReturnData}, $CurrentElement;
        }
    }
    else {
        return $Self->_Error(
            Summary   => 'Unsupported request content structure.',
            HTTPError => 500,
        );
    }

    # all ok - return data
    return {
        Success   => 1,
        Operation => $Operation,
        Data      => $ReturnData,
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

    # check success param
    my $HTTPCode = 200;
    if ( !$Param{Success} ) {

        # create Fault structure
        my $FaultString = $Param{ErrorMessage} || 'Unknown';
        $Param{Data} = {
            faultcode   => 'Server',
            faultstring => $FaultString,
        };

        # override HTTPCode to 500
        $HTTPCode = 500;
    }

    # prepare data
    my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Data},
    );

    if ( !$JSONString ) {
        return $Self->_Output(
            HTTPCode => 500,
            Content  => 'Error while encoding return JSON structure.',
        );
    }

    # no error - return output
    return $Self->_Output(
        HTTPCode => $HTTPCode,
        Content  => $JSONString,
    );
}

=item RequesterPerformRequest()

Prepare data payload as XML structure, generate an outgoing web service request,
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
            ErrorMessage => 'REST Transport: Have no TransportConfig',
        };
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    NEEDED:
    for my $Needed (qw(Host DefaultCommand)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "REST Transport: Have no $Needed in config",
        };
    }

    # check data param
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Invalid Data',
        };
    }

    # check operation param
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'REST Transport: Need Operation',
        };
    }

    my $Headers = {};
    if ( IsHashRefWithData( $Config->{Authentication} ) ) {

        # basic authentication
        if (
            IsStringWithData( $Config->{Authentication}->{Type} )
            && $Config->{Authentication}->{Type} eq 'BasicAuth'
            )
        {
            my $User = $Config->{Authentication}->{User};
            my $Password = $Config->{Authentication}->{Password} || '';

            if ( IsStringWithData($User) ) {
                my $EncodedCredentials = encode_base64("$User:$Password");
                $Headers->{Authorization} = 'Basic ' . $EncodedCredentials;
            }
        }
    }

    # set up a REST session
    my $RestClient = REST::Client->new(
        {
            host => $Config->{Host},
        }
    );

    if ( !$RestClient ) {

        my $ErrorMessage = "Error while creating REST client from 'REST::Client'.";

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    # add X509 options if configured
    if ( IsHashRefWithData( $Config->{X509} ) ) {

        # use X509 options
        if (
            IsStringWithData( $Config->{X509}->{UseX509} )
            && $Config->{X509}->{UseX509} eq 'Yes'
            )
        {
            #X509 client authentication
            $RestClient->setCert( $Config->{X509}->{X509CertFile} );
            $RestClient->setKey( $Config->{X509}->{X509KeyFile} );

            #add a CA to verify server certificates
            if ( IsStringWithData( $Config->{X509}->{X509CAFile} ) ) {
                $RestClient->setCa( $Config->{X509}->{X509CAFile} );
            }
        }
    }

    my $RestCommand = $Config->{DefaultCommand};
    if ( IsStringWithData( $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Command} ) )
    {
        $RestCommand = $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Command};
    }

    $RestCommand = uc $RestCommand;

    if ( !grep { $_ eq $RestCommand } qw(GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE) ) {

        my $ErrorMessage = "'$RestCommand' is not a valid REST command.";

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    if (
        !IsHashRefWithData( $Config->{InvokerControllerMapping} )
        || !IsHashRefWithData( $Config->{InvokerControllerMapping}->{ $Param{Operation} } )
        || !IsStringWithData(
            $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Controller}
        )
        )
    {
        my $ErrorMessage = "REST Transport: Have no Invoker <-> Controller mapping for Invoker '$Param{Operation}'.";

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ErrorMessage,
        );
        return {
            Success      => 0,
            ErrorMessage => $ErrorMessage,
        };
    }

    my @RequestParam;
    my $Controller = $Config->{InvokerControllerMapping}->{ $Param{Operation} }->{Controller};

    # remove any query parameters that might be in the config
    # For example, from the controller: /Ticket/:TicketID/?:UserLogin&:Password
    #     controller must remain  /Ticket/:TicketID/
    $Controller =~ s{([^?]+)(.+)?}{$1};

    # remember the query parameters e.g. ?:UserLogin&:Password
    my $QueryParamsStr = $2 || '';

    my @ParamsToDelete;

    # replace any URI params with their actual value
    #    for example: from /Ticket/:TicketID/:Other
    #    to /Ticket/1/2 (considering that $Param{Data} contains TicketID = 1 and Other = 2)
    for my $ParamName ( sort keys %{ $Param{Data} } ) {
        if ( $Controller =~ m{:$ParamName(?=/|\?|$)}msx ) {
            my $ParamValue = $Param{Data}->{$ParamName};
            $ParamValue = URI::Escape::uri_escape_utf8($ParamValue);
            $Controller =~ s{:$ParamName(?=/|\?|$)}{$ParamValue}msxg;
            push @ParamsToDelete, $ParamName;
        }
    }

    $Self->{DebuggerObject}->Debug(
        Summary => "URI after interpolating URI params from outgoing data",
        Data    => $Controller,
    );

    if ($QueryParamsStr) {

        # replace any query params with their actual value
        #    for example: from ?UserLogin:UserLogin&Password=:Password
        #    to ?UserLogin=user&Password=secret
        #    (considering that $Param{Data} contains UserLogin = 'user' and Password = 'secret')
        my $ReplaceFlag;
        for my $ParamName ( sort keys %{ $Param{Data} } ) {
            if ( $QueryParamsStr =~ m{:$ParamName(?=&|$)}msx ) {
                my $ParamValue = $Param{Data}->{$ParamName};
                $ParamValue = URI::Escape::uri_escape_utf8($ParamValue);
                $QueryParamsStr =~ s{:$ParamName(?=&|$)}{$ParamValue}msxg;
                push @ParamsToDelete, $ParamName;
                $ReplaceFlag = 1;
            }
        }

        # append query params in the URI
        if ($ReplaceFlag) {
            $Controller .= $QueryParamsStr;

            $Self->{DebuggerObject}->Debug(
                Summary => "URI after interpolating Query params from outgoing data",
                Data    => $Controller,
            );
        }
    }

    # remove already used params
    for my $ParamName (@ParamsToDelete) {
        delete $Param{Data}->{$ParamName};
    }

    # get JSON object
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my $Body;
    if ( IsHashRefWithData( $Param{Data} ) ) {

        # POST, PUT and PATCH can have Data in the Body
        if (
            $RestCommand eq 'POST'
            || $RestCommand eq 'PUT'
            || $RestCommand eq 'PATCH'
            )
        {
            $Self->{DebuggerObject}->Debug(
                Summary => "Remaining outgoing data to be sent",
                Data    => $Param{Data},
            );

            $Param{Data} = $JSONObject->Encode(
                Data => $Param{Data},
            );
        }

        # whereas GET and the others just have a the data added to the Query URI.
        else {
            my $QueryParams = $RestClient->buildQuery(
                %{ $Param{Data} }
            );

            # check if controller already have a  question mark '?'
            if ( $Controller =~ m{\?}msx ) {

                # replace question mark '?' by an ampersand '&'
                $QueryParams =~ s{\A\?}{&};
            }

            $Controller .= $QueryParams;

            $Self->{DebuggerObject}->Debug(
                Summary => "URI after adding Query params from outgoing data",
                Data    => $Controller,
            );

            $Self->{DebuggerObject}->Debug(
                Summary => "Remaining outgoing data to be sent",
                Data    => "No data is sent in the request body as $RestCommand command sets all"
                    . " Data as query params",
            );
        }
    }
    push @RequestParam, $Controller;

    if ( IsStringWithData( $Param{Data} ) ) {
        $Body = $Param{Data};
        push @RequestParam, $Body;
    }

    # Headers is an optional tag, so just add it if present.
    if ( IsHashRefWithData($Headers) ) {
        push @RequestParam, $Headers;
    }

    $RestClient->$RestCommand(@RequestParam);

    my $ResponseCode = $RestClient->responseCode();
    my $ResponseError;
    my $ErrorMessage = "Error while performing REST '$RestCommand' request to Controller '$Controller' on Host '"
        . $Config->{Host} . "'.";

    if ( !IsStringWithData($ResponseCode) ) {
        $ResponseError = $ErrorMessage;
    }

    if ( $ResponseCode ne '200' ) {
        $ResponseError = $ErrorMessage . " Response code '$ResponseCode'.";
    }

    if ($ResponseError) {

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ResponseError,
        );
        return {
            Success      => 0,
            ErrorMessage => $ResponseError,
        };
    }

    my $ResponseContent = $RestClient->responseContent();
    if ( !IsStringWithData($ResponseContent) ) {

        my $ResponseError = $ErrorMessage . ' No content provided.';

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ResponseError,
        );
        return {
            Success      => 0,
            ErrorMessage => $ResponseError,
        };
    }

    {
        my $MaxSize = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::ResponseLoggingMaxSize') || 200;
        $MaxSize = $MaxSize * 1024;
        use bytes;

        my $ByteSize = length($ResponseContent);
        if ( $ByteSize < $MaxSize ) {
            $Self->{DebuggerObject}->Debug(
                Summary => 'JSON data received from remote system',
                Data    => $ResponseContent,
            );
        }
        else {
            $Self->{DebuggerObject}->Debug(
                Summary => "JSON data received from remote system was too large for logging",
                Data    => 'See SysConfig option GenericInterface::Operation::ResponseLoggingMaxSize to change the maximum.',
            );
        }
    }

    # send processed data to debugger
    $Self->{DebuggerObject}->Debug(
        Summary => 'JSON data received from remote system',
        Data    => $ResponseContent,
    );

    $ResponseContent = $Kernel::OM->Get('Kernel::System::Encode')->Convert2CharsetInternal(
        Text => $ResponseContent,
        From => 'utf-8',
    );

    # to convert the data into a hash, use the JSON module
    my $Result = $JSONObject->Decode(
        Data => $ResponseContent,
    );

    if ( !$Result ) {
        my $ResponseError = $ErrorMessage . ' Error while parsing JSON data.';

        # log to debugger
        $Self->{DebuggerObject}->Error(
            Summary => $ResponseError,
        );
        return {
            Success      => 0,
            ErrorMessage => $ResponseError,
        };
    }

    # all OK - return result
    return {
        Success => 1,
        Data    => $Result || undef,
    };
}

=begin Internal:

=item _Output()

Generate http response for provider and send it back to remote system.
Environment variables are checked for potential error messages.
Returns structure to be passed to provider.

    my $Result = $TransportObject->_Output(
        HTTPCode => 200,           # http code to be returned, optional
        Content  => 'response',    # message content, XML response on normal execution
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
    # for IIS to imitate nph- behavior
    # for all other browser 'Status:' should be used here
    # this breaks apache though

    # prepare data
    $Param{Content}  ||= '';
    $Param{HTTPCode} ||= 500;
    my $ContentType;
    if ( $Param{HTTPCode} eq 200 ) {
        $ContentType = 'application/json';
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
    my $Connection = $Self->{KeepAlive} ? 'Keep-Alive' : 'close';

    # in the constructor of this module STDIN and STDOUT are set to binmode without any additional
    # layer (according to the documentation this is the same as set :raw). Previous solutions for
    # binary responses requires the set of :raw or :utf8 according to IO layers.
    # with that solution Windows OS requires to set the :raw layer in binmode, see #bug#8466.
    # while in *nix normally was better to set :utf8 layer in binmode, see bug#8558, otherwise
    # XML parser complains about it... ( but under special circumstances :raw layer was needed
    # instead ).
    # this solution to set the binmode in the constructor and then :utf8 layer before the response
    # is sent  apparently works in all situations. ( Linux circumstances to requires :raw was no
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

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
