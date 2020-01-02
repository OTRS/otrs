# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::Base::Framework;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
);

=head1 NAME

Kernel::System::SysConfig::Base::Framework - Base class for system configuration.

=head1 PUBLIC INTERFACE

=head2 SettingModifiedXMLContentParsedGet()

Returns perl structure for modified setting.

    my $Result = $SysConfigObject->SettingModifiedXMLContentParsedGet(
        ModifiedSetting => {
            EffectiveValue => 'Scalar value updated'
        },
        DefaultSetting => {
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
        },
    );

Returns:

    $Result = [
        {
            'Item' => [
                {
                    'Content' => "Scalar value updated",
                },
            ],
        },
    ];

=cut

sub SettingModifiedXMLContentParsedGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DefaultSetting ModifiedSetting)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Result = $Param{DefaultSetting}->{XMLContentParsed};

    $Result = $Self->_ModifiedValueCalculate(
        Value          => $Result->{Value},
        EffectiveValue => $Param{ModifiedSetting}->{EffectiveValue},
    );

    return $Result;
}

=head1 PRIVATE INTERFACE

=head2 _ModifiedValueCalculate()

Recursive helper for SettingModifiedXMLContentParsedGet().

    my $Result = $SysConfigObject->_ModifiedValueCalculate(
        'EffectiveValue' => 'Scalar value updated',         # (optional) new effective value
        'Value' => [                                        # (required) the XMLContentParsed value from Defaults
            {
                'Item' => [
                    {
                        'Content' => 'Scalar value',
                    },
                ],
            },
        ],
    );

Returns:

    $Result =  [
        {
            'Item' => [
                {
                    'Content' => 'Scalar value updated'
                },
            ],
        },
    ];

=cut

