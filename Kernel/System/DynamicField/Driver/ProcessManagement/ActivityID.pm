# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::Driver::ProcessManagement::ActivityID;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::BaseText);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Main',
    'Kernel::System::ProcessManagement::Activity',
    'Kernel::System::ProcessManagement::DB::Activity',
    'Kernel::System::Ticket::ColumnFilter',
);

=head1 NAME

Kernel::System::DynamicField::Driver::ProcessManagement::ActivityID

=head1 DESCRIPTION

DynamicFields Text Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions
        = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::Text');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # set HTMLOutput as default if not specified
    if ( !defined $Param{HTMLOutput} ) {
        $Param{HTMLOutput} = 1;
    }

    # get raw Title and Value strings from field value
    # convert the ActivityEntityID to the Activity name
    my $Activity;
    if ( $Param{Value} ) {
        $Activity = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityGet(
            ActivityEntityID => $Param{Value},
            Interface        => 'all',
        );
    }
    my $Value = $Activity->{Name} // '';
    my $Title = $Value;

    # HTMLOutput transformations
    if ( $Param{HTMLOutput} ) {
        $Value = $Param{LayoutObject}->Ascii2Html(
            Text => $Value,
            Max  => $Param{ValueMaxChars} || '',
        );

        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max  => $Param{TitleMaxChars} || '',
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

    # create return structure
    my $Data = {
        Value => $Value,
        Title => $Title,
        Link  => $Link,
    };

    return $Data;
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};

    # set PossibleValues
    my $SelectionData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityList();

    # get column filter values from database
    my $ColumnFilterValues = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter')->DynamicFieldFilterValuesGet(
        TicketIDs => $Param{TicketIDs},
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {
        if ( $SelectionData->{$Key} ) {
            $ColumnFilterValues->{$Key} = $SelectionData->{$Key};
        }
    }

    return $ColumnFilterValues;
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # Get field value.
    my $Value = $Self->SearchFieldValueGet(%Param);

    # Set operator.
    my $Operator = 'Equals';

    # Search for a wild card in the value.
    if ( $Value && ( $Value =~ m{\*} || $Value =~ m{\|\|} ) ) {

        # Change operator.
        $Operator = 'Like';
    }

    if ( $Param{DynamicFieldConfig}->{Name} eq 'ProcessManagementActivityID' && $Value ) {

        my $ActivityEntityIDs = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity')->ActivitySearch(
            ActivityName => $Value,
        );

        if ( IsArrayRefWithData($ActivityEntityIDs) ) {

            # Add search term from input field.
            push @{$ActivityEntityIDs}, $Value;

            # Return search parameter structure.
            return {
                Parameter => {
                    $Operator => $ActivityEntityIDs,
                },
                Display => $Value,
            };
        }
    }

    # Return search parameter structure.
    return {
        Parameter => {
            $Operator => $Value,
        },
        Display => $Value,
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Value};

    # set operator
    my $Operator = 'Equals';

    # search for a wild card in the value
    if ( $Value && $Value =~ m{\*} ) {

        # change operator
        $Operator = 'Like';
    }

    if ( $Param{DynamicFieldConfig}->{Name} eq 'ProcessManagementActivityID' && $Value ) {

        my $ActivityEntityIDs = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity')->ActivitySearch(
            ActivityName => $Value,
        );

        if ( IsArrayRefWithData($ActivityEntityIDs) ) {

            # Add search term from input field.
            push @{$ActivityEntityIDs}, $Value;

            # Return search parameter structure.
            return {
                $Operator => $ActivityEntityIDs,
            };
        }
    }

    return {
        $Operator => $Value,
    };
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
