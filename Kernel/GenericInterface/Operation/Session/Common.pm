# --
# Kernel/GenericInterface/Operation/Session/Common.pm - common operation functions
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.2 2012-01-25 17:29:13 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Session::Common;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::User;
use Kernel::System::Auth;
use Kernel::System::Group;
use Kernel::System::AuthSession;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerAuth;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::GenericInterface::Operation::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you do not need to instantiate this object directly.
It will be passed to all Operation backends so that they can
take advantage of it.

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
    $Self->{SessionObject} = Kernel::System::AuthSession->new( %{$Self} );
    $Self->{UserObject}    = Kernel::System::User->new( %{$Self} );
    $Self->{GroupObject}   = Kernel::System::Group->new( %{$Self} );
    $Self->{AuthObject}    = Kernel::System::Auth->new( %{$Self} );

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{CustomerAuthObject} = Kernel::System::CustomerAuth->new( %{$Self} );

    return $Self;
}

=item CreateSessionID()

performs user authentication and return a new SessionID value

    my $SessionID = $CommonObject->CreateSessionID(
        Data {
            UserLogin         => 'Agent1',
            CustomerUserLogin => 'Customer1',       # optional, provide UserLogin or
                                                    #   CustomerUserLogin
            Password          => 'some password',   # plain text password
        }
    );

Returns undef on failure or

    $SessionID = 'AValidSessionIDValue';         # the new session id value

=cut

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    my $User;
    my %UserData;
    my $UserType;

    # get params
    my $PostPw = $Param{Data}->{Password} || '';

    if ( defined $Param{Data}->{UserLogin} && $Param{Data}->{UserLogin} ) {

        # if UserLogin
        my $PostUser = $Param{Data}->{UserLogin} || $Param{Data}->{UserLogin} || '';

        # check submitted data
        $User = $Self->{AuthObject}->Auth(
            User => $PostUser,
            Pw   => $PostPw,
        );
        %UserData = $Self->{UserObject}->GetUserData(
            User  => $User,
            Valid => 1,
        );
        $UserType = 'Agent';
    }
    elsif ( defined $Param{Data}->{CustomerUserLogin} && $Param{Data}->{CustomerUserLogin} ) {

        # if UserCustomerLogin
        my $PostUser = $Param{Data}->{CustomerUserLogin} || $Param{Data}->{CustomerUserLogin} || '';

        # check submitted data
        $User = $Self->{CustomerAuthObject}->Auth(
            User => $PostUser,
            Pw   => $PostPw,
        );
        %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User  => $PostUser,
            Valid => 1,
        );
        $UserType = 'Customer';
    }

    # login is invalid
    return if !$User;

    # create new session id
    my $NewSessionID = $Self->{SessionObject}->CreateSessionID(
        %UserData,
        UserLastRequest => $Self->{TimeObject}->SystemTime(),
        UserType        => $UserType,
    );

    return $NewSessionID if ($NewSessionID);

    return;
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

$Revision: 1.2 $ $Date: 2012-01-25 17:29:13 $

=cut
