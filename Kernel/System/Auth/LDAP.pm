# --
# Kernel/System/Auth/LDAP.pm - provides the ldap authentification
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: LDAP.pm,v 1.39.2.1 2007-11-06 06:53:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth::LDAP;

use strict;
use warnings;
use Net::LDAP;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.39.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    $Self->{Count} = $Param{Count} || '';
    $Self->{Die} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Die'.$Param{Count});
    if ($Self->{ConfigObject}->Get('AuthModule::LDAP::Host'.$Param{Count})) {
        $Self->{Host} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Host'.$Param{Count});
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need AuthModule::LDAP::Host$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if (defined($Self->{ConfigObject}->Get('AuthModule::LDAP::BaseDN'.$Param{Count}))) {
        $Self->{BaseDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::BaseDN'.$Param{Count});
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need AuthModule::LDAP::BaseDN$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ($Self->{ConfigObject}->Get('AuthModule::LDAP::UID'.$Param{Count})) {
        $Self->{UID} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UID'.$Param{Count});
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need AuthModule::LDAP::UID$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserDN'.$Param{Count}) || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserPw'.$Param{Count}) || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::GroupDN'.$Param{Count}) || '';
    $Self->{AccessAttr} = $Self->{ConfigObject}->Get('AuthModule::LDAP::AccessAttr'.$Param{Count}) || 'memberUid';
    $Self->{UserAttr} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UserAttr'.$Param{Count}) || 'DN';
    $Self->{UserSuffix} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UserSuffix'.$Param{Count}) || '';
    $Self->{UserLowerCase} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UserLowerCase'.$Param{Count}) || 0;
    $Self->{DestCharset} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Charset'.$Param{Count}) || 'utf-8';

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{ConfigObject}->Get('AuthModule::LDAP::AlwaysFilter'.$Param{Count}) || '';
    # Net::LDAP new params
    if ($Self->{ConfigObject}->Get('AuthModule::LDAP::Params'.$Param{Count})) {
        $Self->{Params} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Params'.$Param{Count});
    }
    else {
        $Self->{Params} = {};
    }

    return $Self;
}

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
    $Param{User} = $Self->_ConvertTo($Param{User}, $Self->{ConfigObject}->Get('DefaultCharset'));
    $Param{Pw} = $Self->_ConvertTo($Param{Pw}, $Self->{ConfigObject}->Get('DefaultCharset'));
    # get params
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;

    # Convert username to lower case letters
    if ($Self->{UserLowerCase}) {
        $Param{User} = lc($Param{User});
    }

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
            Message => "User: '$Param{User}' tried to authenticate with Pw: '$Param{Pw}' ".
                "(REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new($Self->{Host}, %{$Self->{Params}});
    if (!$LDAP) {
        if ($Self->{Die}) {
            die "Can't connect to $Self->{Host}: $@";
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't connect to $Self->{Host}: $@",
            );
            return;
        }
    }
    my $Result = '';
    if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
        $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
    }
    else {
        $Result = $LDAP->bind();
    }
    if ($Result->code) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "First bind failed! ".$Result->error(),
        );
        return;
    }
    # user quote
    my $UserQuote = $Param{User};
    $UserQuote =~ s/\\/\\\\/g;
    # build filter
    my $Filter = "($Self->{UID}=$UserQuote)";
    # prepare filter
    if ($Self->{AlwaysFilter}) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }
    # perform user search
    $Result = $LDAP->search (
        base => $Self->{BaseDN},
        filter => $Filter,
    );
    if ($Result->code) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Search failed! ".$Result->error,
        );
        return;
    }
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
    # DN quote
    my $UserDNQuote = $UserDN;
    $UserDNQuote =~ s/\\/\\\\/g;

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
            $Filter2 = "($Self->{AccessAttr}=$UserDNQuote)";
        }
        else {
            $Filter2 = "($Self->{AccessAttr}=$UserQuote)";
        }
        my $Result2 = $LDAP->search (
            base => $Self->{GroupDN},
            filter => $Filter2,
        );
        if ($Result2->code) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Search failed! base='".$Self->{GroupDN}."', filter='".$Filter2."', ".$Result->error,
            );
            return;
        }
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
            Message => "User: $Param{User} ($UserDN) authentication failed: '".$Result->error()."' (REMOTE_ADDR: $RemoteAddr).",
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
#            );
#            return;
#        }
        # login note
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "User: $Param{User} ($UserDN) authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        # sync user from ldap
        if ($Self->{ConfigObject}->Get('UserSyncLDAPMap'.$Self->{Count})) {
            my $Result = '';
            if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
                $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
            }
            else {
                $Result = $LDAP->bind();
            }
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Sync bind failed! ".$Result->error,
                );
                # take down session
                $LDAP->unbind;
                return $Param{User};
            }
            # build filter
            my $Filter = "($Self->{UID}=$UserQuote)";
            # prepare filter
            if ($Self->{AlwaysFilter}) {
                $Filter = "(&$Filter$Self->{AlwaysFilter})";
            }
            # perform user search
            $Result = $LDAP->search (
                base => $Self->{BaseDN},
                filter => $Filter,
            );
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Search failed! (".$Self->{BaseDN}.") filter='$Filter' ".$Result->error,
                );
            }
            # get whole user dn
            my $UserDN = '';
            my %SyncUser = ();
            foreach my $Entry ($Result->all_entries) {
                $UserDN = $Entry->dn();
                foreach my $Key (keys %{$Self->{ConfigObject}->Get('UserSyncLDAPMap'.$Self->{Count})}) {
                    # detect old config setting
                    if ($Key =~ /^(Firstname|Lastname|Email)/) {
                        $Key = "User".$Key;
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message => "Old config setting detected, please use the new one from Kernel/Config/Defaults.pm (User* has been added!).",
                        );
                    }
                    $SyncUser{$Key} = $Entry->get_value($Self->{ConfigObject}->Get('UserSyncLDAPMap'.$Self->{Count})->{$Key});
                    # e. g. set utf-8 flag
                    $SyncUser{$Key} = $Self->_ConvertFrom($SyncUser{$Key}, $Self->{ConfigObject}->Get('DefaultCharset'));
                }
                if ($Entry->get_value('userPassword')) {
                    $SyncUser{Pw} = $Entry->get_value('userPassword');
                    # e. g. set utf-8 flag
                    $SyncUser{Pw} = $Self->_ConvertFrom($SyncUser{Pw}, $Self->{ConfigObject}->Get('DefaultCharset'));
                }
            }

            # sync user
            if (%SyncUser) {
                my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
                if (!%UserData) {
                    my $UserID = $Self->{UserObject}->UserAdd(
                        UserSalutation => 'Mr/Mrs',
                        UserLogin => $Param{User},
                        %SyncUser,
                        UserType => 'User',
                        ValidID => 1,
                        ChangeUserID => 1,
                    );
                    if ($UserID) {
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message => "Initial data for '$Param{User}' ($UserDN) created in RDBMS.",
                        );
                        # sync initial groups
                        if ($Self->{ConfigObject}->Get('UserSyncLDAPGroups'.$Self->{Count})) {
                            my %Groups = $Self->{GroupObject}->GroupList();
                            foreach (@{$Self->{ConfigObject}->Get('UserSyncLDAPGroups'.$Self->{Count})}) {
                                my $GroupID = '';
                                foreach my $GID (keys %Groups) {
                                    if ($Groups{$GID} eq $_) {
                                        $GroupID = $GID;
                                    }
                                }
                                if ($GroupID) {
                                    $Self->{GroupObject}->GroupMemberAdd(
                                        GID => $GroupID,
                                        UID => $UserID,
                                        Permission => {
                                            rw => 1,
                                        },
                                        UserID => 1,
                                    );
                                }
                            }
                        }
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message => "Can't create user '$Param{User}' ($UserDN) in RDBMS!",
                        );
                    }
                }
                else {
                    $Self->{UserObject}->UserUpdate(
                        %UserData,
                        UserID => $UserData{UserID},
                        UserLogin => $Param{User},
                        %SyncUser,
                        UserType => 'User',
                        ChangeUserID => 1,
                    );
                }
            }
        }
        # sync ldap group 2 otrs group permissions
        if ($Self->{ConfigObject}->Get('UserSyncLDAPGroupsDefination'.$Self->{Count})) {
            my $Result = '';
            if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
                $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
            }
            else {
                $Result = $LDAP->bind();
            }
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Sync bind failed! ".$Result->error,
                );
                # take down session
                $LDAP->unbind;
                return $Param{User};
            }
            # get current user data
            my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
            # system permissions
            my %PermissionsEmpty = ();
            foreach (@{$Self->{ConfigObject}->Get('System::Permission'.$Self->{Count})}) {
                $PermissionsEmpty{$_} = 0;
            }
            # remove all group permissions
            my %Groups = $Self->{GroupObject}->GroupList();
            foreach my $GID (keys %Groups) {
                $Self->{GroupObject}->GroupMemberAdd(
                    GID => $GID,
                    UID => $UserData{UserID},
                        Permission => {
                            %PermissionsEmpty,
                        },
                    UserID => 1,
                );
            }
            # group config settings
            foreach my $GroupDN (sort keys %{$Self->{ConfigObject}->Get('UserSyncLDAPGroupsDefination'.$Self->{Count})}) {
                # just in case for debug
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "User: '$Param{User}' sync ldap groups $GroupDN to groups!",
                );
                # search if we're allowed to
                my $Filter = '';
                if ($Self->{UserAttr} eq 'DN') {
                    $Filter = "($Self->{AccessAttr}=$UserDNQuote)";
                }
                else {
                    $Filter = "($Self->{AccessAttr}=$UserQuote)";
                }
                my $Result = $LDAP->search (
                    base => $GroupDN,
                    filter => $Filter,
                );
                if ($Result->code) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Search failed! (".$GroupDN.") filter='$Filter' ".$Result->error,
                    );
                }
                # extract it
                my $Valid = '';
                foreach my $Entry ($Result->all_entries) {
                    $Valid = $Entry->dn();
                }
                # log if there is no LDAP entry
                if (!$Valid) {
                    # failed login note
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message => "User: $Param{User} not in ".
                            "GroupDN='$GroupDN', Filter='$Filter'! (REMOTE_ADDR: $RemoteAddr).",
                    );
                }
                else {
                    # sync groups permissions
                    my %SGroups = %{$Self->{ConfigObject}->Get('UserSyncLDAPGroupsDefination'.$Self->{Count})->{$GroupDN}};
                    foreach my $SGroup (sort keys %SGroups) {
                        my %Permissions = %{$SGroups{$SGroup}};
                        # get group id
                        my $GroupID = '';
                        my %Groups = $Self->{GroupObject}->GroupList();
                        foreach my $GID (keys %Groups) {
                            if ($Groups{$GID} eq $SGroup) {
                                $GroupID = $GID;
                            }
                        }
                        if ($GroupID) {
                            # just in case for debug
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message => "User: '$Param{User}' sync ldap group $GroupDN in $SGroup group!",
                            );
                            $Self->{GroupObject}->GroupMemberAdd(
                                GID => $GroupID,
                                UID => $UserData{UserID},
                                Permission => {
                                    %PermissionsEmpty,
                                    %Permissions,
                                },
                                UserID => 1,
                            );
                        }
                    }
                }
            }
        }
        # sync ldap group 2 otrs role permissions
        if ($Self->{ConfigObject}->Get('UserSyncLDAPRolesDefination'.$Self->{Count})) {
            my $Result = '';
            if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
                $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
            }
            else {
                $Result = $LDAP->bind();
            }
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Sync bind failed! ".$Result->error,
                );
                # take down session
                $LDAP->unbind;
                return $Param{User};
            }
            # get current user data
            my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
            # remove all role permissions
            my %Roles = $Self->{GroupObject}->RoleList();
            foreach my $RID (keys %Roles) {
                $Self->{GroupObject}->GroupUserRoleMemberAdd(
                    UID => $UserData{UserID},
                    RID => $RID,
                    Active => 0,
                    UserID => 1,
                );
            }
            # group config settings
            foreach my $GroupDN (sort keys %{$Self->{ConfigObject}->Get('UserSyncLDAPRolesDefination'.$Self->{Count})}) {
                # just in case for debug
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "User: '$Param{User}' sync ldap groups $GroupDN to roles!",
                );
                # search if we're allowed to
                my $Filter = '';
                if ($Self->{UserAttr} eq 'DN') {
                    $Filter = "($Self->{AccessAttr}=$UserDNQuote)";
                }
                else {
                    $Filter = "($Self->{AccessAttr}=$UserQuote)";
                }
                my $Result = $LDAP->search (
                    base => $GroupDN,
                    filter => $Filter,
                );
                if ($Result->code) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Search failed! (".$GroupDN.") filter='$Filter' ".$Result->error,
                    );
                }
                # extract it
                my $Valid = '';
                foreach my $Entry ($Result->all_entries) {
                    $Valid = $Entry->dn();
                }
                # log if there is no LDAP entry
                if (!$Valid) {
                    # failed login note
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message => "User: $Param{User} not in ".
                            "GroupDN='$GroupDN', Filter='$Filter'! (REMOTE_ADDR: $RemoteAddr).",
                    );
                }
                else {
                    # sync groups permissions
                    my %SRoles = %{$Self->{ConfigObject}->Get('UserSyncLDAPRolesDefination'.$Self->{Count})->{$GroupDN}};
                    foreach my $SRole (sort keys %SRoles) {
                        # get group id
                        my $RoleID = '';
                        my %Roles = $Self->{GroupObject}->RoleList();
                        foreach my $RID (keys %Roles) {
                            if ($Roles{$RID} eq $SRole) {
                                $RoleID = $RID;
                            }
                        }
                        if ($SRoles{$SRole}) {
                            # just in case for debug
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message => "User: '$Param{User}' sync ldap group $GroupDN in $SRole role!",
                            );
                            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                                UID => $UserData{UserID},
                                RID => $RoleID,
                                Active => 1,
                                UserID => 1,
                            );
                        }
                    }
                }
            }
        }
        # sync ldap attribute 2 otrs group permissions
        if ($Self->{ConfigObject}->Get('UserSyncLDAPAttibuteGroupsDefination'.$Self->{Count})) {
            my $Result = '';
            if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
                $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
            }
            else {
                $Result = $LDAP->bind();
            }
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Sync bind failed! ".$Result->error,
                );
                # take down session
                $LDAP->unbind;
                return $Param{User};
            }
            # get current user data
            my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
            # system permissions
            my %PermissionsEmpty = ();
            foreach (@{$Self->{ConfigObject}->Get('System::Permission'.$Self->{Count})}) {
                $PermissionsEmpty{$_} = 0;
            }
            # remove all group permissions
            my %SystemGroups = $Self->{GroupObject}->GroupList();
            foreach my $GID (keys %SystemGroups) {
                $Self->{GroupObject}->GroupMemberAdd(
                    GID => $GID,
                    UID => $UserData{UserID},
                        Permission => {
                            %PermissionsEmpty,
                        },
                    UserID => 1,
                );
            }
            # build filter
            my $Filter = "($Self->{UID}=$UserQuote)";
            # perform search
            $Result = $LDAP->search (
                base => $Self->{BaseDN},
                filter => $Filter,
            );
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Search failed! (".$Self->{BaseDN}.") filter='$Filter' ".$Result->error,
                );
            }
            my %SyncConfig = %{$Self->{ConfigObject}->Get('UserSyncLDAPAttibuteGroupsDefination'.$Self->{Count})};
            foreach my $Attribute (keys %SyncConfig) {
                my %AttributeValues = %{$SyncConfig{$Attribute}};
                foreach my $AttributeValue (keys %AttributeValues) {
                    foreach my $Entry ($Result->all_entries) {
                        # Check all values of group attribute if needed value exists.
                        # If yes, add all groups to the user.
                        my $Sync = 0;
                        my @Attributes = $Entry->get_value($Attribute);
                        for my $Attribute (@Attributes) {
                            if ($Attribute =~ /^\Q$AttributeValue\E$/i) {
                                $Sync = 1;
                                last;
                            }
                        }
                        if ( $Sync ) {
                            my %Groups = %{$AttributeValues{$AttributeValue}};
                            foreach my $Group (keys %Groups) {
                                # get group id
                                my $GroupID = 0;
                                foreach (keys %SystemGroups) {
                                    if ($SystemGroups{$_} eq $Group) {
                                        $GroupID = $_;
                                        last;
                                    }
                                }
                                if ($GroupID) {
                                    # just in case for debug
                                    $Self->{LogObject}->Log(
                                        Priority => 'notice',
                                        Message => "User: '$Param{User}' sync ldap attribute $Attribute=$AttributeValue in $Group group!",
                                    );
                                    $Self->{GroupObject}->GroupMemberAdd(
                                        GID => $GroupID,
                                        UID => $UserData{UserID},
                                        Permission => {
                                            %PermissionsEmpty,
                                            %{$Groups{$Group}},
                                        },
                                        UserID => 1,
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
        # sync ldap attribute 2 otrs role permissions
        if ($Self->{ConfigObject}->Get('UserSyncLDAPAttibuteRolesDefination'.$Self->{Count})) {
            my $Result = '';
            if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
                $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
            }
            else {
                $Result = $LDAP->bind();
            }
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Sync bind failed! ".$Result->error,
                );
                # take down session
                $LDAP->unbind;
                return $Param{User};
            }
            # get current user data
            my %UserData = $Self->{UserObject}->GetUserData(User => $Param{User});
            # remove all role permissions
            my %SystemRoles = $Self->{GroupObject}->RoleList();
            foreach my $RID (keys %SystemRoles) {
                $Self->{GroupObject}->GroupUserRoleMemberAdd(
                    UID => $UserData{UserID},
                    RID => $RID,
                    Active => 0,
                    UserID => 1,
                );
            }
            # build filter
            my $Filter = "($Self->{UID}=$UserQuote)";
            # perform search
            $Result = $LDAP->search (
                base => $Self->{BaseDN},
                filter => $Filter,
            );
            if ($Result->code) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Search failed! (".$Self->{BaseDN}.") filter='$Filter' ".$Result->error,
                );
            }
            my %SyncConfig = %{$Self->{ConfigObject}->Get('UserSyncLDAPAttibuteRolesDefination'.$Self->{Count})};
            foreach my $Attribute (keys %SyncConfig) {
                my %AttributeValues = %{$SyncConfig{$Attribute}};
                foreach my $AttributeValue (keys %AttributeValues) {
                    foreach my $Entry ($Result->all_entries) {
                        # Check all values of roles attribute if needed value exists.
                        # If yes, add all roles to the user.
                        my $Sync = 0;
                        my @Attributes = $Entry->get_value($Attribute);
                        for my $Attribute (@Attributes) {
                            if ($Attribute =~ /^\Q$AttributeValue\E$/i) {
                                $Sync = 1;
                                last;
                            }
                        }
                        if ( $Sync ) {
                            my %Roles = %{$AttributeValues{$AttributeValue}};
                            foreach my $Role (keys %Roles) {
                                # get role id
                                my $RoleID = 0;
                                foreach (keys %SystemRoles) {
                                    if ($SystemRoles{$_} eq $Role) {
                                        $RoleID = $_;
                                        last;
                                    }
                                }
                                if ($RoleID && $Roles{$Role} eq 1) {
                                    # just in case for debug
                                    $Self->{LogObject}->Log(
                                        Priority => 'notice',
                                        Message => "User: '$Param{User}' sync ldap attribute $Attribute=$AttributeValue in $Role role!",
                                    );
                                    $Self->{GroupObject}->GroupUserRoleMemberAdd(
                                        UID => $UserData{UserID},
                                        RID => $RoleID,
                                        Active => 1,
                                        UserID => 1,
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
        # take down session
        $LDAP->unbind;
        return $Param{User};
    }
}

sub _ConvertTo {
    my $Self = shift;
    my $Text = shift;
    my $Charset = shift;
    if (!$Charset || !$Self->{DestCharset}) {
        $Self->{EncodeObject}->Encode(\$Text);
        return $Text;
    }
    if (!defined($Text)) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Self->{DestCharset},
            To => $Charset,
        );
    }
}

sub _ConvertFrom {
    my $Self = shift;
    my $Text = shift;
    my $Charset = shift;
    if (!$Charset || !$Self->{DestCharset}) {
        $Self->{EncodeObject}->Encode(\$Text);
        return $Text;
    }
    if (!defined($Text)) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Self->{DestCharset},
            To => $Charset,
        );
    }
}

1;
