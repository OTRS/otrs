# --
# Kernel/System/DynamicField/Backend/DateTime.pm - Delegate for DynamicField DateTime backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

=head1 NAME

Kernel::System::DynamicField::Backend::DateTime

=head1 SYNOPSIS

DynamicFields DateTime backend delegate

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

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->ValueDelete(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );

    return $Success;
}

sub AllValuesDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->AllValuesDelete(
        FieldID => $Param{DynamicFieldConfig}->{ID},
        UserID  => $Param{UserID},
    );

    return $Success;
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->ValueValidate(
        Value => {
            ValueDateTime => $Param{Value},
        },
        UserID => $Param{UserID}
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    my %Operators = (
        Equals            => '=',
        GreaterThan       => '>',
        GreaterThanEquals => '>=',
        SmallerThan       => '<',
        SmallerThanEquals => '<=',
    );

    if ( $Operators{ $Param{Operator} } ) {
        my $SQL = " $Param{TableAlias}.value_date $Operators{$Param{Operator}} '";
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

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $FieldConfig->{DefaultValue} || '';
    }

    my %SplitedFieldValues;
    if ( defined $Param{Value} ) {
        $Value = $Param{Value};
        my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $Value =~
            m{ \A ( \d{4} ) - ( \d{2} ) - ( \d{2} ) \s ( \d{2} ) : ( \d{2} ) : ( \d{2} ) \z }xms;

        %SplitedFieldValues = (

            # if a value is sent this value must be active, then the Used part needs to be set to 1
            # otherwise user can easily forget to mark the checkbox and this could lead into data
            # lost Bug#8258
            $FieldName . 'Used'   => 1,
            $FieldName . 'Year'   => $Year,
            $FieldName . 'Month'  => $Month,
            $FieldName . 'Day'    => $Day,
            $FieldName . 'Hour'   => $Hour,
            $FieldName . 'Minute' => $Minute,
        );
    }

    # extract the dynamic field value form the web request
    # TransformDates is always needed from EditFieldRender Bug#8452
    my $FieldValues = $Self->EditFieldValueGet(
        TransformDates       => 1,
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
    # Bug#9358: Class 'DateSelection' is needed for CustomerInterface
    my $FieldClass = 'DynamicFieldText DateSelection';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    $FieldClass .= ' Validate_Required' if $Param{Mandatory};

    # set error css class
    $FieldClass .= ' ServerError' if $Param{ServerError};

    # to set the predefined based on a time difference
    my $DiffTime = $FieldConfig->{DefaultValue};
    if ( !defined $DiffTime || $DiffTime !~ m/^ \s* -? \d+ \s* $/smx ) {
        $DiffTime = 0;
    }

    # to set the years range
    my %YearsPeriodRange;
    if ( defined $FieldConfig->{YearsPeriod} && $FieldConfig->{YearsPeriod} eq '1' ) {
        %YearsPeriodRange = (
            YearPeriodPast   => $FieldConfig->{YearsInPast}   || 0,
            YearPeriodFuture => $FieldConfig->{YearsInFuture} || 0,
        );
    }

    my $HTMLString = $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName,
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => $DiffTime,
        $FieldName . Required => $Param{Mandatory} || 0,
        $FieldName . Optional => 1,
        Validate              => 1,
        %{$FieldConfig},
        %SplitedFieldValues,
        %YearsPeriodRange,
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

    # set the Prefix as the dynamic field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my %DynamicFieldValues;

    # check if there is a Template and retreive the dinalic field value from there
    if ( IsHashRefWithData( $Param{Template} ) ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $DynamicFieldValues{ $Prefix . $Type } = $Param{Template}->{ $Prefix . $Type };
        }
    }

    # otherwise get dynamic field value form param
    else {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
                Param => $Prefix . $Type,
            );
        }
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'Used' }
        && !$DynamicFieldValues{ $Prefix . 'Year' }
        && !$DynamicFieldValues{ $Prefix . 'Month' }
        && !$DynamicFieldValues{ $Prefix . 'Day' }
        && !$DynamicFieldValues{ $Prefix . 'Hour' }
        && !$DynamicFieldValues{ $Prefix . 'Minute' };

    # check if need and can transform dates
    # transform the dates early for ReturnValueStructure or ManualTimeStamp Bug#8452
    if ( $Param{TransformDates} && $Param{LayoutObject} ) {

        # transform time stamp based on user time zone
        %DynamicFieldValues = $Param{LayoutObject}->TransformDateSelection(
            %DynamicFieldValues,
            Prefix => $Prefix,
        );
    }

    # check if return value structure is nedded
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # check if return template structure is nedded
    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    my $ManualTimeStamp = '';

    if ( $DynamicFieldValues{ $Prefix . 'Used' } ) {

        # add a leading zero for date parts that could be less than ten to generate a correct
        # time stamp
        for my $Type (qw(Month Day Hour Minute Second)) {
            if (
                $DynamicFieldValues{ $Prefix . $Type }
                && $DynamicFieldValues{ $Prefix . $Type } < 10
                && $DynamicFieldValues{ $Prefix . $Type } !~ m{\A 0 \d \z}smx
                )
            {
                $DynamicFieldValues{ $Prefix . $Type }
                    = '0' . $DynamicFieldValues{ $Prefix . $Type };
            }
        }

        my $Year   = $DynamicFieldValues{ $Prefix . 'Year' }   || '0000';
        my $Month  = $DynamicFieldValues{ $Prefix . 'Month' }  || '00';
        my $Day    = $DynamicFieldValues{ $Prefix . 'Day' }    || '00';
        my $Hour   = $DynamicFieldValues{ $Prefix . 'Hour' }   || '00';
        my $Minute = $DynamicFieldValues{ $Prefix . 'Minute' } || '00';
        my $Second = $DynamicFieldValues{ $Prefix . 'Second' } || '00';

        $ManualTimeStamp =
            $Year . '-' . $Month . '-' . $Day . ' '
            . $Hour . ':' . $Minute . ':' . $Second;
    }

    return $ManualTimeStamp;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig   => $Param{DynamicFieldConfig},
        ParamObject          => $Param{ParamObject},
        ReturnValueStructure => 1,
    );

    # on normal basis Used field could be empty but if there was no value from EditFieldValueGet()
    # it must be an error
    if ( !defined $Value ) {
        return {
            ServerError  => 1,
            ErrorMessage => 'Invalid Date!'
            }
    }

    my $ServerError;
    my $ErrorMessage;

    # set the date time prefix as field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value->{ $Prefix . 'Used' } ) {
        $ServerError = 1;
    }

    # create resulting structure
    my $Result = {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };

    return $Result;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = '';

    # convert date to localized string
    if ( defined $Param{Value} ) {
        $Value = $Param{LayoutObject}->Output(
            Template => '$TimeShort{"$Data{"Value"}"}',
            Data => { Value => $Param{Value}, },
        );
    }

    # in this backend there is no need for HTMLOutput
    # Title is always equal to Value
    my $Title = $Value;

    # set field link form config
    my $Link = $Param{DynamicFieldConfig}->{Config}->{Link} || '';

    my $Data = {
        Value => $Value,
        Title => $Title,
        Link  => $Link,
    };

    return $Data;
}

