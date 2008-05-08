# --
# Kernel/System/CustomerAuth/HTTPBasicAuth.pm - provides the $ENV authntication
# authentification
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: HTTPBasicAuth.pm,v 1.11 2008-05-08 09:36:20 mh Exp $
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
# If use isn't login through apache ($ENV{REMOTE_USER} or $ENV{HTTP_REMOTE_USER})
# $Self->{CustomerPanelLoginURL} = 'http://host.example.com/not-authorised-for-otrs.html';
#
# $Self->{CustomerPanelLogoutURL} = 'http://host.example.com/thanks-for-using-otrs.html';
# --

package Kernel::System::CustomerAuth::HTTPBasicAuth;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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
    my $User       = $ENV{REMOTE_USER} || $ENV{HTTP_REMOTE_USER};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    if ($User) {
        my $Replace = $Self->{ConfigObject}->Get(
            'Customer::AuthModule::HTTPBasicAuth::Replace' . $Self->{Count},
        );
        if ($Replace) {
            $User =~ s/^\Q$Replace\E//;
        }
        my $ReplaceRegExp = $Self->{ConfigObject}->Get(
            'Customer::AuthModule::HTTPBasicAuth::ReplaceRegExp' . $Self->{Count},
        );
        if ($ReplaceRegExp) {
            $User =~ s/$ReplaceRegExp/$1/;
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentification ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "User: No \$ENV{REMOTE_USER} or \$ENV{HTTP_REMOTE_USER} !(REMOTE_ADDR: $RemoteAddr).",
        );
        return;
    }
}

1;
