# --
# Kernel/GenericInterface/Operation/Session/Common.pm - common operation functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Session::Common;

use strict;
use warnings;

use vars qw(@ISA);

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

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Operation::Session::Common;

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
    my $SessionCommonObject = Kernel::GenericInterface::Operation::Session::Common->new(
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

=cut
