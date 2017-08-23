# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Provider;

use strict;
use warnings;

use URI::Escape;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport;
use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Operation;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::GenericInterface::Webservice',
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

    # Read request content.
    my $FunctionResult = $Self->{TransportObject}->ProviderProcessRequest();

    # If the request was not processed correctly, send error to client.
    if ( !$FunctionResult->{Success} ) {
        $DebuggerObject->Error(
            Summary => 'Request could not be processed',
            Data    => $FunctionResult->{ErrorMessage},
        );

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $DebuggerObject,
            ErrorMessage   => $FunctionResult->{ErrorMessage},
        );
    }

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

        $FunctionResult = $MappingInObject->Map(
            Data => $DataIn,
        );

        if ( !$FunctionResult->{Success} ) {

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            );
        }

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

    $FunctionResult = $OperationObject->Run(
        Data => $DataIn,
    );

    if ( !$FunctionResult->{Success} ) {

        return $Self->_GenerateErrorResponse(
            DebuggerObject => $DebuggerObject,
            ErrorMessage   => $FunctionResult->{ErrorMessage},
        );
    }

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
            Data => $DataOut,
        );

        if ( !$FunctionResult->{Success} ) {

            return $Self->_GenerateErrorResponse(
                DebuggerObject => $DebuggerObject,
                ErrorMessage   => $FunctionResult->{ErrorMessage},
            );
        }

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
        $DebuggerObject->Error(
            Summary => 'Response could not be sent',
            Data    => $FunctionResult->{ErrorMessage},
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

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
