# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::Password;
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

Kernel::System::SysConfig::ValueType::Password - System configuration password value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Password');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
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
                'ValueType' => 'Password',
                'Content' => 'Secret',
            },
        ],
        RW => 1,                            # (optional) Allow editing. Default 0.
        IsArray => 1,                       # (optional) Item is part of the array
        IsHash  => 1,                       # (optional) Item is part of the hash
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

    my $IDSuffix = $Param{IDSuffix} || '';

    my $EffectiveValue = $Param{EffectiveValue};
    if (
        !defined $EffectiveValue
        && $Param{Item}
        && $Param{Item}->[0]->{Content}
        )
    {
        $EffectiveValue = $Param{Item}->[0]->{Content};
    }

    $Param{Class}        //= '';
    $Param{DefaultValue} //= '';

    my $DefaultValueStrg = $Kernel::OM->Get('Kernel::Language')->Translate('Default');

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
    $HTML .= "<input class=\"$Param{Class}\" type=\"password\" name=\"$Param{Name}\" id=\"$Param{Name}$IDSuffix\"";

    my $HTMLValue = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Ascii2Html(
        Text => $EffectiveValue,
        Type => 'Normal',
    );

    $HTML .= "\" value=\"$HTMLValue\" ";

    if ( !$Param{RW} ) {
        $HTML .= "disabled='disabled' ";
    }

    $HTML .= " />\n";

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $Kernel::OM->Get('Kernel::Language')
            ->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    $HTML .= "</div>\n";

    return $HTML;
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

    $HTML = "<input type='password' id='Setting_ExampleArray'
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

    my $DefaultValue = '';
    if ( $Param{DefaultItem} && $Param{DefaultItem}->{Item} ) {
        $DefaultValue = $Param{DefaultItem} && $Param{DefaultItem}->{Item}->{Content} || '';
    }
    elsif ( $Param{DefaultItem} ) {
        $DefaultValue = $Param{DefaultItem} && $Param{DefaultItem}->{Content} || '';
    }

    my $RemoveThisEntry = $Kernel::OM->Get('Kernel::Language')->Translate("Remove this entry");

    my $Result = "<input type='password' id='$Param{Name}$IDSuffix'
        value='$DefaultValue' name='$Param{Name}' class='$Class Entry'/>";

    return $Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
