# --
# Kernel/GenericInterface/Mapping/Test.pm - GenericInterface test data mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.8 2011-02-09 11:12:05 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::Test;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping::Test

=head1 SYNOPSIS

GenericInterface test data mapping backend

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
    use Kernel::GenericInterface::Mapping::Test;

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
    my $MappingObject = Kernel::GenericInterface::Mapping::Test->new(
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
    return $Self->_LogAndExit( ErrorMessage => 'Got no MappingConfig as hash ref with content!' )
        if !$Self->_IsNonEmptyHashRef( Data => $Param{MappingConfig} );

    # check config - if we have a map config, it has to be a non-empty hash ref
    if (
        defined $Param{MappingConfig}->{Config}
        && !$Self->_IsNonEmptyHashRef( Data => $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->_LogAndExit(
            ErrorMessage => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    return $Self;
}

=item Map()

perform data mapping

    my $Result = $MappingObject->Map(
        Data => {              # data payload before mapping
            ...
        },
    );

    $Result = {
        Success         => 1,  # 0 or 1
        ErrorMessage    => '', # in case of error
        Data            => {   # data payload of after mapping
            ...
        },
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref with at least one entry
    return $Self->_LogAndExit( ErrorMessage => 'Got no Data hash ref with content!' )
        if !$Self->_IsNonEmptyHashRef( Data => $Param{Data} );

    # no config, just return input data
    if (
        !defined $Self->{MappingConfig}->{Config}
        || !defined $Self->{MappingConfig}->{Config}->{TestOption}
        )
    {
        return $Self->_CleanExit( Data => $Param{Data} );
    }

    # check TestOption format
    return $Self->_LogAndExit( ErrorMessage => 'Got no TestOption as string with value!' )
        if !$Self->_IsNonEmptyString( Data => $Self->{MappingConfig}->{Config}->{TestOption} );

    # parse data according to configuration
    my $ReturnData = {};
    if ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'ToUpper' ) {
        $ReturnData = $Self->_ToUpper( Data => $Param{Data} );
    }
    elsif ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'ToLower' ) {
        $ReturnData = $Self->_ToLower( Data => $Param{Data} );
    }
    elsif ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'Empty' ) {
        $ReturnData = $Self->_Empty( Data => $Param{Data} );
    }
    else {
        $ReturnData = $Param{Data};
    }

    # return result
    return $Self->_CleanExit( Data => $ReturnData );
}

=item _LogAndExit()

log specified error message to debug log and return error hash ref

    my $Result = $MappingObject->_LogAndExit(
        ErrorMessage => 'An error occured!', # optional
    );

    $Result = {
        Success      => 0,
        ErrorMessage => 'An error occured!',
    };

=cut

sub _LogAndExit {
    my ( $Self, %Param ) = @_;

    # get message
    my $ErrorMessage = $Param{ErrorMessage} || 'Unspecified error!';

    # log error
    $Self->{DebuggerObject}->DebugLog(
        DebugLevel => 'error',
        Title      => $ErrorMessage,

        # FIXME this should be optional
        Data => $ErrorMessage,
    );

    # return error
    return {
        Success      => 0,
        ErrorMessage => $ErrorMessage,
    };
}

=item _CleanExit()

return hash reference indicating success and containing return data

    my $Result = $MappingObject->_CleanExit(
        Data => {
            ...
        },
    );

    $Result = {
        Success => 1,
        Data    => {
            ...
        },
    };

=cut

sub _CleanExit {
    my ( $Self, %Param ) = @_;

    # check data
    return $Self->_LogAndExit( ErrorMessage => 'Got no Data as hash ref with content!' )
        if !$Self->_IsNonEmptyHashRef( Data => $Param{Data} );

    # return
    return {
        Success => 1,
        Data    => $Param{Data},
    };
}

=item _ToUpper()

change all characters in values to upper case

    my $ReturnData => $MappingObject->_ToUpper(
        Data => { # data payload before mapping
            'abc' => 'Def,
            'ghi' => 'jkl',
        },
    );

    $ReturnData = { # data payload after mapping
        'abc' => 'DEF',
        'ghi' => 'JKL',
    };

=cut

sub _ToUpper {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = uc $Param{Data}->{$Key};
    }

    return $ReturnData;
}

=item _ToLower()

change all characters in values to lower case

    my $ReturnData => $MappingObject->_ToLower(
        Data => { # data payload before mapping
            'abc' => 'Def,
            'ghi' => 'JKL',
        },
    );

    $ReturnData = { # data payload after mapping
        'abc' => 'def',
        'ghi' => 'jkl',
    };

=cut

sub _ToLower {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = lc $Param{Data}->{$Key};
    }

    return $ReturnData;
}

=item _Empty()

set all values to empty string

    my $ReturnData => $MappingObject->_Empty(
        Data => { # data payload before mapping
            'abc' => 'Def,
            'ghi' => 'JKL',
        },
    );

    $ReturnData = { # data payload after mapping
        'abc' => '',
        'ghi' => '',
    };

=cut

sub _Empty {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = '';
    }

    return $ReturnData;
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

$Revision: 1.8 $ $Date: 2011-02-09 11:12:05 $

=cut
