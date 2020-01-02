# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Provider;

use strict;
use warnings;

use URI::Escape;
use Storable;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport;
use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Operation;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::GenericInterface::ErrorHandling',
);

=head1 NAME

Kernel::GenericInterface::Provider - handler for incoming web service requests.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ProviderObject = $Kernel::OM->Get('Kernel::GenericInterface::Provider');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

Receives the current incoming web service request, handles it,
and returns an appropriate answer based on the requested web service.

    # put this in the handler script
    $ProviderObject->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # On Microsoft IIS 7.0, $ENV{REQUEST_URI} is not set. See bug#9172.
    my $RequestURI = $ENV{REQUEST_URI} || $ENV{PATH_INFO};

    #
    # Locate and verify the desired web service based on the request URI and load its configuration data.
    #

    # Check RequestURI for a web service by id or name.
    my %WebserviceGetData;
    if (
        $RequestURI
        && $RequestURI
        =~ m{ nph-genericinterface[.]pl/ (?: WebserviceID/ (?<ID> \d+ ) | Webservice/ (?<Name> [^/?]+ ) ) }smx
        )
    {
        %WebserviceGetData = (
            ID   => $+{ID},
            Name => $+{Name} ? URI::Escape::uri_unescape( $+{Name} ) : undef,
        );
    }

    # URI is empty or invalid.
    if ( !%WebserviceGetData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine WebserviceID or Webservice from query string '$RequestURI'",
        );
        return;    # bail out without Transport, Apache will generate 500 Error
    }

    # Check if requested web service exists and is valid.
    my $WebserviceObject      = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $WebserviceList        = $WebserviceObject->WebserviceList();
    my %WebserviceListReverse = reverse %{$WebserviceList};
    if (
        $WebserviceGetData{Name}  && !$WebserviceListReverse{ $WebserviceGetData{Name} }
        || $WebserviceGetData{ID} && !$WebserviceList->{ $WebserviceGetData{ID} }
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not find valid web service for query string '$RequestURI'",
        );
        return;    # bail out without Transport, Apache will generate 500 Error
    }

    my $Webservice = $WebserviceObject->WebserviceGet(%WebserviceGetData);
    if ( !IsHashRefWithData($Webservice) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Could not load web service configuration for query string '$RequestURI'",
        );
        return;    # bail out without Transport, Apache will generate 500 Error
    }

    # Create a debugger instance which will log the details of this communication entry.
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig    => $Webservice->{Config}->{Debugger},
        WebserviceID      => $Webservice->{ID},
        CommunicationType => 'Provider',
        RemoteIP          => $ENV{REMOTE_ADDR},
    );

    if ( ref $DebuggerObject ne 'Kernel::GenericInterface::Debugger' ) {

        return;    # bail out without Transport, Apache will generate 500 Error
    }

    $DebuggerObject->Debug(
        Summary => 'Communication sequence started',
        Data    => \%ENV,
    );

    #
    # Create the network transport backend and read the network request.
    #

    my $ProviderConfig = $Webservice->{Config}->{Provider};

    $Self->{TransportObject} = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => $ProviderConfig->{Transport},
    );

    # Bail out if transport initialization failed.
    if ( ref $Self->{TransportObject} ne 'Kernel::GenericInterface::Transport' ) {

        return $DebuggerObject->Error(
            Summary => 'TransportObject could not be initialized',
            Data    => $Self->{TransportObject},
        );
    }

    # Combine all data for error handler we got so far.
    my %HandleErrorData = (
        DebuggerObject   => $DebuggerObject,
        WebserviceID     => $Webservice->{ID},
        WebserviceConfig => $Webservice->{Config},
    );

    # Read request content.
    my $FunctionResult = $Self->{TransportObject}->ProviderProcessRequest();

    # If the request was not processed correctly, send error to client.
    if ( !$FunctionResult->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'TransportObject returned an error, cancelling Request';
        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => {},
            ErrorStage  => 'ProviderRequestReceive',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
        );
    }

    # prepare the data include configuration and payload
    my %DataInclude = (
        ProviderRequestInput => $FunctionResult->{Data},
    );

    my $Operation = $FunctionResult->{Operation};

    $DebuggerObject->Debug(
        Summary => "Detected operation '$Operation'",
    );

    #
    # Map the incoming data based on the configured mapping.
    #

    my $DataIn = $FunctionResult->{Data};

    $DebuggerObject->Debug(
        Summary => "Incoming data before mapping",
        Data    => $DataIn,
    );

    # Decide if mapping needs to be used or not.
    if (
        IsHashRefWithData( $ProviderConfig->{Operation}->{$Operation}->{MappingInbound} )
        )
    {
        my $MappingInObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            Operation      => $Operation,
            OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
            MappingConfig =>
                $ProviderConfig->{Operation}->{$Operation}->{MappingInbound},
        );

        # If mapping initialization failed, bail out.
        if ( ref $MappingInObject ne 'Kernel::GenericInterface::Mapping' ) {
            $DebuggerObject->Error(
                Summary => 'MappingIn could not be initialized',
                Data    => $MappingInObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            );
        }

        # add operation to data for error handler
        $HandleErrorData{Operation} = $Operation;

        $FunctionResult = $MappingInObject->Map(
            Data => $DataIn,
        );

        if ( !$FunctionResult->{Success} ) {

            my $Summary = $FunctionResult->{ErrorMessage} // 'MappingInObject returned an error, cancelling Request';
            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderRequestMap',
                Summary     => $Summary,
                Data        => $FunctionResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderRequestMapOutput} = $FunctionResult->{Data};

        $DataIn = $FunctionResult->{Data};

        $DebuggerObject->Debug(
            Summary => "Incoming data after mapping",
            Data    => $DataIn,
        );
    }

    #
    # Execute actual operation.
    #

    my $OperationObject = Kernel::GenericInterface::Operation->new(
        DebuggerObject => $DebuggerObject,
        Operation      => $Operation,
        OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
        WebserviceID   => $Webservice->{ID},
    );

    # If operation initialization failed, bail out.
    if ( ref $OperationObject ne 'Kernel::GenericInterface::Operation' ) {
        $DebuggerObject->Error(
            Summary => 'Operation could not be initialized',
            Data    => $OperationObject,
        );

        # Set default error message.
        my $ErrorMessage = 'Unknown error in Operation initialization';

        # Check if we got an error message from the operation and overwrite it.
        if ( IsHashRefWithData($OperationObject) && $OperationObject->{ErrorMessage} ) {
            $ErrorMessage = $OperationObject->{ErrorMessage};
        }

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $DebuggerObject,
            ErrorMessage   => $ErrorMessage,
        );
    }

    # add operation object to data for error handler
    $HandleErrorData{OperationObject} = $OperationObject;

    $FunctionResult = $OperationObject->Run(
        Data => $DataIn,
    );

    if ( !$FunctionResult->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'OperationObject returned an error, cancelling Request';
        return $Self->_HandleError(
            %HandleErrorData,
            DataInclude => \%DataInclude,
            ErrorStage  => 'ProviderRequestProcess',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
        );
    }

    # extend the data include payload
    $DataInclude{ProviderResponseInput} = $FunctionResult->{Data};

    #
    # Map the outgoing data based on configured mapping.
    #

    my $DataOut = $FunctionResult->{Data};

    $DebuggerObject->Debug(
        Summary => "Outgoing data before mapping",
        Data    => $DataOut,
    );

    # Decide if mapping needs to be used or not.
    if (
        IsHashRefWithData(
            $ProviderConfig->{Operation}->{$Operation}->{MappingOutbound}
        )
        )
    {
        my $MappingOutObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $DebuggerObject,
            Operation      => $Operation,
            OperationType  => $ProviderConfig->{Operation}->{$Operation}->{Type},
            MappingConfig =>
                $ProviderConfig->{Operation}->{$Operation}->{MappingOutbound},
        );

        # If mapping initialization failed, bail out
        if ( ref $MappingOutObject ne 'Kernel::GenericInterface::Mapping' ) {
            $DebuggerObject->Error(
                Summary => 'MappingOut could not be initialized',
                Data    => $MappingOutObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            );
        }

        $FunctionResult = $MappingOutObject->Map(
            Data        => $DataOut,
            DataInclude => \%DataInclude,
        );

        if ( !$FunctionResult->{Success} ) {

            my $Summary = $FunctionResult->{ErrorMessage} // 'MappingOutObject returned an error, cancelling Request';
            return $Self->_HandleError(
                %HandleErrorData,
                DataInclude => \%DataInclude,
                ErrorStage  => 'ProviderResponseMap',
                Summary     => $Summary,
                Data        => $FunctionResult->{Data} // $Summary,
            );
        }

        # extend the data include payload
        $DataInclude{ProviderResponseMapOutput} = $FunctionResult->{Data};

        $DataOut = $FunctionResult->{Data};

        $DebuggerObject->Debug(
            Summary => "Outgoing data after mapping",
            Data    => $DataOut,
        );
    }

    #
    # Generate the actual response.
    #

    $FunctionResult = $Self->{TransportObject}->ProviderGenerateResponse(
        Success => 1,
        Data    => $DataOut,
    );

    if ( !$FunctionResult->{Success} ) {

        my $Summary = $FunctionResult->{ErrorMessage} // 'TransportObject returned an error, cancelling Request';
        $Self->_HandleError(
            %HandleErrorData,
            DataInclude => \%DataInclude,
            ErrorStage  => 'ProviderResponseTransmit',
            Summary     => $Summary,
            Data        => $FunctionResult->{Data} // $Summary,
        );
    }

    return;
}