sub _ModifiedValueCalculate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my %Objects;
    if ( $Param{Objects} ) {
        %Objects = %{ $Param{Objects} };
    }

    my @SkipParameters = (
        'Hash',
        'Array',
        'Item',
        'Content',
        'Key',
    );

    my $Result;

    my $ValueType;

    # Check if additional parameters are provided.
    if ( IsHashRefWithData( $Param{Parameters} ) && $Param{Value}->[0]->{Item} ) {
        for my $Parameter ( sort keys %{ $Param{Parameters} } ) {
            $Result->[0]->{Item}->[0]->{$Parameter} = $Param{Parameters}->{$Parameter};
        }
    }

    if (
        $Param{Value}->[0]->{Item}
        && $Param{Value}->[0]->{Item}->[0]->{ValueType}
        )
    {
        $ValueType = $Param{Value}->[0]->{Item}->[0]->{ValueType};
    }
    if ( $Param{ValueType} ) {
        $ValueType = $Param{ValueType};
    }

    if ($ValueType) {

        if ( !$Objects{$ValueType} ) {

            # Make sure the ValueType backed is present and is syntactically correct.
            my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            return $Result if !$Loaded;

            # Create object instance.
            $Objects{$ValueType} = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );
        }

        $Result = $Objects{$ValueType}->ModifiedValueGet(%Param);

        # Get all additional parameters (defined as attributes in XML).
        if ( IsHashRefWithData( $Param{Value}->[0]->{Item}->[0] ) ) {
            PARAMETER:
            for my $Parameter ( sort keys %{ $Param{Value}->[0]->{Item}->[0] } ) {
                next PARAMETER if grep { $_ eq $Parameter } @SkipParameters;

                # Skip already defined values.
                next PARAMETER if $Result->[0]->{Item}->[0]->{$Parameter};

                $Result->[0]->{Item}->[0]->{$Parameter} =
                    $Param{Value}->[0]->{Item}->[0]->{$Parameter};
            }
        }
    }
    elsif ( ref $Param{EffectiveValue} eq 'ARRAY' ) {

        # Create basic structure.
        $Result = [
            {
                'Array' => [
                    {
                        'Item' => [],
                    },
                ],
            },
        ];

        my $DefaultItem = $Param{Value}->[0]->{Array}->[0]->{DefaultItem};

        if ( $Param{Value}->[0]->{Array}->[0]->{MinItems} ) {
            $Result->[0]->{Array}->[0]->{MinItems} = $Param{Value}->[0]->{Array}->[0]->{MinItems};
        }

        if ( $Param{Value}->[0]->{Array}->[0]->{MaxItems} ) {
            $Result->[0]->{Array}->[0]->{MaxItems} = $Param{Value}->[0]->{Array}->[0]->{MaxItems};
        }

        my %Attributes;

        if (
            $DefaultItem
            && ref $DefaultItem eq 'ARRAY'
            && scalar @{$DefaultItem}
            && ref $DefaultItem->[0] eq 'HASH'
            )
        {
            # Get additional attributes
            ATTRIBUTE:
            for my $Attribute ( sort keys %{ $DefaultItem->[0] } ) {
                next ATTRIBUTE if grep { $Attribute eq $_ } qw(Hash Array Item Content);

                $Attributes{$Attribute} = $DefaultItem->[0]->{$Attribute};
            }
        }

        for my $Index ( 0 .. scalar @{ $Param{EffectiveValue} } - 1 ) {

            if (
                $DefaultItem
                && $DefaultItem->[0]->{ValueType}
                && $Param{Value}->[0]->{Array}->[0]->{Item}
                )
            {

                # It's Item with defined ValueType.

                my $ItemData = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                    Data => $DefaultItem,
                );

                my $Value = $Self->_ModifiedValueCalculate(
                    Value => [
                        {
                            Item => $ItemData,
                        },
                    ],
                    EffectiveValue => $Param{EffectiveValue}->[$Index],
                    ValueType      => $Param{Value}->[0]->{Array}->[0]->{ValueType},
                    Objects        => \%Objects,
                );

                push @{ $Result->[0]->{Array}->[0]->{Item} }, $Value->[0];
            }
            elsif (
                $DefaultItem
                && ( $DefaultItem->[0]->{Array} || $DefaultItem->[0]->{Hash} )
                )
            {
                # It's complex structure (AoA or AoH), continue recursion.
                my $StructureType = $DefaultItem->[0]->{Array} ? 'Array' : 'Hash';

                $Param{Value}->[0]->{Array}->[0]->{Item}->[0]->{$StructureType}->[0]->{DefaultItem} =
                    $DefaultItem->[0]->{$StructureType}->[0]->{DefaultItem};

                my $Value = $Self->_ModifiedValueCalculate(
                    Value          => $Param{Value}->[0]->{Array}->[0]->{Item},
                    EffectiveValue => $Param{EffectiveValue}->[$Index],
                    Objects        => \%Objects,
                );

                push @{ $Result->[0]->{Array}->[0]->{Item} }, $Value->[0];
            }
            else {

                if ( IsArrayRefWithData( $Param{EffectiveValue}->[$Index] ) ) {
                    for my $ArrayItem ( @{ $Param{EffectiveValue}->[$Index] } ) {
                        push @{ $Result->[0]->{Array}->[0]->{Item} }, {
                            %Attributes,
                            Content => $ArrayItem,
                        };
                    }
                }
                else {

                    # This is a string value.
                    push @{ $Result->[0]->{Array}->[0]->{Item} }, {
                        %Attributes,
                        Content => $Param{EffectiveValue}->[$Index],
                    };
                }
            }
        }
    }
    elsif ( ref $Param{EffectiveValue} eq 'HASH' ) {

        # Create basic structure.
        $Result = [
            {
                'Hash' => [
                    {
                        'Item' => [],
                    },
                ],
            }
        ];

        if ( $Param{Value}->[0]->{Hash}->[0]->{MinItems} ) {
            $Result->[0]->{Hash}->[0]->{MinItems} = $Param{Value}->[0]->{Hash}->[0]->{MinItems};
        }

        if ( $Param{Value}->[0]->{Hash}->[0]->{MaxItems} ) {
            $Result->[0]->{Hash}->[0]->{MaxItems} = $Param{Value}->[0]->{Hash}->[0]->{MaxItems};
        }

        my $DefaultItem;

        my %Attributes;

        for my $Key ( sort keys %{ $Param{EffectiveValue} } ) {
            %Attributes = ();

            $DefaultItem = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem};

            if ( $Param{Value}->[0]->{Hash}->[0]->{Item} ) {
                my @ItemWithSameKey = grep { $Key eq ( $Param{Value}->[0]->{Hash}->[0]->{Item}->[$_]->{Key} || '' ) }
                    0 .. scalar @{ $Param{Value}->[0]->{Hash}->[0]->{Item} } - 1;
                if ( scalar @ItemWithSameKey ) {

                    if (
                        $DefaultItem
                        && !$Param{Value}->[0]->{Hash}->[0]->{Item}->[ $ItemWithSameKey[0] ]->{ValueType}
                        && $DefaultItem->[0]->{ValueType}
                        )
                    {
                        # update hash
                        for my $DefaultKey (
                            sort keys %{ $Param{Value}->[0]->{Hash}->[0]->{Item}->[ $ItemWithSameKey[0] ] }
                            )
                        {
                            $DefaultItem->[0]->{$DefaultKey}
                                = $Param{Value}->[0]->{Hash}->[0]->{Item}->[ $ItemWithSameKey[0] ]->{$DefaultKey};
                        }
                    }
                    else {
                        $DefaultItem = [
                            $Param{Value}->[0]->{Hash}->[0]->{Item}->[ $ItemWithSameKey[0] ],
                        ];
                    }
                }
            }

            if (
                $DefaultItem
                && ref $DefaultItem eq 'ARRAY'
                && scalar @{$DefaultItem}
                && ref $DefaultItem->[0] eq 'HASH'
                )
            {
                # Get additional attributes
                ATTRIBUTE:
                for my $Attribute ( sort keys %{ $DefaultItem->[0] } ) {
                    next ATTRIBUTE if grep { $Attribute eq $_ } qw(Hash Array Content Key);

                    if ( $Attribute eq 'Item' ) {
                        if (
                            !$DefaultItem->[0]->{Item}->[0]->{ValueType}
                            || $DefaultItem->[0]->{Item}->[0]->{ValueType} ne 'Option'
                            )
                        {
                            next ATTRIBUTE;
                        }
                    }
                    $Attributes{$Attribute} = $DefaultItem->[0]->{$Attribute};
                }
            }

            if (
                $DefaultItem
                && !$DefaultItem->[0]->{Content}
                && $Param{Value}->[0]->{Hash}->[0]->{Item}
                && scalar @{ $Param{Value}->[0]->{Hash}->[0]->{Item} }
                && $Param{Value}->[0]->{Hash}->[0]->{Item}->[0]->{Item}
                )
            {
                # It's Item with defined ValueType.
                my $ItemData = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                    Data => $DefaultItem,
                );

                ATTRIBUTE:
                for my $Attribute ( sort keys %Attributes ) {
                    next ATTRIBUTE if defined $ItemData->[0]->{$Attribute};

                    $ItemData->[0]->{$Attribute} = $Attributes{$Attribute};
                }

                if (
                    !$ItemData->[0]->{Item}
                    || ( $ItemData->[0]->{Item} && !$ItemData->[0]->{Item}->[0]->{ValueType} )
                    )
                {
                    $ItemData->[0]->{ValueType} //= 'String';
                }

                my $Value = $Self->_ModifiedValueCalculate(
                    Value          => $ItemData,
                    EffectiveValue => $Param{EffectiveValue}->{$Key},
                    ValueType      => $DefaultItem->[0]->{ValueType},
                    Objects        => \%Objects,
                );

                $Value->[0]->{Key} = $Key;

                push @{ $Result->[0]->{Hash}->[0]->{Item} }, $Value->[0];
            }
            elsif (
                $DefaultItem
                && ( $DefaultItem->[0]->{Array} || $DefaultItem->[0]->{Hash} )
                )
            {
                # It's complex structure (HoA or HoH), continue recursion.
                my $StructureType = $DefaultItem->[0]->{Array} ? 'Array' : 'Hash';

                my ($SubValue)
                    = grep { defined $_->{Key} && $_->{Key} eq $Key } @{ $Param{Value}->[0]->{Hash}->[0]->{Item} };

                if (
                    $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}
                    && $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$StructureType}
                    )
                {
                    $SubValue->{$StructureType}->[0]->{DefaultItem} =
                        $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$StructureType}->[0]->{DefaultItem};
                }

                my $Value = $Self->_ModifiedValueCalculate(
                    Value          => [$SubValue],
                    EffectiveValue => $Param{EffectiveValue}->{$Key},
                    Objects        => \%Objects,
                );
                $Value->[0]->{Key} = $Key;

                if ( $SubValue->{$StructureType}->[0]->{DefaultItem} ) {
                    $Value->[0]->{$StructureType}->[0]->{DefaultItem} = $SubValue->{$StructureType}->[0]->{DefaultItem};
                }

                push @{ $Result->[0]->{Hash}->[0]->{Item} }, $Value->[0];
            }
            else {
                # This is a scaler value.

                my $ValueAttribute = "Content";    # by default

                my $ValueType = $Attributes{ValueType};

                if ($ValueType) {
                    if ( !$Objects{$ValueType} ) {

                        # Make sure the ValueType backed is present and is syntactically correct.
                        my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                            "Kernel::System::SysConfig::ValueType::$ValueType",
                        );

                        if ($Loaded) {

                            # Create object instance.
                            $Objects{$ValueType} = $Kernel::OM->Get(
                                "Kernel::System::SysConfig::ValueType::$ValueType",
                            );
                        }
                    }

                    $ValueAttribute = $Objects{$ValueType}->ValueAttributeGet();
                }

                push @{ $Result->[0]->{Hash}->[0]->{Item} }, {
                    %Attributes,
                    Key             => $Key,
                    $ValueAttribute => $Param{EffectiveValue}->{$Key},
                };
            }
        }
    }
    else {

        # This is a scaler value.
        $Result = [
            {
                Item => [
                    {
                        Content => $Param{EffectiveValue},
                    },
                ],
            },
        ];

        # Get all additional parameters (defined as attributes in XML).
        if ( IsHashRefWithData( $Param{Value}->[0]->{Item}->[0] ) ) {
            PARAMETER:
            for my $Parameter ( sort keys %{ $Param{Value}->[0]->{Item}->[0] } ) {
                next PARAMETER if grep { $_ eq $Parameter } @SkipParameters;

                $Result->[0]->{Item}->[0]->{$Parameter} =
                    $Param{Value}->[0]->{Item}->[0]->{$Parameter};
            }
        }
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
