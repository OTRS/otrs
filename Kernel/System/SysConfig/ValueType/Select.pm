# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::Select;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Select - System configuration select value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Select');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 SettingEffectiveValueCheck()

Check if provided EffectiveValue matches structure defined in XMLContentParsed.

    my %Result = $ValueTypeObject->SettingEffectiveValueCheck(
        XMLContentParsed => {
            Value => [
                {
                    'Item' => [
                        {
                            'Item' => [
                                {
                                    'Content'   => 'Option 1',
                                    'Value'     => 'option-1',
                                    'ValueType' => 'Option',
                                },
                                {
                                    'Content'   => 'Option 2',
                                    'Value'     => 'option-2',
                                    'ValueType' => 'Option',
                                },
                            ],
                            'SelectedID' => 'option-1',
                            'ValueType'  => 'Select',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => 'option-1',
    );

Result:
    %Result = (
        EffectiveValue => 'option-1',   # Note for Select ValueTypes EffectiveValue is not changed.
        Success => 1,
        Error   => undef,
    );

=cut

sub SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(XMLContentParsed)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    my %Result = (
        Success => 0,
    );

    my $Value = $Param{XMLContentParsed}->{Value};

    for my $Parameter ( sort keys %{ $Param{Parameters} } ) {
        if ( !defined $Value->[0]->{Item}->[0]->{$Parameter} ) {
            $Value->[0]->{Item}->[0]->{$Parameter} = $Param{Parameters}->{$Parameter};
        }
    }

    # Data should be scalar.
    if ( ref $Param{EffectiveValue} ) {
        $Result{Error} = 'EffectiveValue for Select must be a scalar!';
        return %Result;
    }

    if (
        !grep {
            $Param{EffectiveValue} eq $_->{Value}
                || ( !$Param{EffectiveValue} && !$_->{Value} )
        }
        @{ $Value->[0]->{Item}->[0]->{Item} }
        )
    {
        $Result{Error} = "'$Param{EffectiveValue}' option not found in Select!";
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $Param{EffectiveValue};

    return %Result;
}

sub EffectiveValueGet {
    my ( $Self, %Param ) = @_;

    if ( !IsArrayRefWithData( $Param{Value} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Value is missing or invalid!",
        );

        return '';
    }

    if ( scalar @{ $Param{Value} } > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Value must be a single element!",
        );
        return '';
    }

    $Param{Value}->[0]->{SelectedID} //= '';

    # Check if option is translatable.
    my ($Option) = grep { $_->{Value} eq $Param{Value}->[0]->{SelectedID} }
        @{ $Param{Value}->[0]->{Item} };

    if ( !defined $Option ) {

        # TODO: Should this really be logged?
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "'$Param{Value}->[0]->{SelectedID}' not found in select!",
        );
    }

    my $EffectiveValue = $Param{Value}->[0]->{SelectedID};

    if (
        $Param{Translate}
        &&
        $Option &&
        $Option->{Translatable}
        )
    {
        $EffectiveValue = $Kernel::OM->Get('Kernel::Language')->Translate($EffectiveValue);
    }

    return $EffectiveValue;
}

sub ModifiedValueGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Result = $Param{Value};

    # Update Content
    $Result->[0]->{Item}->[0]->{SelectedID} = $Param{EffectiveValue} || '';

    return $Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        DefaultID      =>  123,             # (required)
        EffectiveValue => '3 medium',
        DefaultValue   => '3 medium',       # (optional)
        Class          => 'My class'        # (optional)
        RW             => 1,                # (optional) Allow editing. Default 0.
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'Select',
                ...
            },
        ],
        IsArray => 1,                       # (optional) Item is part of the array
        IsHash  => 1,                       # (optional) Item is part of the hash
        Key     => 'Key',                   # (optional) Hash key (if available)
        SkipEffectiveValueCheck => 1,       # (optional) If enabled, system will not perform effective value check.
                                            #            Default: 1.
    );

Returns:

    $SettingHTML = '<div class "Field"...</div>';

=cut

