# --
# Kernel/GenericInterface/Transport/HTTP/SOAP.pm - GenericInterface network transport interface for HTTP::SOAP
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: SOAP.pm,v 1.19 2011-03-17 03:02:12 sb Exp $
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

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

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
    for my $Needed (qw(MainObject EncodeObject DebuggerObject TransportConfig)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

#TODO QA: add perldoc to all functions!

# FIXME perldoc for all functions
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

    # check if we have content
    if ( !IsStringWithData($Content) ) {
        return $Self->_Error(
            Summary   => 'Could not read input data',
            HTTPError => 500,
        );
    }

    # convert charset if necessary
    my $ContentCharset = $1
        if $ENV{'CONTENT_TYPE'} =~ m{ \A .* charset= ["']? ( [^"']+ ) ["']? \z }xmsi;
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
    my @CallData = ( 'response', $Self->{Operation} . 'Response' );
    if ($SOAPResult) {
        push @CallData, $SOAPResult;
    }
    my $Serialized = SOAP::Serializer
        ->autotype(0)
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
        HTTPCode => 200,
        Content  => $Serialized,
    );
}

sub RequesterPerformRequest {
    my ( $Self, %Param ) = @_;

    # check transport config
    if ( !IsHashRefWithData( $Self->{TransportConfig} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Have no TransportConfig',
        };
    }
    if ( !IsHashRefWithData( $Self->{TransportConfig}->{Config} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Have no Config',
        };
    }
    my $Config = $Self->{TransportConfig}->{Config};

    # check namespace and endpoint config
    NEEDED:
    for my $Needed (qw(Endpoint NameSpace)) {
        next NEEDED if IsStringWithData( $Config->{$Needed} );

        return {
            Success      => 0,
            ErrorMessage => "Have no $Needed in config",
        };
    }

    # check data param
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'Invalid Data',
        };
    }

    # check operation param
    if ( !IsStringWithData( $Param{Operation} ) ) {
        return {
            Success      => 0,
            ErrorMessage => 'Need Operation',
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
            ErrorMessage => 'Error preparing used method',
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
                $URL =~ s{ ( http s? :// ) }{$1$User:$Password@}xmsi;
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

    # send request to server
    my @CallData = ($SOAPMethod);
    if ($SOAPData) {
        push @CallData, $SOAPData->{Data};
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
            ErrorMessage => 'Could not get xml data sent to remote system',
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
            ErrorMessage => 'Could not deserialize received xml data',
        };
    }

    # check if we have response data for the specified operation in the soap result
    my $Body = $Deserialized->body();
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
        Data    => $Body->{ $Param{Operation} . 'Response' },
    };
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

    # imitate nph- cgi for IIS
    my $Status;

    # FIXME is this correct? it seems to break things for apache
    # if ( IsStringWithData($ENV{'SERVER_SOFTWARE'}) && $ENV{'SERVER_SOFTWARE'} =~ m{ IIS }xms ) {
    $Status = $ENV{SERVER_PROTOCOL} || 'HTTP/1.0';

    # }
    # else {
    #     $Status = 'Status:';
    # }

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

    # calculate content length (before convert for correct result)
    my $ContentLength = length $Param{Content};

    # convert from perl internal format to utf8 for output
    $Param{Content} = Encode::decode( 'utf8', $Param{Content} );

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

    # print data to http - '\r' is required according to HTTP RFCs
    my $StatusMessage = HTTP::Status::status_message( $Param{HTTPCode} );
    print STDOUT <<"EOF";
$Status $Param{HTTPCode} $StatusMessage\r
Content-Type: $ContentType; charset=UTF-8\r
Content-Length: $ContentLength\r
\r
$Param{Content}
EOF

    return {
        Success      => $Success,
        ErrorMessage => $ErrorMessage,
    };
}

sub _SOAPOutputRecursion {
    my ( $Self, %Param ) = @_;

    my @Result;
    if ( !defined $Param{Data} ) {
        return {
            Success => 1,
            Data    => SOAP::Data->value(''),
        };
    }
    if ( IsString( $Param{Data} ) ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Data} );
        return {
            Success => 1,
            Data    => SOAP::Data->value( $Param{Data} ),
        };
    }
    if ( IsArrayRefWithData( $Param{Data} ) ) {
        KEY:
        for my $Key ( @{ $Param{Data} } ) {
            my $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Key );
            if ( !$RecurseResult->{Success} ) {
                return $RecurseResult;
            }
            if ( IsString($Key) ) {
                push @Result, SOAP::Data->value( $RecurseResult->{Data} );
                next KEY;
            }
            push @Result, \SOAP::Data->value(
                @{ $RecurseResult->{Data} },
            );
        }
        return {
            Success => 1,
            Data    => \@Result,
        };
    }
    if ( IsHashRefWithData( $Param{Data} ) ) {
        for my $Key ( sort keys %{ $Param{Data} } ) {
            my $RecurseResult;
            my $Value;
            if ( !defined $Param{Data}->{$Key} || IsString( $Param{Data}->{$Key} ) ) {
                $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} );
                if ( !$RecurseResult->{Success} ) {
                    return $RecurseResult;
                }
                $Value = $RecurseResult->{Data};
            }
            elsif ( IsHashRefWithData( $Param{Data}->{$Key} ) ) {
                $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} );
                if ( !$RecurseResult->{Success} ) {
                    return $RecurseResult;
                }
                $Value = \SOAP::Data->value(
                    @{ $RecurseResult->{Data} },
                );
            }
            elsif ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {
                $RecurseResult = $Self->_SOAPOutputRecursion( Data => $Param{Data}->{$Key} );
                if ( !$RecurseResult->{Success} ) {
                    return $RecurseResult;
                }
                $Value = SOAP::Data->value(
                    @{ $RecurseResult->{Data} },
                );
            }
            else {
                return {
                    Success      => 0,
                    ErrorMessage => 'Param is not a string, an array reference or a hash reference',
                };
            }
            $Self->{EncodeObject}->EncodeOutput( \$Key );
            push @Result, SOAP::Data->name($Key)->value($Value);
        }
        return {
            Success => 1,
            Data    => \@Result,
        };
    }
    return {
        Success      => 0,
        ErrorMessage => 'Param is not a string, an array reference or a hash reference',
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

$Revision: 1.19 $ $Date: 2011-03-17 03:02:12 $

=cut
