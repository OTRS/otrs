# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
package Kernel::System::SysConfig::ValueType::Date;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Date - System configuration date value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Date');

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
        XMLContentParsed => {                           # (required)
            Value => [
                {
                    'Item' => [
                        {
                            'Content'   => '2016-01-01',
                            'ValueType' => 'Date',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => '2016-02-02',                 # (optional)
        UserID         => 1,                            # (required)
    );

Result:
    %Result = (
        EffectiveValue => '2016-02-03',                 # Note that EffectiveValue can be modified
        Success => 1,
        Error   => undef,
    );

=cut

sub SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(XMLContentParsed UserID)) {
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
        $Result{Error} = 'EffectiveValue for Date must be a scalar!';
        return %Result;
    }

    if ( $Param{EffectiveValue} !~ m{\d{4}-\d{2}-\d{2}} ) {
        $Result{Error} = "EffectiveValue for Date($Param{EffectiveValue}) must be in format YYYY-MM-DD!";
        return %Result;
    }

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Param{UserID},
    );

    my $OTRSTimeZone = $Kernel::OM->Get('Kernel::Config')->Get("OTRSTimeZone");
    my $DateTimeObject;

    if ( !$Preferences{UserTimeZone} || $Preferences{UserTimeZone} eq $OTRSTimeZone ) {
        $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => $OTRSTimeZone,
            },
        );

        my $SetSuccess = $DateTimeObject->Set( String => $Param{EffectiveValue} );

        if ( !$SetSuccess ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "EffectiveValue for Date($Param{EffectiveValue}) must be in format YYYY-MM-DD!",
            );
            return %Result;
        }

        $Result{EffectiveValue} = $Param{EffectiveValue};
    }
    else {
        $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => $Preferences{UserTimeZone},
            },
        );

        my $SetSuccess = $DateTimeObject->Set( String => $Param{EffectiveValue} );

        if ( !$SetSuccess ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "EffectiveValue for Date($Param{EffectiveValue}) must be in format YYYY-MM-DD!",
            );
            return %Result;
        }

        my $Success = $DateTimeObject->ToTimeZone(
            TimeZone => $OTRSTimeZone,
        );

        if ($Success) {
            $Result{EffectiveValue} = $DateTimeObject->ToString();
        }
        else {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "System was not able to calculate user Date in OTRSTimeZone!"
            );

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System was not able to calculate user Date in OTRSTimeZone!"
            );
        }
    }

    if ( !$DateTimeObject ) {
        $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
            "EffectiveValue for Date($Param{EffectiveValue}) must be in format YYYY-MM-DD!",
        );
        return %Result;
    }

    $Result{Success} = 1;

    return %Result;
}

=head2 SettingRender()

Extracts the effective value from a XML parsed setting.

    my $SettingHTML = $ValueTypeObject->SettingRender(
        Name           => 'SettingName',
        EffectiveValue => '2016-02-02',     # (optional)
        DefaultValue   => 'Product 5',      # (optional)
        Class          => 'My class'        # (optional)
        RW             => 1,                # (optional) Allow editing. Default 0.
        Item           => [                 # (optional) XML parsed item
            {
                'ValueType' => 'Date',
                'Content' => '2016-02-02',
                'ValueRegex' => '',
            },
        ],
        IsArray  => 1,                      # (optional) Item is part of the array
        IsHash   => 1,                      # (optional) Item is part of the hash
        IDSuffix => 1,                      # (optional) Suffix will be added to the element ID
        SkipEffectiveValueCheck => 1,       # (optional) If enabled, system will not perform effective value check.
                                            #            Default: 1.
        UserID                  => 1,       # (required) UserID
    );

Returns:

    $SettingHTML = '<div class "Field"...</div>';

=cut

