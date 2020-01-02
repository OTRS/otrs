# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
package Kernel::System::SysConfig::ValueType::VacationDays;

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

Kernel::System::SysConfig::ValueType::VacationDays - System configuration vacation-days value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::VacationDays');

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
                                    'Content'      => 'New Year\'s Day',
                                    'Translatable' => '1',
                                    'ValueDay'     => '1',
                                    'ValueMonth'   => '1',
                                },
                            ],
                            'ValueType' => 'VacationDays',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => {
            '1' => {
                '1' => 'New Year\'s Day',
            },
            '12' => {
                '24' => 'Christmas Eve',
            },
        },
    );

Result:
    %Result = (
        EffectiveValue => {                     # Note for VacationDays ValueTypes EffectiveValue is not changed.
            '1' => {
                '1' => 'New Year\'s Day',
            },
            '12' => {
                '24' => 'Christmas Eve',
            },
        },
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

    # Data should be hash.
    if ( ref $Param{EffectiveValue} ne 'HASH' ) {
        $Result{Error} = 'EffectiveValue for VacationDays must be a hash!';
        return %Result;
    }

    MONTH:
    for my $Month ( sort keys %{ $Param{EffectiveValue} } ) {
        if ( $Month !~ m{^([1-9]|1[0-2])$}gsmx ) {
            $Result{Error} = "'$Month' must be a month number(1..12)!";
            last MONTH;
        }

        if ( !IsHashRefWithData( $Param{EffectiveValue}->{$Month} ) ) {
            $Result{Error} = "'$Month' must be a hash reference!";
            last MONTH;
        }

        for my $Day ( sort keys %{ $Param{EffectiveValue}->{$Month} } ) {
            if ( $Day !~ m{^([1-9]|[12][0-9]|3[01])$}gsmx ) {
                $Result{Error} = "'$Day' must be a day number(1..31)!";
                last MONTH;
            }

            if (
                ref $Param{EffectiveValue}->{$Month}->{$Day}
                || !$Param{EffectiveValue}->{$Month}->{$Day}
                )
            {
                $Result{Error} = "Vacation description must be a string!";
                last MONTH;
            }
        }
    }
    return %Result if $Result{Error};

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

    return '' if !$Param{Value}->[0]->{Item};

    return '' if ref $Param{Value}->[0]->{Item} ne 'ARRAY';

    my %Result;

    COMPONENT:
    for my $Component ( @{ $Param{Value}->[0]->{Item} } ) {
        next COMPONENT if !$Component->{ValueMonth};
        next COMPONENT if !$Component->{ValueDay};
        $Result{ $Component->{ValueMonth} }->{ $Component->{ValueDay} } = $Component->{Content};
    }

    return \%Result;
}

