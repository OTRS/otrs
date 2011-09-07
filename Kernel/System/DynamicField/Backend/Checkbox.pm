# --
# Kernel/System/DynamicField/Backend/Checkbox.pm - Delefate for DynamicField Checkbox backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Checkbox.pm,v 1.6 2011-09-07 23:03:11 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::Checkbox;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;
use Kernel::System::DynamicField::Backend::BackendCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Checkbox

=head1 SYNOPSIS

DynamicFields Checkbox backend delegate

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
    $Self->{BackendCommonObject}
        = Kernel::System::DynamicField::Backend::BackendCommon->new( %{$Self} );

    return $Self;
}

=item ValueGet()

get a dynamic field value.

    my $Value = $DynamicFieldTextObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
    );

    Returns

    $Value = '1';                                       # or 0

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;

    return if !IsHashRefWithData($DFValue);

    return $DFValue->{ValueInt};
}

=item ValueSet()

sets a dynamic field value.

    my $Success = $DynamicFieldTextObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        Value              => 1,                        # or 0, Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check value for just 1 or 0
    if ( defined $Param{Value} && !$Param{Value} ) {
        $Param{Value} = 0;
    }
    elsif ( $Param{Value} && $Param{Value} !~ m{\A [0|1]? \z}xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Value $Param{Value} is invalid for Checkbox fields!",
        );
        return;
    }

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        ValueInt => $Param{Value},
        UserID   => $Param{UserID},
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} ne 'Equals' ) {
        $Self->{'LogObject'}->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Operator $Param{Operator}",
        );
        return;
    }

    my $SQL = " $Param{TableAlias}.value_int = ";
    $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm}, 'Integer' ) . ' ';

    return $SQL;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_int";
}

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $DynamicFieldTextObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        Value              => 'Any value',                # Optional
        Checked            => 1,                          # 0 or 1,
        Mandatory          => 1,                          # 0 or 1,
        Class              => 'AnyCSSClass OrOneMore',    # Optional
        ServerError        => 1,                          # 0 or 1
        ErrorMessage       => $ErrorMessage,              # Optional or a default will be used in error case
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

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    # set the field value or default
    my $Value
        = ( defined $Param{Value} ? $Param{Value} : $FieldConfig->{DefaultValue} );

    # set as checked if necessary
    my $FieldChecked = ( defined $Param{Checked} ? 'checked="checked"' : '' );

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    $FieldClass .= ' Validate_Required' if $Param{Mandatory};

    # set error css class
    $FieldClass .= ' ServerError' if $Param{ServerError};

    my $HTMLString =
        '<input type="checkbox" '
        . 'class="' . $FieldClass . '" '
        . 'id="' . $FieldName . '" '
        . 'name="' . $FieldName . '" '
        . 'title="' . $FieldLabel . '" '
        . $FieldChecked . ' ';

    if ( defined $Value ) {
        $HTMLString .= 'value="' . $Value . '" ';
    }
    else {
        $HTMLString .= 'value="" ';
    }

    $HTMLString .= '/>';

    if ( $Param{Mandatory} ) {

        # for client side validation
        $HTMLString .=
            '<div id="' . $FieldName . 'Error" '
            . 'class="TooltipErrorMessage">'
            . '<p>$Text{"This field is required."}</p>'
            . '</div>';
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{ErrorMessage} || 'This field is required.';

        # for server side validation
        $HTMLString .=
            '<div id="' . $FieldName . 'ServerError" '
            . 'class="TooltipErrorMessage">'
            . '<p>$Text{"' . $ErrorMessage . '"}</p>'
            . '</div>';
    }

    # call EditLabelRender on the common backend
    my $LabelString = $Self->{BackendCommonObject}->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Mandatory          => $Param{Mandatory} || '0',
        FieldName          => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
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