sub SettingRender {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
            return;
        }
    }

    $Param{Class} //= '';
    $Param{Class} .= ' Date';
    $Param{DefaultValue} //= '';

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check if there is Datepicker before we add it.
    my $HasDatepicker = $LayoutObject->{HasDatepicker};

    my $Name = $Param{Name} . $IDSuffix;

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
            UserID => $Param{UserID},
        );
    }

    my $TimeZone = $Kernel::OM->Get('Kernel::Config')->Get("OTRSTimeZone");

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $EffectiveValue,
            TimeZone => $TimeZone,
        },
    );

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Param{UserID},
    );

    if ( $Preferences{UserTimeZone} ) {
        my $Success = $DateTimeObject->ToTimeZone(
            TimeZone => $Preferences{UserTimeZone},
        );

        $TimeZone = $Preferences{UserTimeZone};

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System was not able to calculate DateTime in user timezone!"
            );
        }
    }

    my @Date = split m{-|\s|:}, $DateTimeObject->ToString();

    my $HTML = "<div class='SettingContent'>\n";
    $HTML .= $LayoutObject->BuildDateSelection(
        Prefix           => $Name,
        $Name . "Class"  => $Param{Class},
        $Name . "Year"   => $Date[0],
        $Name . "Month"  => $Date[1],
        $Name . "Day"    => $Date[2],
        YearDiff         => 10,
        Format           => 'DateInputFormat',
        Validate         => 1,
        Disabled         => $Param{RW} ? 0 : 1,
        OverrideTimeZone => 1,
    );

    my $TimeZoneText = $Kernel::OM->Get('Kernel::Language')->Translate("Time Zone");
    $HTML .= "<span class='TimeZoneText'>$TimeZoneText: $TimeZone</span>\n";

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

    if ( $Param{IsAjax} && $LayoutObject->{_JSOnDocumentComplete} && $Param{RW} ) {
        for my $JS ( @{ $LayoutObject->{_JSOnDocumentComplete} } ) {
            $HTML .= "<script>$JS</script>";
        }
    }

    if ( $Param{IsAjax} ) {

       # Remove JS generated in BuildDateSelection() call (setting is disabled or it's already sent together with HTML).
       # It also prevents multiple Datepicker initializations (if there are several on the page).
        pop @{ $LayoutObject->{_JSOnDocumentComplete} };

        if ( !$HasDatepicker ) {
            my $VacationDays  = $LayoutObject->DatepickerGetVacationDays();
            my $TextDirection = $LanguageObject->{TextDirection} || '';

            my $JSONString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => {
                    VacationDays => $VacationDays,
                    IsRTL        => ( $TextDirection eq 'rtl' ) ? 1 : 0,
                },
            );

            $HTML .= "<script>
                Core.Config.Set('Datepicker', $JSONString);
            </script>";

            # If there are several DateTime settings, don't run this block again.
            $LayoutObject->{HasDatepicker} = 1;
        }
    }

    return $HTML;
}

=head2 AddItem()

Generate HTML for new array/hash item.

    my $HTML = $ValueTypeObject->AddItem(
        Name           => 'SettingName',    (required) Name
        DefaultItem    => {                 (optional) DefaultItem hash, if available
            Content => '2017-01-01',
            ValueType => 'Date',
        },
        IDSuffix       => '_Array1',        (optional) IDSuffix is needed for arrays and hashes.
    );

Returns:

    $HTML = '<select class="Validate_DateMonth  Date" id="SettingName_Array1Month" ...';

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
    $Class .= ' Date Entry';

    my $Name = $Param{Name} . $IDSuffix;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TimeZone     = $Kernel::OM->Get('Kernel::Config')->Get("OTRSTimeZone");

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Param{UserID},
    );

    my $DefaultValue;
    if ( $Param{DefaultItem} ) {
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String   => $Param{DefaultItem}->{Content},
                TimeZone => $TimeZone,
            },
        );

        if ( $Preferences{UserTimeZone} ) {
            my $Success = $DateTimeObject->ToTimeZone(
                TimeZone => $Preferences{UserTimeZone},
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "System was not able to calculate DateTime in user timezone!"
                );
            }
        }

        $DefaultValue = $DateTimeObject->ToString();
    }

    if ( $Preferences{UserTimeZone} ) {
        $TimeZone = $Preferences{UserTimeZone};
    }

    my $Result;

    if ($DefaultValue) {
        my @Date = split m{-|\s|:}, $DefaultValue;

        $Result = $LayoutObject->BuildDateSelection(
            Prefix           => $Name,
            $Name . "Year"   => $Date[0],
            $Name . "Month"  => $Date[1],
            $Name . "Day"    => $Date[2],
            $Name . "Class"  => $Class,
            YearDiff         => 10,
            Format           => 'DateInputFormat',
            Validate         => 1,
            OverrideTimeZone => 1,
        );
    }
    else {
        $Result = $LayoutObject->BuildDateSelection(
            Prefix           => $Name,
            $Name . "Class"  => $Class,
            YearDiff         => 10,
            Format           => 'DateInputFormat',
            Validate         => 1,
            OverrideTimeZone => 1,
        );
    }

    my $TimeZoneText = $Kernel::OM->Get('Kernel::Language')->Translate("Time Zone");
    $Result .= "<span class='TimeZoneText'>$TimeZoneText: $TimeZone</span>\n";

    for my $JS ( @{ $LayoutObject->{_JSOnDocumentComplete} } ) {
        $Result .= "<script>$JS</script>";
    }

    return $Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