sub IsSortable {
    my ( $Self, %Param ) = @_;

    return 1;
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    my %DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        my @Items = split /;/, $Param{DefaultValue};
        for my $Item (@Items) {
            my ( $Key, $Value ) = split /=/, $Item;
            if ( $Key =~ m{Start} ) {
                $DefaultValue{ValueStart}->{$Key} = $Value;
            }
            elsif ( $Key =~ m{Stop} ) {
                $DefaultValue{ValueStop}->{$Key} = $Value;
            }
        }
    }

    # set the field value
    if (%DefaultValue) {
        $Value = \%DefaultValue;
    }

    # get the field value, this function is always called after the profile is loaded
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if (
        defined $FieldValues
        && defined $FieldValues->{ValueStart}
        && defined $FieldValues->{ValueStop}
        )
    {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldDateTime';

    # set as checked if necessary
    my $FieldChecked
        = ( defined $Value->{$FieldName} && $Value->{$FieldName} == 1 ? 'checked="checked"' : '' );

    my $HTMLString = <<"EOF";
    <input type="hidden" id="$FieldName" name="$FieldName" value="1"/>
EOF

    if ( $Param{ConfirmationCheckboxes} ) {
        $HTMLString = <<"EOF";
    <input type="checkbox" id="$FieldName" name="$FieldName" value="1" $FieldChecked/>
EOF
    }

    # build HTML for start value set
    $HTMLString .= $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName . 'Start',
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => -( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStart} },
    );

    # build HTML for "and" separator
    $HTMLString .= <<'EOF';
  $Text{"and"}
  <br/>
