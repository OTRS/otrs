# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::ObjectType::Article;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::ObjectType::Article

=head1 DESCRIPTION

Article object handler for DynamicFields

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::ObjectType::Article->new();

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

    #
    # This is a rare case where we don't have the TicketID of an article, even though the article API requires it.
    #   Since this is not called often and we don't want to cache on per-article basis, get the ID directly from the
    #   database and use it.
    #

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $TicketID;

    return if !$DBObject->Prepare(
        SQL => '
            SELECT ticket_id
            FROM article
            WHERE id = ?',
        Bind  => [ \$Param{ObjectID} ],
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TicketID = $Row[0];
    }

    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine TicketID of Article $Param{ArticleID}!",
        );
        return;
    }

    # update change time
    return if !$DBObject->Do(
        SQL => '
            UPDATE ticket
            SET change_time = current_timestamp, change_by = ?
            WHERE id = ?',
        Bind => [ \$Param{UserID}, \$TicketID ],
    );

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $TicketObject->_TicketCacheClear( TicketID => $TicketID );

    $TicketObject->EventHandler(
        Event => 'ArticleDynamicFieldUpdate',
        Data  => {
            FieldName => $Param{DynamicFieldConfig}->{Name},
            Value     => $Param{Value},
            OldValue  => $Param{OldValue},
            TicketID  => $TicketID,
            ArticleID => $Param{ObjectID},
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
            ArticleID              => 123,
            TicketID               => 2,
            CommunicationChannelID => 1,
            SenderTypeID           => 1,
            IsVisibleForCustomer   => 0,
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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $ArticleID = $ParamObject->GetParam(
        Param => 'ArticleID',
    );

    return if !$ArticleID;

    my $TicketID = $ParamObject->GetParam(
        Param => 'TicketID',
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # In case TicketID is not in the web request, look for it using the article.
    if ( !$TicketID ) {
        $TicketID = $ArticleObject->TicketIDLookup(
            ArticleID => $ArticleID,
        );
    }

    if ( !$TicketID ) {
        return (
            ObjectID => $ArticleID,
            Data     => {},
        );
    }

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $ArticleID,
        TicketID  => $TicketID
    );

    my %ArticleData = $ArticleBackendObject->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 1,
        TicketID      => $TicketID,
        UserID        => $Param{UserID},
    );

    return (
        ObjectID => $ArticleID,
        Data     => \%ArticleData,
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
