# --
# Kernel/GenericInterface/Operation/Common.pm - common operation functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Common;

use strict;
use warnings;

use vars qw(@ISA $VERSION);

use Kernel::System::User;
use Kernel::System::Auth;
use Kernel::System::Group;
use Kernel::System::AuthSession;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerAuth;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::GenericInterface::Operation::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Operation::Common;

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
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        DebuggerConfig   => {
            DebugThreshold  => 'debug',
            TestMode        => 0,           # optional, in testing mode the data will not be
                                            #   written to the DB
            ...
        },
    my $CommonObject = Kernel::GenericInterface::Operation::Common->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
        DebuggerObject     => $DebuggerObject,
        WebserviceID       => $WebserviceID,             # ID of the currently used web service
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw( DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject)
        )
    {

        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{UserObject}    = Kernel::System::User->new( %{$Self} );
    $Self->{SessionObject} = Kernel::System::AuthSession->new( %{$Self} );
    $Self->{GroupObject}   = Kernel::System::Group->new( %{$Self} );
    $Self->{AuthObject}    = Kernel::System::Auth->new( %{$Self} );

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{CustomerAuthObject} = Kernel::System::CustomerAuth->new( %{$Self} );

    return $Self;
}

=item Auth()

performs user or customer user authorization

    my ( $UserID, $UserType ) = $CommonObject->Auth(
        Data => {
            SessionID         => 'AValidSessionIDValue'     # the ID of the user session
            UserLogin         => 'Agent',                   # if no SessionID is given UserLogin or
                                                            #   CustomerUserLogin is required
            CustomerUserLogin => 'Customer',
            Password  => 'some password',                   # user password
        },
    );

    returns

    (
        1,                                              # the UserID from login or session data
        'Agent',                                        # || 'Customer', the UserType.
    );

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    my $SessionID = $Param{Data}->{SessionID} || '';

    # check if a valid SessionID is present
    if ($SessionID) {
        my $ValidSessionID;
        if ($SessionID) {
            $ValidSessionID = $Self->{SessionObject}->CheckSessionID( SessionID => $SessionID );
        }
        return 0 if !$ValidSessionID;

        # get session data
        my %UserData = $Self->{SessionObject}->GetSessionIDData(
            SessionID => $SessionID,
        );

        # get UserID from SessionIDData
        if ( $UserData{UserID} && $UserData{UserType} ne 'Customer' ) {
            return ( $UserData{UserID}, $UserData{UserType} );
        }
        elsif ( $UserData{UserLogin} && $UserData{UserType} eq 'Customer' ) {

            # if UserCustomerLogin
            return ( $UserData{UserLogin}, $UserData{UserType} );
        }
        return 0;
    }

    if ( defined $Param{Data}->{UserLogin} && $Param{Data}->{UserLogin} ) {

        my $UserID = $Self->_AuthUser(%Param);

        # if UserLogin
        if ($UserID) {
            return ( $UserID, 'Agent' );
        }
    }
    elsif ( defined $Param{Data}->{CustomerUserLogin} && $Param{Data}->{CustomerUserLogin} ) {

        my $CustomerUserID = $Self->_AuthCustomerUser(%Param);

        # if UserCustomerLogin
        if ($CustomerUserID) {
            return ( $CustomerUserID, 'Customer' );
        }
    }

    return 0;
}

=item ReturnError()

helper function to return an error message.

    my $Return = $CommonObject->ReturnError(
        ErrorCode    => Ticket.AccessDenied,
        ErrorMessage => 'You dont have rights to access this ticket',
    );

=cut

sub ReturnError {
    my ( $Self, %Param ) = @_;

    $Self->{DebuggerObject}->Error(
        Summary => $Param{ErrorCode},
        Data    => $Param{ErrorMessage},
    );

    # return structure
    return {
        Success      => 1,
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
        Data         => {
            Error => {
                ErrorCode    => $Param{ErrorCode},
                ErrorMessage => $Param{ErrorMessage},
            },
        },
    };
}

=begin Internal:

=item _AuthUser()

performs user authentication

    my $UserID = $CommonObject->_AuthUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
    );

    returns

    $UserID = 1;                                # the UserID from login or session data

=cut

sub _AuthUser {
    my ( $Self, %Param ) = @_;

    my $ReturnData = 0;

    # get params
    my $PostUser = $Param{Data}->{UserLogin} || '';
    my $PostPw   = $Param{Data}->{Password}  || '';

    # check submitted data
    my $User = $Self->{AuthObject}->Auth(
        User => $PostUser,
        Pw   => $PostPw,
    );

    # login is valid
    if ($User) {

        # get UserID
        my $UserID = $Self->{UserObject}->UserLookup(
            UserLogin => $User,
        );
        $ReturnData = $UserID;
    }

    return $ReturnData;
}

=item _AuthCustomerUser()

performs customer user authentication

    my $UserID = $CommonObject->_AuthCustomerUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
    );

    returns

    $UserID = 1;                               # the UserID from login or session data

=cut

sub _AuthCustomerUser {
    my ( $Self, %Param ) = @_;

    my $ReturnData = $Param{Data}->{CustomerUserLogin} || 0;

    # get params
    my $PostUser = $Param{Data}->{CustomerUserLogin} || '';
    my $PostPw   = $Param{Data}->{Password}          || '';

    # check submitted data
    my $User = $Self->{CustomerAuthObject}->Auth(
        User => $PostUser,
        Pw   => $PostPw,
    );

    # login is invalid
    if ( !$User ) {
        $ReturnData = 0;
    }

    return $ReturnData;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