EOF

    # build HTML for stop value set
    $HTMLString .= $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName . 'Stop',
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => +( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStop} },
    );

    my $AdditionalText;
    if ( $Param{UseLabelHints} ) {
        $AdditionalText = 'between';
    }

    # call EditLabelRender on the common backend
    my $LabelString = $Self->{BackendCommonObject}->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        FieldName          => $FieldName,
        AdditionalText     => $AdditionalText,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    # set the Prefix as the dynamic field name
    my $Prefix = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # get dynamic field value
    my %DynamicFieldValues;
    for my $Type (qw(Start Stop)) {
        for my $Part (qw(Year Month Day Hour Minute)) {

            # get dynamic field value form param object
            if ( defined $Param{ParamObject} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{ParamObject}->GetParam( Param => $Prefix );

                $DynamicFieldValues{ $Prefix . $Type . $Part } = $Param{ParamObject}->GetParam(
                    Param => $Prefix . $Type . $Part,
                );
            }

            # otherwise get the value from the profile
            elsif ( defined $Param{Profile} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{Profile}->{$Prefix};

                $DynamicFieldValues{ $Prefix . $Type . $Part }
                    = $Param{Profile}->{ $Prefix . $Type . $Part };
            }
            else {
                return;
            }
        }
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'StartYear' }
        && !$DynamicFieldValues{ $Prefix . 'StartMonth' }
        && !$DynamicFieldValues{ $Prefix . 'StartDay' }
        && !$DynamicFieldValues{ $Prefix . 'StopYear' }
        && !$DynamicFieldValues{ $Prefix . 'StopMonth' }
        && !$DynamicFieldValues{ $Prefix . 'StopDay' };

    $DynamicFieldValues{ $Prefix . 'StartSecond' } = '00';
    $DynamicFieldValues{ $Prefix . 'StopSecond' }  = '59';

    $DynamicFieldValues{$Prefix} = 1;

    # check if return value structure is nedded
    if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # add a leading zero for date parts that could be less than ten to generate a correct
    # time stamp
    for my $Type (qw(Start Stop)) {
        for my $Part (qw(Month Day Hour Minute Second)) {
            if (
                $DynamicFieldValues{ $Prefix . $Type . $Part }
                && $DynamicFieldValues{ $Prefix . $Type . $Part } < 10
                && length $DynamicFieldValues{ $Prefix . $Type . $Part } == 1
                )
            {
                $DynamicFieldValues{ $Prefix . $Type . $Part }
                    = '0' . $DynamicFieldValues{ $Prefix . $Type . $Part };
            }
        }
    }

    my $ValueStart = {
        $Prefix . 'StartYear'   => $DynamicFieldValues{ $Prefix . 'StartYear' }   || '0000',
        $Prefix . 'StartMonth'  => $DynamicFieldValues{ $Prefix . 'StartMonth' }  || '00',
        $Prefix . 'StartDay'    => $DynamicFieldValues{ $Prefix . 'StartDay' }    || '00',
        $Prefix . 'StartHour'   => $DynamicFieldValues{ $Prefix . 'StartHour' }   || '00',
        $Prefix . 'StartMinute' => $DynamicFieldValues{ $Prefix . 'StartMinute' } || '00',
        $Prefix . 'StartSecond' => $DynamicFieldValues{ $Prefix . 'StartSecond' } || '00',
    };

    my $ValueStop = {
        $Prefix . 'StopYear'   => $DynamicFieldValues{ $Prefix . 'StopYear' }   || '0000',
        $Prefix . 'StopMonth'  => $DynamicFieldValues{ $Prefix . 'StopMonth' }  || '00',
        $Prefix . 'StopDay'    => $DynamicFieldValues{ $Prefix . 'StopDay' }    || '00',
        $Prefix . 'StopHour'   => $DynamicFieldValues{ $Prefix . 'StopHour' }   || '00',
        $Prefix . 'StopMinute' => $DynamicFieldValues{ $Prefix . 'StopMinute' } || '00',
        $Prefix . 'StopSecond' => $DynamicFieldValues{ $Prefix . 'StopSecond' } || '00',
    };

    return {
        $Prefix    => 1,
        ValueStart => $ValueStart,
        ValueStop  => $ValueStop,
    };
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    # do not search if value was not checked (useful for customer interface)
    if ( !$Value ) {
        return {
            Equals => '',
            }
    }

    # search for a wild card in the value
    if ( $Value && IsHashRefWithData($Value) ) {

        my $Prefix = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};

        my $ValueStart
            = $Value->{ValueStart}->{ $Prefix . 'StartYear' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartMonth' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartDay' } . ' '
            . $Value->{ValueStart}->{ $Prefix . 'StartHour' } . ':'
            . $Value->{ValueStart}->{ $Prefix . 'StartMinute' } . ':'
            . $Value->{ValueStart}->{ $Prefix . 'StartSecond' };

        my $ValueStop
            = $Value->{ValueStop}->{ $Prefix . 'StopYear' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopMonth' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopDay' } . ' '
            . $Value->{ValueStop}->{ $Prefix . 'StopHour' } . ':'
            . $Value->{ValueStop}->{ $Prefix . 'StopMinute' } . ':'
            . $Value->{ValueStop}->{ $Prefix . 'StopSecond' };

        # return search parameter structure
        return {
            Parameter => {
                GreaterThanEquals => $ValueStart,
                SmallerThanEquals => $ValueStop,
            },
            Display => $ValueStart . ' - ' . $ValueStop,
        };
    }

    return;
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # this field should not be shown in stats
    return;
}

