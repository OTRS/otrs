# --
# Kernel/GenericInterface/Mapping/Simple.pm - GenericInterface simple data mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.pm,v 1.5 2011-02-08 15:59:51 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::Simple;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping::Simple

=head1 SYNOPSIS

GenericInterface simple data mapping backend

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MainObject MappingConfig)) {
        return { ErrorMessage => "Got no $Needed!" } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    return { ErrorMessage => 'MappingConfig is no hash reference!' }
        if ref $Self->{MappingConfig} ne 'HASH';
    return { ErrorMessage => 'Config param in MappingConfig is no hash reference!' }
        if ref $Self->{MappingConfig}->{Config} ne 'HASH';

    return $Self;
}

=item Map()

provides 1:1 and regex mapping for keys and values
also the use of a default for unmapped keys and values is possible

we require the config to be in the following format

    $Self->{MappingConfig}->{Config} = {
        KeyMapExact => {          # key/value pairs for direct replacement
            'old_value'         => 'new_value',
            'another_old_value' => 'another_new_value',
            'maps_to_same_value => 'another_new_value',
        },
        KeyMapRegEx => {          # replace keys with value if current key matches regex
            'Stat(e|us)'  => 'state',
            '[pP]riority' => 'prio',
        },
        KeyMapDefault => {        # optional. If not set, keys will remain unchanged
            MapType => 'Keep',    # possible values are
                                  # 'Keep' (leave unchanged)
                                  # 'Ignore' (drop key/value pair)
                                  # 'MapTo' (use provided value as default)
            MapTo => 'new_value', # only used if 'MapType' is 'MapTo'
        },
        ValueMap => {
            'new_key_name' => {
                ValueMapExact => {        # key/value pairs for direct replacement
                    'old_value'         => 'new_value',
                    'another_old_value' => 'another_new_value',
                    'maps_to_same_value => 'another_new_value',
                },
                ValueMapRegEx => {        # replace keys with value if current key matches regex
                    'Stat(e|us)'  => 'state',
                    '[pP]riority' => 'prio',
                },
            },
        },
        ValueMapDefault => {      # optional. If not set, values will remain unchanged
            MapType => 'Keep',    # possible values are
                                  # 'Keep' (leave unchanged)
                                  # 'Ignore' (drop key/value pair)
                                  # 'MapTo' (use provided value as default)
            MapTo => 'new_value', # only used if 'MapType' is 'MapTo'
        },
    };

    my $ReturnData = $MappingObject->Map(
        Data => {
            'original_key' => 'original_value',
            'another_key'  => 'next_value',
        },
    );

    my $ReturnData = {
        'changed_key'          => 'changed_value',
        'original_key'         => 'another_changed_value',
        'another_original_key' => 'default_value',
        'default_key'          => 'changed_value',
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'Data is not a hash reference!',
        };
    }
    if ( !%{ $Param{Data} } ) {
        return {
            Success      => 0,
            ErrorMessage => 'Got no Data!',
        };
    }

    # do no replacements if we have no config
    if ( !%{ $Self->{MappingConfig}->{Config} } ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # check if config is valid
    my $Config = $Self->{MappingConfig}->{Config};

    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapExact KeyMapRegEx KeyMapDefault ValueMap ValueMapDefault)) {

        # check top level
        if (
            $Config->{$ConfigType}
            && (
                ref $Config->{$ConfigType} ne 'HASH'
                || !%{ $Config->{$ConfigType} }
            )
            )
        {
            return {
                Success => 0,
                ErrorMessage =>
                    "Config type $ConfigType is defined but not a hash reference or empty!",
            };
        }
        next CONFIGTYPE if !$Config->{$ConfigType};

        # check keys and values of these config types
        if (
            $ConfigType =~ m{
                \A (?: KeyMapExact | KeyMapRegEx | KeyMapDefault | ValueMapDefault ) \z
            }xms
            )
        {
            for my $ConfigKey ( %{ $Config->{$ConfigType} } ) {
                if ( ref $ConfigKey ) {
                    return {
                        Success => 0,
                        ErrorMessage =>
                            "Config key $ConfigKey in config type $ConfigType is not a string!",
                    };
                }
                if ( ref $Config->{$ConfigType}->{$ConfigKey} ) {
                    return {
                        Success => 0,
                        ErrorMessage =>
                            "Config value of key $ConfigKey"
                            . " in config type $ConfigType is not a string!",
                    };
                }
            }
        }
    }

    # check valid values for MapType in KeyMapDefault and ValueMapDefault
    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapDefault ValueMapDefault)) {
        next CONFIGTYPE if !$Config->{$ConfigType};

        if ( !$Config->{$ConfigType}->{MapType} ) {
            return {
                Success => 0,
                ErrorMessage =>
                    "Config value of key MapType must be set if config type $ConfigType exists!",
            };
        }

        if ( ref $Config->{$ConfigType}->{MapType} ) {
            return {
                Success => 0,
                ErrorMessage =>
                    "Config value of key MapType"
                    . " in config type $ConfigType is not a string!",
            };
        }

        next CONFIGTYPE if $Config->{$ConfigType}->{MapType} =~ m{
            \A (?: Keep | Ignore | MapTo ) \z
        }xms;

        return {
            Success => 0,
            ErrorMessage =>
                "Value of config key MapType ($Config->{$ConfigType}->{MapType})"
                . " in config type $ConfigType is not allowed!",
        };
    }

    # check valid value in MapTo of KeyMapDefault
    if (
        $Config->{KeyMapDefault}
        && $Config->{KeyMapDefault}->{MapType}
        && $Config->{KeyMapDefault}->{MapType} eq 'MapTo'
        )
    {
        if ( !$Config->{KeyMapDefault}->{MapTo} ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Value of config value MapTo in config type KeyMapDefault must not be empty!',
            };
        }
        elsif ( ref $Config->{KeyMapDefault}->{MapTo} ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Value of config value MapTo in config type KeyMapDefault is not a string!',
            };
        }
    }

    # check ValueMap
    for my $KeyName ( keys %{ $Config->{ValueMap} } ) {
        if ( ref $Config->{ValueMap}->{$KeyName} ne 'HASH' ) {
            return {
                Success => 0,
                ErrorMessage =>
                    "Value of config value $KeyName in config type ValueMap"
                    . ' is not a hash reference!',
            };
        }
        SUBKEY:
        for my $SubKeyName (qw(ValueMapExact ValueMapRegEx)) {
            next if !$Config->{ValueMap}->{$KeyName}->{$SubKeyName};
            if ( ref $Config->{ValueMap}->{$KeyName}->{$SubKeyName} ne 'HASH' ) {
                return {
                    Success => 0,
                    ErrorMessage =>
                        "Value of config value $KeyName->$SubKeyName in config type ValueMap"
                        . ' is not a hash reference!',
                };
            }

            for my $ConfigKey ( %{ $Config->{ValueMap}->{$KeyName}->{$SubKeyName} } ) {
                if ( ref $ConfigKey ) {
                    return {
                        Success => 0,
                        ErrorMessage =>
                            "Config key $KeyName->$SubKeyName->$ConfigKey in config type ValueMap"
                            . ' is not a string!',
                    };
                }
                if ( ref $Config->{ValueMap}->{$KeyName}->{$SubKeyName}->{$ConfigKey} ) {
                    return {
                        Success => 0,
                        ErrorMessage =>
                            "Config value of key $KeyName->$SubKeyName->$ConfigKey"
                            . ' in config type ValueMap is not a string!',
                    };
                }
            }
        }
    }

    # go through keys for replacement
    my %ReturnData;
    CONFIGKEY:
    for my $OldKey ( sort keys %{ $Param{Data} } ) {

        # check if key is valid
        if (
            !$OldKey
            || ref $OldKey
            )
        {
            return {
                Success      => 0,
                ErrorMessage => "Original key is invalid!",
            };
        }

        # check mapping for key
        my $NewKey;

        # first check in exact (1:1) map
        if ( $Config->{KeyMapExact} ) {
            KEYMAPEXACT:
            for my $ConfigKey ( sort keys %{ $Config->{KeyMapExact} } ) {
                next KEYMAPEXACT if $OldKey ne $ConfigKey;

                $NewKey = $Config->{KeyMapExact}->{$ConfigKey};
                last KEYMAPEXACT;
            }
        }

        # if we have no match from exact map, try regex map
        if ( !$NewKey && $Config->{KeyMapRegEx} ) {
            KEYMAPREGEX:
            for my $ConfigKey ( sort keys %{ $Config->{KeyMapRegEx} } ) {
                next KEYMAPREGEX if $OldKey !~ m{ \A $ConfigKey \z }xms;

                $NewKey = $Config->{KeyMapRegEx}->{$ConfigKey};
                last KEYMAPREGEX;
            }
        }

        # if we still have no match, apply default
        if ( !$NewKey ) {

            # FIXME is this the way to go or shall we throw an error?
            # use fallback if there is no default config
            if ( !$Config->{KeyMapDefault} ) {
                $NewKey = $OldKey;
            }

            # check map type options
            if ( $Config->{KeyMapDefault}->{MapType} eq 'Keep' ) {
                $NewKey = $OldKey;
            }
            elsif ( $Config->{KeyMapDefault}->{MapType} eq 'Ignore' ) {
                next CONFIGKEY;
            }
            elsif ( $Config->{KeyMapDefault}->{MapType} eq 'MapTo' ) {

                # check if we already have a key with the same name
                if ( $ReturnData{ $Config->{KeyMapDefault}->{MapTo} } ) {
                    $Self->{DebuggerObject}->DebugLog(
                        DebugLevel => 'notice',
                        Title      => 'Duplicate data key',
                        Data =>
                            "The data key $Config->{KeyMapDefault}->{MapTo} already exists!",
                    );
                    next CONFIGKEY;
                }

                $NewKey = $Config->{KeyMapDefault}->{MapTo};
            }
        }

        # now we have mapped $OldKey to $NewKey we map $OldValue to $NewValue
        my $OldValue = $Param{Data}->{$OldKey};

        # check if value is valid
        if ( ref $OldValue ) {
            return {
                Success      => 0,
                ErrorMessage => "Original value is not a string!",
            };
        }

        # check if we have a value mapping for the key
        if ( $Config->{ValueMap}->{$NewKey} ) {
            my $ValueMap = $Config->{ValueMap}->{$NewKey};

            # first check in exact (1:1) map
            if ( $ValueMap->{KeyMapExact} ) {
                KEYMAPEXACT:
                for my $ConfigKey ( sort keys %{ $ValueMap->{KeyMapExact} } ) {
                    next KEYMAPEXACT if $OldKey ne $ConfigKey;

                    $ReturnData{$NewKey} = $ValueMap->{KeyMapExact}->{$ConfigKey};
                    next CONFIGKEY;
                }
            }

            # if we have no match from exact map, try regex map
            if ( !$NewKey && $ValueMap->{KeyMapRegEx} ) {
                KEYMAPREGEX:
                for my $ConfigKey ( sort keys %{ $ValueMap->{KeyMapRegEx} } ) {
                    next KEYMAPREGEX if $OldKey !~ m{ \A $ConfigKey \z }xms;

                    $ReturnData{$NewKey} = $ValueMap->{KeyMapRegEx}->{$ConfigKey};
                    next CONFIGKEY;
                }
            }
        }

        # if we had no mapping, apply default
        if ( $Config->{ValueMapDefault} ) {

            # keep current value
            if ( $Config->{ValueMapDefault}->{MapType} eq 'Keep' ) {
                $ReturnData{$NewKey} = $OldValue;
                next CONFIGKEY;
            }

            # map to default value
            if ( $Config->{ValueMapDefault}->{MapType} eq 'MapTo' ) {
                $ReturnData{$NewKey} = $Config->{ValueMapDefault}->{MapTo};
                next CONFIGKEY;
            }

            # implicit ignore
            next CONFIGKEY;
        }

        # otherwise use current value
        $ReturnData{$NewKey} = $OldValue;
    }

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.5 $ $Date: 2011-02-08 15:59:51 $

=cut
