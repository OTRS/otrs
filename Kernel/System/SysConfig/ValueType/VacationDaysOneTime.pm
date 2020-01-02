# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

package Kernel::System::SysConfig::ValueType::VacationDaysOneTime;

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

Kernel::System::SysConfig::ValueType::VacationDaysOneTime - System configuration vacation-days-one-time value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::VacationDaysOneTime');

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
                                    'ValueYear'    => '2004',
                                },
                            ],
                            'ValueType' => 'VacationDaysOneTime',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => {
            '2014' => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
            },
            '2016' => {
                '2' => {
                    '2' => 'Test',
                },
            },
        },
    );

Result:
    %Result = (
        EffectiveValue => {                     # Note for VacationDaysOneTime ValueTypes EffectiveValue is not changed.
            '2014' => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
            },
            '2016' => {
                '2' => {
                    '2' => 'Test',
                },
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
        $Result{Error} = 'EffectiveValue for VacationDaysOneTime must be a hash!';
        return %Result;
    }

    YEAR:
    for my $Year ( sort keys %{ $Param{EffectiveValue} } ) {
        if ( $Year !~ m{^\d{4}$}gsmx ) {
            $Result{Error} = "'$Year' must be a year number(1000-9999)!";
            last YEAR;
        }

        if ( !IsHashRefWithData( $Param{EffectiveValue}->{$Year} ) ) {
            $Result{Error} = "'$Year' must be a hash reference!";
            return %Result;
        }

        for my $Month ( sort keys %{ $Param{EffectiveValue}->{$Year} } ) {
            if ( $Month !~ m{^([1-9]|1[0-2])$}gsmx ) {
                $Result{Error} = "'$Month' must be a month number(1..12)!";
                last YEAR;
            }

            if ( !IsHashRefWithData( $Param{EffectiveValue}->{$Year}->{$Month} ) ) {
                $Result{Error} = "'$Month' must be a hash reference!";
                last YEAR;
            }

            for my $Day ( sort keys %{ $Param{EffectiveValue}->{$Year}->{$Month} } ) {
                if ( $Day !~ m{^([1-9]|[12][0-9]|3[01])$}gsmx ) {
                    $Result{Error} = "'$Day' must be a day number(1..31)!";
                    last YEAR;
                }

                if (
                    ref $Param{EffectiveValue}->{$Year}->{$Month}->{$Day}
                    || !$Param{EffectiveValue}->{$Year}->{$Month}->{$Day}
                    )
                {
                    $Result{Error} = "Vacation description must be a string!";
                    last YEAR;
                }
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
        next COMPONENT if !$Component->{ValueYear};
        next COMPONENT if !$Component->{ValueMonth};
        next COMPONENT if !$Component->{ValueDay};
        $Result{ $Component->{ValueYear} }->{ $Component->{ValueMonth} }->{ $Component->{ValueDay} }
            = $Component->{Content};
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
    YEAR:
    for my $Year ( sort { $a <=> $b } keys %{ $Param{EffectiveValue} } ) {
        if ( ref $Param{EffectiveValue}->{$Year} ne 'HASH' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EffectiveValue must be a HoH!"
            );
            next YEAR;
        }

        MONTH:
        for my $Month ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Year} } ) {

            if ( ref $Param{EffectiveValue}->{$Year}->{$Month} ne 'HASH' ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "EffectiveValue must be a HoHoH!"
                );
                next MONTH;
            }

            for my $Day ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Year}->{$Month} } ) {
                my $Item = {
                    'ValueYear'  => $Year,
                    'ValueMonth' => $Month,
                    'ValueDay'   => $Day,
                    'Content'    => $Param{EffectiveValue}->{$Year}->{$Month}->{$Day},
                };

                push @Items, $Item;
            }
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
            '2016' => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
            },
            ...
        },
        DefaultValue   => 'Product 5',      # (optional)
        Class          => 'My class'        # (optional)
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'VacationDaysOneTime',
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
    $Param{Class} .= " VacationDaysOneTime ";
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

    my $HTML = "<div class='Array VacationDaysOneTimeArray'>\n";

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

    my $DateTime = $Kernel::OM->Create('Kernel::System::DateTime')->Get();

    for my $Year ( sort { $a <=> $b } keys %{ $Param{EffectiveValue} } ) {
        for my $Month ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Year} } ) {

            for my $Day ( sort { $a <=> $b } keys %{ $Param{EffectiveValue}->{$Year}->{$Month} } ) {
                my $Text = $Param{EffectiveValue}->{$Year}->{$Month}->{$Day};

                $HTML .= "<div class='ArrayItem'>\n";
                $HTML .= "<div class='SettingContent'>\n";

                my $YearPeriodFuture = 10;
                my $YearPeriodPast   = 10;

                if ( $DateTime->{Year} - 10 > $Year ) {
                    $YearPeriodPast = $DateTime->{Year} - $Year;
                }
                elsif ( $DateTime->{Year} + 10 < $Year ) {
                    $YearPeriodFuture = $Year - $DateTime->{Year};
                }

                my $Prefix = $Param{Name} . $IDSuffix . $Index;

                $HTML .= $LayoutObject->BuildDateSelection(
                    Prefix            => $Prefix,
                    $Prefix . "Year"  => $Year,
                    $Prefix . "Month" => $Month,
                    $Prefix . "Day"   => $Day,
                    $Prefix . "Class" => $Param{Class},
                    YearPeriodFuture  => $YearPeriodFuture,
                    YearPeriodPast    => $YearPeriodPast,
                    Format            => 'DateInputFormat',
                    Validate          => 1,
                    Disabled          => $Param{RW} ? 0 : 1,
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
    }

    if ( $Param{RW} ) {
        $HTML .= "    <button data-suffix='$Index' class='AddArrayItem' "
            . "type='button' title='$AddNewEntry' value='Add new entry'>\n"
            . "        <i class='fa fa-plus-circle'></i>\n"
            . "        <span class='InvisibleText'>$AddNewEntry</span>\n"
            . "    </button>\n";
    }
    $HTML .= "</div>\n";    # Array

    if ( $Param{IsAjax} && $LayoutObject->{_JSOnDocumentComplete} && $Param{RW} ) {
        for my $JS ( @{ $LayoutObject->{_JSOnDocumentComplete} } ) {
            $HTML .= "<script>$JS</script>";
        }
    }

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
    $Class .= " VacationDaysOneTime ";

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

    my $DateTime = $Kernel::OM->Create('Kernel::System::DateTime')->Get();

    my $HTML = "";

    my $Prefix = $Param{Name} . $IDSuffix;

    $HTML .= $LayoutObject->BuildDateSelection(
        Prefix            => $Prefix,
        $Prefix . "Year"  => $DateTime->{Year},
        $Prefix . "Month" => $DateTime->{Month},
        $Prefix . "Day"   => $DateTime->{Day},
        $Prefix . "Class" => $Class,
        YearPeriodFuture  => 10,
        YearPeriodPast    => 10,
        Format            => 'DateInputFormat',
        Validate          => 1,
    );

    # Description
    $HTML .= "<input class=\"$Class\" type=\"text\" name=\"$Param{Name}\" "
        . "id=\"$Param{Name}$IDSuffix" . "Description\" value=\"\" "
        . "title=\"" . $LanguageObject->Translate("Description") . "\" "
        . " />\n";

    for my $JS ( @{ $LayoutObject->{_JSOnDocumentComplete} } ) {
        $HTML .= "<script>$JS</script>";
    }

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
        ValueType => 'VacationDaysOneTime',
    };

=cut

sub DefaultItemAdd {
    my ( $Self, %Param ) = @_;

    my %Result = (
        Item => {
            Content => '',
        },
        ValueType => 'VacationDaysOneTime',
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
