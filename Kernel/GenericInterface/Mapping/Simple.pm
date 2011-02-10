# --
# Kernel/GenericInterface/Mapping/Simple.pm - GenericInterface simple data mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Simple.pm,v 1.7 2011-02-10 10:46:14 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::Simple;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping::Simple

=head1 SYNOPSIS

GenericInterface simple data mapping backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a Mapping backend object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Mapping::Simple;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        ConfigObject       => $ConfigObject,
        EncodeObject       => $EncodeObject,
        LogObject          => $LogObject,
        MainObject         => $MainObject,
        DBObject           => $DBObject,
        TimeObject         => $TimeObject,
    );
    my $MappingObject = Kernel::GenericInterface::Mapping::Simple->new(
        ConfigObject       => $ConfigObject,
        EncodeObject       => $EncodeObject,
        LogObject          => $LogObject,
        MainObject         => $MainObject,
        DBObject           => $DBObject,
        TimeObject         => $TimeObject,
        DebuggerObject     => $DebuggerObject,

        MappingConfig   => {
            Config => {
                ...
            },
        },
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MainObject MappingConfig)) {
        return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!",
        } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    if ( !$Self->_IsNonEmptyHashRef( Data => $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # check config - if we have a map config, it has to be a non-empty hash ref
    if (
        defined $Param{MappingConfig}->{Config}
        && !$Self->_IsNonEmptyHashRef( Data => $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    return $Self;
}

=item Map()

provides 1:1 and regex mapping for keys and values
also the use of a default for unmapped keys and values is possible

we require the config to be in the following format

    $Self->{MappingConfig}->{Config} = {
        KeyMapExact => {           # optional. key/value pairs for direct replacement
            'old_value'         => 'new_value',
            'another_old_value' => 'another_new_value',
            'maps_to_same_value => 'another_new_value',
        },
        KeyMapRegEx => {           # optional. replace keys with value if current key matches regex
            'Stat(e|us)'  => 'state',
            '[pP]riority' => 'prio',
        },
        KeyMapDefault => {         # required. replace keys if the have not been replaced before
            MapType => 'Keep',     # possible values are
                                   # 'Keep' (leave unchanged)
                                   # 'Ignore' (drop key/value pair)
                                   # 'MapTo' (use provided value as default)
            MapTo => 'new_value',  # only used if 'MapType' is 'MapTo'. then required
        },
        ValueMap => {
            'new_key_name' => {    # optional. Replacement for a specific key
                ValueMapExact => { # optional. key/value pairs for direct replacement
                    'old_value'         => 'new_value',
                    'another_old_value' => 'another_new_value',
                    'maps_to_same_value => 'another_new_value',
                },
                ValueMapRegEx => { # optional. replace keys with value if current key matches regex
                    'Stat(e|us)'  => 'state',
                    '[pP]riority' => 'prio',
                },
            },
        },
        ValueMapDefault => {       # required. replace keys if the have not been replaced before
            MapType => 'Keep',     # possible values are
                                   # 'Keep' (leave unchanged)
                                   # 'Ignore' (drop key/value pair)
                                   # 'MapTo' (use provided value as default)
            MapTo => 'new_value',  # only used if 'MapType' is 'MapTo'. then required
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

    # check data - we need a hash ref with at least one entry
    if ( !$Self->_IsNonEmptyHashRef( Data => $Param{Data} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data hash ref with content!' );
    }

    # no config means we just return input data
    if ( !$Self->{MappingConfig}->{Config} ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # prepare short config variable
    my $Config = $Self->{MappingConfig}->{Config};

    # check configuration
    my $ConfigCheck = $Self->_ConfigCheck( Config => $Self->{MappingConfig}->{Config} );
    return $ConfigCheck if !$ConfigCheck->{Success};

    # go through keys for replacement
    my %ReturnData;
    CONFIGKEY:
    for my $OldKey ( sort keys %{ $Param{Data} } ) {

        # check if key is valid
        if ( !$Self->_IsNonEmptyString( Data => $OldKey ) ) {
            $Self->{DebuggerObject}->Notice( Summary => 'Got an original key that is not valid!' );
            next CONFIGKEY;
        }

        # map key
        my $NewKey;

        # first check in exact (1:1) map
        if ( $Config->{KeyMapExact} && $Config->{KeyMapExact}->{$OldKey} ) {
            $NewKey = $Config->{KeyMapExact}->{$OldKey};
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
                    $Self->{DebuggerObject}->Notice(
                        Summary => "The data key $Config->{KeyMapDefault}->{MapTo} already exists!",
                    );
                    next CONFIGKEY;
                }

                $NewKey = $Config->{KeyMapDefault}->{MapTo};
            }
        }

        # sanity check - we should have a translated key now
        if ( !$NewKey ) {
            return $Self->{DebuggerObject}->Error( Summary => "Could not map data key $NewKey!" );
        }

        # map value
        my $OldValue = $Param{Data}->{$OldKey};

        # check if value is valid
        if ( !$Self->_IsString( Data => $OldValue ) ) {
            $Self->{DebuggerObject}->Notice( Summary => "Value for data key $OldKey is invalid!" );
            $ReturnData{$NewKey} = undef;
            next CONFIGKEY;
        }

        # check if we have a value mapping for the specific key
        my $ValueMap = $Config->{ValueMap}->{$NewKey};
        if ($ValueMap) {

            # first check in exact (1:1) map
            if ( $ValueMap->{KeyMapExact} && $ValueMap->{KeyMapExact}->{$OldValue} ) {
                $ReturnData{$NewKey} = $ValueMap->{KeyMapExact}->{$OldValue};
                next CONFIGKEY;
            }

            # if we have no match from exact map, try regex map
            if ( $ValueMap->{KeyMapRegEx} ) {
                VALUEMAPREGEX:
                for my $ConfigKey ( sort keys %{ $ValueMap->{KeyMapRegEx} } ) {
                    next VALUEMAPREGEX if $OldKey !~ m{ \A $ConfigKey \z }xms;
                    $ReturnData{$NewKey} = $ValueMap->{KeyMapRegEx}->{$ConfigKey};
                    next VALUEMAPREGEX;
                }
            }
        }

        # if we had no mapping, apply default

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

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=item _ConfigCheck()

does checks to make sure the config is sane

    my $Return = $MappingObject->_ConfigCheck(
        Config => { # config as defined for Map
            ...
        },
    );

in case of an error

    $Return => {
        Success      => 0,
        ErrorMessage => 'An error occured',
    };

in case of a success

    $Return = {
        Success => 1,
    };

=cut

sub _ConfigCheck {
    my ( $Self, %Param ) = @_;

    # get required param
    my $Config = $Param{Config};
    if ( !$Config ) {
        return {
            Success      => 0,
            ErrorMessage => 'Need Config!',
        };
    }

    # parse config options for validity
    my %OnlyStringConfigTypes = (
        KeyMapExact     => 1,
        KeyMapRegEx     => 1,
        KeyMapDefault   => 1,
        ValueMapDefault => 1,
    );
    my %RequiredConfigTypes = (
        KeyMapDefault   => 1,
        ValueMapDefault => 1,
    );
    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapExact KeyMapRegEx KeyMapDefault ValueMap ValueMapDefault)) {

        # require some types
        if ( !defined $Config->{$ConfigType} ) {
            next CONFIGTYPE if !$RequiredConfigTypes{$ConfigType};
            return $Self->{DebuggerObject}->Error(
                Summary => "Got no $ConfigType, but it is required!",
            );
        }

        # check type definition
        if ( !$Self->_IsNonEmptyHashRef( Data => $Config->{$ConfigType} ) ) {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got $ConfigType with Data, but Data is no hash ref with content!",
            );
        }

        # check keys and values of these config types
        next CONFIGTYPE if !$OnlyStringConfigTypes{$ConfigType};
        for my $ConfigKey ( sort keys %{ $Config->{$ConfigType} } ) {
            if ( !$Self->_IsString( Data => $ConfigKey ) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Got key in $ConfigType which is not a string!",
                );
            }
            if ( !$Self->_IsString( Data => $Config->{$ConfigType}->{$ConfigKey} ) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary => "Got value for $ConfigKey in $ConfigType which is not a string!",
                );
            }
        }
    }

    # check default configuration in KeyMapDefault and ValueMapDefault
    my %ValidMapTypes = (
        Keep   => 1,
        Ignore => 1,
        MapTo  => 1,
    );
    CONFIGTYPE:
    for my $ConfigType (qw(KeyMapDefault ValueMapDefault)) {

        # require MapType as a string with a valid value
        if (
            !$Self->_IsNonEmptyString( Data => $Config->{$ConfigType}->{MapType} )
            || !$ValidMapTypes{ $Config->{$ConfigType}->{MapType} }
            )
        {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got no valid MapType in $ConfigType!",
            );
        }

        # check MapTo if MapType is set to 'MapTo'
        if (
            $Config->{$ConfigType}->{MapType} eq 'MapTo'
            && !$Self->_IsNonEmptyString( Data => $Config->{$ConfigType}->{MapTo} )
            )
        {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got MapType 'MapTo', but MapTo value is not valid in $ConfigType!",
            );
        }
    }

    # check ValueMap
    for my $KeyName ( keys %{ $Config->{ValueMap} } ) {

        # require values to be hash ref
        if ( !$Self->_IsNonEmptyHashRef( Data => $Config->{ValueMap}->{$KeyName} ) ) {
            return $Self->{DebuggerObject}->Error(
                Summary => "Got $KeyName in ValueMap, but it is no hash ref with content!",
            );
        }

        # possible subvalues are ValueMapExact or ValueMapRegEx and need to be hash ref if defined
        SUBKEY:
        for my $SubKeyName (qw(ValueMapExact ValueMapRegEx)) {
            my $ValueMapType = $Config->{ValueMap}->{$KeyName}->{$SubKeyName};
            next SUBKEY if !defined $ValueMapType;
            if ( !$Self->_IsNonEmptyHashRef( Data => $ValueMapType ) ) {
                return $Self->{DebuggerObject}->Error(
                    Summary =>
                        "Got $SubKeyName in $KeyName in ValueMap,"
                        . ' but it is no hash ref with content!',
                );
            }

            # key/value pairs of ValueMapExact and ValueMapRegEx must be strings
            for my $ValueMapTypeKey ( sort keys %{$ValueMapType} ) {
                if ( !$Self->_IsString( Data => $ValueMapTypeKey ) ) {
                    return $Self->{DebuggerObject}->Error(
                        Summary =>
                            "Got key in $SubKeyName in $KeyName in ValueMap which is not a string!",
                    );
                }
                if ( !$Self->_IsString( Data => $ValueMapType->{$ValueMapTypeKey} ) ) {
                    return $Self->{DebuggerObject}->Error(
                        Summary =>
                            "Got value for $ValueMapTypeKey in $SubKeyName in $KeyName in ValueMap"
                            . ' which is not a string!',
                    );
                }
            }
        }
    }

    # if we arrive here, all checks were ok
    return {
        Success => 1,
    };
}

