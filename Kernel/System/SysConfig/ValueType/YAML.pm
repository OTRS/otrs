# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::YAML;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::YAML - System configuration YAML value type backend.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::YAML');

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
                            'Content'   => 'YAML content',
                            'ValueType' => 'YAML',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => 'YAML content',
    );

Result:
    %Result = (
        EffectiveValue => 'YAML content',
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

    # Data should be scalar.
    if ( ref $Param{EffectiveValue} ) {
        $Result{Error} = 'EffectiveValue for YAML must be a scalar!';
        return %Result;
    }

    my $EffectiveValue = $Param{EffectiveValue};
    if ( !( defined $EffectiveValue ) || $EffectiveValue =~ m{^---\s*$}i ) {
        return (
            Success        => 1,
            EffectiveValue => $EffectiveValue,
        );
    }

    my $YAMLObject          = $Kernel::OM->Get('Kernel::System::YAML');
    my $PerlStructureScalar = $YAMLObject->Load(
        Data => $Param{EffectiveValue},
    );

    if ( !$PerlStructureScalar || !( ref $PerlStructureScalar ) ) {
        $Result{Error} = 'EffectiveValue is not valid YAML';
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $EffectiveValue;

    return %Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        EffectiveValue => 'YAML content', # (optional)
        DefaultValue   => 'YAML content', # (optional)
        Class          => 'My class'          # (optional)
        Item           => [                   # (optional) XML parsed item
            {
                'ValueType' => 'YAML',
                'Content' => 'YAML content',
            },
        ],
        RW       => 1,                      # (optional) Allow editing. Default 0.
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

    $Param{Class}        //= '';
    $Param{DefaultValue} //= '';
    $Param{IDSuffix}     //= '';

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $Name = $Param{Name};

    my $EffectiveValue = $Param{EffectiveValue};
    if (
        !defined $EffectiveValue
        && $Param{Item}
        && $Param{Item}->[0]->{Content}
        )
    {
        $EffectiveValue = $Param{Item}->[0]->{Content};
    }

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

    my $HTML = "<div class='SettingContent'>\n";
    $HTML
        .= "<textarea rows='15' cols='50' class=\"$Param{Class}\" type=\"text\" name=\"$Name\"" .
        " id=\"$Param{Name}$Param{IDSuffix}\"";

    if ( !$Param{RW} ) {
        $HTML .= "disabled='disabled' ";
    }

    my $HTMLValue = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Ascii2Html(
        Text => $EffectiveValue,
        Type => 'Normal',
    );

    $HTML .= ">$HTMLValue</textarea>\n";

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    $HTML .= "</div>\n";

    if ( !$Param{IsArray} && !$Param{IsHash} ) {
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

    $HTML = '<textarea rows=\'15\' cols=\'50\' class="" type="text" name="SettingName">
        ...
        </textarea>';

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

    my $DefaultValue = $Param{DefaultItem}->{Content} || '';

    my $Result = "<textarea rows='15' cols='100' class=\"$Param{Class} Entry\" type=\"text\" name=\"$Param{Name}\" ";
    $Result .= "id=\"$Param{Name}$Param{IDSuffix}\">$DefaultValue</textarea>";

    return $Result;
}

1;
