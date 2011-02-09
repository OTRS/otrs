# --
# Kernel/GenericInterface/Mapping.pm - GenericInterface data mapping interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Mapping.pm,v 1.6 2011-02-09 09:46:07 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping

=head1 SYNOPSIS

GenericInterface data mapping interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. This will return the Mapping backend for the current web service configuration.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Mapping;

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
    my $MappingObject = Kernel::GenericInterface::Mapping->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        MappingConfig   => {
            Type => 'MappingSimple',
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

    # check needed params - DebuggerObject needs to go first because it is used for logging errors
    for my $Needed (qw(DebuggerObject DBObject MainObject MappingConfig)) {
        return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!",
        } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check config - we need at least a config type
    return $Self->_LogAndExit( ErrorMessage => 'MappingConfig is no hash ref!' )
        if !$Self->_IsNonEmptyHashRef( Data => $Param{MappingConfig} );
    return $Self->_LogAndExit( ErrorMessage => 'Need Type as string in MappingConfig!' )
        if !$Self->_IsNonEmptyString( Data => $Param{MappingConfig}->{'Type'} );

    # load backend module
    my $GenericModule = 'Kernel::GenericInterface::Mapping::' . $Param{MappingConfig}->{'Type'};
    return $Self->_LogAndExit( ErrorMessage => "Can't load mapping backend module!" )
        if !$Self->{MainObject}->Require($GenericModule);
    $Self->{BackendObject} = $GenericModule->new( %{$Self} );

    # pass back error message from backend if backend module could not be executed
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=item Map()

perform data mapping in backend

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
    return $Self->_LogAndExit( ErrorMessage => 'Need Data hash ref with content!' )
        if !$Self->_IsNonEmptyHashRef( Data => $Param{Data} );

    # start map on backend
    return $Self->{BackendObject}->Map( Data => $Param{Data} );
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

$Revision: 1.6 $ $Date: 2011-02-09 09:46:07 $

=cut
