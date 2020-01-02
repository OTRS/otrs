# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::BaseValueType;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SysConfig::BaseValueType - Common system configuration value type backend functions.

=head1 PUBLIC INTERFACE

=head2 SettingEffectiveValueCheck()

Check if provided EffectiveValue matches structure defined in XMLContentParsed.

    my %Result = $ValueTypeObject->SettingEffectiveValueCheck(
        EffectiveValue => 'open',
        XMLContentParsed => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content' => "Scalar value",
                        },
                    ],
                },
            ],
        },
    );

Result:
    $Result = (
        EffectiveValue => 'open',    # Note for common ValueTypes EffectiveValue is not changed.
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
        $Result{Error} = 'EffectiveValue must be a scalar!';
        return %Result;
    }

    my $Regex = $Value->[0]->{Item}->[0]->{ValueRegex};

    # RegEx check - do not use any modifiers for compatibility reasons.
    if ( $Regex && $Param{EffectiveValue} !~ m{$Regex} ) {
        $Result{Error} = "EffectiveValue not valid - regex '$Regex'!";
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $Param{EffectiveValue};

    return %Result;
}

=head2 EffectiveValueGet()

Extracts the effective value from a XML parsed setting.

    my $EffectiveValue = $ValueTypeObject->EffectiveValueGet(
        Value => [
            {
                ValueRegex => '',                       # (optional)
                Content    => 'TheEffectiveValue',
                ValueType  => 'AValueType',             # (optional)
                # ...
            }
        ],
    );

Returns:

    $EffectiveValue = 'TheEffectiveValue';

=cut

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

    $Param{Translate} = 0;    # common ValueTypes are never translated

    my $Result = $Param{Value}->[0]->{Content} // '';

    if (
        $Result
        && $Param{Translate}
        && $Param{Value}->[0]->{Translatable}
        )
    {
        $Result = $Kernel::OM->Get('Kernel::Language')->Translate($Result);
    }

    return $Result;
}

=head2 ModifiedValueGet()

Returns parsed value with updated content(according to EffectiveValue).

    my $ModifiedValue = $ValueTypeObject->ModifiedValueGet(
        'EffectiveValue' => 'Item 1',
        'Value' => [
            {
                'Item' => [
                    {
                        'Content' => 'Default value',
                        'ValueType' => 'String',
                    },
                ],
            },
        ],
    );

Returns:

    $ModifiedValue = [
        {
            'Item' => [
                {
                    'Content' => 'Item 1',
                    'ValueType' => 'String',
                },
            ],
        },
    ];

=cut

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
    $Result->[0]->{Item}->[0]->{Content} = $Param{EffectiveValue} || '';

    return $Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        EffectiveValue => 'Product 6',      # (optional)
        DefaultValue   => 'Product 5',      # (optional)
        Class          => 'My class'        # (optional)
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'String',
                'Content' => 'admin@example.com',
                'ValueRegex' => '',
            },
        ],
        RW => 1,                            # (optional) Allow editing. Default 0.
        IsArray  => 1,                      # (optional) Item is part of the array
        IsHash   => 1,                      # (optional) Item is part of the hash
        IDSuffix => 1,                      # (optional) Suffix will be added to the element ID
        SkipEffectiveValueCheck => 1,       # (optional) If enabled, system will not perform effective value check.
                                            #            Default: 1.
    );

Returns:

    $SettingHTML = '<div class "Field"...</div>';

=cut

