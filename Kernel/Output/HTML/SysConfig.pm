# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::SysConfig;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );
use parent qw(Kernel::System::SysConfig::Base::Framework);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::SysConfig',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::Output::HTML::SysConfig - Manage HTML representation of SysConfig settings.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigHTMLObject = $Kernel::OM->Get('Kernel::Output::HTML::SysConfig');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 SettingRender()

Returns the specific HTML for the setting.

    my $HTMLStr = $SysConfigHTMLObject->SettingRender(
        Setting   => {
            Name             => 'Setting Name',
            XMLContentParsed => $XMLParsedToPerl,
            EffectiveValue   => "Product 6",        # or a complex structure
            DefaultValue     => "Product 5",        # or a complex structure
            IsAjax           => 1,                  # (optional) is ajax request. Default 0.
            # ...
        },
        RW     => 1,                                # (optional) Allow editing. Default 0.
        UserID => 1,                                # (required) UserID
    );

Returns:

    $HTMLStr = '<div class="Setting"><div class "Field"...</div></div>'        # or false in case of an error

=cut

sub SettingRender {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Setting UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !IsHashRefWithData( $Param{Setting} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting is invalid!",
        );
    }

    my %Setting = %{ $Param{Setting} };

    my $RW = $Param{RW};
    if ( $Setting{OverriddenFileName} ) {
        $RW = 0;
    }

    my $Result = $Self->_SettingRender(
        %Setting,
        Value                   => $Setting{XMLContentParsed}->{Value},
        RW                      => $RW,
        IsAjax                  => $Param{IsAjax},
        SkipEffectiveValueCheck => $Param{SkipEffectiveValueCheck},
        EffectiveValue          => $Setting{EffectiveValue},
        UserID                  => $Param{UserID},
    );

    my $HTML = <<"EOF";
                        <div class="Setting" data-change-time="$Param{Setting}->{ChangeTime}">
                            $Result
                        </div>
EOF

    if ($RW) {
        my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

        my $SaveText   = $LanguageObject->Translate('Save this setting');
        my $CancelText = $LanguageObject->Translate('Cancel editing and unlock this setting');
        my $ResetText  = $LanguageObject->Translate('Reset this setting to its default value.');

        $HTML .= "
                                <div class='SettingUpdateBox'>
                                    <button class='CallForAction Update' aria-controls='fieldset$Param{Setting}->{DefaultID}' type='button' value='$SaveText' title='$SaveText'>
                                        <span><i class='fa fa-check'></i></span>
                                    </button>
                                    <button class='CallForAction Cancel' aria-controls='fieldset$Param{Setting}->{DefaultID}' type='button' value='$CancelText' title='$CancelText'>
                                        <span><i class='fa fa-times'></i></span>
                                    </button>
                                </div>\n";
    }

    return $HTML;
}

=head2 SettingAddItem()

Returns response that is sent when user adds new array/hash item.

    my %Result = $SysConfigHTMLObject->SettingAddItem(
        SettingStructure  => [],         # (required) array that contains structure
                                         #  where a new item should be inserted (can be empty)
        Setting           => {           # (required) Setting hash (from SettingGet())
            'DefaultID' => '8905',
            'DefaultValue' => [ 'Item 1', 'Item 2' ],
            'Description' => 'Simple array item(Min 1, Max 3).',
            'Name' => 'TestArray',
            ...
        },
        Key               => 'HashKey',  # (optional) hash key
        IDSuffix          => '_Array3,   # (optional) suffix that will be added to all input/select fields
                                         #    (it is used in the JS on Update, during EffectiveValue calculation)
        Value             => [           # (optional) Perl structure
            {
                'Array' => [
                    'Item' => [
                        {
                        'Content' => 'Item 1',
                        },
                        ...
                    ],
                ],
            },
        ],
        AddSettingContent => 0,          # (optional) if enabled, result will be inside of div with class "SettingContent"
        UserID            => 1,          # (required) UserID
    );

Returns:

    %Result = (
        'Item' => '<div class=\'SettingContent\'>
<input type=\'text\' id=\'TestArray_Array4\'
        value=\'Default value\' name=\'TestArray\' class=\' Entry\'/></div>',
    );

    or

    %Result = (
        'Error' => 'Error description',
    );

=cut

