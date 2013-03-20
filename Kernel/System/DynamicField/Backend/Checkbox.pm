# --
# Kernel/System/DynamicField/Backend/Checkbox.pm - Delegate for DynamicField Checkbox backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

=head1 NAME

Kernel::System::DynamicField::Backend::Checkbox

=head1 SYNOPSIS

DynamicFields Checkbox backend delegate

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

    return $DFValue->[0]->{ValueInt};
}

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
        Value    => [
            {
                ValueInt => $Param{Value},
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

    my $Success = $Self->{DynamicFieldValueObject}->ValueValidate(
        Value => {
            ValueInt => $Param{Value},
        },
        UserID => $Param{UserID}
    );

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} eq 'Equals' ) {
        my $SQL = " $Param{TableAlias}.value_int = ";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm}, 'Integer' ) . ' ';
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

    return "$Param{TableAlias}.value_int";
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
    $Value = $Param{Value} if defined $Param{Value};

    # extract the dynamic field value form the web request
    my $FieldValue = $Self->EditFieldValueGet(
        ReturnValueStructure => 1,
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValue && IsHashRefWithData($FieldValue) ) {
        if (
            !defined $FieldValue->{FieldValue} &&
            defined $FieldValue->{UsedValue}   && $FieldValue->{UsedValue} eq '1'
            )
        {
            $Value = '0';
        }
        elsif (
            defined $FieldValue->{FieldValue} && $FieldValue->{FieldValue} eq '1' &&
            defined $FieldValue->{UsedValue} && $FieldValue->{UsedValue} eq '1'
            )
        {
            $Value = '1';
        }
    }

    # set as checked if necessary
    my $FieldChecked = ( defined $Value && $Value eq '1' ? 'checked="checked"' : '' );

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldCheckbox';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    $FieldClass .= ' Validate_Required' if $Param{Mandatory};

    # set error css class
    $FieldClass .= ' ServerError' if $Param{ServerError};

    my $FieldNameUsed = $FieldName . "Used";

    my $HTMLString = <<"EOF";
<input type="hidden" id="$FieldNameUsed" name="$FieldNameUsed" value="1" />
EOF

    if ( $Param{ConfirmationNeeded} ) {

        # set checked property
        my $FieldUsedChecked0 = '';
        my $FieldUsedChecked1 = '';
        if ( $FieldValue->{UsedValue} ) {
            $FieldUsedChecked1 = 'checked="checked"';
        }
        else {
            $FieldUsedChecked0 = 'checked="checked"';
        }

        my $FieldNameUsed0 = $FieldNameUsed . '0';
        my $FieldNameUsed1 = $FieldNameUsed . '1';
        $HTMLString = <<"EOF";
<input type="radio" id="$FieldNameUsed0" name="$FieldNameUsed" value="" $FieldUsedChecked0 />
Ignore this field.
<div class="clear"></div>
<input type="radio" id="$FieldNameUsed1" name="$FieldNameUsed" value="1" $FieldUsedChecked1 />
EOF
    }

    $HTMLString .= <<"EOF";
