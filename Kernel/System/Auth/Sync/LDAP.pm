# --
# Kernel/System/Auth/Sync/LDAP.pm - provides the ldap sync
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: LDAP.pm,v 1.3 2009-01-12 13:38:51 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Auth::Sync::LDAP;

use strict;
use warnings;
use Net::LDAP;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    $Self->{Count} = $Param{Count} || '';
    $Self->{Die} = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Die' . $Param{Count} );
    if ( $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Host' . $Param{Count} ) ) {
        $Self->{Host} = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::Host' . $Param{Count} );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::Host$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( defined( $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::BaseDN' . $Param{Count} ) ) ) {
        $Self->{BaseDN}
            = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::BaseDN' . $Param{Count} );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::BaseDN$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
    if ( $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UID' . $Param{Count} ) ) {
        $Self->{UID} = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UID' . $Param{Count} );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need AuthSyncModule::LDAP::UID$Param{Count} in Kernel/Config.pm",
        );
        return;
    }
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
    for (qw(User)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Param{User} = $Self->_ConvertTo( $Param{User}, $Self->{ConfigObject}->Get('DefaultCharset') );

    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';

    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;

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
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{Host}: $@",
            );
            return;
        }
    }
    my $Result = '';
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result = $LDAP->bind( dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw} );
    }
    else {
        $Result = $LDAP->bind();
    }
    if ( $Result->code ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'First bind failed! ' . $Result->error(),
        );
        return;
    }

    # user quote
    my $UserQuote = $Param{User};
    $UserQuote =~ s/\\/\\\\/g;
    $UserQuote =~ s/\(/\\(/g;
    $UserQuote =~ s/\)/\\)/g;

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
    if ( $Result->code ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error,
        );
        return;
    }

    # get whole user dn
    my $UserDN = '';
    for my $Entry ( $Result->all_entries ) {
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
        $LDAP->unbind;
        return;
    }

    # DN quote
    my $UserDNQuote = $UserDN;
    $UserDNQuote =~ s/\\/\\\\/g;
    $UserDNQuote =~ s/\(/\\(/g;
    $UserDNQuote =~ s/\)/\\)/g;

    # sync user from ldap
    my $UserSyncMap
        = $Self->{ConfigObject}->Get( 'AuthSyncModule::LDAP::UserSyncMap' . $Self->{Count} );
    if ($UserSyncMap) {

        # get whole user dn
        my %SyncUser = ();
        for my $Entry ( $Result->all_entries ) {
            for my $Key ( keys %{$UserSyncMap} ) {

                # detect old config setting
                if ( $Key =~ /^(Firstname|Lastname|Email)/ ) {
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
                    $Self->{ConfigObject}->Get('DefaultCharset'),
                );
            }
            if ( $Entry->get_value('userPassword') ) {
                $SyncUser{Pw} = $Entry->get_value('userPassword');

                # e. g. set utf-8 flag
                $SyncUser{Pw} = $Self->_ConvertFrom(
                    $SyncUser{Pw},
                    $Self->{ConfigObject}->Get('DefaultCharset')
                );
            }
        }

        # sync user
        if (%SyncUser) {
            my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );
            if ( !%UserData ) {
                my $UserID = $Self->{UserObject}->UserAdd(
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
                        my %Groups = $Self->{GroupObject}->GroupList();
                        for ( @{$UserSyncInitialGroups} ) {
                            my $GroupID = '';
                            for my $GID ( keys %Groups ) {
                                if ( $Groups{$GID} eq $_ ) {
                                    $GroupID = $GID;
                                }
                            }
                            next if !$GroupID;
                            $Self->{GroupObject}->GroupMemberAdd(
                                GID        => $GroupID,
                                UID        => $UserID,
                                Permission => { rw => 1, },
                                UserID     => 1,
                            );
                        }
                    }
                }
            }
            else {
                $Self->{UserObject}->UserUpdate(
                    %UserData,
                    UserID    => $UserData{UserID},
                    UserLogin => $Param{User},
                    %SyncUser,
                    UserType     => 'User',
                    ChangeUserID => 1,
                );
            }
        }
    }

    # sync ldap group 2 otrs group permissions
    my $UserSyncGroupsDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncGroupsDefinition' . $Self->{Count}
    );
    if ($UserSyncGroupsDefinition) {

        # get current user data
        my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );

        # system permissions
        my %PermissionsEmpty = ();
        for ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            $PermissionsEmpty{$_} = 0;
        }

        # remove all group permissions
        my %Groups = $Self->{GroupObject}->GroupList();
        for my $GID ( keys %Groups ) {
            $Self->{GroupObject}->GroupMemberAdd(
                GID        => $GID,
                UID        => $UserData{UserID},
                Permission => \%PermissionsEmpty,
                UserID     => 1,
            );
        }

        # group config settings
        for my $GroupDN ( sort keys %{$UserSyncGroupsDefinition} ) {

            # just in case for debug
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "User: '$Param{User}' sync ldap groups $GroupDN to groups!",
            );

            # search if we're allowed to
            my $Filter = '';
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
            if ( $Result->code ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Search failed! ($GroupDN) filter='$Filter' " . $Result->error,
                );
            }

            # extract it
            my $Valid = '';
            for my $Entry ( $Result->all_entries ) {
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
            }
            else {

                # sync groups permissions
                my %SGroups = %{ $UserSyncGroupsDefinition->{$GroupDN} };
                for my $SGroup ( sort keys %SGroups ) {
                    my %Permissions = %{ $SGroups{$SGroup} };

                    # get group id
                    my $GroupID = '';
                    my %Groups  = $Self->{GroupObject}->GroupList();
                    for my $GID ( keys %Groups ) {
                        if ( $Groups{$GID} eq $SGroup ) {
                            $GroupID = $GID;
                        }
                    }
                    next if !$GroupID;

                    # just in case for debug
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message =>
                            "User: '$Param{User}' sync ldap group $GroupDN in $SGroup group!",
                    );
                    $Self->{GroupObject}->GroupMemberAdd(
                        GID        => $GroupID,
                        UID        => $UserData{UserID},
                        Permission => { %PermissionsEmpty, %Permissions },
                        UserID     => 1,
                    );
                }
            }
        }
    }

    # sync ldap group 2 otrs role permissions
    my $UserSyncRolesDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncRolesDefinition' . $Self->{Count}
    );
    if ($UserSyncRolesDefinition) {

        # get current user data
        my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );

        # remove all role permissions
        my %Roles = $Self->{GroupObject}->RoleList();
        for my $RID ( keys %Roles ) {
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $UserData{UserID},
                RID    => $RID,
                Active => 0,
                UserID => 1,
            );
        }

        # group config settings
        for my $GroupDN ( sort keys %{$UserSyncRolesDefinition} ) {

            # just in case for debug
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "User: '$Param{User}' sync ldap groups $GroupDN to roles!",
            );

            # search if we're allowed to
            my $Filter = '';
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
            if ( $Result->code ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Search failed! ($GroupDN) filter='$Filter' " . $Result->error,
                );
            }

            # extract it
            my $Valid = '';
            for my $Entry ( $Result->all_entries ) {
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
            }
            else {

                # sync groups permissions
                my %SRoles = %{ $UserSyncRolesDefinition->{$GroupDN} };
                for my $SRole ( sort keys %SRoles ) {

                    # get group id
                    my $RoleID = '';
                    my %Roles  = $Self->{GroupObject}->RoleList();
                    for my $RID ( keys %Roles ) {
                        if ( $Roles{$RID} eq $SRole ) {
                            $RoleID = $RID;
                        }
                    }
                    if ( $SRoles{$SRole} ) {

                        # just in case for debug
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message =>
                                "User: '$Param{User}' sync ldap group $GroupDN in $SRole role!",
                        );
                        $Self->{GroupObject}->GroupUserRoleMemberAdd(
                            UID    => $UserData{UserID},
                            RID    => $RoleID,
                            Active => 1,
                            UserID => 1,
                        );
                    }
                }
            }
        }
    }

    # sync ldap attribute 2 otrs group permissions
    $UserSyncGroupsDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncAttributeGroupsDefinition' . $Self->{Count}
    );
    if ($UserSyncGroupsDefinition) {

        # get current user data
        my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );

        # system permissions
        my %PermissionsEmpty = ();
        for ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            $PermissionsEmpty{$_} = 0;
        }

        # remove all group permissions
        my %SystemGroups = $Self->{GroupObject}->GroupList();
        for my $GID ( keys %SystemGroups ) {
            $Self->{GroupObject}->GroupMemberAdd(
                GID        => $GID,
                UID        => $UserData{UserID},
                Permission => {%PermissionsEmpty},
                UserID     => 1,
            );
        }

        # build filter
        my $Filter = "($Self->{UID}=$UserQuote)";

        # perform search
        $Result = $LDAP->search(
            base   => $Self->{BaseDN},
            filter => $Filter,
        );
        if ( $Result->code ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error,
            );
        }
        my %SyncConfig = %{$UserSyncGroupsDefinition};
        for my $Attribute ( keys %SyncConfig ) {
            my %AttributeValues = %{ $SyncConfig{$Attribute} };
            for my $AttributeValue ( keys %AttributeValues ) {
                for my $Entry ( $Result->all_entries ) {

                    # Check all values of group attribute if needed value exists.
                    # If yes, add all groups to the user.
                    my $Sync       = 0;
                    my @Attributes = $Entry->get_value($Attribute);
                    for my $Attribute (@Attributes) {
                        if ( $Attribute =~ /^\Q$AttributeValue\E$/i ) {
                            $Sync = 1;
                            last;
                        }
                    }
                    next if !$Sync;
                    my %Groups = %{ $AttributeValues{$AttributeValue} };
                    for my $Group ( keys %Groups ) {

                        # get group id
                        my $GroupID = 0;
                        for ( keys %SystemGroups ) {
                            if ( $SystemGroups{$_} eq $Group ) {
                                $GroupID = $_;
                                last;
                            }
                        }
                        next if !$GroupID;

                        # just in case for debug
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message =>
                                "User: '$Param{User}' sync ldap attribute $Attribute=$AttributeValue in $Group group!",
                        );
                        $Self->{GroupObject}->GroupMemberAdd(
                            GID        => $GroupID,
                            UID        => $UserData{UserID},
                            Permission => { %PermissionsEmpty, %{ $Groups{$Group} } },
                            UserID     => 1,
                        );
                    }
                }
            }
        }
    }

    # sync ldap attribute 2 otrs role permissions
    $UserSyncRolesDefinition = $Self->{ConfigObject}->Get(
        'AuthSyncModule::LDAP::UserSyncAttributeRolesDefinition' . $Self->{Count}
    );
    if ($UserSyncRolesDefinition) {

        # get current user data
        my %UserData = $Self->{UserObject}->GetUserData( User => $Param{User} );

        # remove all role permissions
        my %SystemRoles = $Self->{GroupObject}->RoleList();
        for my $RID ( keys %SystemRoles ) {
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $UserData{UserID},
                RID    => $RID,
                Active => 0,
                UserID => 1,
            );
        }

        # build filter
        my $Filter = "($Self->{UID}=$UserQuote)";

        # perform search
        $Result = $LDAP->search(
            base   => $Self->{BaseDN},
            filter => $Filter,
        );
        if ( $Result->code ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Search failed! ($Self->{BaseDN}) filter='$Filter' " . $Result->error,
            );
        }
        my %SyncConfig = %{$UserSyncRolesDefinition};
        for my $Attribute ( keys %SyncConfig ) {
            my %AttributeValues = %{ $SyncConfig{$Attribute} };
            for my $AttributeValue ( keys %AttributeValues ) {
                for my $Entry ( $Result->all_entries ) {

                    # Check all values of rolle attribute if needed value exists.
                    # If yes, add all roles to the user.
                    my $Sync       = 0;
                    my @Attributes = $Entry->get_value($Attribute);
                    for my $Attribute (@Attributes) {
                        if ( $Attribute =~ /^\Q$AttributeValue\E$/i ) {
                            $Sync = 1;
                            last;
                        }
                    }
                    next if !$Sync;
                    my %Roles = %{ $AttributeValues{$AttributeValue} };
                    for my $Role ( keys %Roles ) {

                        # get role id
                        my $RoleID = 0;
                        for ( keys %SystemRoles ) {
                            if ( $SystemRoles{$_} eq $Role ) {
                                $RoleID = $_;
                                last;
                            }
                        }
                        if ( $RoleID && $Roles{$Role} eq 1 ) {

                            # just in case for debug
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message =>
                                    "User: '$Param{User}' sync ldap attribute $Attribute=$AttributeValue in $Role role!",
                            );
                            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                                UID    => $UserData{UserID},
                                RID    => $RoleID,
                                Active => 1,
                                UserID => 1,
                            );
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

sub _ConvertTo {
    my ( $Self, $Text, $Charset ) = @_;

    if ( !$Charset || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->Encode( \$Text );
        return $Text;
    }
    if ( !defined($Text) ) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Self->{DestCharset},
            To   => $Charset,
        );
    }
}

sub _ConvertFrom {
    my ( $Self, $Text, $Charset ) = @_;

    if ( !$Charset || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->Encode( \$Text );
        return $Text;
    }
    if ( !defined($Text) ) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Self->{DestCharset},
            To   => $Charset,
        );
    }
}

1;
