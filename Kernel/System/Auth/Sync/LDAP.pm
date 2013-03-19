# --
# Kernel/System/Auth/Sync/LDAP.pm - provides the ldap sync
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth::Sync::LDAP;

use strict;
use warnings;

use Net::LDAP;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(LogObject ConfigObject DBObject UserObject GroupObject EncodeObject MainObject)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    if ( !$Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Host' . $Param{Count} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::Host$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( !defined $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::BaseDN' . $Param{Count} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::BaseDN$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( !$Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UID' . $Param{Count} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::UID$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    $Self->{Count}  = $Param{Count} || '';
    $Self->{Die}    = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Die' . $Param{Count} );
    $Self->{Host}   = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Host' . $Param{Count} );
    $Self->{BaseDN} = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::BaseDN' . $Param{Count} );
    $Self->{UID}    = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UID' . $Param{Count} );
    $Self->{SearchUserDN}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::SearchUserDN' . $Param{Count} ) || '';
    $Self->{SearchUserPw}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::SearchUserPw' . $Param{Count} ) || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::GroupDN' . $Param{Count} )
        || '';
    $Self->{AccessAttr}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::AccessAttr' . $Param{Count} )
        || 'memberUid';
    $Self->{UserAttr}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UserAttr' . $Param{Count} )
        || 'DN';
    $Self->{DestCharset}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Charset' . $Param{Count} )
        || 'utf-8';

    # ldap filter always used
    $Self->{AlwaysFilter}
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::AlwaysFilter' . $Param{Count} ) || '';

    # Net::LDAP new params
    if ( $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Params' . $Param{Count} ) ) {
        $Self->{Params}
            = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Params' . $Param{Count} );
    }
    else {
        $Self->{Params} = {};
    }

    return $Self;
}