=begin Internal:

=head2 _GenerateErrorResponse()

returns an error message to the client.

    $ProviderObject->_GenerateErrorResponse(
        ErrorMessage => $ErrorMessage,
    );

=cut

sub _GenerateErrorResponse {
    my ( $Self, %Param ) = @_;

    my $FunctionResult = $Self->{TransportObject}->ProviderGenerateResponse(
        Success      => 0,
        ErrorMessage => $Param{ErrorMessage},
    );

    if ( !$FunctionResult->{Success} ) {
        $Param{DebuggerObject}->Error(
            Summary => 'Error response could not be sent',
            Data    => $FunctionResult->{ErrorMessage},
        );
    }

    return;
}

=head2 _HandleError()

handles errors by
- informing operation about it (if supported)
- calling an error handling layer

    my $ReturnData = $RequesterObject->_HandleError(
        DebuggerObject   => $DebuggerObject,
        WebserviceID     => 1,
        WebserviceConfig => $WebserviceConfig,
        DataInclude      => $DataIncludeStructure,
        ErrorStage       => 'PrepareRequest',        # at what point did the error occur?
        Summary          => 'an error occurred',
        Data             => $ErrorDataStructure,
        OperationObject  => $OperationObject,        # optional
        Operation        => 'OperationName',         # optional
    );

    my $ReturnData = {
        Success      => 0,
        ErrorMessage => $Param{Summary},
    };

