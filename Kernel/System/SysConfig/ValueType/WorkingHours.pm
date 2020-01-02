# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::WorkingHours;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::WorkingHours - System configuration working-hours value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::WorkingHours');

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
                                    'Item' => [
                                        {
                                            'Content'   => '8',
                                            'ValueType' => 'Hour',
                                        },
                                    ],
                                    'ValueName' => 'Tue',
                                    'ValueType' => 'Day',
                                },
                            ],
                            'ValueType' => 'WorkingHours',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => {
            'Fri' => [
                '8',
                '9',
            ],
        },
    );

Result:
    %Result = (
        EffectiveValue => {         # Note for WorkingHours ValueTypes EffectiveValue is not changed.
            'Fri' => [
                '8',
                '9',
            ],
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
        $Result{Error} = 'EffectiveValue for WorkingHours must be a hash!';
        return %Result;
    }

    my @Days = ( 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' );

    DAY:
    for my $Day ( sort keys %{ $Param{EffectiveValue} } ) {
        if ( !grep { $_ eq $Day } @Days ) {
            $Result{Error} = "'$Day' must be Mon, Tue, Wed, Thu, Fri, Sat or Sun!";
            last DAY;
        }

        if ( ref $Param{EffectiveValue}->{$Day} ne 'ARRAY' ) {
            $Result{Error} = "'$Day' must be an array reference!";
            last DAY;
        }

        for my $Hour ( @{ $Param{EffectiveValue}->{$Day} } ) {

            if ( $Hour !~ m{^([0-9]|1[0-9]|2[0-3])$}msx ) {
                $Result{Error} = "'$Hour' must be number(0-23)!";
                last DAY;
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
        next COMPONENT if !$Component->{ValueName};
        next COMPONENT if !$Component->{ValueType};

        $Result{ $Component->{ValueName} } = [];

        next COMPONENT if !$Component->{Item};
        next COMPONENT if ref $Component->{Item} ne 'ARRAY';

        HOUR:
        for my $Hour ( @{ $Component->{Item} } ) {
            next HOUR if !$Hour->{Content};

            push @{ $Result{ $Component->{ValueName} } }, $Hour->{Content};
        }
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

    my @Days = ( 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' );

    my @Items;

    # Update Content
    DAY:
    for my $Day (@Days) {
        if ( !$Param{EffectiveValue}->{$Day} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Missing value for $Day!"
            );
            next DAY;
        }

        if ( ref $Param{EffectiveValue}->{$Day} ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EffectiveValue must be HoA!"
            );
            next DAY;
        }

        my @HourItems;

        for my $Hour ( @{ $Param{EffectiveValue}->{$Day} } ) {
            push @HourItems, {
                Content   => $Hour,
                ValueType => 'Hour',
            };
        }

        my $Item = {
            'ValueName' => $Day,
            'ValueType' => 'Day',
        };

        if ( scalar @HourItems ) {
            $Item->{Item} = \@HourItems;
        }
        else {
            $Item->{Content} = '';
        }

        push @Items, $Item;
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
    $Param{Class} .= " WorkingHoursContainer ";

    my $IDSuffix = $Param{IDSuffix} || '';

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

    my $HTML = "<div class='SettingContent'>\n";

    if ( !$EffectiveValueCheck{Success} ) {
        my $Message = $LanguageObject->Translate("Value is not correct! Please, consider updating this field.");

        $HTML .= $Param{IsValid} ? "<div class='BadEffectiveValue'>\n" : "<div>\n";
        $HTML .= "<p>* $Message</p>\n";
        $HTML .= "</div>\n";
    }

    for my $Day (qw(Mon Tue Wed Thu Fri Sat Sun)) {
        $HTML .= "<p class='WorkingHoursDayName'>" . $LanguageObject->Translate($Day) . "</p>\n";

        for my $Hour ( 0 .. 23 ) {
            my $Checked = 0;
            if ( grep { $_ == $Hour } @{ $EffectiveValue->{$Day} } ) {
                $Checked = 1;
            }

            my $Title = $Hour . ':00 - ' . $Hour . ':59';

            $HTML
                .= "<div title='"
                . $Title
                . "' class='WorkingHoursItem "
                . ( ($Checked) ? 'Checked' : '' )
                . "'><div><div>\n";
            $HTML .= "<label for='$Param{Name}$IDSuffix$Day$Hour'>$Hour</label>\n";
            $HTML .= "<input type='checkbox' value='$Hour' name='$Param{Name}' "
                . "id='$Param{Name}$IDSuffix$Day$Hour' data-day='$Day' class='WorkingHours' ";

            if ($Checked) {
                $HTML .= "checked='checked' ";
            }

            $HTML .= " />\n";

            $HTML .= "</div></div></div>\n";
        }

        $HTML .= "<div class='Clear'></div>\n";
    }
    $HTML .= "</div>\n";

    return $HTML;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