sub Sync {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User!' );
        return;
    }
    $Param{User} = $Self->_ConvertTo( $Param{User}, 'utf-8' );

    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';

    # remove leading and trailing spaces
    $Param{User} =~ s{ \A \s* ( [^\s]+ ) \s* \z }{$1}xms;

    # just in case for debug!
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: '$Param{User}' tried to sync (REMOTE_ADDR: $RemoteAddr)",
        );
    }

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new( $Self->{Host}, %{ $Self->{Params} } );
    if ( !$LDAP ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{Host}: $@";
        }

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't connect to $Self->{Host}: $@",
        );
        return;
    }
    my $Result;
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result = $LDAP->bind( dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw} );
    }
    else {
        $Result = $LDAP->bind();
    }
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'First bind failed! ' . $Result->error(),
        );
        return;
    }

    # user quote
    my $UserQuote = $Param{User};
    $UserQuote =~ s{ ( [\\()] ) }{\\$1}xmsg;

    # build filter
    my $Filter = "($Self->{UID}=$UserQuote)";

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # perform user search
    $Result = $LDAP->search(
        base   => $Self->{BaseDN},
        filter => $Filter,
    );
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error(),
        );
        return;
    }

    # get whole user dn
    my $UserDN;
    for my $Entry ( $Result->all_entries() ) {
        $UserDN = $Entry->dn();
    }

    # log if there is no LDAP user entry
    if ( !$UserDN ) {

        # failed login note
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $Param{User} sync failed, no LDAP entry found!"
                . "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );

        # take down session
        $LDAP->unbind();
        return;
    }

    # DN quote
    my $UserDNQuote = $UserDN;
    $UserDNQuote =~ s{ ( [\\()] ) }{\\$1}xmsg;

    # get current user id
    my $UserID = $Self->{UserObject}->UserLookup( UserLogin => $Param{User} );

    # system permissions
    my %PermissionsEmpty =
        map { $_ => 0 } @{ $Self->{ConfigObject}->Get('System::Permission') };

    # get system groups and create lookup
    my %SystemGroups = $Self->{GroupObject}->GroupList( Valid => 1 );
    my %SystemGroupsByName = reverse %SystemGroups;

    # get system roles and create lookup
    my %SystemRoles = $Self->{GroupObject}->RoleList( Valid => 1 );
    my %SystemRolesByName = reverse %SystemRoles;

    # sync user from ldap
    my $UserSyncMap
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UserSyncMap' . $Self->{Count} );
    if ($UserSyncMap) {

        # get whole user dn
        my %SyncUser;
        for my $Entry ( $Result->all_entries() ) {
            for my $Key ( sort keys %{$UserSyncMap} ) {

                # detect old config setting
                if ( $Key =~ m{ \A (?: Firstname | Lastname | Email ) }xms ) {
                    $Key = 'User' . $Key;
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => 'Old config setting detected, please use the new one '
                            . 'from Kernel/Config/Defaults.pm (User* has been added!).',
                    );
                }
                $SyncUser{$Key} = $Entry->get_value( $UserSyncMap->{$Key} );

                # e. g. set utf-8 flag
                $SyncUser{$Key} = $Self->_ConvertFrom(
                    $SyncUser{$Key},
                    'utf-8',
                );
            }
            if ( $Entry->get_value('userPassword') ) {
                $SyncUser{UserPw} = $Entry->get_value('userPassword');

                # e. g. set utf-8 flag
                $SyncUser{UserPw} = $Self->_ConvertFrom(
                    $SyncUser{UserPw},
                    'utf-8',
                );
            }
        }

        # add new user
        if ( %SyncUser && !$UserID ) {
            $UserID = $Self->{UserObject}->UserAdd(
                UserSalutation => 'Mr/Mrs',
                UserLogin      => $Param{User},
                %SyncUser,
                UserType     => 'User',
                ValidID      => 1,
                ChangeUserID => 1,
            );
            if ( !$UserID ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't create user '$Param{User}' ($UserDN) in RDBMS!",
                );

                # take down session
                $LDAP->unbind();
                return;
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Initial data for '$Param{User}' ($UserDN) created in RDBMS.",
                );

                # sync initial groups
                my $UserSyncInitialGroups = $Self->{ConfigObject}->Get(
                    'AuthSyncModule::LDAP::UserSyncInitialGroups' . $Self->{Count}
                );
                if ($UserSyncInitialGroups) {
                    GROUP:
                    for my $Group ( @{$UserSyncInitialGroups} ) {

                        # only for valid groups
                        if ( !$SystemGroupsByName{$Group} ) {
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message =>
                                    "Invalid group '$Group' in "
                                    . "'AuthSyncModule::LDAP::UserSyncInitialGroups"
                                    . "$Self->{Count}'!",
                            );
                            next GROUP;
                        }

                        $Self->{GroupObject}->GroupMemberAdd(
                            GID        => $SystemGroupsByName{$Group},
                            UID        => $UserID,
                            Permission => { rw => 1, },
                            UserID     => 1,
                        );
                    }
                }
            }
        }

        # update user attributes (only if changed)
        elsif (%SyncUser) {

            # get user data
            my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );

            # check for changes
            my $AttributeChange;
            ATTRIBUTE:
            for my $Attribute ( sort keys %SyncUser ) {
                next ATTRIBUTE if $SyncUser{$Attribute} eq $UserData{$Attribute};
                $AttributeChange = 1;
                last ATTRIBUTE;
            }

            if ($AttributeChange) {
                $Self->{UserObject}->UserUpdate(
                    %UserData,
                    UserID    => $UserID,
                    UserLogin => $Param{User},
                    %SyncUser,
                    UserType     => 'User',
                    ChangeUserID => 1,
                );
            }
        }
    }

    # variable to store group permissions from ldap
    my %GroupPermissionsFromLDAP;

    # sync ldap group 2 otrs group permissions
    my $UserSyncGroupsDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncGroupsDefinition' . $Self->{Count}
    );
    if ($UserSyncGroupsDefinition) {

        # read and remember groups from ldap
        GROUPDN:
        for my $GroupDN ( sort keys %{$UserSyncGroupsDefinition} ) {

            # search if we are allowed to
            my $Filter;
            if ( $Self->{UserAttr} eq 'DN' ) {
                $Filter = "($Self->{AccessAttr}=$UserDNQuote)";
            }
            else {
                $Filter = "($Self->{AccessAttr}=$UserQuote)";
            }
            my $Result = $LDAP->search(
                base   => $GroupDN,
                filter => $Filter,
            );
            if ( $Result->code() ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Search failed! ($GroupDN) filter='$Filter' " . $Result->error(),
                );
                next GROUPDN;
            }

            # extract it
            my $Valid;
            for my $Entry ( $Result->all_entries() ) {
                $Valid = $Entry->dn();
            }

            # log if there is no LDAP entry
            if ( !$Valid ) {

                # failed login note
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "User: $Param{User} not in "
                        . "GroupDN='$GroupDN', Filter='$Filter'! (REMOTE_ADDR: $RemoteAddr).",
                );
                next GROUPDN;
            }

            # remember group permissions
            my %SyncGroups = %{ $UserSyncGroupsDefinition->{$GroupDN} };
            SYNCGROUP:
            for my $SyncGroup ( sort keys %SyncGroups ) {

                # only for valid groups
                if ( !$SystemGroupsByName{$SyncGroup} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message =>
                            "Invalid group '$SyncGroup' in "
                            . "'AuthSyncModule::LDAP::UserSyncGroupsDefinition"
                            . "$Self->{Count}'!",
                    );
                    next SYNCGROUP;
                }

                # set/overwrite remembered permissions

                # if rw permission exists, discard all other permissions
                if ( $SyncGroups{$SyncGroup}->{rw} ) {
                    $GroupPermissionsFromLDAP{ $SystemGroupsByName{$SyncGroup} } = {
                        rw => 1,
                    };
                    next SYNCGROUP;
                }

                # remember permissions as provided
                $GroupPermissionsFromLDAP{ $SystemGroupsByName{$SyncGroup} } = {
                    %PermissionsEmpty,
                    %{ $SyncGroups{$SyncGroup} },
                };
            }
        }
    }

    # sync ldap attribute 2 otrs group permissions
    my $UserSyncAttributeGroupsDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncAttributeGroupsDefinition' . $Self->{Count}
    );
    if ($UserSyncAttributeGroupsDefinition) {

        # build filter
        my $Filter = "($Self->{UID}=$UserQuote)";

        # perform search
        $Result = $LDAP->search(
            base   => $Self->{BaseDN},
            filter => $Filter,
        );
        if ( $Result->code() ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error(),
            );
        }
        else {
            my %SyncConfig = %{$UserSyncAttributeGroupsDefinition};
            for my $Attribute ( sort keys %SyncConfig ) {

                my %AttributeValues = %{ $SyncConfig{$Attribute} };
                ATTRIBUTEVALUE:
                for my $AttributeValue ( sort keys %AttributeValues ) {

                    for my $Entry ( $Result->all_entries() ) {

                        # Check if configured value exists in values of group attribute
                        # If yes, add sync groups to the user
                        my $GotValue;
                        my @Values = $Entry->get_value($Attribute);
                        VALUE:
                        for my $Value (@Values) {
                            next VALUE if $Value !~ m{ \A \Q$AttributeValue\E \z }xmsi;
                            $GotValue = 1;
                            last VALUE;
                        }
                        next ATTRIBUTEVALUE if !$GotValue;

                        # remember group permissions
                        my %SyncGroups = %{ $AttributeValues{$AttributeValue} };
                        SYNCGROUP:
                        for my $SyncGroup ( sort keys %SyncGroups ) {

                            # only for valid groups
                            if ( !$SystemGroupsByName{$SyncGroup} ) {
                                $Self->{LogObject}->Log(
                                    Priority => 'notice',
                                    Message =>
                                        "Invalid group '$SyncGroup' in "
                                        . "'AuthSyncModule::LDAP::UserSyncAttributeGroupsDefinition"
                                        . "$Self->{Count}'!",
                                );
                                next SYNCGROUP;
                            }

                            # set/overwrite remembered permissions

                            # if rw permission exists, discard all other permissions
                            if ( $SyncGroups{$SyncGroup}->{rw} ) {
                                $GroupPermissionsFromLDAP{ $SystemGroupsByName{$SyncGroup} } = {
                                    rw => 1,
                                };
                                next SYNCGROUP;
                            }

                            # remember permissions as provided
                            $GroupPermissionsFromLDAP{ $SystemGroupsByName{$SyncGroup} } = {
                                %PermissionsEmpty,
                                %{ $SyncGroups{$SyncGroup} },
                            };
                        }
                    }
                }
            }
        }
    }

    # compare group permissions from ldap with current user group permissions
    my %GroupPermissionsChanged;
    if (%GroupPermissionsFromLDAP) {
        PERMISSIONTYPE:
        for my $PermissionType ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {

            # get current permission for type
            my %GroupPermissions = $Self->{GroupObject}->GroupGroupMemberList(
                UserID => $UserID,
                Type   => $PermissionType,
                Result => 'HASH',
            );

            GROUPID:
            for my $GroupID ( sort keys %SystemGroups ) {

                my $OldPermission = $GroupPermissions{$GroupID};
                my $NewPermission = $GroupPermissionsFromLDAP{$GroupID}->{$PermissionType};

                # if old and new permission for group/type match, do nothing
                if (
                    ( $OldPermission && $NewPermission )
                    ||
                    ( !$OldPermission && !$NewPermission )
                    )
                {
                    next GROUPID;
                }

                # permission for group/type differs - remember
                $GroupPermissionsChanged{$GroupID}->{$PermissionType} = $NewPermission;
            }
        }
    }

    # update changed group permissions
    if (%GroupPermissionsChanged) {
        for my $GroupID ( sort keys %GroupPermissionsChanged ) {

            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "User: '$Param{User}' sync ldap group $SystemGroups{$GroupID}!",
            );
            $Self->{GroupObject}->GroupMemberAdd(
                GID        => $GroupID,
                UID        => $UserID,
                Permission => $GroupPermissionsChanged{$GroupID} || \%PermissionsEmpty,
                UserID     => 1,
            );
        }
    }

    # variable to store role permissions from ldap
    my %RolePermissionsFromLDAP;

    # sync ldap group 2 otrs role permissions
    my $UserSyncRolesDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncRolesDefinition' . $Self->{Count}
    );
    if ($UserSyncRolesDefinition) {

        # read and remember roles from ldap
        GROUPDN:
        for my $GroupDN ( sort keys %{$UserSyncRolesDefinition} ) {

            # search if we're allowed to
            my $Filter;
            if ( $Self->{UserAttr} eq 'DN' ) {
                $Filter = "($Self->{AccessAttr}=$UserDNQuote)";
            }
            else {
                $Filter = "($Self->{AccessAttr}=$UserQuote)";
            }
            my $Result = $LDAP->search(
                base   => $GroupDN,
                filter => $Filter,
            );
            if ( $Result->code() ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Search failed! ($GroupDN) filter='$Filter' " . $Result->error(),
                );
                next GROUPDN;
            }

            # extract it
            my $Valid;
            for my $Entry ( $Result->all_entries() ) {
                $Valid = $Entry->dn();
            }

            # log if there is no LDAP entry
            if ( !$Valid ) {

                # failed login note
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "User: $Param{User} not in "
                        . "GroupDN='$GroupDN', Filter='$Filter'! (REMOTE_ADDR: $RemoteAddr).",
                );
                next GROUPDN;
            }

            # remember role permissions
            my %SyncRoles = %{ $UserSyncRolesDefinition->{$GroupDN} };
            SYNCROLE:
            for my $SyncRole ( sort keys %SyncRoles ) {

                # only for valid roles
                if ( !$SystemRolesByName{$SyncRole} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message =>
                            "Invalid role '$SyncRole' in "
                            . "'AuthSyncModule::LDAP::UserSyncRolesDefinition"
                            . "$Self->{Count}'!",
                    );
                    next SYNCROLE;
                }

                # set/overwrite remembered permissions
                $RolePermissionsFromLDAP{ $SystemRolesByName{$SyncRole} } =
                    $SyncRoles{$SyncRole};
            }
        }
    }

    # sync ldap attribute 2 otrs role permissions
    my $UserSyncAttributeRolesDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncAttributeRolesDefinition' . $Self->{Count}
    );
    if ($UserSyncAttributeRolesDefinition) {

        # build filter
        my $Filter = "($Self->{UID}=$UserQuote)";

        # perform search
        $Result = $LDAP->search(
            base   => $Self->{BaseDN},
            filter => $Filter,
        );
        if ( $Result->code() ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error(),
            );
        }
        else {
            my %SyncConfig = %{$UserSyncAttributeRolesDefinition};
            for my $Attribute ( sort keys %SyncConfig ) {

                my %AttributeValues = %{ $SyncConfig{$Attribute} };
                ATTRIBUTEVALUE:
                for my $AttributeValue ( sort keys %AttributeValues ) {

                    for my $Entry ( $Result->all_entries() ) {

                        # Check if configured value exists in values of role attribute
                        # If yes, add sync roles to the user
                        my $GotValue;
                        my @Values = $Entry->get_value($Attribute);
                        VALUE:
                        for my $Value (@Values) {
                            next VALUE if $Value !~ m{ \A \Q$AttributeValue\E \z }xmsi;
                            $GotValue = 1;
                            last VALUE;
                        }
                        next ATTRIBUTEVALUE if !$GotValue;

                        # remember role permissions
                        my %SyncRoles = %{ $AttributeValues{$AttributeValue} };
                        SYNCROLE:
                        for my $SyncRole ( sort keys %SyncRoles ) {

                            # only for valid roles
                            if ( !$SystemRolesByName{$SyncRole} ) {
                                $Self->{LogObject}->Log(
                                    Priority => 'notice',
                                    Message =>
                                        "Invalid role '$SyncRole' in "
                                        . "'AuthSyncModule::LDAP::UserSyncAttributeRolesDefinition"
                                        . "$Self->{Count}'!",
                                );
                                next SYNCROLE;
                            }

                            # set/overwrite remembered permissions
                            $RolePermissionsFromLDAP{ $SystemRolesByName{$SyncRole} } =
                                $SyncRoles{$SyncRole};
                        }
                    }
                }
            }
        }
    }

    # compare role permissions from ldap with current user role permissions and update if necessary
    if (%RolePermissionsFromLDAP) {

        # get current user roles
        my %UserRoles = $Self->{GroupObject}->GroupUserRoleMemberList(
            UserID => $UserID,
            Result => 'HASH',
        );

        ROLEID:
        for my $RoleID ( sort keys %SystemRoles ) {

            # if old and new permission for role matches, do nothing
            if (
                ( $UserRoles{$RoleID} && $RolePermissionsFromLDAP{$RoleID} )
                ||
                ( !$UserRoles{$RoleID} && !$RolePermissionsFromLDAP{$RoleID} )
                )
            {
                next ROLEID;
            }

            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "User: '$Param{User}' sync ldap role $SystemRoles{$RoleID}!",
            );
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $UserID,
                RID    => $RoleID,
                Active => $RolePermissionsFromLDAP{$RoleID} || 0,
                UserID => 1,
            );
        }
    }

    # take down session
    $LDAP->unbind();

    return $Param{User};
}

sub _ConvertTo {
    my ( $Self, $Text, $Charset ) = @_;

    return if !defined $Text;

    if ( !$Charset || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->EncodeInput( \$Text );
        return $Text;
    }

    # convert from input charset ($Charset) to directory charset ($Self->{DestCharset})
    return $Self->{EncodeObject}->Convert(
        Text => $Text,
        From => $Charset,
        To   => $Self->{DestCharset},
    );
}

sub _ConvertFrom {
    my ( $Self, $Text, $Charset ) = @_;

    return if !defined $Text;

    if ( !$Charset || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->EncodeInput( \$Text );
        return $Text;
    }

    # convert from directory charset ($Self->{DestCharset}) to input charset ($Charset)
    return $Self->{EncodeObject}->Convert(
        Text => $Text,
        From => $Self->{DestCharset},
        To   => $Charset,
    );
}

1;
