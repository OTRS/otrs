# --
# Kernel/System/Auth/LDAP.pm - provides the ldap authentification 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAP.pm,v 1.2 2002-07-24 08:48:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# --

package Kernel::System::Auth::LDAP;

use strict;
use Net::LDAP;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(User Pw)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get params
    # --
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    # --
    # get ldap preferences
    # --
    my $Host = $Self->{ConfigObject}->Get('AuthModule::LDAP::Host') 
     || die "Need AuthModule::LDAPHost in Kernel/Config.pm";
    my $BaseDN = $Self->{ConfigObject}->Get('AuthModule::LDAP::BaseDN')
     || die "Need AuthModule::LDAPBaseDN in Kernel/Config.pm";
    my $UID = $Self->{ConfigObject}->Get('AuthModule::LDAP::UID')
     || die "Need AuthModule::LDAPBaseDN in Kernel/Config.pm";
    my $SearchUserDN = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserDN') || '';
    my $SearchUserPw = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserPw') || '';

    # --
    # just in case!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{User}' tried to login with Pw: '$Param{Pw}' (REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # --
    # ldap stuff
    # --
    my $LDAP = Net::LDAP->new($Host) or die "$@";
    if (!$LDAP->bind(dn => $SearchUserDN, password => $SearchUserPw)) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }
    # --
    # perform a search
    # --
    my $Result = $LDAP->search ( 
        base   => $BaseDN,
        filter => "($UID=$Param{User})"
    ); 
    # --
    # get whole user dn
    # --
    my $UserDN = '';
    foreach my $Entry ($Result->all_entries) {
        $UserDN = $Entry->dn();
    }
    # --
    # log if there is no LDAP entry
    # --
    if (!$UserDN) {
        # --
        # failed login note
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} login failed, no LDAP entry found! (REMOTE_ADDR: $RemoteAddr).",
        );
        # --
        # take down session
        # --
        $LDAP->unbind;
        return;
    }
    # --
    # bind with user data
    # --
    $Result = $LDAP->bind(dn => $UserDN, password => $Param{Pw});
    if ($Result->code) {
        # --
        # failed login note
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} login failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
        );
        # --
        # take down session
        # --
        $LDAP->unbind;
        return;
    }
    else {
        # --
        # login note
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} logged in (REMOTE_ADDR: $RemoteAddr).",
        );
        # --
        # take down session
        # --
        $LDAP->unbind;
        return 1;
    }
}
# --

1;

