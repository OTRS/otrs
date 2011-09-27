# --
# Kernel/System/DynamicField/ObjectType/Ticket.pm - Ticket object handler for DynamicField
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.5 2011-09-27 18:06:02 cg Exp $
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

use Kernel::System::Web::Request;
use Kernel::Output::HTML::Layout;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject EncodeObject LogObject MainObject DBObject TimeObject)
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check for TicketObject
    if ( $Param{TicketObject} ) {

        $Self->{TicketObject} = $Param{TicketObject};

     # Make ticket object reference weak so it will not count as a reference on objetcs destroy.
     #   This is because the TicketObject has a Kernel::DynamicField::Backend object, which has this
     #   object, which has a TicketObject again. Without weaken() we'd have a cyclic reference.
        Scalar::Util::weaken( $Self->{TicketObject} );
    }

    # otherwise create it
    else {

        # Here we must not call weaken(), because this is the only reference
        $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
    }

    # create extra needed objects
    my $ParamObject = Kernel::System::Web::Request->new(
        %{$Self},
        WebRequest => 0,
    );
    $Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(
        ParamObject => $ParamObject,
        %{$Self},
    );

    return $Self;
}

=item PostValueSet()

perform specific fuctions after the Value set for this object type.

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{ObjectID} );

    my $HistoryValue;
    if ( !defined $Param{Value} ) {
        $HistoryValue = '',
    }
    else {
        $HistoryValue = $Param{Value};
    }

    # get value for storing
    my $ValueStrg = $Self->{TicketObject}->{DynamicFieldBackendObject}->DisplayValueRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Value              => $HistoryValue,
        HTMLOutput         => 0,
        LayoutObject       => $Self->{LayoutObject},
    );
    $HistoryValue = $ValueStrg->{Value};

    # history insert
    $Self->{TicketObject}->HistoryAdd(
        TicketID    => $Param{ObjectID},
        QueueID     => $Ticket{QueueID},
        HistoryType => 'TicketDynamicFieldUpdate',
        Name =>
            "\%\%FieldName\%\%$Param{DynamicFieldConfig}->{Name}\%\%Value\%\%$HistoryValue",
        CreateUserID => $Param{UserID},
    );

    # clear ticket cache
    delete $Self->{TicketObject}->{ 'Cache::GetTicket' . $Param{ObjectID} };

    # trigger event
    $Self->{TicketObject}->EventHandler(
        Event => 'TicketDynamicFieldUpdate',
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            TicketID  => $Param{ObjectID},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1
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

$$

=cut