sub ModifiedValueGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value EffectiveValue)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( ref $Param{EffectiveValue} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EffectiveValue mush be a hash reference!"
        );
        return;
    }

    my $Result = $Param{Value};

    my @Items;

    # Update Content
    MONTH:
    for my $Month ( sort { $a <=> $b } keys %{ $Param{EffectiveValue} } ) {

        if ( ref $Param{EffectiveValue}->{$Month} ne 'HASH' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EffectiveValue must be a HoH!"
            );
            next MONTH;
        }

        for my $Day ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Month} } ) {
            my $Item = {
                'ValueMonth'   => $Month,
                'ValueDay'     => $Day,
                'Content'      => $Param{EffectiveValue}->{$Month}->{$Day},
                'Translatable' => '1',
            };

            push @Items, $Item;
        }
    }

    $Result->[0]->{Item}->[0]->{Item} = \@Items;

    return $Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        DefaultID      =>  123,             # (required)
        EffectiveValue => '{
            '1' => {
                '1' => 'New Year\'s Day',
            },
            ...
        },
        DefaultValue   => 'Product 5',      # (optional)
        Class          => 'My class'        # (optional)
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'VacationDays',
                'Content' => '',
                'ValueRegex' => '',
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

    for my $Needed (qw(Name EffectiveValue)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
            return;
        }
    }

    $Param{Class} //= '';
    $Param{Class} .= " VacationDays ";
    $Param{DefaultValue} //= '';
    my $IDSuffix = $Param{IDSuffix} || '';

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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

    my $HTML = "<div class='Array VacationDaysArray'>\n";

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this setting.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    my @Days;
    for my $Item ( 1 .. 31 ) {
        push @Days, sprintf( "%02d", $Item );
    }

    my @Months;
    for my $Item ( 1 .. 12 ) {
        push @Months, sprintf( "%02d", $Item );
    }

    my $AddNewEntry     = $LanguageObject->Translate("Add new entry");
    my $RemoveThisEntry = $LanguageObject->Translate("Remove this entry");

    my $Index = 1;

    for my $Month ( sort { $a <=> $b } keys %{ $Param{EffectiveValue} } ) {

        for my $Day ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Month} } ) {
            my $Text = $Param{EffectiveValue}->{$Month}->{$Day};

            $HTML .= "<div class='ArrayItem'>\n";
            $HTML .= "<div class='SettingContent'>\n";

            # month
            $HTML .= $LayoutObject->BuildSelection(
                Data          => \@Months,
                Name          => $Param{Name},
                ID            => $Param{Name} . $IDSuffix . $Index . "Month",
                Class         => $Param{Class},
                Disabled      => $Param{RW} ? 0 : 1,
                SelectedValue => sprintf( "%02d", $Month ),
                Title         => $LanguageObject->Translate("Month"),
            );

            $HTML .= "<span>/</span>";

            # day
            $HTML .= $LayoutObject->BuildSelection(
                Data          => \@Days,
                Name          => $Param{Name},
                ID            => $Param{Name} . $IDSuffix . $Index . "Day",
                Class         => $Param{Class},
                Disabled      => $Param{RW} ? 0 : 1,
                SelectedValue => sprintf( "%02d", $Day ),
                Title         => $LanguageObject->Translate("Day"),
            );

            # description
            my $HTMLDescription = $LayoutObject->Ascii2Html(
                Text => $Text,
                Type => 'Normal',
            );
            $HTML .= "<input class=\"$Param{Class}\" type=\"text\" name=\"$Param{Name}\" "
                . "id=\"$Param{Name}$IDSuffix" . $Index . "Description\" value=\"$HTMLDescription\" "
                . "title=\"" . $LanguageObject->Translate("Description") . "\" ";

            if ( !$Param{RW} ) {
                $HTML .= "disabled='disabled' ";
            }

            $HTML .= " />\n";

            $HTML .= "</div>\n";    # SettingContent

            if ( $Param{RW} ) {
                $HTML .= "<button class='RemoveButton' type='button' "
                    . "title='$RemoveThisEntry' value='Remove this entry'>\n"
                    . "    <i class='fa fa-minus-circle'></i>\n"
                    . "    <span class='InvisibleText'>$RemoveThisEntry</span>\n"
                    . "</button>\n";
            }
            $HTML .= "</div>\n";    # ArrayItem
            $Index++;
        }
    }

    if ( $Param{RW} ) {
        $HTML .= "    <button data-suffix='$Index' class='AddArrayItem' "
            . "type='button' title='$AddNewEntry' value='Add new entry'>\n"
            . "        <i class='fa fa-plus-circle'></i>\n"
            . "        <span class='InvisibleText'>$AddNewEntry</span>\n"
            . "    </button>\n";
    }
    $HTML .= "</div>\n";            # Array

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

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $IDSuffix = $Param{IDSuffix} || '';
    my $Class    = $Param{Class}    || '';
    $Class .= " VacationDays ";

    my $Name = $Param{Name} . $IDSuffix;

    my @Days;
    for my $Item ( 1 .. 31 ) {
        push @Days, sprintf( "%02d", $Item );
    }

    my @Months;
    for my $Item ( 1 .. 12 ) {
        push @Months, sprintf( "%02d", $Item );
    }

    my $RemoveThisEntry = $Kernel::OM->Get('Kernel::Language')->Translate("Remove this entry");

    my $HTML = "";

    # month
    $HTML .= $LayoutObject->BuildSelection(
        Data          => \@Months,
        Name          => $Param{Name},
        ID            => $Param{Name} . $IDSuffix . "Month",
        Class         => $Class,
        SelectedValue => '01',
        Title         => $LanguageObject->Translate("Month"),
    );

    $HTML .= "<span>/</span>";

    # day
    $HTML .= $LayoutObject->BuildSelection(
        Data          => \@Days,
        Name          => $Param{Name},
        ID            => $Param{Name} . $IDSuffix . "Day",
        Class         => $Class,
        SelectedValue => '01',
        Title         => $LanguageObject->Translate("Day"),
    );

    # Description
    $HTML .= "<input class=\"$Class\" type=\"text\" name=\"$Param{Name}\" "
        . "id=\"$Param{Name}$IDSuffix" . "Description\" value=\"\" "
        . "title=\"" . $LanguageObject->Translate("Description") . "\" "
        . " />\n";

    return $HTML;
}

=head2 DefaultItemAdd()

Return structure of the DefaultItem in case it's not inside of Array or Hash.

    my $DefaultItem = $ValueTypeObject->DefaultItemAdd();

Returns:

    $DefaultItem = {
        Item => {
            Content => '',
        },
        ValueType => 'VacationDays',
    };

=cut

sub DefaultItemAdd {
    my ( $Self, %Param ) = @_;

    my %Result = (
        Item => {
            Content => '',
        },
        ValueType => 'VacationDays',
    );

    return \%Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
