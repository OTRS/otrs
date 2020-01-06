# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CommunicationLog;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our %ObjectManagerFlags = (
    NonSingleton            => 1,
    AllowConstructorFailure => 1,
);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::CommunicationLog::DB',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Main',
);

=head1 PUBLIC INTERFACE

=head2 new()

Creates a CommunicationLog object. Do not use new() directly, instead use the object manager.
This is a class which represents a complete communication. Therefore the created
instances must not be shared between processes of different communications.

Please use the object manager as follows for this class:

    # Create an object, representing a new communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        }
    );

    # Create an object for an already existing communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => 123,
        }
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    if ( IsStringWithData( $Param{CommunicationID} ) || IsStringWithData( $Param{ObjectLogID} ) ) {
        return $Self->_RecoverCommunicationObject(%Param);
    }

    return $Self->_CommunicationStart(%Param);
}

=head2 CommunicationStop()

Update the status of a communication entry.

    my $Success = $CommunicationLogObject->CommunicationStop(
        Status => 'Successful', # (required) Needs to be either 'Successful', 'Warning' or 'Failed'
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub CommunicationStop {
    my ( $Self, %Param ) = @_;

    # close open object types before
    for my $ObjectType ( sort keys %{ $Self->{Object} } ) {
        return if !$Self->ObjectLogStop( ObjectType => $ObjectType );
    }

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my $Result = $CommunicationDBObject->CommunicationUpdate(
        CommunicationID => $Self->{CommunicationID},
        Status          => $Param{Status},
    );

    # Remember status
    $Self->{Status} = $Param{Status};

    return 1;
}

=head2 CommunicationIDGet()

Returns the communication id.

    my $CommunicationID = $CommunicationLogObject->CommunicationIDGet();

Returns:

    The communication id of the current communication represented by this object.

=cut

sub CommunicationIDGet {
    my ( $Self, %Param ) = @_;

    return $Self->{CommunicationID};
}

=head2 TransportGet()

Returns the used transport.

    my $Transport = $CommunicationLogObject->TransportGet();

Returns:

    The transport of the current communication represented by this object.

=cut

sub TransportGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Transport};
}

=head2 DirectionGet()

Returns the used direction.

    my $Direction = $CommunicationLogObject->DirectionGet();

Returns:

    The direction of the current communication represented by this object.

=cut

sub DirectionGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Direction};
}

=head2 StatusGet()

Returns the current Status.

    my $Direction = $CommunicationLogObject->StatusGet();

Returns:

    The status of the current communication represented by this object.

=cut

sub StatusGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Status};
}

=head2 ObjectLogStart()

Starts a log object of a given object type.

    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection' # (required) Can be 'Connection' or 'Message'
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLogStart {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Current}->{ $Param{ObjectLogType} } ) {
        return $Self->_LogError("Object already has an open Log for this type.");
    }

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my $ObjectLogID = $CommunicationDBObject->ObjectLogCreate(
        CommunicationID => $Self->{CommunicationID},
        %Param
    );

    return if !$ObjectLogID;

    $Self->{Current}->{ $Param{ObjectLogType} } = $ObjectLogID;

    return $ObjectLogID;
}

=head2 ObjectLogStop()

Stops a log object of a given object type.

    my $Success = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection'                        # (required) Can be 'Connection' or 'Message'
        ObjectLogID   => 123, # (required) The ObjectID of the started object type
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLogStop {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ObjectLogType} ) {
        return $Self->_LogError("Need ObjectLogType.");
    }

    if ( !$Self->{Current}->{ $Param{ObjectLogType} } ) {
        return $Self->_LogError("Cannot stop a ObjectLog that is not open.");
    }

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my $Result = $CommunicationDBObject->ObjectLogUpdate(
        CommunicationID => $Self->{CommunicationID},
        ObjectLogID     => $Self->{Current}->{ $Param{ObjectLogType} },
        ObjectLogType   => $Param{ObjectLogType},
        Status          => $Param{Status},
    );

    if ( !$Result ) {
        return $Self->_LogError("Could not stop object log.");
    }

    delete $Self->{Current}->{ $Param{ObjectLogType} };

    return 1;
}

=head2 ObjectLog()

Adds a log entry for a certain log object.

    my $Success = $CommunicationLogObject->ObjectLog(
        ObjectLogType => '...' # (required) To be defined by the related LogObject
        ObjectLogID   => 123, # (required) The ObjectID of the started object type
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLog {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ObjectLogType} ) {
        return $Self->_LogError("Need ObjectLogType.");
    }

    my $ObjectLogID = $Self->{Current}->{ $Param{ObjectLogType} };
    if ( !$ObjectLogID ) {
        return $Self->_LogError("Object Log needs to have an open Log Type.");
    }

    $Param{Priority} //= 'Info';

    # In case of error also add it to the system log.
    if ( $Param{Priority} eq 'Error' ) {
        my @Identification = (
            'ID:' . $Self->CommunicationIDGet(),
            'AccountType:' . ( $Self->{AccountType} || '-' ),
            'AccountID:' .   ( $Self->{AccountID}   || '-' ),
            'Direction:' . $Self->{Direction},
            'Transport:' . $Self->{Transport},
            'ObjectLogType:' . $Param{ObjectLogType},
            'ObjectLogID:' . $ObjectLogID,
        );

        $Self->_LogError(
            sprintf(
                'CommunicationLog(%s)' . '::%s => %s',
                join( ',', @Identification, ),
                $Param{Key},
                $Param{Value},
            ),
        );
    }

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    return $CommunicationDBObject->ObjectLogEntryCreate(
        CommunicationID => $Self->{CommunicationID},
        ObjectLogID     => $ObjectLogID,
        Key             => $Param{Key},
        Value           => $Param{Value},
        Priority        => $Param{Priority},
    );
}

