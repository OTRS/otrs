# --
# Kernel/GenericInterface/Operation.pm - GenericInterface operation interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Operation.pm,v 1.4 2011-02-10 10:46:14 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation

=head1 SYNOPSIS

GenericInterface Operation interface.

Operations are called by web service requests from remote
systems.

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
    use Kernel::GenericInterface::Operation;

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
    my $OperationObject = Kernel::GenericInterface::Operation->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        Operation => 'Ticket::TicketCreate',    # the local operation to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject MainObject ConfigObject LogObject EncodeObject TimeObject DBObject Operation)
        )
    {
        return {
            Success      => 0,
            ErrorMessage => "Got no $Needed!",
        } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check operation
    if ( !$Self->_IsNonEmptyString( Data => $Param{Operation} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no Operation with content!',
        );
    }

    # load backend module
    my $GenericModule = 'Kernel::GenericInterface::Operation::' . $Param{Operation};
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        return $Self->{DebuggerObject}->Error( Summary => "Can't load operation backend module!" );
    }
    $Self->{BackendObject} = $GenericModule->new( %{$Self} );

    # pass back error message from backend if backend module could not be executed
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=item Run()

perform the selected Operation.

    my $Result = $OperationObject->Run(
        Data => {                               # data payload before Operation
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # result data payload after Operation
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref with at least one entry
    if ( !$Self->_IsNonEmptyHashRef( Data => $Param{Data} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no Data hash ref with content!' );
    }

    # start map on backend
    return $Self->{BackendObject}->Run( Data => $Param{Data} );
}

=item _Auth()

helper function which authenticates Agents or Customers.
This function is used by the different Operations.

    my $UserID = $ControllerObject->_Auth(
        Type     => 'Agent',    # Agent or Customer
        Username => 'User',
        Password => 'PW',
        TTL      => 60*60*24,   # TTL for caching of successful logins
    );

Returns UserID (for Agents), CustomerUserID (for Customers), or undef
(on authentication failure).

=cut

sub _Auth {
    my ( $Self, %Param ) = @_;

    # TODO move this function somewhere else, e. g. Kernel/System/GenericInterface/*.pm

    # check all parameters are present
    for my $Key (qw(Type Username Password TTL)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if type is correct
    return if ( $Param{Type} ne 'Agent' || $Param{Type} ne 'Customer' );

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "Auth::$Param{Type}::$Param{Username}",
        );
        return $Data if $Data;
    }

    # assing correct AuthObject and User Object
    my $AuthObject = Kernel::System::Auth->new( %{$Self} );
    if ( $Param{Type} eq 'Customer' ) {
        $AuthObject = Kernel::System::CustomerAuth->new( %{$Self} );
    }

    # perform authentication
    my $UserLogin = $AuthObject->Auth( User => $Param{Username}, Pw => $Param{Password} );

    if ( !$UserLogin ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $Param{Username} failed!",
        );
        return;
    }

    # to store the UserID or CustomerUserID
    my $UserID;

    # check either User or Customer in order to obtain the ID
    if ( $Param{Type} eq 'Agent' ) {

        # set user id
        my $UserObject = Kernel::System::User->new( %{$Self} );
        $UserID = $UserObject->UserLookup(
            UserLogin => $UserLogin,
        );
    }
    else {

        # set customer user id
        my $CustomerUserObject = Kernel::System::CustomerUser->new( %{$Self} );

        my %User = $CustomerUserObject->CustomerUserDataGet(
            User => $UserLogin,
        );
        $UserID = $User{CustomerUserID},
    }
    return if !$UserID;

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "Auth::$Param{Type}::$Param{Username}",
            Value => {$UserID},
            TTL   => $Param{TTL},
        );
    }

    # return the Agent ot Customer UserID
    return $UserID;
}

=item _IsNonEmptyString()

test supplied data to determine if it is a non zero-length string

returns 1 if data matches criteria or undef otherwise

    my $Result = $OperationObject->_IsNonEmptyString(
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

    my $Result = $OperationObject->_IsNonEmptyHashRef(
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

$Revision: 1.4 $ $Date: 2011-02-10 10:46:14 $

=cut
