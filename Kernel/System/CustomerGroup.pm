# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerGroup;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CustomerCompany',
    'Kernel::System::CustomerGroup',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::CustomerGroup - customer group lib

=head1 DESCRIPTION

All customer group functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CustomerGroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'CustomerGroup';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 GroupMemberAdd()

to add a member to a group

    Permission: ro,move_into,priority,create,rw

    my $Success = $CustomerGroupObject->GroupMemberAdd(
        GID => 12,
        UID => 6,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
        UserID => 123,
    );

=cut

sub GroupMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UID GID UserID Permission)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # check rw rule (set only rw and remove rest, because it's including all in rw)
    if ( $Param{Permission}->{rw} ) {
        $Param{Permission} = { rw => 1 };
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # update permission
    TYPE:
    for my $Type ( sort keys %{ $Param{Permission} } ) {

        # delete existing permission
        $DBObject->Do(
            SQL => 'DELETE FROM group_customer_user WHERE '
                . ' group_id = ? AND user_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{UID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message =>
                    "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$Param{Permission}->{$Type};

        $DBObject->Do(
            SQL => 'INSERT INTO group_customer_user '
                . '(user_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{UID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Type}, \$Param{UserID},
                \$Param{UserID},
            ],
        );
    }

    # delete cache
    # remove complete CustomerGroup cache because
    #   GroupMemberList() cache is CustomerUserID based
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 GroupMemberList()

Get users of the given group.

    my %Users = $CustomerGroupObject->GroupMemberList(
        GroupID        => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'HASH',      # return hash of user id => user name entries
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

or

    my @UserIDs = $CustomerGroupObject->GroupMemberList(
        GroupID        => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'ID',        # return array of user ids
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

or

    my @UserNames = $CustomerGroupObject->GroupMemberList(
        GroupID        => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'Name',        # return array of user names
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

Get groups of given user.

    my %Groups = $CustomerGroupObject->GroupMemberList(
        UserID         => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'HASH',      # return hash of group id => group name entries
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

or

    my @GroupIDs = $CustomerGroupObject->GroupMemberList(
        UserID         => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'ID',        # return array of group ids
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

or

    my @GroupNames = $CustomerGroupObject->GroupMemberList(
        UserID         => '123',
        Type           => 'move_into', # ro|move_into|priority|create|rw
        Result         => 'Name',        # return array of group names
        RawPermissions => 0,           # 0 (return inherited permissions from CustomerCompany), default
                                       # 1 (return only direct permissions)
    );

=cut

sub GroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Result Type)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or GroupID!'
        );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupMemberList::' . $Param{Type} . '::';
    if ( $Param{RawPermissions} ) {
        $CacheKey .= "Raw::";
    }
    if ( $Param{UserID} ) {
        $CacheKey .= "UserID::$Param{UserID}";
    }
    else {
        $CacheKey .= "GroupID::$Param{GroupID}";
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ($Cache) {
        if ( $Param{Result} eq 'HASH' ) {
            return %{$Cache};
        }
        elsif ( $Param{Result} eq 'ID' ) {
            return ( sort keys %{$Cache} );
        }
        elsif ( $Param{Result} eq 'Name' ) {
            return ( sort values %{$Cache} );
        }
        return;
    }

    my %Data;

    # check if customer group feature is active, if not, return all groups
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') ) {

        # get permissions
        %Data = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
    }
    else {
        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # if it's active, return just the permitted groups
        my $SQL =
            'SELECT g.id, g.name, gu.permission_key, gu.permission_value, gu.user_id'
            . ' FROM groups g, group_customer_user gu'
            . ' WHERE g.valid_id IN ( ' . join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() . ')'
            . ' AND g.id = gu.group_id AND gu.permission_value = 1'
            . " AND gu.permission_key IN (?, 'rw')";
        my @Bind = ( \$Param{Type} );

        if ( $Param{UserID} ) {
            $SQL .= ' AND gu.user_id = ?';
            push @Bind, \$Param{UserID};
        }
        else {
            $SQL .= ' AND gu.group_id = ?';
            push @Bind, \$Param{GroupID};
        }

        $DBObject->Prepare(
            SQL  => $SQL,
            Bind => \@Bind,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( $Param{UserID} ) {
                $Data{ $Row[0] } = $Row[1];
            }
            else {
                $Data{ $Row[4] } = $Row[1];
            }
        }

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        for my $Key ( sort keys %Data ) {

            # Bugfix #12285 - Check if customer user is valid.
            if ( $Param{GroupID} ) {

                my %User = $CustomerUserObject->CustomerUserDataGet(
                    User => $Key,
                );

                if ( defined $User{ValidID} && $User{ValidID} != 1 ) {
                    delete $Data{$Key};
                }
            }
        }

        # add customer company groups
        if ( !$Param{RawPermissions} && $Param{UserID} ) {
            my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
                User => $Param{UserID},
            );

            for my $CustomerID (@CustomerIDs) {
                my %CustomerGroups = $Self->GroupCustomerList(
                    CustomerID => $CustomerID,
                    Type       => $Param{Type},
                    Result     => 'HASH',
                );
                GROUPID:
                for my $GroupID ( sort keys %CustomerGroups ) {
                    next GROUPID if $Data{$GroupID};
                    $Data{$GroupID} = $CustomerGroups{$GroupID};
                }
            }
        }
        elsif ( !$Param{RawPermissions} ) {
            my %CustomerGroups = $Self->GroupCustomerList(
                GroupID => $Param{GroupID},
                Type    => $Param{Type},
                Result  => 'HASH',
            );

            my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
            for my $CustomerID ( sort keys %CustomerGroups ) {
                my %CustomerUsers = $CustomerUserObject->CustomerSearch(
                    CustomerIDRaw => $CustomerID,
                    Valid         => 1,
                );
                CUSTOMERUSERID:
                for my $CustomerUserID ( sort keys %CustomerUsers ) {
                    next CUSTOMERUSERID if $Data{$CustomerUserID};
                    $Data{$CustomerUserID} = $CustomerGroups{$CustomerID};
                }
            }
        }
    }

    # add always groups if groups are requested
    if (
        $Param{UserID}
        && $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupAlwaysGroups')
        )
    {
        my %Groups        = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
        my %GroupsReverse = reverse %Groups;
        ALWAYSGROUP:
        for my $AlwaysGroup ( @{ $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupAlwaysGroups') } ) {
            next ALWAYSGROUP if !$GroupsReverse{$AlwaysGroup};
            next ALWAYSGROUP if $Data{ $GroupsReverse{$AlwaysGroup} };
            $Data{ $GroupsReverse{$AlwaysGroup} } = $AlwaysGroup;
        }
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    # return data depending on requested result
    if ( $Param{Result} eq 'HASH' ) {
        return %Data;
    }
    elsif ( $Param{Result} eq 'ID' ) {
        return ( sort keys %Data );
    }
    elsif ( $Param{Result} eq 'Name' ) {
        return ( sort values %Data );
    }
    return;
}

=head2 GroupCustomerAdd()

to add a customer to a group

    Permission types: e.g. ro,move_into,priority,create,rw
    Permission context: e.g. Ticket::CustomerID::Same, Ticket::CustomerID::Other

    my $Success = $CustomerGroupObject->GroupCustomerAdd(
        GID        => 12,
        CustomerID => 'customer-company',
        Permission => {
            'Ticket::CustomerID::Same' => {
                ro            => 1,
                move_into     => 1,
                create        => 1,
                owner         => 1,
                priority      => 0,
                rw            => 0,
            },
            'Ticket::CustomerID::Other' => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                owner     => 1,
                priority  => 0,
                rw        => 0,
            },
            ...
        },
        UserID => 123,
    );

=cut

sub GroupCustomerAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(CustomerID GID UserID Permission)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check rw rule (set only rw and remove rest, because it's including all in rw)
    my @Contexts = $Self->GroupContextNameList();
    CONTEXT:
    for my $Context (@Contexts) {
        next CONTEXT if !$Param{Permission}->{$Context}->{rw};
        $Param{Permission}->{$Context} = { rw => 1 };
    }

    # get database object
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $Permissions = $Kernel::OM->Get('Kernel::Config')->Get('System::Customer::Permission');

    # update permission
    CONTEXT:
    for my $Context (@Contexts) {
        next CONTEXT if !IsHashRefWithData( $Param{Permission}->{$Context} );

        # delete existing permission
        $DBObject->Do(
            SQL => 'DELETE FROM group_customer WHERE '
                . ' group_id = ? AND customer_id = ? AND '
                . ' permission_context = ?',
            Bind => [ \$Param{GID}, \$Param{CustomerID}, \$Context ],
        );

        # insert new permission (if needed)
        TYPE:
        for my $Type ( @{$Permissions} ) {
            next TYPE if !$Param{Permission}->{$Context}->{$Type};

            # debug
            if ( $Self->{Debug} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message =>
                        "Add CustomerID:$Param{CustomerID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Context}->{$Type}, Context:$Context!",
                );
            }

            $DBObject->Do(
                SQL => 'INSERT INTO group_customer '
                    . '(customer_id, group_id, permission_key, permission_value, '
                    . 'permission_context, create_time, create_by, change_time, change_by) '
                    . 'VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
                Bind => [
                    \$Param{CustomerID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Context}->{$Type},
                    \$Context, \$Param{UserID}, \$Param{UserID},
                ],
            );
        }
    }

    # delete cache
    # remove complete CustomerGroup cache because
    #   it affects GroupMemberList() which is CustomerUserID based
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 GroupCustomerList()

Get customers of the given group.

    my %Customers = $CustomerGroupObject->GroupCustomerList(
        GroupID => '123',
        Type    => 'ro',    # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result  => 'HASH',  # return hash of customer id => group name entries
    );

or

    my @CustomerIDs = $CustomerGroupObject->GroupCustomerList(
        GroupID => '123',
        Type    => 'ro',    # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result  => 'ID',    # return array of customer ids
    );

or

    my @CustomerNames = $CustomerGroupObject->GroupCustomerList(
        GroupID => '123',
        Type    => 'ro',    # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result  => 'Name',  # return array of customer ids
    );

Get groups of given customer.

    my %Groups = $CustomerGroupObject->GroupCustomerList(
        CustomerID => '123',
        Type       => 'ro',     # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result     => 'HASH',   # return hash of group id => group name entries
    );

or

    my @GroupIDs = $CustomerGroupObject->GroupCustomerList(
        CustomerID => '123',
        Type       => 'ro',     # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result     => 'ID',     # return array of group ids
    );

or

    my @GroupNames = $CustomerGroupObject->GroupCustomerList(
        CustomerID => '123',
        Type       => 'ro',     # ro|move_into|priority|create|owner|rw
        Context => 'Ticket::CustomerID::Same',
                            # permissions to same company tickets, default context
        Result     => 'Name',   # return array of group names
    );

=cut

sub GroupCustomerList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Result Type)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !$Param{CustomerID} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerID or GroupID!',
        );
        return;
    }

    # fallback to the default context
    if ( !$Param{Context} ) {
        $Param{Context} = $Self->GroupContextNameGet(
            SysConfigName => '001-CustomerID-same',
        );
    }

    # create cache key
    my $CacheKey = 'GroupCustomerList::' . $Param{Type} . '::' . $Param{Context} . '::';
    if ( $Param{CustomerID} ) {
        $CacheKey .= 'CustomerID::' . $Param{CustomerID};
    }
    else {
        $CacheKey .= 'GroupID::' . $Param{GroupID};
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    if ($Cache) {
        if ( $Param{Result} eq 'HASH' ) {
            return %{$Cache};
        }
        elsif ( $Param{Result} eq 'ID' ) {
            return ( sort keys %{$Cache} );
        }
        elsif ( $Param{Result} eq 'Name' ) {
            return ( sort values %{$Cache} );
        }
        return;
    }

    my %Data;

    # check if customer group feature is active, if not, return all groups
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') ) {

        # get permissions
        %Data = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
    }
    else {
        # get database object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # if it's active, return just the permitted groups
        my $SQL =
            'SELECT g.id, g.name, gc.permission_key, gc.permission_value, gc.customer_id'
            . ' FROM groups g, group_customer gc'
            . ' WHERE g.valid_id IN ( ' . join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() . ')'
            . ' AND g.id = gc.group_id AND gc.permission_value = 1'
            . " AND gc.permission_key IN (?, 'rw')"
            . ' AND gc.permission_context = ?';
        my @Bind = ( \$Param{Type}, \$Param{Context} );

        if ( $Param{CustomerID} ) {
            $SQL .= ' AND gc.customer_id = ?';
            push @Bind, \$Param{CustomerID};
        }
        else {
            $SQL .= ' AND gc.group_id = ?';
            push @Bind, \$Param{GroupID};
        }
        $DBObject->Prepare(
            SQL  => $SQL,
            Bind => \@Bind,
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( $Param{CustomerID} ) {
                $Data{ $Row[0] } = $Row[1];
            }
            else {
                $Data{ $Row[4] } = $Row[1];
            }
        }
    }

    # add always groups if groups are requested
    # don't add them for non-default context (same CustomerID permission) requests
    my $DefaultContextName = $Self->GroupContextNameGet(
        SysConfigName => '001-CustomerID-same',
    );
    if (
        $Param{CustomerID}
        && $Param{Context} eq $DefaultContextName
        && $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupCompanyAlwaysGroups')
        )
    {
        my %Groups        = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
        my %GroupsReverse = reverse %Groups;
        ALWAYSGROUP:
        for my $AlwaysGroup ( @{ $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupCompanyAlwaysGroups') } ) {
            next ALWAYSGROUP if !$GroupsReverse{$AlwaysGroup};
            next ALWAYSGROUP if $Data{ $GroupsReverse{$AlwaysGroup} };
            $Data{ $GroupsReverse{$AlwaysGroup} } = $AlwaysGroup;
        }
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    # return data depending on requested result
    if ( $Param{Result} eq 'HASH' ) {
        return %Data;
    }
    elsif ( $Param{Result} eq 'ID' ) {
        return ( sort keys %Data );
    }
    elsif ( $Param{Result} eq 'Name' ) {
        return ( sort values %Data );
    }
    return;
}

=head2 GroupContextNameGet()

Helper function to get currently configured name of a specific group access context

    my $ContextName = $CustomerGroupObject->GroupContextNameGet(
        SysConfigName => '100-CustomerID-other', # optional, defaults to '001-CustomerID-same'
    );

=cut

sub GroupContextNameGet {
    my ( $Self, %Param ) = @_;

    # get config name
    # fallback to 'normal' group permission config
    $Param{SysConfigName} ||= '001-CustomerID-same';

    my $ContextConfig = $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupPermissionContext');
    return if !IsHashRefWithData($ContextConfig);
    return if !IsHashRefWithData( $ContextConfig->{ $Param{SysConfigName} } );

    return $ContextConfig->{ $Param{SysConfigName} }->{Value};
}

=head2 GroupContextNameList()

Helper function to get the names of all configured group access contexts

    my @ContextNames = $CustomerGroupObject->GroupContextNameList();

=cut

sub GroupContextNameList {
    my ( $Self, %Param ) = @_;

    my $ContextConfig = $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupPermissionContext');
    return () if !IsHashRefWithData($ContextConfig);

    # fill list
    my @ContextNames;
    CONTEXT:
    for my $Item ( sort keys %{$ContextConfig} ) {
        next CONTEXT if !IsHashRefWithData( $ContextConfig->{$Item} );
        next CONTEXT if !$ContextConfig->{$Item}->{Value};

        push @ContextNames, $ContextConfig->{$Item}->{Value};
    }

    return @ContextNames;
}

=head2 GroupContextCustomers()

Get all customer companies of the given customer user,
including those associated via context based permissions.

    my %Customers = $CustomerGroupObject->GroupContextCustomers(
        CustomerUserID => '123',
    );

Returns hash with Customer IDs as key and Customer Company Name as value:

    %Customers = {
      '001' => 'Customer Company 1',
      '002' => 'Customer Company 2',
    };

=cut

sub GroupContextCustomers {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUserID!',
        );
        return;
    }

    # no cache is used because of too many factors outside our control

    # get customer ids from backend
    my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
        User => $Param{CustomerUserID},
    );

    # check for access to other CustomerIDs via group assignment
    # add all combinations based on context bases group access
    my $ExtraPermissionContext = $Self->GroupContextNameGet(
        SysConfigName => '100-CustomerID-other',
    );
    if (
        $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport')
        && $ExtraPermissionContext
        )
    {

        # for all CustomerIDs get groups with extra access
        my %ExtraPermissionGroups;
        CUSTOMERID:
        for my $CustomerID (@CustomerIDs) {
            my %GroupList = $Self->GroupCustomerList(
                CustomerID => $CustomerID,
                Type       => 'ro',
                Context    => $ExtraPermissionContext,
                Result     => 'HASH',
            );
            next CUSTOMERID if !%GroupList;

            # add to groups
            %ExtraPermissionGroups = (
                %ExtraPermissionGroups,
                %GroupList,
            );
        }

        # add all accessible CustomerIDs
        GROUPID:
        for my $GroupID ( sort keys %ExtraPermissionGroups ) {
            my @ExtraCustomerIDs = $Self->GroupCustomerList(
                GroupID => $GroupID,
                Type    => 'ro',
                Result  => 'ID',
            );
            next GROUPID if !@ExtraCustomerIDs;

            # add to CustomerIDs
            push @CustomerIDs, @ExtraCustomerIDs;
        }
    }

    # get all customer companies for quick name lookup
    my %AllCustomers = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyList(
        Valid => 1,
        Limit => 0,
    );

    # filter results using valid customers, add customer name to results
    my %Customers;
    CUSTOMERID:
    for my $CustomerID (@CustomerIDs) {
        next CUSTOMERID if !$AllCustomers{$CustomerID};
        next CUSTOMERID if $Customers{$CustomerID};
        $Customers{$CustomerID} = $AllCustomers{$CustomerID};
    }

    return %Customers;
}