sub CommonSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # this field should not be shown in stats
    return;
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # Title is always equal to Value
    my $Title = $Value;

    my $Data = {
        Value => $Value,
        Title => $Title,
    };

    return $Data;
}

sub TemplateValueTypeGet {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # set the field types
    my $EditValueType   = 'SCALAR';
    my $SearchValueType = 'SCALAR';

    # return the correct structure
    if ( $Param{FieldType} eq 'Edit' ) {
        return {
            $FieldName => $EditValueType,
            }
    }
    elsif ( $Param{FieldType} eq 'Search' ) {
        return {
            'Search_' . $FieldName => $SearchValueType,
            }
    }
    else {
        return {
            $FieldName             => $EditValueType,
            'Search_' . $FieldName => $SearchValueType,
            }
    }
}

sub IsAJAXUpdateable {
    my ( $Self, %Param ) = @_;

    return 0;
}

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    my $YearValue   = int( rand(40) ) + 1_990;
    my $MonthValue  = int( rand(9) ) + 1;
    my $DayValue    = int( rand(10) ) + 10;
    my $HourValue   = int( rand(12) ) + 10;
    my $MinuteValue = int( rand(30) ) + 10;
    my $SecondValue = int( rand(30) ) + 10;

    my $Value = $YearValue . '-0' . $MonthValue . '-' . $DayValue . ' '
        . $HourValue . ':' . $MinuteValue . ':' . $SecondValue;

    my $Success = $Self->ValueSet(
        %Param,
        Value => $Value,
    );

    if ( !$Success ) {
        return {
            Success => 0,
        };
    }
    return {
        Success => 1,
        Value   => $Value,
    };
}

sub IsMatchable {
    my ( $Self, %Param ) = @_;

    return 0;
}

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # not supported
    return 0;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # get historical values from database
    my $HistoricalValues = $Self->{DynamicFieldValueObject}->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'DateTime',
    );

    # return the historical values from database
    return $HistoricalValues;
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Key} ? $Param{Key} : '';

    return $Value;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
