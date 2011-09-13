# --
# Kernel/System/DynamicField/Backend/Date.pm - Delegate for DynamicField Date backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Date.pm,v 1.10 2011-09-13 12:47:53 mg Exp $
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
use Kernel::System::Time;
use Kernel::System::DynamicField::Backend::BackendCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::Date

=head1 SYNOPSIS

DynamicFields Date backend delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

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
    $Self->{TimeObject}              = Kernel::System::Time->new( %{$Self} );
    $Self->{BackendCommonObject}
        = Kernel::System::DynamicField::Backend::BackendCommon->new( %{$Self} );

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;
    return if !IsArrayRefWithData($DFValue);
    return if !IsHashRefWithData( $DFValue->[0] );

    return $DFValue->[0]->{ValueDateTime};
}

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
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => [
            {
                ValueDateTime => $Param{Value},
            },
        ],
        UserID => $Param{UserID},
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

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject ParamObject)) {
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

    my $Used = 0;

    # set the field value or default
    my $Value = $FieldConfig->{DefaultValue} || '';
    if ( defined $Param{Value} ) {
        $Value = $Param{Value};
        $Used  = 1;
    }

    # extract the dynamic field value form the web request
    my $FieldValues = $Self->EditFieldValueGet(
        ReturnValueStructure => 1,
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValues && IsHashRefWithData($FieldValues) ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $FieldConfig->{ $FieldName . $Type } = $FieldValues->{ $FieldName . $Type };
        }
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    $FieldClass .= ' Validate_Required' if $Param{Mandatory};

    # set error css class
    $FieldClass .= ' ServerError' if $Param{ServerError};

    my $HTMLString = $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName,
        Format               => 'DateInputFormat',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => $FieldConfig->{DefaultValue} || '',
        $FieldName . Required => $Param{Mandatory} || 0,
        $FieldName . Used     => $Used,
        $FieldName . Optional => 1,
        Validate              => 1,
        %{$FieldConfig},
    );

    if ( $Param{Mandatory} ) {
        my $DivID = $FieldName . 'UsedError';

        # for client side validation
        $HTMLString .= <<"EOF";

    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            \$Text{"This field is required."}
        </p>
    </div>
EOF
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{ErrorMessage} || 'This field is required.';
        my $DivID = $FieldName . 'UsedServerError';

        # for server side validation
        $HTMLString .= <<"EOF";
    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            \$Text{"$ErrorMessage"}
        </p>
    </div>
EOF
    }

    # call EditLabelRender on the common backend
    my $LabelString = $Self->{BackendCommonObject}->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Mandatory          => $Param{Mandatory} || '0',
        FieldName          => $FieldName . 'Used',
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ParamObject LayoutObject)) {
        if ( !$Param{DynamicFieldConfig} ) {
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
    for my $Needed (qw( ID Config Name )) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the Prefix as the dynamic field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # get dynamic field value form param
    my %DynamicFieldValues;
    for my $Type (qw(Used Year Month Day)) {
        $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
            Param => $Prefix . $Type,
        );
    }
    for my $Type (qw(Hour Minute Second)) {
        $DynamicFieldValues{ $Prefix . $Type } = '00';
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'Used' }
            && !$DynamicFieldValues{ $Prefix . 'Year' }
            && !$DynamicFieldValues{ $Prefix . 'Month' }
            && !$DynamicFieldValues{ $Prefix . 'Day' };

    # check if return value structure is nedded
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # transform time stamp based on user time zone
    %DynamicFieldValues = $Param{LayoutObject}->TransformDateSelection(
        %DynamicFieldValues,
        Prefix => $Prefix,
    );

    # convert the already transformed time data into a string to return as the value
    my $SystemTime = $Self->{TimeObject}->Date2SystemTime(
        Year   => $DynamicFieldValues{Year},
        Month  => $DynamicFieldValues{Month},
        Day    => $DynamicFieldValues{Day},
        Hour   => '00',
        Minute => '00',
        Second => '00',
    );

    return $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );
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
