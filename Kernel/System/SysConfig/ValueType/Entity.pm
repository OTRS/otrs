# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::Entity;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SysConfig::EntityType',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Entity - System configuration entity value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Entity');

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
                            'Content'            => '3 - normal',
                            'ValueEntityType'    => 'Priority',
                            'ValueEntitySubType' => 'SomeSubType',
                            'ValueType'          => 'Entity',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => '2 - low',
    );

Result:
    $Result = (
        EffectiveValue => '2 - low',    # Note for Entity ValueTypes EffectiveValue is not changed.
        Success => 1,
        Error   => undef,
    );

=cut

sub SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    for (qw(XMLContentParsed)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my %Result = (
        Success => 0,
    );

    # Data should be scalar.
    if ( ref $Param{EffectiveValue} ) {
        $Result{Error} = 'EffectiveValue for Entity must be scalar!';
        return %Result;
    }

    my $Value = $Param{XMLContentParsed}->{Value};

    for my $Parameter ( sort keys %{ $Param{Parameters} } ) {
        if ( !defined $Value->[0]->{Item}->[0]->{$Parameter} ) {
            $Value->[0]->{Item}->[0]->{$Parameter} = $Param{Parameters}->{$Parameter};
        }
    }

    my $EntityType = $Value->[0]->{Item}->[0]->{ValueEntityType};

    if ( !$EntityType ) {
        $Result{Error} = 'ValueEntityType not provided!';
        return %Result;
    }

    my $EntitySubType = $Value->[0]->{Item}->[0]->{ValueEntitySubType} || '';

    my @ValidValues = $Self->EntityValueList(
        EntityType    => $EntityType,
        EntitySubType => $EntitySubType,
    );

    if ( !grep { $_ eq $Param{EffectiveValue} } @ValidValues ) {
        $Result{Error} = "Entity value is invalid($Param{EffectiveValue})!";
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $Param{EffectiveValue};

    return %Result;
}

=head2 EntityValueList()

Returns a list of valid values for provided EntityType.

    my $Result = $ValueTypeObject->EntityValueList(
        EntityType    => 'Priority',
        EntitySubType => 'SomeSubtype',     # optional e.g. the ObjectType for DynamicField entities
    );

Returns:

    $Result = [
        '1 very low',
        '2 low',
        '3 medium',
        '4 high',
        '5 very high',
    ];

=cut

sub EntityValueList {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(EntityType)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::System::SysConfig::ValueType::Entity::$Param{EntityType}",
    );

    return [] if !$Loaded;

    my $BackendObject = $Kernel::OM->Get(
        "Kernel::System::SysConfig::ValueType::Entity::$Param{EntityType}",
    );

    return $BackendObject->EntityValueList(%Param);
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
                'ValueType'          => 'Entity',
                'ValueEntityType'    => 'Priority',
                'ValueEntitySubType' => 'SomeSubType',
                'Content'            => '2 low',
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

    my $Value = $Param{Value};

    my $EntityType;
    my $EntitySubType;

    my $EffectiveValue = $Param{EffectiveValue};
    if (
        !defined $EffectiveValue
        && $Param{Item}->[0]->{Content}
        )
    {
        $EffectiveValue = $Param{Item}->[0]->{Content};
    }

    if (
        $Param{Item}
        && $Param{Item}->[0]->{ValueEntityType}
        )
    {
        $EntityType    = $Param{Item}->[0]->{ValueEntityType};
        $EntitySubType = $Param{Item}->[0]->{ValueEntitySubType} || '';
    }
    elsif (
        $Value->[0]->{Item}
        && $Value->[0]->{Item}->[0]->{ValueEntityType}
        )
    {
        $EntityType    = $Value->[0]->{Item}->[0]->{ValueEntityType};
        $EntitySubType = $Value->[0]->{Item}->[0]->{ValueEntitySubType} || '';
    }
    elsif ( $Value->[0]->{Array} ) {
        $EntityType    = $Value->[0]->{Array}->[0]->{DefaultItem}->[0]->{ValueEntityType};
        $EntitySubType = $Value->[0]->{Array}->[0]->{DefaultItem}->[0]->{ValueEntitySubType} || '';
    }
    elsif ( $Value->[0]->{Hash} ) {
        if (
            $Value->[0]->{Hash}->[0]->{DefaultItem}
            && $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueEntityType}
            )
        {

            # take ValueEntityType from DefaultItem
            $EntityType    = $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueEntityType};
            $EntitySubType = $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueEntitySubType} || '';
        }
        else {
            # check if there is definition for certain key
            ITEM:
            for my $Item ( @{ $Value->[0]->{Hash}->[0]->{Item} } ) {
                if ( $Item->{Key} eq $Param{Key} ) {
                    $EntityType    = $Item->{ValueEntityType}    || '';
                    $EntitySubType = $Item->{ValueEntitySubType} || '';
                    last ITEM;
                }
            }
        }
    }

    my @EntityValues = $Self->EntityValueList(
        EntityType    => $EntityType,
        EntitySubType => $EntitySubType,
    );

    # When displaying diff between current and old value, it can happen that value is missing
    #    since it was renamed, or removed. In this case, we need to add this "old" value also.
    if (
        $EffectiveValue
        && !grep { $_ eq $EffectiveValue } @EntityValues
        )
    {
        push @EntityValues, $EffectiveValue;
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
        Data          => \@EntityValues,
        Name          => $Param{Name},
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
            'Content'            => '3 normal',
            'ValueType'          => 'Entity',
            'ValueEntityType'    => 'Priority',
            'ValueEntitySubType' => 'SomeSubType',
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

    my @EntityValues = $Self->EntityValueList(
        EntityType    => $Param{DefaultItem}->{ValueEntityType},
        EntitySubType => $Param{DefaultItem}->{ValueEntitySubType} || '',
    );

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data          => \@EntityValues,
        Name          => $Param{Name},
        ID            => $Param{Name} . $Param{IDSuffix},
        SelectedValue => $Param{DefaultItem}->{Content},
        Title         => $Param{Name},
        OptionTitle   => 1,
        Class         => "$Param{Class} Modernize Entry",
    );

    return $Result;
}

=head2 EntityLookupFromWebRequest()

Gets the entity name from the web request

Called URL: index.pl?Action=AdminQueue;Subaction=Change;QueueID=1

    my $EntityName = $ValueTypeObject->EntityLookupFromWebRequest(
        EntityType    => 'Queue',
    );

Returns:

    $EntityName = 'Postmaster';

=cut

sub EntityLookupFromWebRequest {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(EntityType)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::System::SysConfig::ValueType::Entity::$Param{EntityType}",
    );

    return if !$Loaded;

    my $BackendObject = $Kernel::OM->Get(
        "Kernel::System::SysConfig::ValueType::Entity::$Param{EntityType}",
    );

    return if !$BackendObject->can('EntityLookupFromWebRequest');

    return $BackendObject->EntityLookupFromWebRequest();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