sub SettingRender {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name",
        );
        return;
    }

    $Param{EffectiveValue} //= '';
    $Param{Class}          //= '';
    $Param{DefaultValue}   //= '';
    my $IDSuffix = $Param{IDSuffix} || '';

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $EffectiveValue = $Param{EffectiveValue};
    if (
        !defined $EffectiveValue
        && $Param{Item}
        && $Param{Item}->[0]->{Content}
        )
    {
        $EffectiveValue = $Param{Item}->[0]->{Content};
    }

    my $Regex;
    if ( $Param{Item}->[0]->{ValueRegex} ) {
        $Regex = $Param{Item}->[0]->{ValueRegex};
        $Param{Class} .= ' Validate_Regex ';
    }

    my $DefaultValueStrg = $LanguageObject->Translate('Default');

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

    my $HTML = '<div class="SettingContent">';
    $HTML .= "<input class=\"$Param{Class}\" type=\"text\" name=\"$Param{Name}\" id=\"$Param{Name}$IDSuffix\" ";

    my $HTMLValue = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Ascii2Html(
        Text => $EffectiveValue,
        Type => 'Normal',
    );
    $HTML .= "value=\"$HTMLValue\" ";

    if ($Regex) {
        $HTML .= "data-regex=\"$Regex\" ";
    }

    if ( !$Param{RW} ) {
        $HTML .= "disabled='disabled' ";
    }

    $HTML .= " />\n";

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    if ($Regex) {
        my $Message = $LanguageObject->Translate(
            "Value doesn't satisfy regex (%s).", $Regex,
        );

        $HTML .= "<div class='TooltipErrorMessage' id=\"$Param{Name}$IDSuffix" . "Error\">\n";
        $HTML .= "<p>$Message</p>\n";
        $HTML .= "</div>\n";
    }

    $HTML .= "</div>";

    if ( !$Param{IsArray} && !$Param{IsHash} ) {
        $HTML .= <<"EOF";
                                <div class=\"WidgetMessage Bottom\">
                                    $DefaultValueStrg: $Param{DefaultValue}
                                </div>
EOF
    }

    return $HTML;
}

sub EffectiveValueCalculate {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Result = '';

    if ( $Param{ $Param{Name} } ) {
        $Result = $Param{ $Param{Name} };
    }

    return $Result;
}

=head2 AddItem()

Generate HTML for new array/hash item.

    my $HTML = $ValueTypeObject->AddItem(
        Name           => 'SettingName',    (required) Name
        DefaultItem    => {                 (optional) DefaultItem hash, if available
            Item => {
                Content => 'Value',
            },
        },
    );

Returns:

    $HTML = "<input type='text' id='Setting_ExampleArray'
        value='Value' name='ExampleArray' class='Entry'/>";

=cut

sub AddItem {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $IDSuffix = $Param{IDSuffix} || '';
    my $Class    = $Param{Class}    || '';

    my $Name = $Param{Name} . $IDSuffix;

    my $DefaultValue = '';

    if ( $Param{DefaultItem} && $Param{DefaultItem}->{Item} ) {
        $DefaultValue = $Param{DefaultItem} && $Param{DefaultItem}->{Item}->{Content} || '';
    }
    elsif ( $Param{DefaultItem} ) {
        $DefaultValue = $Param{DefaultItem} && $Param{DefaultItem}->{Content} || '';
    }

    my $RemoveThisEntry = $Kernel::OM->Get('Kernel::Language')->Translate("Remove this entry");

    my $Result = "<input type='text' id='$Name'
        value='$DefaultValue' name='$Param{Name}' class='$Class Entry'/>";

    return $Result;
}

=head2 ValueAttributeGet()

Returns attribute name in the parsed XML that contains Value.

    my $Result = $ValueTypeObject->ValueAttributeGet();

Result:
    $Result = 'Content';

=cut

sub ValueAttributeGet {
    my ( $Self, %Param ) = @_;

    return 'Content';
}

=head2 DefaultItemAdd()

Return structure of the DefaultItem in case it's not inside of Array or Hash.

    my $DefaultItem = $ValueTypeObject->DefaultItemAdd();

Returns:

    $DefaultItem = undef;
        # or
    $DefaultItem = {
        Item => {
            Content => '',
        },
        ValueType => 'VacationDaysOneTime',
    };

=cut

sub DefaultItemAdd {
    my ( $Self, %Param ) = @_;

    # For most ValueTypes there is no such case, so return undef.
    return;
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

    return ();
}

=head2 AddSettingContent()

Checks if a div with class 'SettingContent' should be added when adding new item to an array/hash in some special cases.

    my $AddSettingContent = $ValueTypeObject->AddSettingContent();

Returns:

    my $AddSettingContent = 1;

=cut

sub AddSettingContent {
    my ( $Self, %Param ) = @_;

    return 1;
}

1;
