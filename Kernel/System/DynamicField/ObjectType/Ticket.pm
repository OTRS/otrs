# --
# Kernel/System/DynamicField/ObjectType/Ticket.pm - Ticket object handler for DynamicField
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::ObjectType::Ticket;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Ticket;

our @ObjectDependencies
    = ( @Kernel::System::ObjectManager::DefaultObjectDependencies, 'TicketObject' );
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::DynamicField::ObjectType::Ticket

=head1 SYNOPSIS

Ticket object handler for DynamicFields

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::Ticket->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item PostValueSet()

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
            $Kernel::OM->Get('LogObject')->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('LogObject')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('LogObject')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # Don't hold a permanent reference to the TicketObject.
    #   This is because the TicketObject has a Kernel::DynamicField::Backend object, which has this
    #   object, which has a TicketObject again. Without weaken() we'd have a cyclic reference.
    my $TicketObject = $Kernel::OM->Get('TicketObject');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{ObjectID},
        DynamicFields => 0,
    );

    my $HistoryValue    = defined $Param{Value}    ? $Param{Value}    : '';
    my $HistoryOldValue = defined $Param{OldValue} ? $Param{OldValue} : '';

    # get value for storing
    my $ValueStrg = $TicketObject->{DynamicFieldBackendObject}->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryValue,
    );
    $HistoryValue = $ValueStrg->{Value};

    my $OldValueStrg = $TicketObject->{DynamicFieldBackendObject}->ReadableValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryOldValue,
    );
    $HistoryOldValue = $OldValueStrg->{Value};

    my $FieldName;
    if ( !defined $Param{DynamicFieldConfig}->{Name} ) {
        $FieldName = '',
    }
    else {
        $FieldName = $Param{DynamicFieldConfig}->{Name};
    }

    my $FieldNameLength       = length($FieldName);
    my $HistoryValueLength    = length($HistoryValue);
    my $HistoryOldValueLength = length($HistoryOldValue);

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
        my $ValueLength = $FieldNameLength;
        if ( length($FieldName) > $FieldNameLength ) {

# HistoryValue will be at least 55 chars or more, if is FieldName or HistoryOldValue less than 55 chars
            if ( length($HistoryValue) > $ValueLength ) {
                $FieldNameLength = $FieldNameLength - 5;
                $FieldName = substr( $FieldName, 0, $FieldNameLength );
                $FieldName .= '[...]';
                $ValueLength = $ValueLength - 5;
                $HistoryValue = substr( $HistoryValue, 0, $ValueLength );
                $HistoryValue .= '[...]';
            }
            else {
                $FieldNameLength
                    = $NoCharacters - length($HistoryOldValue) - length($HistoryValue) - 5;
                $FieldName = substr( $FieldName, 0, $FieldNameLength );
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

    # history insert
    $TicketObject->HistoryAdd(
        TicketID    => $Param{ObjectID},
        QueueID     => $Ticket{QueueID},
        HistoryType => 'TicketDynamicFieldUpdate',
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
