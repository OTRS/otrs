# --
# Kernel/System/Auth/HTTPBasicAuth.pm - provides the $ENV{REMOTE_USER} authentification
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: HTTPBasicAuth.pm,v 1.9 2008-02-20 22:05:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
# Note:
#
# If you use this module, you should use as fallback the following
# config settings:
#
# If use isn't login through apache ($ENV{REMOTE_USER})
# $Self->{LoginURL} = 'http://host.example.com/not-authorised-for-otrs.html';
#
# $Self->{LogoutURL} = 'http://host.example.com/thanks-for-using-otrs.html';
# --

package Kernel::System::Auth::HTTPBasicAuth;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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

    $Self->{Count} = $Param{Count} || '';

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
    my %Option = ( PreAuth => 1, );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # get params
    my $User = $ENV{REMOTE_USER};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    if ($User) {
        my $Replace = $Self->{ConfigObject}->Get( 'AuthModule::HTTPBasicAuth::Replace' . $Self->{Count} );
        if ($Replace) {
            $User =~ s/^\Q$Replace\E//;
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: No \$ENV{REMOTE_USER} !(REMOTE_ADDR: $RemoteAddr).",
        );
        return;
    }
}

1;
