# --
# Kernel/System/Auth/LDAP.pm - provides the ldap authentification
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAP.pm,v 1.15 2005-09-19 16:39:43 martin Exp $
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
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject UserObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    $Self->{Host} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Host')
     || die "Need AuthModule::LDAP::Host in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::BaseDN')
     || die "Need AuthModule::LDAP::BaseDN in Kernel/Config.pm";
    $Self->{UID} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UID')
     || die "Need AuthModule::LDAP::UID in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserDN') || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserPw') || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::GroupDN') || '';
    $Self->{AccessAttr} = $Self->{ConfigObject}->Get('AuthModule::LDAP::AccessAttr') || '';
    $Self->{UserAttr} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UserAttr') || 'DN';
    $Self->{UserSuffix} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UserSuffix') || '';

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{ConfigObject}->Get('AuthModule::LDAP::AlwaysFilter') || '';
    # Net::LDAP new params
    if ($Self->{ConfigObject}->Get('AuthModule::LDAP::Params')) {
        $Self->{Params} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Params');
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

    # add user suffix
    if ($Self->{UserSuffix}) {
        $Param{User} .= $Self->{UserSuffix};
        # just in case for debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "User: ($Param{User}) added $Self->{UserSuffix} to username!",
            );
        }
    }
    # just in case for debug!
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{User}' tried to authenticate with Pw: '$Param{Pw}' (REMOTE_ADDR: $RemoteAddr)",
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
          Message => "User: $Param{User} authentication failed, no LDAP entry found!".
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
            filter => $Filter2,
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
              Message => "User: $Param{User} authentication failed, no LDAP group entry found".
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
          Message => "User: $Param{User} ($UserDN) authentication failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return;
    }
    else {
        # maybe check if pw is expired
        # if () {
#           $Self->{LogObject}->Log(
#               Priority => 'info',
#               Message => "Password is expired!",
#           );
#            return;
#        }
        # login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} ($UserDN) authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        # sync user from ldap
        if ($Self->{ConfigObject}->Get('UserSyncLDAPMap')) {
            if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
                $Self->{LogObject}->Log(
                  Priority => 'error',
                  Message => "Sync bind failed!",
                );
            }
            else {
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
                my %SyncUser = ();
                foreach my $Entry ($Result->all_entries) {
                    $UserDN = $Entry->dn();
                    foreach (keys %{$Self->{ConfigObject}->Get('UserSyncLDAPMap')}) {
                        $SyncUser{$_} = $Entry->get_value($Self->{ConfigObject}->Get('UserSyncLDAPMap')->{$_});
                    }
                    if ($Entry->get_value('userPassword')) {
                        $SyncUser{Pw} = $Entry->get_value('userPassword');
                    }
                }
                if (%SyncUser) {
                    my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
                    if (!%UserData) {
                        if ($Self->{UserObject}->UserAdd(
                            Salutation => 'Mr/Mrs',
                            Login => $Param{User},
                            %SyncUser,
                            UserType => 'User',
                            ValidID => 1,
                            UserID => 1,
                        )) {
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message => "Data for '$Param{User} ($UserDN)' created in RDBMS, proceed.",
                            );
                        }
                        else {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message => "Can't create user '$Param{User} ($UserDN)' in RDBMS!",
                            );
                        }
                    }
                    else {
                        $Self->{UserObject}->UserUpdate(
                            ID => $UserData{UserID},
                            Salutation => 'Mr/Mrs',
                            Login => $Param{User},
                            %SyncUser,
                            UserType => 'User',
                            ValidID => 1,
                            UserID => 1,
                        );
                    }
                }
            }
        }
        # take down session
        $LDAP->unbind;
        return $Param{User};
    }
}
# --

1;
