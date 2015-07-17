# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
use Kernel::System::VariableCheck (qw(IsHashRefWithData));

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::GenericInterface::Webservice',
);

=head1 NAME

Kernel::GenericInterface::Provider - handler for incoming webservice requests.

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ProviderObject = $Kernel::OM->Get('Kernel::GenericInterface::Provider');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

receives the current incoming web service request, handles it,
and returns an appropriate answer based on the configured requested
web service.

    # put this in the handler script
    $ProviderObject->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    #
    # First, we need to locate the desired webservice and load its configuration data.
    #

    my $Webservice;

    # on Microsoft IIS 7.0, $ENV{REQUEST_URI} is not set. See bug#9172.
    my $RequestURI = $ENV{REQUEST_URI} || $ENV{PATH_INFO};

    my ($WebserviceID) = $RequestURI =~ m{ nph-genericinterface[.]pl [/] WebserviceID [/] (\d+) }smx;

    if ($WebserviceID) {

        $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            ID => $WebserviceID,
        );

    }
    else {

        my ($WebserviceName) = $RequestURI =~ m{ nph-genericinterface[.]pl [/] Webservice [/] ([^/?]+) }smx;

        if ( !$WebserviceName ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not determine WebserviceID from query string $RequestURI",
            );

            return;    # bail out without Transport, Apache will generate 500 Error
        }

        $WebserviceName = URI::Escape::uri_unescape($WebserviceName);

        $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            Name => $WebserviceName,
        );
    }

    if ( !IsHashRefWithData($Webservice) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Could not load web service configuration for web service at $RequestURI",
        );

        return;    # bail out without Transport, Apache will generate 500 Error
    }

    $WebserviceID = $Webservice->{ID};

    #
    # Create a debugger instance which will log the details of this
    #   communication entry.
    #

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig    => $Webservice->{Config}->{Debugger},
        WebserviceID      => $WebserviceID,
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

    # bail out if transport init failed
    if ( ref $Self->{TransportObject} ne 'Kernel::GenericInterface::Transport' ) {

        return $DebuggerObject->Error(
            Summary => 'TransportObject could not be initialized',
            Data    => $Self->{TransportObject},
        );
    }

    # read request content
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
    # Map the incoming data based on the configured mapping
    #

    my $DataIn = $FunctionResult->{Data};

    $DebuggerObject->Debug(
        Summary => "Incoming data before mapping",
        Data    => $DataIn,
    );

    # decide if mapping needs to be used or not
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

        # if mapping init failed, bail out
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
        WebserviceID   => $WebserviceID,
    );

    # if operation init failed, bail out
    if ( ref $OperationObject ne 'Kernel::GenericInterface::Operation' ) {
        $DebuggerObject->Error(
            Summary => 'Operation could not be initialized',
            Data    => $OperationObject,
        );

        # set default error message
        my $ErrorMessage = 'Unknown error in Operation initialization';

        # check if we got an error message from the operation and overwrite it
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

    # decide if mapping needs to be used or not
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

        # if mapping init failed, bail out
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
    # Generate the actual response
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

=item _GenerateErrorResponse()

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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