=cut

sub _HandleError {
    my ( $Self, %Param ) = @_;

    NEEDED:
    for my $Needed (qw(DebuggerObject WebserviceID WebserviceConfig DataInclude ErrorStage Summary Data)) {
        next NEEDED if $Param{$Needed};
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no $Needed!",
        );

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $Param{DebuggerObject},
            ErrorMessage   => "Got no $Needed!",
        );
    }

    my $ErrorHandlingResult = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling')->HandleError(
        WebserviceID      => $Param{WebserviceID},
        WebserviceConfig  => $Param{WebserviceConfig},
        CommunicationID   => $Param{DebuggerObject}->{CommunicationID},
        CommunicationType => 'Provider',
        CommunicationName => $Param{Operation},
        ErrorStage        => $Param{ErrorStage},
        Summary           => $Param{Summary},
        Data              => $Param{Data},
    );

    if (
        !$Param{Operation}
        || !$Param{OperationObject}
        || !$Param{OperationObject}->{BackendObject}->can('HandleError')
        )
    {
        return $Self->_GenerateErrorResponse(
            DebuggerObject => $Param{DebuggerObject},
            ErrorMessage   => $Param{Summary},
        );
    }

    my $HandleErrorData;
    if ( !defined $Param{Data} || IsString( $Param{Data} ) ) {
        $HandleErrorData = $Param{Data} // '';
    }
    else {
        $HandleErrorData = Storable::dclone( $Param{Data} );
    }
    $Param{DebuggerObject}->Debug(
        Summary => 'Error data before mapping',
        Data    => $HandleErrorData,
    );

    my $OperationConfig = $Param{WebserviceConfig}->{Provider}->{Operation}->{ $Param{Operation} };

    # TODO: use separate mapping config for errors.
    if ( IsHashRefWithData( $OperationConfig->{MappingInbound} ) ) {
        my $MappingErrorObject = Kernel::GenericInterface::Mapping->new(
            DebuggerObject => $Param{DebuggerObject},
            Operation      => $Param{Operation},
            OperationType  => $OperationConfig->{Type},
            MappingConfig  => $OperationConfig->{MappingInbound},
        );

        # If mapping init failed, bail out.
        if ( ref $MappingErrorObject ne 'Kernel::GenericInterface::Mapping' ) {
            $Param{DebuggerObject}->Error(
                Summary => 'MappingErr could not be initialized',
                Data    => $MappingErrorObject,
            );

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $Param{DebuggerObject},
                ErrorMessage   => 'MappingErr could not be initialized',
            );
        }

        # Map error data.
        my $MappingErrorResult = $MappingErrorObject->Map(
            Data => {
                Fault => $HandleErrorData,
            },
            DataInclude => {
                %{ $Param{DataInclude} },
                ProviderErrorHandlingOutput => $ErrorHandlingResult->{Data},
            },
        );
        if ( !$MappingErrorResult->{Success} ) {
            return $Self->_GenerateErrorResponse(
                DebuggerObject => $Param{DebuggerObject},
                ErrorMessage   => $MappingErrorResult->{ErrorMessage},
            );
        }

        $HandleErrorData = $MappingErrorResult->{Data};

        $Param{DebuggerObject}->Debug(
            Summary => 'Error data after mapping',
            Data    => $HandleErrorData,
        );
    }

    my $OperationHandleErrorOutput = $Param{OperationObject}->HandleError(
        Data => $HandleErrorData,
    );
    if ( !$OperationHandleErrorOutput->{Success} ) {
        $Param{DebuggerObject}->Error(
            Summary => 'Error handling error data in Operation',
            Data    => $OperationHandleErrorOutput->{ErrorMessage},
        );
    }

    return $Self->_GenerateErrorResponse(
        DebuggerObject => $Param{DebuggerObject},
        ErrorMessage   => $Param{Summary},
    );
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
