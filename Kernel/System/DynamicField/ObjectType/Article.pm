# --
# Kernel/System/DynamicField/ObjectType/Article.pm - Article object handler for DynamicField
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::ObjectType::Article;

use strict;
use warnings;

use Scalar::Util;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Ticket;

our @ObjectDependencies
    = ( @Kernel::System::ObjectManager::DefaultObjectDependencies, 'TicketObject' );
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::DynamicField::Backend::Article

=head1 SYNOPSIS

Article object handler for DynamicFields

=head1 PUBLIC INTERFACE

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

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

    my %Article = $TicketObject->ArticleGet(
        ArticleID     => $Param{ObjectID},
        DynamicFields => 0,
    );

    # trigger event
    $TicketObject->EventHandler(
        Event => 'ArticleDynamicFieldUpdate',
        Data  => {
            TicketID  => $Article{TicketID},
            ArticleID => $Param{ObjectID},
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