sub SettingRender {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name EffectiveValue Item)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
            return;
        }
    }

    $Param{Class}        //= '';
    $Param{DefaultValue} //= '';
    $Param{IDSuffix}     //= '';

    if ( !IsArrayRefWithData( $Param{Item} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Item is invalid!",
        );
    }

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $EffectiveValue = $Param{EffectiveValue};

    my %EffectiveValueCheck = (
        Success => 1,
    );

    if ( !$Param{SkipEffectiveValueCheck} ) {
        %EffectiveValueCheck = $Self->SettingEffectiveValueCheck(
            EffectiveValue   => $EffectiveValue,
            XMLContentParsed => {
                Value => [
                    {
                        Item => $Param{Item},
                    },
                ],
            },
        );
    }

    my %Data;
    OPTION:
    for my $Option ( @{ $Param{Item}->[0]->{Item} } ) {
        next OPTION if $Option->{ValueType} ne 'Option';

        if ( $Option->{Translatable} ) {

            $Data{ $Option->{Value} } = $LanguageObject->Translate( $Option->{Content} );
            next OPTION;
        }
        $Data{ $Option->{Value} } = $Option->{Content};
    }

    # find data in hash if provided
    if ( !%Data && $Param{Value}->[0]->{Hash}->[0]->{Item} ) {
        my ($OptionItems) = grep { $_->{Key} eq $Param{Key} } @{ $Param{Value}->[0]->{Hash}->[0]->{Item} };

        OPTION:
        for my $Option ( @{ $OptionItems->{Item} } ) {
            next OPTION if $Option->{ValueType} ne 'Option';

            if ( $Option->{Translatable} ) {
                $Data{ $Option->{Value} } = $LanguageObject->Translate( $Option->{Content} );
                next OPTION;
            }
            $Data{ $Option->{Value} } = $Option->{Content};
        }
    }

    # data not found, try in DefaultItem
    if (
        !%Data
        && $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}
        && $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Item}
        )
    {
        OPTION:
        for my $Option ( @{ $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Item} } ) {
            next OPTION if $Option->{ValueType} ne 'Option';

            if ( $Option->{Translatable} ) {
                $Data{ $Option->{Value} } = $LanguageObject->Translate( $Option->{Content} );
                next OPTION;
            }
            $Data{ $Option->{Value} } = $Option->{Content};
        }
    }

    # When displaying diff between current and old value, it can happen that value is missing
    #    since it was renamed, or removed. In this case, we need to add this "old" value also.
    if (
        !grep {
            $_ eq $EffectiveValue
                || ( !$EffectiveValue && !$_ )
        } keys %Data
        )
    {
        $Data{$EffectiveValue} = $EffectiveValue;
    }

    my $OptionStrg = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Name        => $Param{Name},
        ID          => $Param{Name} . $Param{IDSuffix},
        Disabled    => $Param{RW} ? 0 : 1,
        Data        => \%Data,
        SelectedID  => $EffectiveValue,
        Class       => "$Param{Class} Modernize",
        Translation => 0,
    );

    my $HTML = "<div class='SettingContent'>\n";
    $HTML .= $OptionStrg;

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    $HTML .= "</div>\n";

    if ( !$Param{IsArray} && !$Param{IsHash} && defined $Param{DefaultValue} ) {
        my $DefaultValueStrg = $LanguageObject->Translate('Default');

        $HTML .= <<"EOF";

                                <div class=\"WidgetMessage Bottom\">
                                    $DefaultValueStrg: $Param{DefaultValue}
                                </div>
EOF
    }
    return $HTML;
}

=head2 AddItem()

Generate HTML for new array/hash item.

    my $HTML = $ValueTypeObject->AddItem(
        Name           => 'SettingName',    (required) Name
        DefaultItem    => {                 (required) DefaultItem hash
            'ValueType' => 'Select',
            'Content' => 'optiont-1',
        },
        IDSuffix       => '_Array1',        (optional) IDSuffix is needed for arrays and hashes.
    );

Returns:

    $HTML = '<select class="Modernize" id="SettingName" name="SettingName" title="SettingName">
        ...
        </select>';

=cut

sub AddItem {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Name DefaultItem)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{Class}        //= '';
    $Param{DefaultValue} //= '';
    $Param{IDSuffix}     //= '';

    my %Data;

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    OPTION:
    for my $Option ( @{ $Param{DefaultItem}->{Item} } ) {
        next OPTION if $Option->{ValueType} ne 'Option';

        if ( $Option->{Translatable} ) {
            $Data{ $Option->{Value} } = $LanguageObject->Translate( $Option->{Content} );
            next OPTION;
        }
        $Data{ $Option->{Value} } = $Option->{Content};
    }

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Name        => $Param{Name},
        ID          => $Param{Name} . $Param{IDSuffix},
        Data        => \%Data,
        SelectedID  => $Param{DefaultItem}->{SelectedID} || '',
        Class       => "$Param{Class} Modernize Entry",
        Title       => $Param{Name},
        Translation => 0,
    );

    return $Result;
}

=head2 ValueAttributeGet()

Returns attribute name in the parsed XML that contains Value.

    my $Result = $ValueTypeObject->ValueAttributeGet();
Result:
    $Result = 'SelectedID';

=cut

sub ValueAttributeGet {
    my ( $Self, %Param ) = @_;

    return 'SelectedID';
}

=head2 ForbiddenValueTypes()

Return array of value types that are not allowed inside this value type.

    my @ForbiddenValueTypes = $ValueTypeObject->ForbiddenValueTypes();

Returns:

    @ForbiddenValueTypes = (
        'Option',
        ...
    );

=cut

sub ForbiddenValueTypes {
    my ( $Self, %Param ) = @_;

    return ("Option");
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
