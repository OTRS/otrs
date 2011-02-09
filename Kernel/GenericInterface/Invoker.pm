# --
# Kernel/GenericInterface/Invoker.pm - GenericInterface Invoker interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Invoker.pm,v 1.2 2011-02-09 17:04:26 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker

=head1 SYNOPSIS

GenericInterface Invoker interface.

Invokers are responsible to prepare for making a remote web service
request.

For every Request, two methods are called:

    L<PrepareRequest()>
    L<HandleResponse()>

The first method prepares the response and can prevent it by returning
an error state. The second method must always be called if the request
was initiated to allow the Invoker to handle possible errors.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Invoker;

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
    my $InvokerObject = Kernel::GenericInterface::Invoker->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        Invoker            => 'Nagios::TicketLock',    # the Invoker to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DBObject DebuggerObject MainObject Invoker)) {
        return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!",
        } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self->_LogAndExit(
        ErrorMessage => 'Got no Invoker Type as string with value!',
    ) if !$Self->_IsNonEmptyString( Data => $Param{Invoker} );

    # load backend module
    my $GenericModule = 'Kernel::GenericInterface::Invoker::' . $Param{Invoker};
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        return $Self->_LogAndExit( ErrorMessage => "Can't load invoker backend module!" );
    }
    $Self->{BackendObject} = $GenericModule->new( %{$Self} );

    # pass back error message from backend if backend module could not be executed
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    #TODO implement
    # check data - we need a hash ref with at least one entry
    if ( !$Self->_IsNonEmptyHashRef( Data => $Param{Data} ) ) {
        return $Self->_LogAndExit( ErrorMessage => 'Got no Data hash ref with content!' );
    }

    # start map on backend
    return $Self->{BackendObject}->PrepareRequest( Data => $Param{Data} );

}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    #TODO implement
    # check data - we need a hash ref with at least one entry
    if ( !$Self->_IsNonEmptyHashRef( Data => $Param{Data} ) ) {
        return $Self->_LogAndExit( ErrorMessage => 'Got no Data hash ref with content!' );
    }

    # start map on backend
    return $Self->{BackendObject}->HandleResponse( Data => $Param{Data} );

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

$Revision: 1.2 $ $Date: 2011-02-09 17:04:26 $

=cut
