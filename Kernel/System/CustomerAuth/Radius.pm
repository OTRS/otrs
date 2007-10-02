# --
# Kernel/System/CustomerAuth/Radius.pm - provides the radius authentification
# based on Martin Edenhofer's Kernel::System::Auth::DB
# Copyright (C) 2004 Andreas Jobs <Andreas.Jobs+dev@ruhr-uni-bochum.de>
# --
# $Id: Radius.pm,v 1.7 2007-10-02 10:36:20 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerAuth::Radius;

use strict;
use warnings;

use Authen::Radius;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get config
    $Self->{Die}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::Radius::Die' . $Param{Count} );

    # get user table
    $Self->{RadiusHost}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::Radius::Host' . $Param{Count} )
        || die "Need Customer::AuthModule::Radius::Host$Param{Count} in Kernel/Config.pm";
    $Self->{RadiusSecret}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::Radius::Password' . $Param{Count} )
        || die "Need Customer::AuthModule::Radius::Password$Param{Count} in Kernel/Config.pm";

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need What!" );
        return;
    }

    # module options
    my %Option = ( PreAuth => 0, );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User!" );
        return;
    }

    # get params
    my $User       = $Param{User}      || '';
    my $Pw         = $Param{Pw}        || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID     = '';
    my $GetPw      = '';

    # just in case for debug!
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: '$User' tried to authentificate with Pw: '$Pw' ($RemoteAddr)",
        );
    }

    # just a note
    if ( !$User ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "No User given!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # just a note
    if ( !$Pw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentification without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # Create a radius object
    my $Radius
        = Authen::Radius->new( Host => $Self->{RadiusHost}, Secret => $Self->{RadiusSecret} );
    if ( !$Radius ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{RadiusHost}: $@";
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{RadiusHost}: $@",
            );
            return;
        }
    }
    my $AuthResult = $Radius->check_pwd( $User, $Pw );

    # login note
    if ( defined($AuthResult) && $AuthResult == 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentification ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }

    # just a note
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentification with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }
}

1;
