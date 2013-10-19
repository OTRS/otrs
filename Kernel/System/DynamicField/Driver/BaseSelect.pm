# --
# Kernel/System/DynamicField/Driver/BaseSelect.pm - Dynamic field Driver functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Driver::BaseSelect;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::DynamicField::Driver::Base);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseSelect - sub module of
Kernel::System::DynamicField::Driver::Dropdown and
Kernel::System::DynamicField::Driver::Multiselect

=head1 SYNOPSIS

Date common functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Self->{DynamicFieldValueObject}->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;
    return if !IsArrayRefWithData($DFValue);
    return if !IsHashRefWithData( $DFValue->[0] );

    return $DFValue->[0]->{ValueText};
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check for valid possible values list
    if ( !$Param{DynamicFieldConfig}->{Config}->{PossibleValues} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need PossibleValues in DynamicFieldConfig!",
        );
        return;
    }

    my $Success = $Self->{DynamicFieldValueObject}->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => [
            {
                ValueText => $Param{Value},
            },
        ],
        UserID => $Param{UserID},
    );

    return $Success;
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->{DynamicFieldValueObject}->ValueValidate(
        Value => {
            ValueText => $Param{Value},
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
        my $SQL = " $Param{TableAlias}.value_text $Operators{$Param{Operator}} '";
        $SQL .= $Self->{DBObject}->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'Like' ) {

        my $SQL = $Self->{DBObject}->QueryCondition(
            Key   => "$Param{TableAlias}.value_text",
            Value => $Param{SearchTerm},
        );

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

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = ( defined $FieldConfig->{DefaultValue} ? $FieldConfig->{DefaultValue} : '' );
    }
    $Value = $Param{Value} // $Value;

    # check if a value in a template (GenericAgent etc.)
    # is configured for this dynamic field
    if (
        IsHashRefWithData( $Param{Template} )
        && defined $Param{Template}->{$FieldName}
        )
    {
        $Value = $Param{Template}->{$FieldName};
    }

    # extract the dynamic field value form the web request
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    if ( $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    # set TreeView class
    if ( $FieldConfig->{TreeView} ) {
        $FieldClass .= ' DynamicFieldWithTreeView';
    }

    # set PossibleValues, use PossibleValuesFilter if defined
    my $PossibleValues = $Param{PossibleValuesFilter} // $Self->PossibleValuesGet(%Param);

    my $Size = 1;

    # TODO change ConfirmationNeeded parameter name to something more generic

    # when ConfimationNeeded parameter is present (AdminGenericAgent) the filed should be displayed
    # as an open list, because you might not want to change the value, otherwise a value will be
    # selected
    if ( $Param{ConfirmationNeeded} ) {
        $Size = 5;
    }

    my $DataValues = $Self->BuildSelectionDataGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        PossibleValues     => $PossibleValues,
        Value              => $Value,
    );

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data => $DataValues || {},
        Name => $FieldName,
        SelectedID  => $Value,
        Translation => $FieldConfig->{TranslatableValues} || 0,
        Class       => $FieldClass,
        Size        => $Size,
        HTMLQuote   => 1,
    );

    if ( $FieldConfig->{TreeView} ) {
        $HTMLString
            .= ' <a href="#" title="$Text{"Show Tree Selection"}" class="ShowTreeSelection">$Text{"Show Tree Selection"}</a>';
    }

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

    if ( $Param{AJAXUpdate} ) {

        my $FieldSelector = '#' . $FieldName;

        my $FieldsToUpdate = '';
        if ( IsArrayRefWithData( $Param{UpdatableFields} ) ) {

            # Remove current field from updatable fields list
            my @FieldsToUpdate = grep { $_ ne $FieldName } @{ $Param{UpdatableFields} };

            # quote all fields, put commas in between them
            $FieldsToUpdate = join( ', ', map {"'$_'"} @FieldsToUpdate );
        }

        # add js to call FormUpdate()
        $HTMLString .= <<"EOF";

<!--dtl:js_on_document_complete-->
<script type="text/javascript">//<![CDATA[
    \$('$FieldSelector').bind('change', function (Event) {
        Core.AJAX.FormUpdate(\$(this).parents('form'), 'AJAXUpdate', '$FieldName', [ $FieldsToUpdate ]);
    });
    Core.App.Subscribe('Event.AJAX.FormUpdate.Callback', function(Data) {
        var FieldName = '$FieldName';
        if (Data[FieldName] && \$('#' + FieldName).hasClass('DynamicFieldWithTreeView')) {
            Core.UI.TreeSelection.RestoreDynamicFieldTreeView(\$('#' + FieldName), Data[FieldName], '' , 1);
        }
    });
//]]></script>
<!--dtl:js_on_document_complete-->
EOF
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
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

    my $Value;

    # check if there is a Template and retrieve the dynamic field value from there
    if ( IsHashRefWithData( $Param{Template} ) ) {
        $Value = $Param{Template}->{$FieldName};
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        $Value = $Param{ParamObject}->GetParam( Param => $FieldName );
    }

    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq 1 ) {
        return {
            $FieldName => $Value,
        };
    }

    # for this field the normal return an the ReturnValueStructure are the same
    return $Value;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},

        # not necessary for this Driver but place it for consistency reasons
        ReturnValueStructure => 1,
    );

    my $ServerError;
    my $ErrorMessage;

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value ) {
        return {
            ServerError => 1,
        };
    }
    else {

        # get possible values list
        my $PossibleValues = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

        # overwrite possible values if PossibleValuesFilter
        if ( defined $Param{PossibleValuesFilter} ) {
            $PossibleValues = $Param{PossibleValuesFilter}
        }

        # validate if value is in possible values list (but let pass empty values)
        if ( $Value && !$PossibleValues->{$Value} ) {
            $ServerError  = 1;
            $ErrorMessage = 'The field content is invalid';
        }
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

    # set HTMLOuput as default if not specified
    if ( !defined $Param{HTMLOutput} ) {
        $Param{HTMLOutput} = 1;
    }

    # get raw Value strings from field value
    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # get real value
    if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value} ) {

        # get readeable value
        $Value = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};
    }

    # check is needed to translate values
    if ( $Param{DynamicFieldConfig}->{Config}->{TranslatableValues} ) {

        # translate value
        $Value = $Param{LayoutObject}->{LanguageObject}->Get($Value);
    }

    # set title as value after update and before limit
    my $Title = $Value;

    # HTMLOuput transformations
    if ( $Param{HTMLOutput} ) {
        $Value = $Param{LayoutObject}->Ascii2Html(
            Text => $Value,
            Max => $Param{ValueMaxChars} || '',
        );

        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max => $Param{TitleMaxChars} || '',
        );
    }
    else {
        if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
            $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
        }
        if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
        }
    }

    # set field link form config
    my $Link = $Param{DynamicFieldConfig}->{Config}->{Link} || '';

    my $Data = {
        Value => $Value,
        Title => $Title,
        Link  => $Link,
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

    my @DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        @DefaultValue = split /;/, $Param{DefaultValue};
    }

    # set the field value
    if (@DefaultValue) {
        $Value = \@DefaultValue;
    }

    # get the field value, this function is always called after the profile is loaded
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if ( defined $FieldValues ) {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldMultiSelect';

    # set TreeView class
    if ( $FieldConfig->{TreeView} ) {
        $FieldClass .= ' DynamicFieldWithTreeView';
    }

    # set PossibleValues
    my $SelectionData = $FieldConfig->{PossibleValues};

    # get historical values from database
    my $HistoricalValues = $Self->HistoricalValuesGet(%Param);

    # add historic values to current values (if they don't exist anymore)
    if ( IsHashRefWithData($HistoricalValues) ) {
        for my $Key ( sort keys %{$HistoricalValues} ) {
            if ( !$SelectionData->{$Key} ) {
                $SelectionData->{$Key} = $HistoricalValues->{$Key}
            }
        }
    }

    # use PossibleValuesFilter if defined
    $SelectionData = $Param{PossibleValuesFilter} // $SelectionData;

    # check if $SelectionData differs from configured PossibleValues
    # and show values which are not contained as disabled if TreeView => 1
    if ( $FieldConfig->{TreeView} ) {

        if ( keys %{ $FieldConfig->{PossibleValues} } != keys %{$SelectionData} ) {

            my @Values;
            for my $Key ( sort keys %{ $FieldConfig->{PossibleValues} } ) {

                push @Values, {
                    Key      => $Key,
                    Value    => $FieldConfig->{PossibleValues}->{$Key},
                    Disabled => ( defined $SelectionData->{$Key} ) ? 0 : 1,
                };
            }
            $SelectionData = \@Values;
        }
    }

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data         => $SelectionData,
        Name         => $FieldName,
        SelectedID   => $Value,
        Translation  => $FieldConfig->{TranslatableValues} || 0,
        PossibleNone => 0,
        Class        => $FieldClass,
        Multiple     => 1,
        HTMLQuote    => 1,
    );

    if ( $FieldConfig->{TreeView} ) {
        $HTMLString
            .= ' <a href="#" title="$Text{"Show Tree Selection"}" class="ShowTreeSelection">$Text{"Show Tree Selection"}</a>';
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
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

    # get dynamic field value from param object
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
        if ( ref $Value eq 'ARRAY' ) {

            my @DisplayItemList;
            for my $Item ( @{$Value} ) {

                # set the display value
                my $DisplayItem = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Item}
                    || $Item;

                # translate the value
                if (
                    $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                    && defined $Param{LayoutObject}
                    )
                {
                    $DisplayItem = $Param{LayoutObject}->{LanguageObject}->Get($DisplayItem);
                }

                push @DisplayItemList, $DisplayItem;
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;
        }
        else {

            # set the display value
            $DisplayValue = $Param{DynamicFieldConfig}->{PossibleValues}->{$Value};

            # translate the value
            if (
                $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                && defined $Param{LayoutObject}
                )
            {
                $DisplayValue = $Param{LayoutObject}->{LanguageObject}->Get($DisplayValue);
            }
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

    # set PossibleValues
    my $Values = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

    # get historical values from database
    my $HistoricalValues = $Self->{DynamicFieldValueObject}->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text,',
    );

    # add historic values to current values (if they don't exist anymore)
    for my $Key ( sort keys %{$HistoricalValues} ) {
        if ( !$Values->{$Key} ) {
            $Values->{$Key} = $HistoricalValues->{$Key}
        }
    }

    # use PossibleValuesFilter if defined
    $Values = $Param{PossibleValuesFilter} // $Values;

    return {
        Values             => $Values,
        Name               => $Param{DynamicFieldConfig}->{Label},
        Element            => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TranslatableValues => $Param{DynamicFieldconfig}->{Config}->{TranslatableValues},
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = 'Equals';
    my $Value    = $Param{Value};

    return {
        $Operator => $Value,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # set title as value after update and before limit
    my $Title = $Value;

    # cut strings if needed
    if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
        $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
    }
    if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
        $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
    }

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

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    my $Value = int( rand(500) );

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

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # return false if field is not defined
    return 0 if ( !defined $Param{ObjectAttributes}->{$FieldName} );

    # return false if not match
    if ( $Param{ObjectAttributes}->{$FieldName} ne $Param{Value} ) {
        return 0;
    }

    return 1;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # get historical values from database
    my $HistoricalValues = $Self->{DynamicFieldValueObject}->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # return the historical values from database
    return $HistoricalValues;
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Key} ? $Param{Key} : '';

    # get real values
    my $PossibleValues = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

    if ($Value) {

        # check if there is a real value for this key (otherwise keep the key)
        if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value} ) {

            # get readeable value
            $Value = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};

            # check if translation is possible
            if (
                defined $Param{LanguageObject}
                && $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                )
            {

                # translate value
                $Value = $Param{LanguageObject}->Get($Value);
            }
        }
    }

    return $Value;
}

