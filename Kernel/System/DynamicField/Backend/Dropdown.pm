# --
# Kernel/System/DynamicField/Backend/Dropdown.pm - Delegate for DynamicField Dropdown backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Dropdown.pm,v 1.2 2011-09-01 13:47:22 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::Dropdown;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Dropdown

=head1 SYNOPSIS

DynamicFields Dropdown backend delegate

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
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{DynamicFieldValueObject} = Kernel::System::DynamicFieldValue->new( %{$Self} );

    return $Self;
}

=item ValueGet()

get a dynamic field value.

    my $Value = $DynamicFieldTextObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
    );

    Returns

    $Value = 'AnOption';

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID    => $Param{DynamicFieldConfig}->{ID},
        ObjectType => $Param{DynamicFieldConfig}->{ObjectType},
        ObjectID   => $Param{ObjectID},
    );

    return if !$DFValue;

    return if !IsHashRefWithData($DFValue);

    return $DFValue->{ValueText};
}

=item ValueSet()

sets a dynamic field value.

    my $Success = $DynamicFieldTextObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        Value              => 'AnOption',              # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check for valid possible values list
    if ( !$Param{DynamicFieldConfig}->{PossibleValues} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need PossibleValues in DynamicFieldConfig!",
        );
        return;
    }

    # check if configuration is valid
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig}->{PossibleValues} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Dynamic field configuration (PossibleValues) is not valid",
        );
        return;
    }

    # get possible values list
    my $PossibleValues = $Param{DynamicFieldConfig}->{PossibleValues};

    # check if values is defiend the possible values list
    if ( !$PossibleValues->{ $Param{Value} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The value $Param{Value} is not a defined option for this field",
        );
        return;
    }

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID    => $Param{DynamicFieldConfig}->{ID},
        ObjectType => $Param{DynamicFieldConfig}->{ObjectType},
        ObjectID   => $Param{ObjectID},
        ValueText  => $Param{Value},
        UserID     => $Param{UserID},
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    my $SQL = " LOWER($Param{TableAlias}.value_text) LIKE LOWER('";
    $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm}, 'Like' );
    $SQL .= "') " . $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString') . ' ';

    return $SQL;
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
