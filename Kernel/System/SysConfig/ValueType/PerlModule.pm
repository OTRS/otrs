# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::PerlModule;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::PerlModule - System configuration perl module value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::PerlModule');

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
                            'Content'     => 'Kernel::System::Log::SysLog',
                            'ValueFilter' => 'Kernel/System/Log/*.pm',
                            'ValueType'   => 'PerlModule',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => 'Kernel::System::Log::SysLog',
    );

Result:
    %Result = (
        EffectiveValue => 'Kernel::System::Log::SysLog',        # Note for PerlModule ValueTypes EffectiveValue is not changed.
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
        $Result{Error} = 'EffectiveValue for PerlModule must be a scalar!';
        return %Result;
    }

    # Check if EffectiveValue matches ValueFilter.
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $ValueFilter = $Param{XMLContentParsed}->{Value}->[0]->{Item}->[0]->{ValueFilter};

    my @ValidValue = $MainObject->DirectoryRead(
        Directory => $Home,
        Filter    => $ValueFilter,
    );

    for my $Value (@ValidValue) {

        # Convert to the relative path.
        $Value =~ s{^$Home/*(.*?)$}{$1}gsmx;

        # Replace '/' with '::'.
        $Value =~ s{/}{::}gsmx;

        # Remove extension.
        $Value =~ s{\..*$}{}gsmx;
    }

    if ( !grep { $_ eq $Param{EffectiveValue} } @ValidValue ) {
        $Result{Error} = "$Param{EffectiveValue} doesn't satisfy ValueFilter($ValueFilter)!";
        return %Result;
    }

    my $Loaded = $MainObject->Require(
        $Param{EffectiveValue},
        Silent => 1,
    );

    if ( !$Loaded ) {
        $Result{Error} = "$Param{EffectiveValue} not exists!";
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $Param{EffectiveValue};

    return %Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        EffectiveValue => '3 medium',       # (optional)
        DefaultValue   => '3 medium',       # (optional)
        Class          => 'My class'        # (optional)
        RW             => 1,                # (optional) Allow editing. Default 0.
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'PerlModule',
                'ValueFilter' => '"Kernel/System/Log/*.pm',
                'Content' => 'Kernel::System::Log::SysLog',
            },
        ],
        IsArray => 1,                       # (optional) Item is part of the array
        IsHash  => 1,                       # (optional) Item is part of the hash
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

    my $Value = $Param{XMLContentParsed}->{Value};

    my $EffectiveValue = $Param{EffectiveValue};
    if (
        !defined $EffectiveValue
        && $Param{Item}
        && $Param{Item}->[0]->{Content}
        )
    {
        $EffectiveValue = $Param{Item}->[0]->{Content};
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Home = $ConfigObject->Get('Home');

    my $Filter;

    if (
        $Param{Item}
        && $Param{Item}->[0]->{ValueFilter}
        )
    {
        $Filter = $Param{Item}->[0]->{ValueFilter};
    }
    elsif ( $Value->[0]->{Item} ) {
        $Filter = $Value->[0]->{Item}->[0]->{ValueFilter};
    }
    elsif ( $Value->[0]->{Array} ) {
        $Filter = $Value->[0]->{Array}->[0]->{DefaultItem}->[0]->{ValueFilter};
    }
    elsif ( $Value->[0]->{Hash} ) {
        if (
            $Value->[0]->{Hash}->[0]->{DefaultItem}
            && $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueFilter}
            )
        {

            # take ValueFilter from DefaultItem
            $Filter = $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueFilter};
        }
        else {
            # check if there is definition for certain key
            ITEM:
            for my $Item ( @{ $Value->[0]->{Hash}->[0]->{Item} } ) {
                if ( $Item->{Key} eq $Param{Key} ) {
                    $Filter = $Item->{ValueFilter} || '';
                    last ITEM;
                }
            }
        }
    }

    my @PerlModules = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Home,
        Filter    => $Filter,
    );

    for my $Module (@PerlModules) {

        # Convert to the relative path.
        $Module =~ s{^$Home/*(.*?)$}{$1}gsmx;

        # Replace '/' with '::'.
        $Module =~ s{/}{::}gsmx;

        # Remove extension.
        $Module =~ s{\..*$}{}gsmx;
    }

    my $Name = $Param{Name};

    # When displaying diff between current and old value, it can happen that value is missing
    #    since it was renamed, or removed. In this case, we need to add this "old" value also.
    if (
        $EffectiveValue
        && !grep { $_ eq $EffectiveValue } @PerlModules
        )
    {
        push @PerlModules, $EffectiveValue;
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
    $HTML .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data          => \@PerlModules,
        Name          => $Name,
        ID            => $Param{Name} . $Param{IDSuffix},
        Disabled      => $Param{RW} ? 0 : 1,
        SelectedValue => $EffectiveValue,
        Title         => $Param{Name},
        OptionTitle   => 1,
        Class         => "$Param{Class} Modernize",
    );

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    $HTML .= "</div>\n";

    if ( !$Param{IsArray} && !$Param{IsHash} ) {
        my $DefaultText = $LanguageObject->Translate('Default');

        $HTML .= <<"EOF";
                                <div class=\"WidgetMessage Bottom\">
                                    $DefaultText: $Param{DefaultValue}
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
            'ValueType' => 'PerlModule',
            'Content' => 'Kernel::System::Log::SysLog',
            'ValueFilter' => 'Kernel/System/Log/*.pm'
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

    $Param{Class}    //= '';
    $Param{IDSuffix} //= '';

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @PerlModules = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Home,
        Filter    => $Param{DefaultItem}->{ValueFilter},
    );

    for my $Module (@PerlModules) {

        # Convert to the relative path.
        $Module =~ s{^$Home/*(.*?)$}{$1}gsmx;

        # Replace '/' with '::'.
        $Module =~ s{/}{::}gsmx;

        # Remove extension.
        $Module =~ s{\..*$}{}gsmx;
    }

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data          => \@PerlModules,
        Name          => $Param{Name},
        ID            => $Param{Name} . $Param{IDSuffix},
        SelectedValue => $Param{DefaultItem}->{Content},
        Title         => $Param{Name},
        OptionTitle   => 1,
        Class         => "$Param{Class} Modernize Entry",
    );

    return $Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
