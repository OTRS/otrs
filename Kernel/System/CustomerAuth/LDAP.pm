# --
# Kernel/System/CustomerAuth/LDAP.pm - provides the ldap authentification
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAP.pm,v 1.10 2005-11-13 21:35:51 martin Exp $
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
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    $Self->{Host} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Host')
     || die "Need Customer::AuthModule::LDAPHost in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::BaseDN')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{UID} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UID')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserDN') || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserPw') || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::GroupDN') || '';
    $Self->{AccessAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::AccessAttr') || '';
    $Self->{UserAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UserAttr') || 'DN';
    $Self->{UserSuffix} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UserSuffix') || '';

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::AlwaysFilter') || '';
    # Net::LDAP new params
    if ($Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Params')) {
        $Self->{Params} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Params');
    }
    else {
        $Self->{Params} = {};
    }

    return $Self;
}
# --
sub GetOption {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{What}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need What!");
        return;
    }
    # module options
    my %Option = (
        PreAuth => 0,
    );
    # return option
    return $Option{$Param{What}};
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(User Pw)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get params
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;
    # add user suffix
    if ($Self->{UserSuffix}) {
        $Param{User} .= $Self->{UserSuffix};
        # just in case for debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "CustomerUser: ($Param{User}) added $Self->{UserSuffix} to username!",
            );
        }
    }
    # just in case for debug!
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: '$Param{User}' tried to authentificate with Pw: '$Param{Pw}' (REMOTE_ADDR: $RemoteAddr)",
        );
    }
    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new($Self->{Host}, %{$Self->{Params}}) or die "$@";
    if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }
    # build filter
    my $Filter = "($Self->{UID}=$Param{User})";
    # prepare filter
    if ($Self->{AlwaysFilter}) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }
    # perform user search
    my $Result = $LDAP->search (
        base   => $Self->{BaseDN},
        filter => $Filter,
    );
    # get whole user dn
    my $UserDN = '';
    foreach my $Entry ($Result->all_entries) {
        $UserDN = $Entry->dn();
    }
    # log if there is no LDAP user entry
    if (!$UserDN) {
        # failed login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $Param{User} authentification failed, no LDAP entry found!".
            "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return;
    }

    # check if user need to be in a group!
    if ($Self->{AccessAttr} && $Self->{GroupDN}) {
        # just in case for debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "check for groupdn!",
            );
        }
        # search if we're allowed to
        my $Filter2 = '';
        if ($Self->{UserAttr} eq 'DN') {
            $Filter2 = "($Self->{AccessAttr}=$UserDN)";
        }
        else {
            $Filter2 = "($Self->{AccessAttr}=$Param{User})";
        }
        my $Result2 = $LDAP->search (
            base   => $Self->{GroupDN},
            filter => $Filter2
        );
        # extract it
        my $GroupDN = '';
        foreach my $Entry ($Result2->all_entries) {
            $GroupDN = $Entry->dn();
        }
        # log if there is no LDAP entry
        if (!$GroupDN) {
            # failed login note
            $Self->{LogObject}->Log(
              Priority => 'notice',
              Message => "CustomerUser: $Param{User} authentification failed, no LDAP group entry found".
                "GroupDN='$Self->{GroupDN}', Filter='$Filter2'! (REMOTE_ADDR: $RemoteAddr).",
            );
            # take down session
            $LDAP->unbind;
            return;
        }
    }

    # bind with user data -> real user auth.
    $Result = $LDAP->bind(dn => $UserDN, password => $Param{Pw});
    if ($Result->code) {
        # failed login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $Param{User} authentification failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return;
    }
    else {
        # login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $Param{User} authentification ok (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return $Param{User};
    }
}
# --

1;
