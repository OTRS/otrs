# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::ObjectType::Ticket;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::ObjectType::Ticket

=head1 DESCRIPTION

Ticket object handler for DynamicFields

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::Ticket->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 PostValueSet()

perform specific functions after the Value set for this object type.

    my $Success = $DynamicFieldTicketHandlerObject->PostValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub PostValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # update change time
    return if !$DBObject->Do(
        SQL => 'UPDATE ticket SET change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [ \$Param{UserID}, \$Param{ObjectID} ],
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{ObjectID},
        DynamicFields => 0,
    );

    my $HistoryValue    = defined $Param{Value}    ? $Param{Value}    : '';
    my $HistoryOldValue = defined $Param{OldValue} ? $Param{OldValue} : '';

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get value for storing
    my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryValue,
    );
    $HistoryValue = $ValueStrg->{Value};

    my $OldValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryOldValue,
    );
    $HistoryOldValue = $OldValueStrg->{Value};

    my $FieldName;
    if ( !defined $Param{DynamicFieldConfig}->{Name} ) {
        $FieldName = '';
    }
    else {
        $FieldName = $Param{DynamicFieldConfig}->{Name};
    }

    my $FieldNameLength       = length $FieldName       || 0;
    my $HistoryValueLength    = length $HistoryValue    || 0;
    my $HistoryOldValueLength = length $HistoryOldValue || 0;

# Name in ticket_history is like this form "\%\%FieldName\%\%$FieldName\%\%Value\%\%$HistoryValue\%\%OldValue\%\%$HistoryOldValue" up to 200 chars
# \%\%FieldName\%\% is 13 chars
# \%\%Value\%\% is 9 chars
# \%\%OldValue\%\%$HistoryOldValue is 12
# we have for info part of ticket history data ($FieldName+$HistoryValue+$OldValue) up to 166 chars
# in this code is made substring. The same number of characters is provided for both of part in Name ($FieldName and $HistoryValue and $OldVAlue) up to 55 chars
# if $FieldName and $HistoryValue and $OldVAlue is cut then info is up to 50 chars plus [...] (5 chars)
# First it is made $HistoryOldValue, then it is made $FieldName, and then  $HistoryValue
# Length $HistoryValue can be longer then 55 chars, also is for $OldValue.

    my $NoCharacters = 166;

    if ( ( $FieldNameLength + $HistoryValueLength + $HistoryOldValueLength ) > $NoCharacters ) {

        # OldValue is maybe less important
        # At first it is made HistoryOldValue
        # and now it is possible that for HistoryValue would FieldName be more than 55 chars
        if ( length($HistoryOldValue) > 55 ) {
            $HistoryOldValue = substr( $HistoryOldValue, 0, 50 );
            $HistoryOldValue .= '[...]';
        }

        # limit FieldName to 55 chars if is necessary
        my $FieldNameLength = int( ( $NoCharacters - length($HistoryOldValue) ) / 2 );
        my $ValueLength     = $FieldNameLength;
        if ( length($FieldName) > $FieldNameLength ) {

            # HistoryValue will be at least 55 chars or more, if is FieldName or HistoryOldValue less than 55 chars
            if ( length($HistoryValue) > $ValueLength ) {
                $FieldNameLength = $FieldNameLength - 5;
                $FieldName       = substr( $FieldName, 0, $FieldNameLength );
                $FieldName .= '[...]';
                $ValueLength  = $ValueLength - 5;
                $HistoryValue = substr( $HistoryValue, 0, $ValueLength );
                $HistoryValue .= '[...]';
            }
            else {
                $FieldNameLength = $NoCharacters - length($HistoryOldValue) - length($HistoryValue) - 5;
                $FieldName       = substr( $FieldName, 0, $FieldNameLength );
                $FieldName .= '[...]';
            }
        }
        else {
            $ValueLength = $NoCharacters - length($HistoryOldValue) - length($FieldName) - 5;
            if ( length($HistoryValue) > $ValueLength ) {
                $HistoryValue = substr( $HistoryValue, 0, $ValueLength );
                $HistoryValue .= '[...]';
            }
        }
    }

    $HistoryValue    //= '';
    $HistoryOldValue //= '';

    # Add history entry.
    $TicketObject->HistoryAdd(
        TicketID    => $Param{ObjectID},
        QueueID     => $Ticket{QueueID},
        HistoryType => 'TicketDynamicFieldUpdate',

        # This insert is not optimal at all (not human readable), but will be kept due to backwards compatibility. The
        #   value will be converted for use in a more speaking form directly in AgentTicketHistory.pm before display.
        Name =>
            "\%\%FieldName\%\%$FieldName"
            . "\%\%Value\%\%$HistoryValue"
            . "\%\%OldValue\%\%$HistoryOldValue",
        CreateUserID => $Param{UserID},
    );

    # clear ticket cache
    $TicketObject->_TicketCacheClear( TicketID => $Param{ObjectID} );

    # Trigger event.
    $TicketObject->EventHandler(
        Event => 'TicketDynamicFieldUpdate_' . $Param{DynamicFieldConfig}->{Name},
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            OldValue  => $Param{OldValue},
            TicketID  => $Param{ObjectID},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ObjectDataGet()

retrieves the data of the current object.

    my %ObjectData = $DynamicFieldTicketHandlerObject->ObjectDataGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        UserID             => 123,
    );

returns:

    %ObjectData = (
        ObjectID => 123,
        Data     => {
            TicketNumber => '20101027000001',
            Title        => 'some title',
            TicketID     => 123,
            # ...
        }
    );

=cut

sub ObjectDataGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check DynamicFieldConfig (general).
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # Check DynamicFieldConfig (internally).
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    my $TicketID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
        Param => 'TicketID',
    );

    return if !$TicketID;

    my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
        Extended      => 1,
        UserID        => $Param{UserID},
    );

    if ( !%TicketData ) {

        return (
            ObjectID => $TicketID,
            Data     => {}
        );
    }

    my %SkipAttributes = (
        Age                         => 1,
        EscalationDestinationIn     => 1,
        EscalationDestinationTime   => 1,
        EscalationSolutionTime      => 1,
        EscalationTime              => 1,
        EscalationTimeWorkingTime   => 1,
        RealTillTimeNotUsed         => 1,
        SolutionTime                => 1,
        SolutionTimeDestinationTime => 1,
        SolutionTimeEscalation      => 1,
        SolutionTimeWorkingTime     => 1,
        UnlockTimeout               => 1,
        UntilTime                   => 1,
    );

    my %Result = (
        ObjectID => $TicketID,
    );

    ATTRIBUTE:
    for my $Attribute ( sort keys %TicketData ) {

        next ATTRIBUTE if $SkipAttributes{$Attribute};

        $Result{Data}->{$Attribute} = $TicketData{$Attribute};
    }

    return %Result;

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
