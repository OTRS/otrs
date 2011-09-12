# --
# Kernel/System/DynamicField/Backend/DateTime.pm - Delegate for DynamicField DateTime backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DateTime.pm,v 1.16 2011-09-12 20:26:40 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend::DateTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;
use Kernel::System::Time;
use Kernel::System::DynamicField::Backend::BackendCommon;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

=head1 NAME

Kernel::System::DynamicField::Backend::DateTime

=head1 SYNOPSIS

DynamicFields DateTime backend delegate

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
    $Self->{TimeObject}              = Kernel::System::Time->new( %{$Self} );
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

    $Value = '1977-12-12 12:34:05';

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
        Value              => '1977-12-12 12:23:09',    # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

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
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThan' ) {
        my $SQL = " $Param{TableAlias}.value_date > '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'GreaterThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date >= '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThan' ) {
        my $SQL = " $Param{TableAlias}.value_date < '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'SmallerThanEquals' ) {
        my $SQL = " $Param{TableAlias}.value_date <= '";
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

    return "$Param{TableAlias}.value_date";
}

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $DynamicFieldTextObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        Value              => 'Any value',                # Optional
        Mandatory          => 1,                          # 0 or 1,
        Class              => 'AnyCSSClass OrOneMore',    # Optional
        ServerError        => 1,                          # 0 or 1
        ErrorMessage       => $ErrorMessage,              # Optional or a default will be used in error case
        LayoutObject         => $LayoutObject,
        ParamObject          => $ParamObject,             # the current request data
    );

=cut

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

        #        DynamicFieldConfig => $DynamicFieldConfig,
        #        ParamObject        => $Self->{ParamObject},
        #        LayoutObject       => $Self->{LayoutObject},
        ReturnValueStructure => 1,
        %Param,
    );

    if ( IsHashRefWithData($FieldValues) ) {

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
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => $FieldConfig->{DefaultValue} || '',
        %{$FieldConfig},
        $FieldName . Required => $Param{Mandatory} || 0,
        $FieldName . Used     => $Used,
        $FieldName . Optional => 1,
        Validate              => 1,
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

=item EditFieldValueGet()

extracts the value of a dynamic field from the param object and transforms it to the user timezone

    my $Value = $BackendObject->EditFieldValueGet(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject          => $ParamObject,             # the current request data
        LayoutObject         => $LayoutObject,
        ReturnValueStructure => 0,                        # || 0, default 0. Not used in this
                                                          #   backend but placed for consistency
                                                          #   reasons
    );

    Returns

    $Value = '1977-12-12 12:00:00';

    my $Value = $BackendObject->EditFieldValueGet(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject          => $ParamObject,             # the current request data
        LayoutObject         => $LayoutObject,
        ReturnValueStructure => 1,                        # || 0, default 0. Not used in this
                                                          #   backend but placed for consistency
                                                          #   reasons
    );
    Returns

    $Value = {
        Used   => 1,
        Year   => '1977',
        Month  => '12',
        Day    => '12',
        Hour   => '12',
        Minute => '00',
        Second => '00',
    };

=cut

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
    for my $Type (qw(Used Year Month Day Hour Minute)) {
        $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
            Param => $Prefix . $Type,
        );
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'Used' }
            && !$DynamicFieldValues{ $Prefix . 'Year' }
            && !$DynamicFieldValues{ $Prefix . 'Month' }
            && !$DynamicFieldValues{ $Prefix . 'Day' }
            && !$DynamicFieldValues{ $Prefix . 'Hour' }
            && !$DynamicFieldValues{ $Prefix . 'Minute' };

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
        Hour   => $DynamicFieldValues{Hour} || '00',
        Minute => $DynamicFieldValues{Minute} || '00',
        Second => $DynamicFieldValues{Second} || '00',
    );

    return $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime,
    );
}

=item EditFieldValueValidate()

validate the current value for the dynamic field

    my $Result =  $DynamicFieldTextObject->EditFieldValueValidate(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
                                                          #     This may be needed to realize ACL support for ticket masks,
                                                          #     where the possible values can be limited with and ACL.
        ParamObject          => $ParamObject              # To get the values directly from the web request
        Mandatory            => 1,                        # 0 or 1,
    );

    Returns

    $Result = {
        ServerError        => 1,                          # 0 or 1,
        ErrorMessage       => $ErrorMessage,              # Optional or a default will be used in error case
    }

=cut

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ParamObject)) {
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

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig   => $Param{DynamicFieldConfig},
        ParamObject          => $Param{ParamObject},
        ReturnValueStructure => 1,
    );

    my $ServerError;
    my $ErrorMessage;

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value ) {
        $ServerError = 1;
    }

    # create resulting structure
    my $Result = {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };

    return $Result;
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
