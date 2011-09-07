# --
# Kernel/System/DynamicField/Backend/Date.pm - Delegate for DynamicField Date backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Date.pm,v 1.5 2011-09-07 05:13:58 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::Date;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Date

=head1 SYNOPSIS

DynamicFields Date backend delegate

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

    $Value = '1977-12-12';

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;

    return if !IsHashRefWithData($DFValue);

    return $DFValue->{ValueDateTime};
}

=item ValueSet()

sets a dynamic field value.

    my $Success = $DynamicFieldTextObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        Value              => '1977-12-12',             # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check for no time in date fields
    if ( $Param{Value} && $Param{Value} !~ m{\A \d{4}-\d{2}-\d{2}\s00:00:00 \z}xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The value for the field Date is invalid!\n"
                . "The date must be valid and the time must be 00:00:00",
        );
        return;
    }

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID       => $Param{DynamicFieldConfig}->{ID},
        ObjectID      => $Param{ObjectID},
        ValueDateTime => $Param{Value},
        UserID        => $Param{UserID},
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} eq 'Equals' ) {
        my $SQL = " $Param{TableAlias}.value_date = '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . " 00:00:00' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThan' ) {
        my $SQL = " $Param{TableAlias}.value_date > '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . " 00:00:00' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date >= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . " 00:00:00' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThan' ) {
        my $SQL = " $Param{TableAlias}.value_date < '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . " 00:00:00' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date <= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . " 00:00:00' ";
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

    return "$Param{TableAlias}.value_date";
}

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $DynamicFieldTextObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        FieldValue         => 'Any value',                # Optional
        Mandatory          => 1,                          # 0 or 1,
        Class              => 'AnyCSSClass, OrOneMore',   # Optional
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

    # set the field value or default
    my $FieldValue
        = ( defined $Param{FieldValue} ? $Param{FieldValue} : $FieldConfig->{DefaultValue} );

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= $Param{Class};
    }

    my $HTMLString = $Self->BuildDateSelection(
        %Param,
        %{$FieldConfig},
        Prefix => $FieldConfig->{Name},
        Format => 'DateInputFormat',

        #            'TicketFreeTime' . $Count . 'Class' => $Class,
        DiffTime => $FieldConfig->{DefaultValue} || 0,

        #            %TimePeriod,
        Validate => 1,
        Required => $Param{Mandatory} ? 1 : 0,
    );

    if ( $Param{Mandatory} ) {

        # for client side validation
        $HTMLString .=
            '<div id="' . $FieldConfig->{Name} . 'Error" ' .
            'class="TooltipErrorMessage">' .
            '<p>$Text{"This field is required."}</p>' .
            '</div>';
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{ErrorMessage} || 'This field is required.';

        # for server side validation
        $HTMLString .=
            '<div id="' . $FieldConfig->{Name} . 'ServerError" ' .
            'class="TooltipErrorMessage">' .
            '<p>$Text{"' . $ErrorMessage . '"}</p>' .
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
