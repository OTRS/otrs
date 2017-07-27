# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Session::Common;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Session::Common - Base class for Session Operations

=head1 PUBLIC INTERFACE

=head2 CreateSessionID()

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
        my $PostUser = $Param{Data}->{UserLogin} || '';

        # check submitted data
        $User = $Kernel::OM->Get('Kernel::System::Auth')->Auth(
            User => $PostUser,
            Pw   => $PostPw,
        );
        %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            User  => $User,
            Valid => 1,
        );
        $UserType = 'User';
    }
    elsif ( defined $Param{Data}->{CustomerUserLogin} && $Param{Data}->{CustomerUserLogin} ) {

        # if UserCustomerLogin
        my $PostUser = $Param{Data}->{CustomerUserLogin} || '';

        # check submitted data
        $User = $Kernel::OM->Get('Kernel::System::CustomerAuth')->Auth(
            User => $PostUser,
            Pw   => $PostPw,
        );
        %UserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User  => $PostUser,
            Valid => 1,
        );
        $UserType = 'Customer';
    }

    # login is invalid
    return if !$User;

    # create new session id
    my $NewSessionID = $Kernel::OM->Get('Kernel::System::AuthSession')->CreateSessionID(
        %UserData,
        UserLastRequest => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
        UserType        => $UserType,
        SessionSource   => 'GenericInterface',
    );

    return $NewSessionID if ($NewSessionID);

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