sub SettingAddItem {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(SettingStructure Setting UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    $Param{Key} //= '';

    my @SettingStructure = @{ $Param{SettingStructure} };

    $Param{IDSuffix} //= '';
    my %Setting = %{ $Param{Setting} };

    my $DefaultItem;
    my %Result;

    my $Value = $Param{Value};

    if ( $Value->{Item} && $Value->{Item}->[0]->{ValueType} ) {
        my $ValueType = $Value->{Item}->[0]->{ValueType};

        my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        if ( !$Loaded ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Unable to load %s!",
                "Kernel::System::SysConfig::ValueType::$ValueType"
            );
            return %Result;
        }

        my $BackendObject = $Kernel::OM->Get(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        $DefaultItem = $BackendObject->DefaultItemAdd();

    }
    elsif ( $Value->{Item} && $Value->{Item}->[0]->{ValueType} eq 'VacationDaysOneTime' ) {
        $DefaultItem = {
            Item => {
                Content => '',
            },
            ValueType => 'VacationDaysOneTime',
        };
    }
    elsif ( $Value->{Array} && $Value->{Array}->[0]->{DefaultItem} ) {
        $DefaultItem = $Value->{Array}->[0]->{DefaultItem}->[0];
    }
    elsif ( $Value->{Hash} && $Value->{Hash}->[0]->{DefaultItem} ) {
        $DefaultItem = $Value->{Hash}->[0]->{DefaultItem}->[0];
    }

    if ( !$DefaultItem && $Value->{Array} ) {
        my $DedicatedDefaultItem = $Value->{Array}->[0];

        my @Structure = split m{_Array|_Hash\#\#\#}smx, $Param{IDSuffix};
        shift @Structure;

        my $Index = 0;

        STRUCTURE:
        for my $StructureItem (@SettingStructure) {
            if ( $StructureItem eq 'Hash' ) {
                my $HashKey = $Structure[$Index];

                my ($Item) = grep { $HashKey eq $_->{Key} } @{ $DedicatedDefaultItem->{Item} };
                last STRUCTURE if !$Item;

                $DedicatedDefaultItem = $Item->{Hash}->[0];
            }
            else {
                my $ArrayIndex = $Structure[$Index];
                last STRUCTURE if !$DedicatedDefaultItem->{Item}->{$ArrayIndex};

                $DedicatedDefaultItem = $DedicatedDefaultItem->{Item}->[$ArrayIndex]->{Array}->[0];
            }

            $Index++;
        }

        if ( $DedicatedDefaultItem->{DefaultItem} ) {
            $DefaultItem      = $DedicatedDefaultItem->{DefaultItem}->[0];
            @SettingStructure = ();
        }
        else {

            # Simple item
            $DefaultItem = {
                Item => {
                    Content => '',
                },
            };
        }
    }
    elsif ( !$DefaultItem && $Value->{Hash} ) {

        my $DedicatedDefaultItem = $Value->{Hash}->[0];

        my @Structure = split m{_Array|_Hash\#\#\#}smx, $Param{IDSuffix};
        shift @Structure;

        my $Index = 0;

        STRUCTURE:
        for my $StructureItem (@SettingStructure) {

            # NOTE: Array elements must contain same structure.
            if ( $StructureItem eq 'Hash' ) {

                # Check original XML structure and search for the element with the same key.
                # If found, system will use this structure.

                my $HashKey = $Structure[$Index];

                my ($Item) = grep { $HashKey eq $_->{Key} } @{ $DedicatedDefaultItem->{Item} };
                last STRUCTURE if !$Item;

                $DedicatedDefaultItem = $Item->{Hash}->[0];
            }

            $Index++;
        }

        if ( $DedicatedDefaultItem->{DefaultItem} ) {
            $DefaultItem      = $DedicatedDefaultItem->{DefaultItem}->[0];
            @SettingStructure = ();
        }
        else {

            # Simple item
            $DefaultItem = {
                Item => {
                    Content => '',
                },
            };
        }
    }

    for my $StructureItem ( reverse @SettingStructure ) {
        if ( $StructureItem eq 'Array' ) {
            $DefaultItem = $DefaultItem->{Array}->[0]->{DefaultItem}->[0];

            if ( !$DefaultItem ) {
                $DefaultItem = {
                    Item => {
                        Content => '',
                    },
                };
            }
        }
        else {
            if ( $DefaultItem->{Hash} && $DefaultItem->{Hash}->[0]->{Item} ) {
                ($DefaultItem) = grep { $_->{Key} eq $Param{Key} } @{ $DefaultItem->{Hash}->[0]->{Item} };
            }
            elsif ( $DefaultItem->{Hash}->[0]->{DefaultItem}->[0] ) {
                $DefaultItem = $DefaultItem->{Hash}->[0]->{DefaultItem}->[0];
            }

            if ( !$DefaultItem ) {
                $DefaultItem = {
                    Item => {
                        Content => '',
                    },
                };
            }
        }
    }

    # Default fallback
    if ( !$DefaultItem ) {
        $DefaultItem = {
            Item => {
                Content => '',
            },
        };
    }

    if ( $DefaultItem->{Item} || $DefaultItem->{ValueType} ) {
        my $ValueType = $DefaultItem->{ValueType} || 'String';

        my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        if ( !$Loaded ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Unable to load %s!",
                "Kernel::System::SysConfig::ValueType::$ValueType"
            );
            return %Result;
        }

        my $BackendObject = $Kernel::OM->Get(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        # Check if ValueType should add SettingContent.
        my $AddSettingContent = $BackendObject->AddSettingContent();

        if ($AddSettingContent) {
            $Result{Item} = "<div class='SettingContent'>\n";
        }

        $Result{Item} .= $BackendObject->AddItem(
            Name        => $Setting{Name},
            DefaultItem => $DefaultItem,
            IDSuffix    => $Param{IDSuffix},
            UserID      => $Param{UserID},
        );

        if ($AddSettingContent) {
            $Result{Item} .= '</div>';
        }
    }
    else {
        $Result{Item} //= '';

        if ( $DefaultItem->{Array} ) {
            pop @SettingStructure;
            $Param{SettingStructure} = \@SettingStructure;

            # new array item
            my %SubResult = $Self->SettingAddItem(
                %Param,
                Value             => $DefaultItem,
                IDSuffix          => $Param{IDSuffix} . '_Array1',
                AddSettingContent => 0,
                UserID            => $Param{UserID},
            );
            return %SubResult if $SubResult{Error};

            if ( $Param{AddSettingContent} ) {
                $Result{Item} .= "<div class=\"SettingContent\">\n";
            }
            $Result{Item} .= '<div class="Array">';
            $Result{Item} .= '<div class="ArrayItem">';
            $Result{Item} .= $SubResult{Item};

            $Result{Item} .= "</div>\n";
            $Result{Item} .= "</div>\n";
            if ( $Param{AddSettingContent} ) {
                $Result{Item} .= "</div>\n";
            }
        }
        elsif ( $DefaultItem->{Hash} ) {
            my $AddKey = $Kernel::OM->Get('Kernel::Language')->Translate("Add key");

            pop @SettingStructure;
            $Param{SettingStructure} = \@SettingStructure;

            # new hash item
            my %SubResult = $Self->SettingAddItem(
                %Param,
                Value             => $DefaultItem,
                IDSuffix          => $Param{IDSuffix} . "_Hash###$Param{Key}",
                AddSettingContent => 0,
                UserID            => $Param{UserID},
            );
            return %SubResult if $SubResult{Error};

            if ( $Param{AddSettingContent} ) {
                $Result{Item} .= "<div class=\"SettingContent\">\n";
            }

            $Result{Item} .= "
            <div class=\"Hash\">
                <div class=\"HashItem\">
                    <input type=\"text\" class=\"Key\" data-suffix=\"$Param{IDSuffix}_Hash###\">
                    <button class=\"AddKey\" value=\"$AddKey\" type=\"button\" title=\"$AddKey\">
                        <i class=\"fa fa-plus-circle\"></i>
                        <span class=\"InvisibleText\">$AddKey</span>
                    </button>
                </div>
            </div>";

            if ( $Param{AddSettingContent} ) {
                $Result{Item} .= "</div>\n";
            }
        }
    }

    return %Result;
}

=head1 PRIVATE INTERFACE

=head2 _SettingRender()

Recursive helper for SettingRender().

    my $HTMLStr = $SysConfigObject->_SettingRender(
        Name             => 'Setting Name',
        Value            => $XMLParsedToPerlValue,  # (required)
        EffectiveValue   => "Product 6",            # (required) or a complex structure
        DefaultValue     => "Product 5",            # (optional) or a complex structure
        ValueType        => "String",               # (optional)
        IsAjax           => 1,                      # (optional) Default 0.
        # ...
        RW => 1,                                    # (optional) Allow editing. Default 0.
        IsArray => 1,                               # (optional) Item is part of the array
        IsHash  => 1,                               # (optional) Item is part of the hash
        Key     => 'Key',                           # (optional) Hash key (if available)
        SkipEffectiveValueCheck => 1,               # (optional) If enabled, system will not perform effective value check.
                                                    #            Default: 1.
        UserID => 1,                                # (required) UserID
    );

Returns:

    $HTMLStr = '<div class "Field"...</div>'        # or false in case of an error

=cut

sub _SettingRender {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value EffectiveValue UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }
    $Param{IDSuffix}       //= '';
    $Param{EffectiveValue} //= '';

    my $Result = $Param{Result} || '';
    my %Objects;
    if ( $Param{Objects} ) {
        %Objects = %{ $Param{Objects} };
    }

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # Make sure structure is correct.
    return $Result if !IsArrayRefWithData( $Param{Value} );
    return $Result if !IsHashRefWithData( $Param{Value}->[0] );

    if ( $Param{Value}->[0]->{Item} ) {

        # Make sure structure is correct.
        return $Result if !IsArrayRefWithData( $Param{Value}->[0]->{Item} );
        return $Result if !IsHashRefWithData( $Param{Value}->[0]->{Item}->[0] );

        # Set default ValueType.
        my $ValueType = "String";

        if ( $Param{Value}->[0]->{Item}->[0]->{ValueType} ) {
            $ValueType = $Param{Value}->[0]->{Item}->[0]->{ValueType};
        }

        if ( !$Objects{$ValueType} ) {

            # Load required class.
            my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            return $Result if !$Loaded;

            # Create object instance.
            $Objects{$ValueType} = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );
        }

        $Result = $Objects{$ValueType}->SettingRender(
            %Param,
            Item => $Param{Value}->[0]->{Item},
        );
    }

    elsif ( $Param{Value}->[0]->{Hash} ) {

        # Make sure structure is correct.
        return {} if !IsArrayRefWithData( $Param{Value}->[0]->{Hash} );
        return {} if ref $Param{Value}->[0]->{Hash}->[0] ne 'HASH';

        if ( !$Param{Value}->[0]->{Hash}->[0]->{Item} ) {
            $Param{Value}->[0]->{Hash}->[0]->{Item} = [];
            delete $Param{Value}->[0]->{Content};
        }

        return {} if ref $Param{Value}->[0]->{Hash}->[0]->{Item} ne 'ARRAY';

        my $ModifiedXMLParsed = $Self->SettingModifiedXMLContentParsedGet(
            ModifiedSetting => {
                EffectiveValue => $Param{EffectiveValue},
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => $Param{Value},
                },
            },
        );
        my @Items;

        my $RemoveThisEntry = $LanguageObject->Translate("Remove this entry");
        $Result .= "<div class='Hash' ";
        if ( $ModifiedXMLParsed->[0]->{Hash}->[0]->{MinItems} ) {
            $Result .= "data-min-items='" . $ModifiedXMLParsed->[0]->{Hash}->[0]->{MinItems} . "' ";
        }

        if ( $ModifiedXMLParsed->[0]->{Hash}->[0]->{MaxItems} ) {
            $Result .= "data-max-items='" . $ModifiedXMLParsed->[0]->{Hash}->[0]->{MaxItems} . "' ";
        }
        $Result .= ">";

        my $Index = 0;

        ITEM:
        for my $Item ( @{ $ModifiedXMLParsed->[0]->{Hash}->[0]->{Item} } ) {
            next ITEM if !IsHashRefWithData($Item);

            $Index++;

            # Add attributes that are defined in the XML file to the corresponding ModifiedXMLParsed items.
            if ( $Param{Value}->[0]->{Hash}->[0]->{Item} ) {

                my ($HashItem) = grep { defined $_->{Key} && $_->{Key} eq $Item->{Key} }
                    @{ $Param{Value}->[0]->{Hash}->[0]->{Item} };

                if ($HashItem) {

                    ATTRIBUTE:
                    for my $Attribute ( sort keys %{$HashItem} ) {

                        # Do not override core attributes.
                        next ATTRIBUTE if grep { $Attribute eq $_ } qw(Content DefaultItem Hash Array Key SelectedID);

                        if ( $Attribute eq 'Item' ) {

                            if (
                                !$HashItem->{Item}->[0]->{ValueType}
                                || $HashItem->{Item}->[0]->{ValueType} ne 'Option'
                                )
                            {
                                # Skip Items that contain Options (they can't be modified).
                                next ATTRIBUTE;
                            }
                        }

                        $Item->{$Attribute} = $HashItem->{$Attribute};
                    }
                }
            }

            my $DefaultValueType;

            if ( $Param{Value}->[0]->{Hash}->[0]->{DefaultItem} ) {
                $DefaultValueType = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueType};
            }

            if ( $Item->{Hash} || $Item->{Array} ) {

                # Complex structure - HoA or HoH

                my $Key = $Item->{Hash} ? 'Hash' : 'Array';

                $Result .= "<div class='HashItem'>\n";

                # Gather the value type from the default item, from a previous call
                #   or string as default.
                my $ValueType = $DefaultValueType
                    || $Param{ValueType}
                    || 'String';

                my $HTMLKey = '';

                # Check if complex structure has a key element.
                if ( defined $Item->{Key} ) {
                    $HTMLKey = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Ascii2Html(
                        Text => $Item->{Key},
                        Type => 'Normal',
                    );
                    $Result .= "
                        <input class=\"Key\" type=\"text\" name=\"$Param{Name}Key\" value=\"$HTMLKey\"/>";
                }
                $Result .= "<div class=\"SettingContent\">\n";

                my $IDSuffix = $Param{IDSuffix} . "_Hash###$HTMLKey";

                if ( $Param{Value}->[0]->{Hash}->[0]->{DefaultItem} ) {
                    if ( $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Array} ) {
                        my $DefaultItem
                            = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Array}->[0]->{DefaultItem};

                        if ($DefaultItem) {

                            # Append default item parameters.
                            $Item->{Array}->[0] = {
                                %{ $Item->{Array}->[0] },
                                DefaultItem => $DefaultItem,
                            };
                        }
                    }
                    elsif ( $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Hash} ) {
                        my $DefaultItem
                            = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Hash}->[0]->{DefaultItem};

                        if ($DefaultItem) {

                            # Append default item parameters.
                            $Item->{Hash}->[0] = {
                                %{ $Item->{Hash}->[0] },
                                DefaultItem => $DefaultItem,
                            };
                        }
                    }
                }

                # Start recursion.
                $Result .= $Self->_SettingRender(
                    %Param,
                    EffectiveValue => $Param{EffectiveValue}->{ $Item->{Key} },
                    Value          => [$Item],
                    Objects        => \%Objects,
                    ValueType      => $ValueType,
                    IDSuffix       => $IDSuffix,
                );
                $Result .= "</div>\n";

                if ( $Param{RW} ) {
                    $Result
                        .= "<button value=\"$RemoveThisEntry\" title=\"$RemoveThisEntry\" type=\"button\" class=\"RemoveButton\">
        <i class=\"fa fa-minus-circle\"></i>
        <span class=\"InvisibleText\">$RemoveThisEntry</span>
    </button>";
                }

                $Result .= "</div>\n";
            }
            else {
                my $HashItem = "<div class='HashItem'>\n";

                # Gather the Value type from parent, from item, from previous call
                #   or use string as default.
                my $ValueType = $Item->{ValueType}
                    || $DefaultValueType
                    || $Param{ValueType}
                    || 'String';

                # Output key element.
                $HashItem .= "<input class=\"Key\" type=\"text\" name=\"$Param{Name}Key\" value=\"$Item->{Key}\" ";
                if ( !$Param{RW} ) {
                    $HashItem .= "disabled=\"disabled\" ";
                }

                $HashItem .= "readonly=\"readonly\" ";
                $HashItem .= "/>\n";

                if ( !$Objects{$ValueType} ) {

                    # Make sure the ValueType backed is present and is syntactically correct.
                    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                        "Kernel::System::SysConfig::ValueType::$ValueType",
                    );

                    return $Result if !$Loaded;

                    # Create object instance
                    $Objects{$ValueType} = $Kernel::OM->Get(
                        "Kernel::System::SysConfig::ValueType::$ValueType",
                    );
                }

                my $IDSuffix = $Param{IDSuffix} || '';
                $IDSuffix .= "_Hash###$Item->{Key}";

                my $ValueAttribute = $Objects{$ValueType}->ValueAttributeGet();

                # Output item.
                $HashItem .= $Objects{$ValueType}->SettingRender(
                    %Param,
                    Name           => $Param{Name},
                    EffectiveValue => $Item->{$ValueAttribute} // '',
                    Class          => 'Content',
                    Item           => [$Item],
                    IsAjax         => $Param{IsAjax},
                    IsHash         => 1,
                    Key            => $Item->{Key},
                    IDSuffix       => $IDSuffix,
                );

                if ( $Param{RW} ) {

                    # Check if item is removable
                    if ( $ValueType eq ( $DefaultValueType || 'String' ) ) {

                        $HashItem .= "
    <button value=\"$RemoveThisEntry\" title=\"$RemoveThisEntry\" type=\"button\" class=\"RemoveButton\">
        <i class=\"fa fa-minus-circle\"></i>
        <span class=\"InvisibleText\">$RemoveThisEntry</span>
    </button>";
                    }
                }
                $HashItem .= "</div>\n";

                $Result .= $HashItem;
            }
        }

        my $KeyTranslation     = $LanguageObject->Translate('Key');
        my $ContentTranslation = $LanguageObject->Translate('Content');

        my $AddNewEntry = $LanguageObject->Translate("Add new entry");
        $Result .= "
    <button data-suffix=\"$Param{IDSuffix}_Hash###\" value=\"$AddNewEntry\" title=\"$AddNewEntry\" type=\"button\" class=\"AddHashKey";
        if ( !$Param{RW} ) {
            $Result .= " Hidden";
        }
        $Result .= "\">
        <i class=\"fa fa-plus-circle\"></i>
        <span class=\"InvisibleText\">$AddNewEntry</span>
    </button>";

        $Result .= "</div>";
    }

    elsif ( $Param{Value}->[0]->{Array} ) {

        # Make sure structure is correct.
        return [] if !IsArrayRefWithData( $Param{Value}->[0]->{Array} );
        return [] if ref $Param{Value}->[0]->{Array}->[0] ne 'HASH';

        if ( !$Param{Value}->[0]->{Array}->[0]->{Item} ) {
            $Param{Value}->[0]->{Array}->[0]->{Item} = [];
        }

        return [] if ref $Param{Value}->[0]->{Array}->[0]->{Item} ne 'ARRAY';

        my $ModifiedXMLParsed = $Self->SettingModifiedXMLContentParsedGet(
            ModifiedSetting => {
                EffectiveValue => $Param{EffectiveValue},
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => $Param{Value},
                },
            },
        );

        my @Items;

        my $RemoveThisEntry = $LanguageObject->Translate("Remove this entry");

        $Result .= "<div class='Array' ";
        if ( $ModifiedXMLParsed->[0]->{Array}->[0]->{MinItems} ) {
            $Result .= "data-min-items='" . $ModifiedXMLParsed->[0]->{Array}->[0]->{MinItems} . "' ";
        }

        if ( $ModifiedXMLParsed->[0]->{Array}->[0]->{MaxItems} ) {
            $Result .= "data-max-items='" . $ModifiedXMLParsed->[0]->{Array}->[0]->{MaxItems} . "' ";
        }
        $Result .= ">";

        my $Index = 0;

        ITEM:
        for my $Item ( @{ $ModifiedXMLParsed->[0]->{Array}->[0]->{Item} } ) {
            next ITEM if !IsHashRefWithData($Item);

            $Index++;

            # check attributes
            if ( $Param{Value}->[0]->{Array}->[0]->{Item} ) {

                ATTRIBUTE:
                for my $Attribute ( sort keys %{ $Param{Value}->[0]->{Array}->[0]->{Item}->[0] } ) {
                    next ATTRIBUTE if grep { $Attribute eq $_ } qw(Content Item DefaultItem Hash Array);

                    $Item->{$Attribute} = $Param{Value}->[0]->{Array}->[0]->{Item}->[0]->{$Attribute};
                }
            }

            my $DefaultValueType;
            if ( $Param{Value}->[0]->{Array}->[0]->{DefaultItem} ) {
                $DefaultValueType = $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{ValueType};
            }

            if ( $Item->{Hash} || $Item->{Array} ) {

                # Complex structure - AoA or AoH

                my $Key = $Item->{Hash} ? 'Hash' : 'Array';

                $Result .= "<div class='ArrayItem'>";

                my $IDSuffix = $Param{IDSuffix} || '';
                $IDSuffix .= "_Array$Index";

                if ( $Param{Value}->[0]->{Array}->[0]->{DefaultItem} ) {

                    if ( $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{Array} ) {
                        my $DefaultItem
                            = $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{Array}->[0]->{DefaultItem};

                        if ($DefaultItem) {

                            # Append default item parameters.
                            $Item->{Array}->[0] = {
                                %{ $Item->{Array}->[0] },
                                DefaultItem => $DefaultItem,
                            };
                        }
                    }
                    elsif ( $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{Hash} ) {
                        my $DefaultItem
                            = $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{Hash}->[0]->{DefaultItem};

                        if ($DefaultItem) {

                            # Append default item parameters.
                            $Item->{Hash}->[0] = {
                                %{ $Item->{Hash}->[0] },
                                DefaultItem => $DefaultItem,
                            };
                        }
                    }
                }

                # Start recursion.
                $Result .= $Self->_SettingRender(
                    %Param,
                    Value          => [$Item],
                    EffectiveValue => $Param{EffectiveValue}->[ $Index - 1 ],
                    IDSuffix       => $IDSuffix,
                );
                if ( $Param{RW} ) {
                    $Result .= "
    <button value=\"$RemoveThisEntry\" title=\"$RemoveThisEntry\" type=\"button\" class=\"RemoveButton\">
        <i class=\"fa fa-minus-circle\"></i>
        <span class=\"InvisibleText\">$RemoveThisEntry</span>
    </button>";
                }
                $Result .= "</div>";
            }
            else {

                # Gather the value type from the default item, from the item, from a previous call
                #   or string as default.
                my $ValueType = $DefaultValueType
                    || $Item->{ValueType}
                    || $Param{ValueType}
                    || 'String';

                if ( !$Objects{$ValueType} ) {

                    # Make sure the ValueType backed is present and is syntactically correct.
                    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                        "Kernel::System::SysConfig::ValueType::$ValueType",
                    );

                    return $Result if !$Loaded;

                    # Create object instance
                    $Objects{$ValueType} = $Kernel::OM->Get(
                        "Kernel::System::SysConfig::ValueType::$ValueType",
                    );
                }

                my $RenderItem;

                if ( $Item->{Content} ) {
                    $RenderItem = [$Item];
                }
                else {
                    $RenderItem = $Item->{Item};
                }

                my $ValueAttribute = $Objects{$ValueType}->ValueAttributeGet();
                my $EffectiveValue = $RenderItem->[0]->{$ValueAttribute} || '';

                my $IDSuffix = $Param{IDSuffix} || '';
                $IDSuffix .= "_Array$Index";

                my $ArrayItem = "<div class='ArrayItem'>";
                $ArrayItem .= $Objects{$ValueType}->SettingRender(
                    %Param,
                    Name           => $Param{Name},
                    EffectiveValue => $EffectiveValue || '',
                    Class          => 'Entry',
                    Item           => $RenderItem,
                    IsAjax         => $Param{IsAjax},
                    IsArray        => 1,
                    IDSuffix       => $IDSuffix,
                );

                if ( $Param{RW} ) {

                    $ArrayItem .= "
    <button value=\"$RemoveThisEntry\" title=\"$RemoveThisEntry\" type=\"button\" class=\"RemoveButton\">
        <i class=\"fa fa-minus-circle\"></i>
        <span class=\"InvisibleText\">$RemoveThisEntry</span>
    </button>";
                }

                $ArrayItem .= "</div>\n";

                $Result .= $ArrayItem;
            }
        }

        my $Size = @{ $ModifiedXMLParsed->[0]->{Array}->[0]->{Item} } + 1;
        $Param{IDSuffix} //= '';

        my $AddNewEntry = $LanguageObject->Translate("Add new entry");

        $Result .= "
    <button value=\"$AddNewEntry\" title=\"$AddNewEntry\" type=\"button\" data-suffix=\"$Param{IDSuffix}_Array$Size\" class=\"AddArrayItem";
        if ( !$Param{RW} ) {
            $Result .= " Hidden";
        }
        $Result .= "\">
        <i class=\"fa fa-plus-circle\"></i>
        <span class=\"InvisibleText\">$AddNewEntry</span>
    </button>\n";

        $Result .= "</div>";
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
