# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::Driver::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Base - common fields backend functions

=head1 PUBLIC INTERFACE

=cut

sub ValueIsDifferent {
    my ( $Self, %Param ) = @_;

    # special cases where the values are different but they should be reported as equals
    return if !defined $Param{Value1} && ( defined $Param{Value2} && $Param{Value2} eq '' );
    return if !defined $Param{Value2} && ( defined $Param{Value1} && $Param{Value1} eq '' );

    # compare the results
    return DataIsDifferent(
        Data1 => \$Param{Value1},
        Data2 => \$Param{Value2}
    );
}

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueDelete(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );

    return $Success;
}

sub AllValuesDelete {
    my ( $Self, %Param ) = @_;

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->AllValuesDelete(
        FieldID => $Param{DynamicFieldConfig}->{ID},
        UserID  => $Param{UserID},
    );

    return $Success;
}

sub HasBehavior {
    my ( $Self, %Param ) = @_;

    # return fail if Behaviors hash does not exists
    return if !IsHashRefWithData( $Self->{Behaviors} );

    # return success if the dynamic field has the expected behavior
    return IsPositiveInteger( $Self->{Behaviors}->{ $Param{Behavior} } );
}

sub SearchFieldPreferences {
    my ( $Self, %Param ) = @_;

    my @Preferences = (
        {
            Type        => '',
            LabelSuffix => '',
        },
    );

    return \@Preferences;
}

=head2 EditLabelRender()

creates the label HTML to be used in edit masks.

    my $LabelHTML = $BackendObject->EditLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        FieldName          => 'TheField',               # the value to be set on the 'for' attribute
        AdditionalText     => 'Between'                 # other text to be placed next to FieldName
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub EditLabelRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig FieldName)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(Label)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    my $Name      = $Param{FieldName};
    my $LabelText = $Param{DynamicFieldConfig}->{Label};

    my $LabelID    = 'Label' . $Param{FieldName};
    my $HTMLString = '';

    if ( $Param{Mandatory} ) {

        # opening tag
        $HTMLString = <<"EOF";
<label id="$LabelID" for="$Name" class="Mandatory">
    <span class="Marker">*</span>
EOF
    }
    else {

        # opening tag
        $HTMLString = <<"EOF";
<label id="$LabelID" for="$Name">
EOF
    }

    # text
    $HTMLString .= $Param{LayoutObject}->Ascii2Html(
        Text => $Param{LayoutObject}->{LanguageObject}->Translate("$LabelText")
    );
    if ( $Param{AdditionalText} ) {
        $HTMLString .= " (";
        $HTMLString .= $Param{LayoutObject}->Ascii2Html(
            Text => $Param{LayoutObject}->{LanguageObject}->Translate("$Param{AdditionalText}")
        );
        $HTMLString .= ")";
    }
    $HTMLString .= ":\n";

    # closing tag
    $HTMLString .= <<"EOF";
</label>
EOF

    return $HTMLString;
}

=head2 ValueSearch()

Searches/fetches dynamic field value.

    my $Value = $BackendObject->ValueSearch(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Search             => 'test',
    );

    Returns [
        {
            ID            => 437,
            FieldID       => 23,
            ObjectID      => 133,
            ValueText     => 'some text',
            ValueDateTime => '1977-12-12 12:00:00',
            ValueInt      => 123,
        },
    ];

=cut

sub ValueSearch {
    my ( $Self, %Param ) = @_;

    # check mandatory parameters
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldConfig!"
        );
        return;
    }

    my $SearchTerm = $Param{Search};
    my $Operator   = 'Equals';
    if ( $Self->HasBehavior( Behavior => 'IsLikeOperatorCapable' ) ) {
        $SearchTerm = '%' . $Param{Search} . '%';
        $Operator   = 'Like';
    }

    my $SearchSQL = $Self->SearchSQLGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        TableAlias         => 'dynamic_field_value',
        SearchTerm         => $SearchTerm,
        Operator           => $Operator,
    );

    if ( !defined $SearchSQL || !length $SearchSQL ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error generating search SQL!"
        );
        return;
    }

    my $Values = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSearch(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        Search    => $Param{Search},
        SearchSQL => $SearchSQL,
    );

    return $Values;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
