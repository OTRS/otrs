# --
# Kernel/System/DynamicField/Backend/Text.pm - Delegate for DynamicField Text backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Text.pm,v 1.11 2011-09-06 17:41:46 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::Text;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Text

=head1 SYNOPSIS

DynamicFields Text backend delegate

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

    $Value = 'some text';

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
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
        Value              => 'some text',              # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ObjectID  => $Param{ObjectID},
        ValueText => $Param{Value},
        UserID    => $Param{UserID},
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} eq 'Like' ) {
        my $SQL = " LOWER($Param{TableAlias}.value_text) LIKE LOWER('";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm}, 'Like' );
        $SQL .= "') " . $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString') . ' ';
        return $SQL;
    }

    if ( $Param{Operator} eq 'Equals' ) {
        my $SQL = " $Param{TableAlias}.value_text = '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThan' ) {
        my $SQL = " $Param{TableAlias}.value_text > '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_text >= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThan' ) {
        my $SQL = " $Param{TableAlias}.value_text < '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_text <= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    $Self->{'LogObject'}->Log(
        'Priority' => 'error',
        'Message'  => "Unsupported Operator $Param{Operator}",
    );

    return;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_text";
}

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $DynamicFieldTextObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
                                                          #     This may be needed to realize ACL support for ticket masks,
                                                          #     where the possible values can be limited with and ACL.
        Mandatory          => 1,                          # 0 or 1,
    );

=cut

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DynamicFieldConfig} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need DynamicFieldConfig!" );
        return;
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
    for my $Needed (qw(ID Config Name )) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};

    my $HTMLString =
        '<input type="text" ' .
        'class="DynamicFieldText" ' .
        'id="' . $FieldConfig->{Name} . '"' .
        'name="' . $FieldConfig->{Name} . '"' .
        'title="' . $FieldConfig->{Label} . '"' .
        'value="" ' .
        '/>';

    if ( $Param{Mandatory} ) {

        # for client side validation
        $HTMLString .=
            '<div id="' . $FieldConfig->{Name} . 'Error" ' .
            'class="TooltipErrorMessage">' .
            '<p>$Text{"This field is required."}</p>' .
            '</div>';

        # for server side validation
        $HTMLString .=
            '<div id="' . $FieldConfig->{Name} . 'ServerError" ' .
            'class="TooltipErrorMessage">' .
            '<p>$Text{"This field is required."}</p>' .
            '</div>';

    }

    return $HTMLString;

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
