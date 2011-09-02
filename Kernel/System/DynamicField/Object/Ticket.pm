# --
# Kernel/System/DynamicField/Object/Ticket.pm - Ticket object handler for DynamicField
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.1 2011-09-02 23:01:33 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Object::Ticket;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Ticket

=head1 SYNOPSIS

Ticket object handler for DynamicFields

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject EncodeObject LogObject MainObject DBObject TimeObject TicketObject)
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

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

    if ( $Param{DynamicFieldConfig}->{ObjectType} eq 'Ticket' ) {

        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{ObjectID} );

        my $HistoryValue;
        if ( !defined $Param{Value} ) {
            $HistoryValue = '',
        }
        else {
            $HistoryValue = $Param{Value};
        }

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
    }

    elsif ( $Param{DynamicFieldConfig}->{ObjectType} eq 'Article' ) {

        my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Param{ObjectID} );

        # event
        $Self->{TicketObject}->EventHandler(
            Event => 'ArticleDynamicFieldUpdate',
            Data  => {
                TicketID  => $Article{TicketID},
                ArticleID => $Param{ObjectID},
            },
            UserID => $Param{UserID},
        );

    }

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