=head2 GroupLookup()

get id or name for group

    my $Group = $CustomerGroupObject->GroupLookup(GroupID => $GroupID);

    my $GroupID = $CustomerGroupObject->GroupLookup(Group => $Group);

=cut

sub GroupLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Group} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no Group or GroupID!',
        );
        return;
    }

    # check if result is cached
    my $CacheKey;
    if ( $Param{GroupID} ) {
        $CacheKey = "GroupLookup::ID::$Param{GroupID}";
    }
    elsif ( $Param{Group} ) {
        $CacheKey = "GroupLookup::Name::$Param{Group}";
    }

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return ${$Cache} if ( ref $Cache eq 'SCALAR' );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get data
    my $SQL;
    my @Bind;
    my $Suffix;
    if ( $Param{Group} ) {
        $Param{What} = $Param{Group};
        $Suffix      = 'GroupID';
        $SQL         = 'SELECT id FROM groups WHERE name = ?';
        push @Bind, \$Param{Group};
    }
    else {
        $Param{What} = $Param{GroupID};
        $Suffix      = 'Group';
        $SQL         = 'SELECT name FROM groups WHERE id = ?';
        push @Bind, \$Param{GroupID};
    }
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # store result
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \$Result,
    );

    return $Result;
}

=head2 PermissionCheck()

Check if a customer user has a certain permission for a certain group.

    my $HasPermission = $CustomerGroupObject->PermissionCheck(
        UserID    => $UserID,
        GroupName => $GroupName,
        Type      => 'move_into',
    );

=cut

sub PermissionCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID GroupName Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my %GroupMemberList = reverse $Self->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Param{Type},
        Result => 'HASH',
    );

    return $GroupMemberList{ $Param{GroupName} } ? 1 : 0;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
