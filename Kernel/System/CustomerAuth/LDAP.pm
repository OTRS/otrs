# --
# Kernel/System/CustomerAuth/LDAP.pm - provides the ldap authentification 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAP.pm,v 1.1 2002-10-20 20:07:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# --

package Kernel::System::CustomerAuth::LDAP;

use strict;
use Net::LDAP;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # --
    # check needed objects
    # --
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # --
    # Debug 0=off 1=on
    # --
    $Self->{Debug} = 0;

    # --
    # get ldap preferences
    # --
    $Self->{Host} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Host')
     || die "Need Customer::AuthModule::LDAPHost in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::BaseDN')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{UID} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UID')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserDN') || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserPw') || '';
   
    return $Self;
}
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
    # just in case!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: '$Param{User}' tried to login with Pw: '$Param{Pw}' (REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # --
    # ldap stuff
    # --
    my $LDAP = Net::LDAP->new($Self->{Host}) or die "$@";
    if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
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
        base   => $Self->{BaseDN},
        filter => "($Self->{UID}=$Param{User})"
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
          Message => "CustomerUser: $Param{User} login failed, no LDAP entry found! (REMOTE_ADDR: $RemoteAddr).",
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
          Message => "CustomerUser: $Param{User} login failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
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
          Message => "CustomerUser: $Param{User} logged in (REMOTE_ADDR: $RemoteAddr).",
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