sub BuildSelectionDataGet {
    my ( $Self, %Param ) = @_;

    my $FieldConfig            = $Param{DynamicFieldConfig}->{Config};
    my $FilteredPossibleValues = $Param{PossibleValues};

    # get the possible values again as it might or might not contain the possible none and it could
    # oso ve overritten
    my $ConfigPossibleValues = $Self->PossibleValuesGet(%Param);

    # check if $PossibleValues differs from configured PossibleValues
    # and show values which are not contained as disabled if TreeView => 1
    if ( $FieldConfig->{TreeView} ) {

        if ( keys %{$ConfigPossibleValues} != keys %{$FilteredPossibleValues} ) {

            # define variables to use later in the for loop
            my @Values;
            my $Parents;
            my %DisabledElements;
            my %ProcessedElements;
            my $PosibleNoneSet;

            # loop on all filtred possible values
            for my $Key ( sort keys %{$FilteredPossibleValues} ) {

                # special case for possible none
                if ( !$Key && !$PosibleNoneSet && $FieldConfig->{PossibleNone} ) {

                    # add possible none
                    push @Values, {
                        Key      => $Key,
                        Value    => $ConfigPossibleValues->{$Key} || '-',
                        Selected => defined $Param{Value} || !$Param{Value} ? 1 : 0,
                    };
                }

                # try to split its parents GrandParent::Parent::Son
                my @Elements = split /::/, $Key;

                # reset parents
                $Parents = '';

                # get each element in the hierarchy
                ELEMENT:
                for my $Element (@Elements) {

                    # add its own parents for the complete name
                    my $ElementLongName = $Parents . $Element;

                    # set new parent (before skip already processed)
                    $Parents .= $Element . '::';

                    # skip if already processed
                    next ELEMENT if $ProcessedElements{$ElementLongName};

                    my $Disabled;

                    # check if element exists in the original data or if it is already marked
                    if (
                        !defined $FilteredPossibleValues->{$ElementLongName}
                        && !$DisabledElements{$ElementLongName}
                        )
                    {

                        # mark element as disabled
                        $DisabledElements{$ElementLongName} = 1;

                        # also set the disabled flag for current emlement to add
                        $Disabled = 1;
                    }

                    # set element as already processed
                    $ProcessedElements{$ElementLongName} = 1;

                    # check if the current element is the selected one
                    my $Selected;
                    if (
                        defined $Param{Value}
                        && $Param{Value}
                        && $ElementLongName eq $Param{Value}
                        )
                    {
                        $Selected = 1;
                    }

                    # add element to the new list of possible values (now including missing parents)
                    push @Values, {
                        Key      => $ElementLongName,
                        Value    => $ConfigPossibleValues->{$ElementLongName} || $ElementLongName,
                        Disabled => $Disabled,
                        Selected => $Selected,
                    };
                }
            }
            $FilteredPossibleValues = \@Values;
        }
    }

    return $FilteredPossibleValues;
}

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    # to store the possible values
    my %PossibleValues;

    # set PossibleNone attribute
    my $FieldPossibleNone;
    if ( defined $Param{OverridePossibleNone} ) {
        $FieldPossibleNone = $Param{OverridePossibleNone};
    }
    else {
        $FieldPossibleNone = $Param{DynamicFieldConfig}->{Config}->{PossibleNone} || 0;
    }

    # set none value if defined on field config
    if ($FieldPossibleNone) {
        %PossibleValues = ( '' => '-' );
    }

    # set all other possible values if defined on field config
    if ( IsHashRefWithData( $Param{DynamicFieldConfig}->{Config}->{PossibleValues} ) ) {
        %PossibleValues = (
            %PossibleValues,
            %{ $Param{DynamicFieldConfig}->{Config}->{PossibleValues} },
        );
    }

    # return the possible values hash as a reference
    return \%PossibleValues;
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};

    # set PossibleValues
    my $SelectionData = $FieldConfig->{PossibleValues};

    # get column filter values from database
    my $ColumnFilterValues = $Self->{ColumnFilterObject}->DynamicFieldFilterValuesGet(
        TicketIDs => $Param{TicketIDs},
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {
        if ( $SelectionData->{$Key} ) {
            $ColumnFilterValues->{$Key} = $SelectionData->{$Key}
        }
    }

    if ( $FieldConfig->{TranslatableValues} ) {

        # translate the value
        for my $ValueKey ( sort keys %{$ColumnFilterValues} ) {

            my $OriginalValueName = $ColumnFilterValues->{$ValueKey};
            $ColumnFilterValues->{$ValueKey}
                = $Param{LayoutObject}->{LanguageObject}->Get($OriginalValueName);
        }
    }

    return $ColumnFilterValues;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
