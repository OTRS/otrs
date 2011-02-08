# --
# Kernel/GenericInterface/Mapping/Simple.pm - GenericInterface simle data mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.pm,v 1.3 2011-02-08 10:15:35 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::Simple;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
    for my $Needed (qw(DebuggerObject MappingConfig MainObject)) {
        return { ErrorMessage => "Got no $Needed!" } if !$Param{Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    return { ErrorMessage => 'MappingConfig is no hash reference!' }
        if ref $Self->{MappingConfig} ne 'HASH';
    return { ErrorMessage => 'Got no Config param in MappingConfig!' }
        if ref $Self->{MappingConfig}->{Config} ne 'HASH';

    return;
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
            MapType => 'keep',    # possible values are
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
            ErrorMessage => 'Got no Data',
        };
    }

    # go through keys for replacement
    my %ReturnData;
    my $Config = $Self->{MappingConfig}->{Config};
    CONFIGKEY:
    for my $OldKey ( sort keys %{ $Param{Data} } ) {

        # check mapping for key
        my $NewKey;

        # first check in exact (1:1) map
        if ( ref $Config->{KeyMapExact} eq 'HASH' ) {
            KEYMAPEXACT:
            for my $ConfigKey ( sort keys %{ $Config->{KeyMapExact} } ) {
                next KEYMAPEXACT if $OldKey ne $ConfigKey;

                # check if map value is valid
                if (
                    !$Config->{KeyMapExact}->{$ConfigKey}
                    || ref $Config->{KeyMapExact}->{$ConfigKey}
                    )
                {
                    return {
                        Success      => 0,
                        ErrorMessage => "KeyMapExact map type for $ConfigKey is invalid!",
                    };
                }

                $NewKey = $Config->{KeyMapExact}->{$ConfigKey};
                last KEYMAPEXACT;
            }
        }

        # if we have no match from exact map, try regex map
        if ( !$NewKey && ref $Config->{KeyMapRegEx} eq 'HASH' ) {
            KEYMAPREGEX:
            for my $ConfigKey ( sort keys %{ $Config->{KeyMapRegEx} } ) {
                next KEYMAPREGEX if $OldKey !~ m{ \A $ConfigKey \z }xms;

                # check if map value is valid
                if (
                    !$Config->{KeyMapRegEx}->{$ConfigKey}
                    || ref $Config->{KeyMapRegEx}->{$ConfigKey}
                    )
                {
                    return {
                        Success      => 0,
                        ErrorMessage => "KeyMapRegEx map type for $ConfigKey is invalid!",
                    };
                }

                $NewKey = $Config->{KeyMapRegEx}->{$ConfigKey};
                last KEYMAPREGEX;
            }
        }

        # if we still have no match, apply default
        if ( !$NewKey ) {

            # FIXME is this the way to go or shall we throw an error?
            # use fallback if there is no default config
            if ( ref $Config->{KeyMapDefault} ne 'HASH' ) {
                $NewKey = $OldKey;
            }

            # check if default config is valid
            if (
                !$Config->{KeyMapDefault}->{MapType}
                || ref $Config->{KeyMapDefault}->{MapType}
                )
            {
                return {
                    Success      => 0,
                    ErrorMessage => "MapType type in KeyMapDefault is invalid!",
                };
            }

            # check map type options
            if ( $Config->{KeyMapDefault}->{MapType} eq 'Keep' ) {
                $NewKey = $OldKey;
            }
            elsif ( $Config->{KeyMapDefault}->{MapType} eq 'Ignore' ) {
                next CONFIGKEY;
            }
            elsif ( $Config->{KeyMapDefault}->{MapType} eq 'MapTo' ) {

                # check if map to value is valid
                if (
                    !$Config->{KeyMapDefault}->{MapTo}
                    || ref $Config->{KeyMapDefault}->{MapTo}
                    )
                {
                    return {
                        Success      => 0,
                        ErrorMessage => "MapTo type in KeyMapDefault is invalid!",
                    };
                }

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
            else {
                return {
                    Success      => 0,
                    ErrorMessage => "MapTo name in KeyMapDefault is invalid!",
                };
            }
        }
    }

    return \%ReturnData;
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

$Revision: 1.3 $ $Date: 2011-02-08 10:15:35 $

=cut
