# --
# Kernel/System/DynamicField/Driver/DriverBaseSelect.pm - Dynamic field Driver functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Driver::DriverBaseSelect;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::DynamicField::Driver::DriverBase);

=head1 NAME

Kernel::System::DynamicField::Driver::DriverBaseSelect - sub module of
Kernel::System::DynamicField::Driver::Dropdown and
Kernel::System::DynamicField::Driver::Multiselect

=head1 SYNOPSIS

Date common functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

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
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if ( defined $FieldValues ) {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldMultiSelect';

    # set TreeView class
    $FieldClass .= ' DynamicFieldWithTreeView' if $FieldConfig->{TreeView};

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
    $SelectionData = $Param{PossibleValuesFilter}
        if defined $Param{PossibleValuesFilter};

    # check if $SelectionData differs from configured PossibleValues
    # and show values which are not contained as disabled if TreeView => 1
    if ( $FieldConfig->{TreeView} ) {

        if ( keys %{ $FieldConfig->{PossibleValues} } != keys %{$SelectionData} ) {

            my @Values;
            for my $Key ( keys %{ $FieldConfig->{PossibleValues} } ) {

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

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = 'Equals';
    my $Value    = $Param{Value};

    return {
        $Operator => $Value,
    };
}

sub IsAJAXUpdateable {
    my ( $Self, %Param ) = @_;

    return 1;
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

sub IsMatchable {
    my ( $Self, %Param ) = @_;

    return 1;
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