=head2 ObjectLookupSet()

Inserts or updates a lookup information.

    my $Result = $CommunicationLogObject->ObjectLookupSet(
        ObjectID         => 123,       # (required)
        TargetObjectType => 'Article', # (required)
        TargetObjectID   => 123,       # (required)
    );

Returns:

    <undef> - if any error occur
          1 - in case of success

=cut

sub ObjectLookupSet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ObjectLogType} ) {
        return $Self->_LogError("Need ObjectLogType.");
    }

    if ( !$Self->{Current}->{ $Param{ObjectLogType} } ) {
        return $Self->_LogError("Cannot set a ObjectLog that is not open.");
    }

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    return $CommunicationDBObject->ObjectLookupSet(
        ObjectLogID      => $Self->{Current}->{ $Param{ObjectLogType} },
        TargetObjectType => $Param{TargetObjectType},
        TargetObjectID   => $Param{TargetObjectID},
    );
}

=head2 ObjectLookupGet()

Gets the object lookup information.

    my $Result = $CommunicationLogObject->ObjectLookupGet(
        TargetObjectID   => '...',
        TargetObjectType => '...',
    );

Returns:

    <undef> - if any error occur
    An hashref with object lookup information - in case info exists
    An empty hasref                           - in case info doesn't exists

=cut

sub ObjectLookupGet {
    my ( $Self, %Param ) = @_;

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    return $CommunicationDBObject->ObjectLookupGet(%Param);
}

=head2 IsObjectLogOpen()

Checks if a given ObjectLogType has an open Object or not.

    my $Result = $CommunicationLogObject->IsObjectLogOpen(
        ObjectLogType => '...',     # Required
    );

Returns:

    The ObjectLogID or undef.

=cut

sub IsObjectLogOpen {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ObjectLogType} ) {
        return $Self->_LogError("Need ObjectLogType.");
    }

    return $Self->{Current}->{ $Param{ObjectLogType} };
}

=head2 PRIVATE INTERFACE

Private methods

=cut

=head2 _CommunicationStart()

Create a new communication entry.

    my $Success = $CommunicationLogObject->CommunicationStart(
        Status => 'Processing', # (optional) Needs to be either 'Successful', 'Processing', 'Warning' or 'Failed'
                                # In most of the cases, just 'Processing' will make sense at the very beginning
                                # of a communication (Default: 'Processing').
        AccountType =>          # (optional) The used account type
        AccountID   =>          # (optional) The used account id
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub _CommunicationStart {
    my ( $Self, %Param ) = @_;

    if ( $Self->{CommunicationID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Communication with id '$Self->{CommunicationID}' is already started!",
        );
        return $Self;
    }

    $Self->{Transport} = $Param{Transport};
    $Self->{Direction} = $Param{Direction};
    $Self->{Status}    = $Param{Status} || 'Processing';

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my $CommunicationID = $CommunicationDBObject->CommunicationCreate(
        Direction   => $Self->{Direction},
        Transport   => $Self->{Transport},
        Status      => $Self->{Status},
        AccountType => $Param{AccountType},
        AccountID   => $Param{AccountID},
    );

    # return if there is not article created
    if ( !$CommunicationID ) {
        return $Self->_LogError("Can't get CommunicationID from communication start!");
    }

    # remember the new communication id
    $Self->{CommunicationID} = $CommunicationID;

    return $Self;
}

=head2 _RecoverCommunciationObject()

Recover a Communication object given an CommunicationID or ObjectLogID.

=cut

sub _RecoverCommunicationObject {
    my ( $Self, %Param ) = @_;

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationData     = {};
    my $ErrorMessage          = "Could not restore the communication with %s '%s'!";

    if ( $Param{CommunicationID} ) {
        $ErrorMessage = sprintf $ErrorMessage, 'CommunicationID', $Param{CommunicationID};
        $CommunicationData = $CommunicationDBObject->CommunicationGet(
            CommunicationID => $Param{CommunicationID},
        );
    }
    else {
        $ErrorMessage = sprintf $ErrorMessage, 'ObjectLogID', $Param{ObjectLogID};

        $CommunicationData = $CommunicationDBObject->CommunicationGetByObjectLogID(
            ObjectLogID => $Param{ObjectLogID},
        );
    }

    if ( !$CommunicationData || !%{$CommunicationData} ) {
        return $Self->_LogError($ErrorMessage);
    }

    if ( $CommunicationData->{Status} ne 'Processing' ) {
        return $Self->_LogError(
            sprintf(
                "The communication '%s' is already closed, can't be used.",
                $CommunicationData->{CommunicationID},
            ),
        );
    }

    $Self->{CommunicationID} = $CommunicationData->{CommunicationID};
    $Self->{Transport}       = $CommunicationData->{Transport};
    $Self->{Direction}       = $CommunicationData->{Direction};
    $Self->{Status}          = $CommunicationData->{Status};

    # Recover open objects.
    my $Objects = $CommunicationDBObject->ObjectLogList(
        CommunicationID => $CommunicationData->{CommunicationID},
        ObjectLogStatus => 'Processing',
    );

    if ( !$Objects ) {
        return $Self->_LogError( $ErrorMessage, );
    }

    for my $Object ( @{$Objects} ) {
        $Self->{Current}->{ $Object->{ObjectLogType} } = $Object->{ObjectLogID};
    }

    return $Self;
}

=head2 _LogError()

Helper Method for logging.

=cut

sub _LogError {
    my ( $Self, $Message ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Message,
    );
    return;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
