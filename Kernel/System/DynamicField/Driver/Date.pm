# --
# Kernel/System/DynamicField/Driver/Date.pm - Delegate for DynamicField Date Driver
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Driver::Date;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicFieldValue;
use Kernel::System::Time;

use base qw(Kernel::System::DynamicField::Driver::BaseDateTime);

=head1 NAME

Kernel::System::DynamicField::Driver::Date

=head1 SYNOPSIS

DynamicFields Date Driver delegate

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

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 1,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
    };

    return $Self;
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

sub ValueValidate {
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
        my $SQL = " $Param{TableAlias}.value_date $Operators{$Param{Operator}} '"
            . $Self->{DBObject}->Quote( $Param{SearchTerm} );

        # Append hh:mm:ss if only the ISO date was supplied to get a full datetime string.
        if ( $Param{SearchTerm} =~ m{\A \d{4}-\d{2}-\d{2}\z}xms ) {
            $SQL .= " 00:00:00";
        }

        $SQL .= "' ";
        return $SQL;
    }

    $Self->{'LogObject'}->Log(
        'Priority' => 'error',
        'Message'  => "Unsupported Operator $Param{Operator}",
    );

    return;
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
        Format               => 'DateInputFormat',
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

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
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

    # check if there is a Template and retrieve the dynamic field value from there
    if ( IsHashRefWithData( $Param{Template} ) ) {
        for my $Type (qw(Used Year Month Day)) {
            $DynamicFieldValues{ $Prefix . $Type } = $Param{Template}->{ $Prefix . $Type };
        }
    }

    # otherwise get dynamic field value from param
    else {
        for my $Type (qw(Used Year Month Day)) {
            $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
                Param => $Prefix . $Type,
            );
        }
    }

    # complete the rest of the date with 0s to have a valid Date/Time value
    for my $Type (qw(Hour Minute Second)) {
        $DynamicFieldValues{ $Prefix . $Type } = '00';
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'Used' }
        && !$DynamicFieldValues{ $Prefix . 'Year' }
        && !$DynamicFieldValues{ $Prefix . 'Month' }
        && !$DynamicFieldValues{ $Prefix . 'Day' };

    # check if return value structure is needed
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # check if return template structure is needed
    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    my $ManualTimeStamp = '';

    if ( $DynamicFieldValues{ $Prefix . 'Used' } ) {

        # add a leading zero for date parts that could be less than ten to generate a correct
        # time stamp
        for my $Type (qw(Month Day Hour Minute Second)) {
            $DynamicFieldValues{ $Prefix . $Type } = sprintf "%02d",
                $DynamicFieldValues{ $Prefix . $Type };
        }
        my $Year  = $DynamicFieldValues{ $Prefix . 'Year' }  || '0000';
        my $Month = $DynamicFieldValues{ $Prefix . 'Month' } || '00';
        my $Day   = $DynamicFieldValues{ $Prefix . 'Day' }   || '00';
        my $Hour  = '00';
        my $Minute = '00';
        my $Second = '00';

        $ManualTimeStamp =
            $Year . '-' . $Month . '-' . $Day . ' '
            . $Hour . ':' . $Minute . ':' . $Second;
    }

    return $ManualTimeStamp;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = '';

    # convert date to localized string
    if ( defined $Param{Value} ) {
        $Value = $Param{LayoutObject}->Output(
            Template => '$Date{"$Data{"Value"}"}',
            Data => { Value => $Param{Value}, },
        );
    }

    # in this Driver there is no need for HTMLOutput
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

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # only keep date part, loose time part of timestamp
    $Value =~ s{ \A (\d{4} - \d{2} - \d{2}) .+?\z }{$1}xms;

    # Title is always equal to Value
    my $Title = $Value;

    my $Data = {
        Value => $Value,
        Title => $Title,
    };

    return $Data;
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
        Format               => 'DateInputFormat',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => -( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStart} },
    );

    # build HTML for "and" separator
    $HTMLString .= <<'EOF';
  $Text{"and"}
EOF

    # build HTML for stop value set
    $HTMLString .= $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName . 'Stop',
        Format               => 'DateInputFormat',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => +( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStop} },
    );

    my $AdditionalText;
    if ( $Param{UseLabelHints} ) {
        $AdditionalText = 'between';
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
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
        for my $Part (qw(Year Month Day)) {

            # get dynamic field value from param object
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

    $DynamicFieldValues{ $Prefix . 'StartHour' }   = '00';
    $DynamicFieldValues{ $Prefix . 'StartMinute' } = '00';
    $DynamicFieldValues{ $Prefix . 'StartSecond' } = '00';
    $DynamicFieldValues{ $Prefix . 'StopHour' }    = '23';
    $DynamicFieldValues{ $Prefix . 'StopMinute' }  = '59';
    $DynamicFieldValues{ $Prefix . 'StopSecond' }  = '59';

    $DynamicFieldValues{$Prefix} = 1;

    # check if return value structure is needed
    if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # add a leading zero for date parts that could be less than ten to generate a correct
    # time stamp
    for my $Type (qw(Start Stop)) {
        for my $Part (qw(Month Day Hour Minute Second)) {
            $DynamicFieldValues{ $Prefix . $Type . $Part } = sprintf "%02d",
                $DynamicFieldValues{ $Prefix . $Type . $Part };
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

        my $DisplayValueStart
            = $Value->{ValueStart}->{ $Prefix . 'StartYear' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartMonth' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartDay' };

        my $DisplayValueStop
            = $Value->{ValueStop}->{ $Prefix . 'StopYear' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopMonth' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopDay' };

        # return search parameter structure
        return {
            Parameter => {
                GreaterThanEquals => $ValueStart,
                SmallerThanEquals => $ValueStop,
            },
            Display => $DisplayValueStart . ' - ' . $DisplayValueStop,
        };
    }

    return;
}

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    my $YearValue  = int( rand(40) ) + 1_990;
    my $MonthValue = int( rand(9) ) + 1;
    my $DayValue   = int( rand(10) ) + 10;

    my $Value = $YearValue . '-0' . $MonthValue . '-' . $DayValue . ' 00:00:00';

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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