<input type="checkbox" class="$FieldClass" id="$FieldName" name="$FieldName" title="$FieldLabel" $FieldChecked value="1" />
EOF

    if ( $Param{Mandatory} ) {
        my $DivID = $FieldName . 'Error';

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
        my $DivID = $FieldName . 'ServerError';

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
        FieldName          => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my %Data;

    # check if there is a Template and retreive the dinalic field value from there
    if ( IsHashRefWithData( $Param{Template} ) ) {

        # get dynamic field value form Template
        $Data{FieldValue} = $Param{Template}->{$FieldName};

        # get dynamic field used value form Template
        $Data{UsedValue} = $Param{Template}->{ $FieldName . 'Used' };
    }

    # otherwise get dynamic field value form param
    else {

        # get dynamic field value form param
        $Data{FieldValue} = $Param{ParamObject}->GetParam( Param => $FieldName );

        # get dynamic field used value form param
        $Data{UsedValue} = $Param{ParamObject}->GetParam( Param => $FieldName . 'Used' );
    }

    # check if return value structure is nedded
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return \%Data;
    }

    # check if return template structure is nedded
    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {
        return {
            $FieldName          => $Data{FieldValue},
            $FieldName . 'Used' => $Data{UsedValue},
        };
    }

    # return undef if the hidden value is not present
    return if !$Data{UsedValue};

    # set the correct return value
    my $Value = '0';
    if ( $Data{FieldValue} ) {
        $Value = $Data{FieldValue};
    }

    return $Value;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $FieldValue = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},

        # not necessary for this backend but place it for consistency reasons
        ReturnValueStructure => 1,
    );
    my $Value = $FieldValue->{FieldValue} || '';

    my $ServerError;
    my $ErrorMessage;

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value ) {
        $ServerError = 1;
    }

    # validate only 0 or 1 as possible values
    if ( $Value && $Value ne 1 ) {
        $ServerError  = 1;
        $ErrorMessage = 'The field content is invalid';
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

    # check for Null value
    if ( !defined $Param{Value} ) {
        return {
            Value => '',
            Title => '',
            Link  => '',
        };
    }

    # convert value to user frendly string
    my $Value = 'Checked';
    if ( $Param{Value} ne 1 ) {
        $Value = 'Unchecked';
    }

    # always translate value
    $Value = $Param{LayoutObject}->{LanguageObject}->Get($Value);

    # in this backend there is no need for HTMLOutput
    # Title is always equal to Value
    my $Title = $Value;

    # this field type does not support the Link Feature
    my $Link;

    # create return structure
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
    my @DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        my @DefaultValue = split /;/, $Param{DefaultValue};
    }

    # set the field value
    if (@DefaultValue) {
        $Value = \@DefaultValue;
    }

    # get the field value, this fuction is always called after the profile is loaded
    my $FieldValue = $Self->SearchFieldValueGet(%Param);

    # set values from profile if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    for my $Item ( @{$Value} ) {

        # value must be 1, '' or -1
        if ( !defined $Item || !$Item ) {
            $Item = '';
        }
        elsif ( $Item && $Item >= 1 ) {
            $Item = 1;
        }
        else {
            $Item = -1;
        }
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldDropdown';

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data => {
            1  => 'Checked',
            -1 => 'Unchecked',
        },
        Name         => $FieldName,
        SelectedID   => $Value || '',
        Translation  => 1,
        PossibleNone => 1,
        Class        => $FieldClass,
        Multiple     => 1,
        HTMLQuote    => 1,
    );

    # call EditLabelRender on the common backend
    my $LabelString = $Self->{BackendCommonObject}->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        FieldName          => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    my $Value;

    # get dynamic field value form param object
    if ( defined $Param{ParamObject} ) {
        my @FieldValues = $Param{ParamObject}->GetArray(
            Param => 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name}
        );

        $Value = \@FieldValues;
    }

    # otherwise get the value from the profile
    elsif ( defined $Param{Profile} ) {
        $Value = $Param{Profile}->{ 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} };
    }
    else {
        return;
    }

    if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq 1 ) {
        return {
            'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} => $Value,
        };
    }

    return $Value;
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    my $DisplayValue;

    if ($Value) {

        if ( ref $Value eq "ARRAY" ) {
            my @DisplayItemList;
            ITEM:
            for my $Item ( @{$Value} ) {

                # set the display value
                my $DisplayItem
                    = $Item eq 1
                    ? 'Checked'
                    : $Item eq -1 ? 'Unchecked'
                    :               '';

                # translate the value
                $DisplayItem = $Param{LayoutObject}->{LanguageObject}->Get($DisplayItem);

                push @DisplayItemList, $DisplayItem;

                # set the correct value for "unchecked" (-1) search options
                if ( $Item && $Item eq -1 ) {
                    $Item = '0';
                }
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;

        }
        else {

            # set the display value
            $DisplayValue
                = $Value eq 1
                ? 'Checked'
                : $Value eq -1 ? 'Unchecked'
                :                '';

            # translate the value
            $DisplayValue = $Param{LayoutObject}->{LanguageObject}->Get($DisplayValue);
        }

        # set the correct value for "unchecked" (-1) search options
        if ( $Value && $Value eq -1 ) {
            $Value = '0';
        }
    }

    # return search parameter structure
    return {
        Parameter => {
            Equals => $Value,
        },
        Display => $DisplayValue,
    };
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    return {
        Values => {
            '1'  => 'Checked',
            '-1' => 'Unchecked',
        },
        Name               => $Param{DynamicFieldConfig}->{Label},
        Element            => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TranslatableValues => 1,
    };
}

sub CommonSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = 'Equals';
    my $Value    = $Param{Value};

    if ( IsArrayRefWithData($Value) ) {
        for my $Item ( @{$Value} ) {

            # set the correct value for "unchecked" (-1) search options
            if ( $Item && $Item eq '-1' ) {
                $Item = '0';
            }
        }
    }
    else {

        # set the correct value for "unchecked" (-1) search options
        if ( $Value && $Value eq '-1' ) {
            $Value = '0';
        }
    }

    return {
        $Operator => $Value,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # Title is always equal to Value
    my $Title = $Value;

    # create return structure
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
    my $SearchValueType = 'ARRAY';

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

    my $Value = int( rand(2) );

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

    return 1;
}

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # return false if not match
    if ( $Param{ObjectAttributes}->{$FieldName} ne $Param{Value} ) {
        return 0;
    }

    return 1;
}

sub AJAXPossibleValuesGet {
    my ( $Self, %Param ) = @_;

    # not supported
    return;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # get historical values from database
    my $HistoricalValues = $Self->{DynamicFieldValueObject}->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Integer',
    );

    # return the historical values from database
    return $HistoricalValues;
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return if !defined $Param{Key};

    return '' if $Param{Key} eq '';

    my $Value = defined $Param{Key} && $Param{Key} eq '1' ? 'Checked' : 'Unchecked';

    # check if translation is possible
    if ( defined $Param{LanguageObject} ) {

        # translate value
        $Value = $Param{LanguageObject}->Get($Value);
    }

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
