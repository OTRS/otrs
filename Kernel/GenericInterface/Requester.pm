# --
# Kernel/GenericInterface/Requester.pm - GenericInterface Requester handler
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Requester;

use strict;
use warnings;

use vars qw(@ISA);

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;
use Kernel::GenericInterface::Mapping;
use Kernel::GenericInterface::Transport;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

=head1 NAME

Kernel::GenericInterface::Requester - GenericInterface handler for sending web service requests to remote providers

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Requester;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $RequesterObject = Kernel::GenericInterface::Requester->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{WebserviceObject}
        = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    return $Self;
}

=item Run()

receives the current incoming web service request, handles it,
and returns an appropriate answer based on the configured requested
web service.

    my $Result = $RequesterObject->Run(
        WebserviceID     => 1,                      # ID of the configured remote web service to use OR
        Invoker          => 'some_operation',       # Name of the Invoker to be used for sending the request
        Data             => {                       # Data payload for the Invoker request (remote webservice)
            ...
        },
    );

    $Result = {
        Success         => 1,   # 0 or 1
        ErrorMessage    => '',  # if an error occurred
        Data            => {    # Data payload of Invoker result (web service response)
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(WebserviceID Invoker Data)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $Needed!",
            );

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }
    }

    #
    # Locate desired webservice and load its configuration data.
    #

    my $WebserviceID = $Param{WebserviceID};

    my $Webservice = $Self->{WebserviceObject}->WebserviceGet(
        ID => $WebserviceID,
    );

    if ( !IsHashRefWithData($Webservice) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Could not load web service configuration for web service $Param{WebserviceID}",
        );

        return {
            Success => 0,
            ErrorMessage =>
                "Could not load web service configuration for web service $Param{WebserviceID}",
        };
    }

    my $RequesterConfig = $Webservice->{Config}->{Requester};

    #
    # Create a debugger instance which will log the details of this
    #   communication entry.
    #

    $Self->{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
        %{$Self},
        DebuggerConfig    => $Webservice->{Config}->{Debugger},
        WebserviceID      => $WebserviceID,
        CommunicationType => 'Requester',
    );

    if ( ref $Self->{DebuggerObject} ne 'Kernel::GenericInterface::Debugger' ) {
        return {
            Success      => 0,
            ErrorMessage => "Could not initialize debugger",
        };
    }

    $Self->{DebuggerObject}->Debug(
        Summary => 'Communication sequence started',
        Data    => $Param{Data},
    );

    #
    # Create Invoker object and prepare the request on it.
    #

    my $InvokerObject = Kernel::GenericInterface::Invoker->new(
        %{$Self},
        InvokerType  => $RequesterConfig->{Invoker}->{ $Param{Invoker} }->{Type},
        WebserviceID => $WebserviceID,
    );

    # bail out if invoker init failed
    if ( ref $InvokerObject ne 'Kernel::GenericInterface::Invoker' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'InvokerObject could not be initialized',
            Data    => $InvokerObject,
        );
    }

    my $FunctionResult = $InvokerObject->PrepareRequest(
        Data => $Param{Data},
    );

    if ( !$FunctionResult->{Success} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'InvokerObject returned an error, cancelling Request',
            Data    => $FunctionResult->{ErrorMessage},
        );
    }

    # not always a success on the invoker prepare request means that invoker need to do something
    # there are cases in which the requester does not need to do anything, for this cases
    # StopCommunication can be sent. in this cases the request will be successfull with out sending
    # the request acctually
    elsif ( $FunctionResult->{StopCommunication} && $FunctionResult->{StopCommunication} eq 1 ) {
        return {
            Success => 1,
        };
    }

    #
    # Map the outgoing data.
    #

    my $DataOut = $FunctionResult->{Data};

    $Self->{DebuggerObject}->Debug(
        Summary => "Outgoing data before mapping",
        Data    => $DataOut,
    );

    # decide if mapping needs to be used or not
    if (
        IsHashRefWithData(
            $RequesterConfig->{Invoker}->{ $Param{Invoker} }->{MappingOutbound}
        )
        )
    {
        my $MappingOutObject = Kernel::GenericInterface::Mapping->new(
            %{$Self},
            MappingConfig =>
                $RequesterConfig->{Invoker}->{ $Param{Invoker} }->{MappingOutbound},
        );

        # if mapping init failed, bail out
        if ( ref $MappingOutObject ne 'Kernel::GenericInterface::Mapping' ) {
            $Self->{DebuggerObject}->Error(
                Summary => 'MappingOut could not be initialized',
                Data    => $MappingOutObject,
            );
            return $Self->{DebuggerObject}->Error(
                Summary => $FunctionResult->{ErrorMessage},
            );
        }

        $FunctionResult = $MappingOutObject->Map(
            Data => $DataOut,
        );

        if ( !$FunctionResult->{Success} ) {
            return $Self->{DebuggerObject}->Error(
                Summary => $FunctionResult->{ErrorMessage},
            );
        }

        $DataOut = $FunctionResult->{Data};

        $Self->{DebuggerObject}->Debug(
            Summary => "Outgoing data after mapping",
            Data    => $DataOut,
        );
    }

    my $TransportObject = Kernel::GenericInterface::Transport->new(
        %{$Self},
        TransportConfig => $RequesterConfig->{Transport},
    );

    # bail out if transport init failed
    if ( ref $TransportObject ne 'Kernel::GenericInterface::Transport' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'TransportObject could not be initialized',
            Data    => $TransportObject,
        );
    }

    # read request content
    $FunctionResult = $TransportObject->RequesterPerformRequest(
        Operation => $Param{Invoker},
        Data      => $DataOut,
    );

    if ( !$FunctionResult->{Success} ) {
        my $ErrorReturn = $Self->{DebuggerObject}->Error(
            Summary => $FunctionResult->{ErrorMessage},
        );

        # Send error to Invoker
        $InvokerObject->HandleResponse(
            ResponseSuccess      => 0,
            ResponseErrorMessage => $FunctionResult->{ErrorMessage},
        );

        return $ErrorReturn;
    }

    my $DataIn = $FunctionResult->{Data};

    $Self->{DebuggerObject}->Debug(
        Summary => "Incoming data before mapping",
        Data    => $DataIn,
    );

    # decide if mapping needs to be used or not
    if (
        IsHashRefWithData(
            $RequesterConfig->{Invoker}->{ $Param{Invoker} }->{MappingInbound}
        )
        )
    {
        my $MappingInObject = Kernel::GenericInterface::Mapping->new(
            %{$Self},
            MappingConfig =>
                $RequesterConfig->{Invoker}->{ $Param{Invoker} }->{MappingInbound},
        );

        # if mapping init failed, bail out
        if ( ref $MappingInObject ne 'Kernel::GenericInterface::Mapping' ) {
            $Self->{DebuggerObject}->Error(
                Summary => 'MappingOut could not be initialized',
                Data    => $MappingInObject,
            );
            return $Self->{DebuggerObject}->Error(
                Summary => $FunctionResult->{ErrorMessage},
            );
        }

        $FunctionResult = $MappingInObject->Map(
            Data => $DataIn,
        );

        if ( !$FunctionResult->{Success} ) {
            return $Self->{DebuggerObject}->Error(
                Summary => $FunctionResult->{ErrorMessage},
            );
        }

        $DataIn = $FunctionResult->{Data};

        $Self->{DebuggerObject}->Debug(
            Summary => "Incoming data after mapping",
            Data    => $DataIn,
        );
    }

    #
    # Handle response data in Invoker
    #

    $FunctionResult = $InvokerObject->HandleResponse(
        ResponseSuccess => 1,
        Data            => $DataIn,
    );

    if ( !$FunctionResult->{Success} ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Error handling response data in Invoker',
            Data    => $FunctionResult->{ErrorMessage},
        );
    }

    $DataIn = $FunctionResult->{Data};

    return {
        Success => 1,
        Data    => $DataIn,
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