=item _IsString()

test supplied data to determine if it is a string - an empty string is valid

returns 1 if data matches criteria or undef otherwise

    my $Result = $MappingObject->_IsString(
        Data => 'abc' # data to be tested
    );

=cut

sub _IsString {
    my ( $Self, %Param ) = @_;

    my $TestData = $Param{Data};

    return if !defined $TestData;
    return if ref $TestData;

    return 1;
}

=item _IsNonEmptyString()

test supplied data to determine if it is a non zero-length string

returns 1 if data matches criteria or undef otherwise

    my $Result = $MappingObject->_IsNonEmptyString(
        Data => 'abc' # data to be tested
    );

=cut

sub _IsNonEmptyString {
    my ( $Self, %Param ) = @_;

    my $TestData = $Param{Data};

    return if !$TestData;
    return if ref $TestData;

    return 1;
}

=item _IsNonEmptyHashRef()

test supplied data to determine if it is a hash reference containing data

returns 1 if data matches criteria or undef otherwise

    my $Result = $MappingObject->_IsNonEmptyHashRef(
        Data => { 'key' => 'value' } # data to be tested
    );

=cut

sub _IsNonEmptyHashRef {
    my ( $Self, %Param ) = @_;

    my $TestData = $Param{Data};

    return if !$TestData;
    return if ref $TestData ne 'HASH';
    return if !%{$TestData};

    return 1;
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

$Revision: 1.7 $ $Date: 2011-02-10 10:46:14 $

=cut
