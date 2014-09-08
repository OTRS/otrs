# --
# Kernel/System/LinkObject.pm - to link objects
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CheckItem',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::LinkObject - to link objects like tickets, faqs, ...

=head1 SYNOPSIS

All functions to link objects like tickets, faqs, ...

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $LinkObject = $Kernel::OM->Get('Kernel::System::Link');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'LinkObject';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=item PossibleTypesList()

return a hash of all possible types

Return
    %PossibleTypesList = (
        'Normal'      => 1,
        'ParentChild' => 1,
    );

    my %PossibleTypesList = $LinkObject->PossibleTypesList(
        Object1 => 'Ticket',
        Object2 => 'FAQ',
        UserID  => 1,
    );

=cut

sub PossibleTypesList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object1 Object2 UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get possible link list
    my %PossibleLinkList = $Self->PossibleLinkList(
        UserID => $Param{UserID},
    );

    # remove not needed entries
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # extract objects
        my $Object1 = $PossibleLinkList{$PossibleLink}->{Object1};
        my $Object2 = $PossibleLinkList{$PossibleLink}->{Object2};

        next POSSIBLELINK
            if ( $Object1 eq $Param{Object1} && $Object2 eq $Param{Object2} )
            || ( $Object2 eq $Param{Object1} && $Object1 eq $Param{Object2} );

        # remove entry from list if objects don't match
        delete $PossibleLinkList{$PossibleLink};
    }

    # get type list
    my %TypeList = $Self->TypeList(
        UserID => $Param{UserID},
    );

    # check types
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # extract type
        my $Type = $PossibleLinkList{$PossibleLink}->{Type} || '';

        next POSSIBLELINK if $TypeList{$Type};

        # remove entry from list if type doesn't exist
        delete $PossibleLinkList{$PossibleLink};
    }

    # extract the type list
    my %PossibleTypesList;
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # extract type
        my $Type = $PossibleLinkList{$PossibleLink}->{Type};

        $PossibleTypesList{$Type} = 1;
    }

    return %PossibleTypesList;
}

=item PossibleObjectsList()

return a hash of all possible objects

Return
    %PossibleObjectsList = (
        'Ticket' => 1,
        'FAQ'    => 1,
    );

    my %PossibleObjectsList = $LinkObject->PossibleObjectsList(
        Object => 'Ticket',
        UserID => 1,
    );

=cut

sub PossibleObjectsList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get possible link list
    my %PossibleLinkList = $Self->PossibleLinkList(
        UserID => $Param{UserID},
    );

    # investigate the possible object list
    my %PossibleObjectsList;
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # extract objects
        my $Object1 = $PossibleLinkList{$PossibleLink}->{Object1};
        my $Object2 = $PossibleLinkList{$PossibleLink}->{Object2};

        next POSSIBLELINK if $Param{Object} ne $Object1 && $Param{Object} ne $Object2;

        # add object to list
        if ( $Param{Object} eq $Object1 ) {
            $PossibleObjectsList{$Object2} = 1;
        }
        else {
            $PossibleObjectsList{$Object1} = 1;
        }
    }

    return %PossibleObjectsList;
}

=item PossibleLinkList()

return a 2d hash list of all possible links

Return
    %PossibleLinkList = (
        001 => {
            Object1 => 'Ticket',
            Object2 => 'Ticket',
            Type    => 'Normal',
        },
        002 => {
            Object1 => 'Ticket',
            Object2 => 'Ticket',
            Type    => 'ParentChild',
        },
    );

    my %PossibleLinkList = $LinkObject->PossibleLinkList(
        UserID => 1,
    );

=cut

sub PossibleLinkList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get needed objects
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # get possible link list
    my $PossibleLinkListRef = $ConfigObject->Get('LinkObject::PossibleLink') || {};
    my %PossibleLinkList = %{$PossibleLinkListRef};

    # prepare the possible link list
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # check the object1, object2 and type string
        ARGUMENT:
        for my $Argument (qw(Object1 Object2 Type)) {

            # set empty string as default value
            $PossibleLinkList{$PossibleLink}->{$Argument} ||= '';

            # trim the argument
            $CheckItemObject->StringClean(
                StringRef => \$PossibleLinkList{$PossibleLink}->{$Argument},
            );

            # extract value
            my $Value = $PossibleLinkList{$PossibleLink}->{$Argument} || '';

            next ARGUMENT if $Value && $Value !~ m{ :: }xms && $Value !~ m{ \s }xms;

            # log the error
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "The $Argument '$Value' is invalid in SysConfig (LinkObject::PossibleLink)!",
            );

            # remove entry from list if it is invalid
            delete $PossibleLinkList{$PossibleLink};

            next POSSIBLELINK;
        }
    }

    # get location of the backend modules
    my $BackendLocation = $ConfigObject->Get('Home') . '/Kernel/System/LinkObject/';

    # check the existing objects
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # check if object backends exist
        ARGUMENT:
        for my $Argument (qw(Object1 Object2)) {

            # extract object
            my $Object = $PossibleLinkList{$PossibleLink}->{$Argument};

            next ARGUMENT if -e $BackendLocation . $Object . '.pm';

            # remove entry from list if it is invalid
            delete $PossibleLinkList{$PossibleLink};

            next POSSIBLELINK;
        }
    }

    # get type list
    my %TypeList = $Self->TypeList(
        UserID => $Param{UserID},
    );

    # check types
    POSSIBLELINK:
    for my $PossibleLink ( sort keys %PossibleLinkList ) {

        # extract type
        my $Type = $PossibleLinkList{$PossibleLink}->{Type};

        next POSSIBLELINK if $TypeList{$Type};

        # log the error
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "The LinkType '$Type' is invalid in SysConfig (LinkObject::PossibleLink)!",
        );

        # remove entry from list if type doesn't exist
        delete $PossibleLinkList{$PossibleLink};
    }

    return %PossibleLinkList;
}

=item LinkAdd()

add a new link between two elements

    $True = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => '321',
        TargetObject => 'FAQ',
        TargetKey    => '5',
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SourceObject SourceKey TargetObject TargetKey Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if source and target are the same object
    if ( $Param{SourceObject} eq $Param{TargetObject} && $Param{SourceKey} eq $Param{TargetKey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Impossible to link object with itself!',
        );
        return;
    }

    # lookup the object ids
    OBJECT:
    for my $Object (qw(SourceObject TargetObject)) {

        # lookup the object id
        $Param{ $Object . 'ID' } = $Self->ObjectLookup(
            Name   => $Param{$Object},
            UserID => $Param{UserID},
        );

        next OBJECT if $Param{ $Object . 'ID' };

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid $Object is given!",
        );

        return;
    }

    # get a list of possible link types for the two objects
    my %PossibleTypesList = $Self->PossibleTypesList(
        Object1 => $Param{SourceObject},
        Object2 => $Param{TargetObject},
        UserID  => $Param{UserID},
    );

    # check if wanted link type is possible
    if ( !$PossibleTypesList{ $Param{Type} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Not possible to create a '$Param{Type}' link between $Param{SourceObject} and $Param{TargetObject}!",
        );
        return;
    }

    # lookup state id
    my $StateID = $Self->StateLookup(
        Name   => $Param{State},
        UserID => $Param{UserID},
    );

    # lookup type id
    my $TypeID = $Self->TypeLookup(
        Name   => $Param{Type},
        UserID => $Param{UserID},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if link already exists in database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT source_object_id, source_key, state_id
            FROM link_relation
            WHERE (
                    ( source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                OR
                    ( source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                )
                AND type_id = ?',
        Bind => [
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$TypeID,
        ],
        Limit => 1,
    );

    # fetch the result
    my %Existing;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Existing{SourceObjectID} = $Row[0];
        $Existing{SourceKey}      = $Row[1];
        $Existing{StateID}        = $Row[2];
    }

    # link exists already
    if (%Existing) {

        # existing link has a different StateID than the new link
        if ( $Existing{StateID} ne $StateID ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link already exists between these two objects "
                    . "with a different state id '$Existing{StateID}'!",
            );
            return;
        }

        # get type data
        my %TypeData = $Self->TypeGet(
            TypeID => $TypeID,
            UserID => $Param{UserID},
        );

        return 1 if !$TypeData{Pointed};
        return 1 if $Existing{SourceObjectID} eq $Param{SourceObjectID}
            && $Existing{SourceKey} eq $Param{SourceKey};

        # log error
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Link already exists between these two objects in opposite direction!',
        );
        return;
    }

    # get all links that the source object already has
    my $Links = $Self->LinkList(
        Object => $Param{SourceObject},
        Key    => $Param{SourceKey},
        State  => $Param{State},
        UserID => $Param{UserID},
    );

    # check type groups
    OBJECT:
    for my $Object ( sort keys %{$Links} ) {

        next OBJECT if $Object ne $Param{TargetObject};

        TYPE:
        for my $Type ( sort keys %{ $Links->{$Object} } ) {

            # extract source and target
            my $Source = $Links->{$Object}->{$Type}->{Source} ||= {};
            my $Target = $Links->{$Object}->{$Type}->{Target} ||= {};

            # check if source and target object are already linked
            next TYPE if !$Source->{ $Param{TargetKey} } && !$Target->{ $Param{TargetKey} };

            # check the type groups
            my $TypeGroupCheck = $Self->PossibleType(
                Type1  => $Type,
                Type2  => $Param{Type},
                UserID => $Param{UserID},
            );

            next TYPE if $TypeGroupCheck;

            # existing link type is in a type group with the new link
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Another Link already exists within the same type group!',
            );

            return;
        }
    }

    # get backend of source object
    my $BackendSourceObject
        = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Param{SourceObject} );

    return if !$BackendSourceObject;

    # get backend of target object
    my $BackendTargetObject
        = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Param{TargetObject} );

    return if !$BackendTargetObject;

    # run pre event module of source object
    $BackendSourceObject->LinkAddPre(
        Key          => $Param{SourceKey},
        TargetObject => $Param{TargetObject},
        TargetKey    => $Param{TargetKey},
        Type         => $Param{Type},
        State        => $Param{State},
        UserID       => $Param{UserID},
    );

    # run pre event module of target object
    $BackendTargetObject->LinkAddPre(
        Key          => $Param{TargetKey},
        SourceObject => $Param{SourceObject},
        SourceKey    => $Param{SourceKey},
        Type         => $Param{Type},
        State        => $Param{State},
        UserID       => $Param{UserID},
    );

    return if !$DBObject->Do(
        SQL => '
            INSERT INTO link_relation
            (source_object_id, source_key, target_object_id, target_key,
            type_id, state_id, create_time, create_by)
            VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?)',
        Bind => [
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$TypeID, \$StateID, \$Param{UserID},
        ],
    );

    # run post event module of source object
    $BackendSourceObject->LinkAddPost(
        Key          => $Param{SourceKey},
        TargetObject => $Param{TargetObject},
        TargetKey    => $Param{TargetKey},
        Type         => $Param{Type},
        State        => $Param{State},
        UserID       => $Param{UserID},
    );

    # run post event module of target object
    $BackendTargetObject->LinkAddPost(
        Key          => $Param{TargetKey},
        SourceObject => $Param{SourceObject},
        SourceKey    => $Param{SourceKey},
        Type         => $Param{Type},
        State        => $Param{State},
        UserID       => $Param{UserID},
    );

    return 1;
}

=item LinkCleanup()

deletes old links from database

return true

    $True = $LinkObject->LinkCleanup(
        State  => 'Temporary',
        Age    => ( 60 * 60 * 24 ),
        UserID => 1,
    );

=cut

sub LinkCleanup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(State Age UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # lookup state id
    my $StateID = $Self->StateLookup(
        Name   => $Param{State},
        UserID => $Param{UserID},
    );

    return if !$StateID;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get current time
    my $Now = $TimeObject->SystemTime();

    # calculate delete time
    my $DeleteTime = $TimeObject->SystemTime2TimeStamp(
        SystemTime => ( $Now - $Param{Age} ),
    );

    # delete the link
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM link_relation
            WHERE state_id = ?
            AND create_time < ?',
        Bind => [
            \$StateID, \$DeleteTime,
        ],
    );

    return 1;
}

=item LinkDelete()

deletes a link

return true

    $True = $LinkObject->LinkDelete(
        Object1 => 'Ticket',
        Key1    => '321',
        Object2 => 'FAQ',
        Key2    => '5',
        Type    => 'Normal',
        UserID  => 1,
    );

=cut

sub LinkDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object1 Key1 Object2 Key2 Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # lookup the object ids
    OBJECT:
    for my $Object (qw(Object1 Object2)) {

        # lookup the object id
        $Param{ $Object . 'ID' } = $Self->ObjectLookup(
            Name   => $Param{$Object},
            UserID => $Param{UserID},
        );

        next OBJECT if $Param{ $Object . 'ID' };

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid $Object is given!",
        );

        return;
    }

    # lookup type id
    my $TypeID = $Self->TypeLookup(
        Name   => $Param{Type},
        UserID => $Param{UserID},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get the existing link
    return if !$DBObject->Prepare(
        SQL => '
            SELECT source_object_id, source_key, target_object_id, target_key, state_id
            FROM link_relation
            WHERE (
                    (source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                OR
                    ( source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                )
                AND type_id = ?',
        Bind => [
            \$Param{Object1ID}, \$Param{Key1},
            \$Param{Object2ID}, \$Param{Key2},
            \$Param{Object2ID}, \$Param{Key2},
            \$Param{Object1ID}, \$Param{Key1},
            \$TypeID,
        ],
        Limit => 1,
    );

    # fetch results
    my %Existing;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $Existing{SourceObjectID} = $Row[0];
        $Existing{SourceKey}      = $Row[1];
        $Existing{TargetObjectID} = $Row[2];
        $Existing{TargetKey}      = $Row[3];
        $Existing{StateID}        = $Row[4];
    }

    return 1 if !%Existing;

    # lookup the object names
    OBJECT:
    for my $Object (qw(SourceObject TargetObject)) {

        # lookup the object name
        $Existing{$Object} = $Self->ObjectLookup(
            ObjectID => $Existing{ $Object . 'ID' },
            UserID   => $Param{UserID},
        );

        next OBJECT if $Existing{$Object};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid $Object is given!",
        );

        return;
    }

    # lookup state
    $Existing{State} = $Self->StateLookup(
        StateID => $Existing{StateID},
        UserID  => $Param{UserID},
    );

    # get backend of source object
    my $BackendSourceObject
        = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Existing{SourceObject} );

    return if !$BackendSourceObject;

    # get backend of target object
    my $BackendTargetObject
        = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Existing{TargetObject} );

    return if !$BackendTargetObject;

    # run pre event module of source object
    $BackendSourceObject->LinkDeletePre(
        Key          => $Existing{SourceKey},
        TargetObject => $Existing{TargetObject},
        TargetKey    => $Existing{TargetKey},
        Type         => $Param{Type},
        State        => $Existing{State},
        UserID       => $Param{UserID},
    );

    # run pre event module of target object
    $BackendTargetObject->LinkDeletePre(
        Key          => $Existing{TargetKey},
        SourceObject => $Existing{SourceObject},
        SourceKey    => $Existing{SourceKey},
        Type         => $Param{Type},
        State        => $Existing{State},
        UserID       => $Param{UserID},
    );

    # delete the link
    return if !$DBObject->Do(
        SQL => '
            DELETE FROM link_relation
            WHERE (
                    ( source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                OR
                    ( source_object_id = ? AND source_key = ?
                    AND target_object_id = ? AND target_key = ? )
                )
                AND type_id = ?',
        Bind => [
            \$Param{Object1ID}, \$Param{Key1},
            \$Param{Object2ID}, \$Param{Key2},
            \$Param{Object2ID}, \$Param{Key2},
            \$Param{Object1ID}, \$Param{Key1},
            \$TypeID,
        ],
    );

    # run post event module of source object
    $BackendSourceObject->LinkDeletePost(
        Key          => $Existing{SourceKey},
        TargetObject => $Existing{TargetObject},
        TargetKey    => $Existing{TargetKey},
        Type         => $Param{Type},
        State        => $Existing{State},
        UserID       => $Param{UserID},
    );

    # run post event module of target object
    $BackendTargetObject->LinkDeletePost(
        Key          => $Existing{TargetKey},
        SourceObject => $Existing{SourceObject},
        SourceKey    => $Existing{SourceKey},
        Type         => $Param{Type},
        State        => $Existing{State},
        UserID       => $Param{UserID},
    );

    return 1;
}

=item LinkDeleteAll()

delete all links of an object

    $True = $LinkObject->LinkDeleteAll(
        Object => 'Ticket',
        Key    => '321',
        UserID => 1,
    );

=cut

sub LinkDeleteAll {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get state list
    my %StateList = $Self->StateList(
        Valid  => 0,
        UserID => $Param{UserID},
    );

    # delete all links
    STATE:
    for my $State ( values %StateList ) {

        # get link list
        my $LinkList = $Self->LinkList(
            Object => $Param{Object},
            Key    => $Param{Key},
            State  => $State,
            UserID => $Param{UserID},
        );

        next STATE if !$LinkList;
        next STATE if !%{$LinkList};

        for my $Object ( sort keys %{$LinkList} ) {

            for my $LinkType ( sort keys %{ $LinkList->{$Object} } ) {

                # extract link type List
                my $LinkTypeList = $LinkList->{$Object}->{$LinkType};

                for my $Direction ( sort keys %{$LinkTypeList} ) {

                    # extract direction list
                    my $DirectionList = $LinkList->{$Object}->{$LinkType}->{$Direction};

                    for my $ObjectKey ( sort keys %{$DirectionList} ) {

                        # delete the link
                        $Self->LinkDelete(
                            Object1 => $Param{Object},
                            Key1    => $Param{Key},
                            Object2 => $Object,
                            Key2    => $ObjectKey,
                            Type    => $LinkType,
                            UserID  => $Param{UserID},
                        );
                    }
                }
            }
        }
    }

    return 1;
}

=item LinkList()

get all existing links for a given object

Return
    $LinkList = {
        Ticket => {
            Normal => {
                Source => {
                    12  => 1,
                    212 => 1,
                    332 => 1,
                },
            },
            ParentChild => {
                Source => {
                    5 => 1,
                    9 => 1,
                },
                Target => {
                    4  => 1,
                    8  => 1,
                    15 => 1,
                },
            },
        },
        FAQ => {
            ParentChild => {
                Source => {
                    5 => 1,
                },
            },
        },
    };

    my $LinkList = $LinkObject->LinkList(
        Object    => 'Ticket',
        Key       => '321',
        Object2   => 'FAQ',         # (optional)
        State     => 'Valid',
        Type      => 'ParentChild', # (optional)
        Direction => 'Target',      # (optional) default Both (Source|Target|Both)
        UserID    => 1,
    );

=cut

sub LinkList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # lookup object id
    my $ObjectID = $Self->ObjectLookup(
        Name   => $Param{Object},
        UserID => $Param{UserID},
    );

    return if !$ObjectID;

    # lookup state id
    my $StateID = $Self->StateLookup(
        Name   => $Param{State},
        UserID => $Param{UserID},
    );

    # prepare SQL statement
    my $TypeSQL = '';
    my @Bind = ( \$ObjectID, \$Param{Key}, \$StateID );

    # add type id to SQL statement
    if ( $Param{Type} ) {

        # lookup type id
        my $TypeID = $Self->TypeLookup(
            Name   => $Param{Type},
            UserID => $Param{UserID},
        );

        $TypeSQL = 'AND type_id = ? ';
        push @Bind, \$TypeID;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get links where the given object is the source
    return if !$DBObject->Prepare(
        SQL => '
            SELECT target_object_id, target_key, type_id
            FROM link_relation
            WHERE source_object_id = ?
                AND source_key = ?
                AND state_id = ? '
            . $TypeSQL,
        Bind => \@Bind,
    );

    # fetch results
    my @Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %LinkData;
        $LinkData{TargetObjectID} = $Row[0];
        $LinkData{TargetKey}      = $Row[1];
        $LinkData{TypeID}         = $Row[2];
        push @Data, \%LinkData;
    }

    # store results
    my %Links;
    my %TypePointedList;
    for my $LinkData (@Data) {

        # lookup object name
        my $TargetObject = $Self->ObjectLookup(
            ObjectID => $LinkData->{TargetObjectID},
            UserID   => $Param{UserID},
        );

        # get type data
        my %TypeData = $Self->TypeGet(
            TypeID => $LinkData->{TypeID},
            UserID => $Param{UserID},
        );

        $TypePointedList{ $TypeData{Name} } = $TypeData{Pointed};

        # store the result
        $Links{$TargetObject}->{ $TypeData{Name} }->{Target}->{ $LinkData->{TargetKey} } = 1;
    }

    # get links where the given object is the target
    return if !$DBObject->Prepare(
        SQL => '
            SELECT source_object_id, source_key, type_id
            FROM link_relation
            WHERE target_object_id = ?
                AND target_key = ?
                AND state_id = ? '
            . $TypeSQL,
        Bind => \@Bind,
    );

    # fetch the result
    @Data = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %LinkData;
        $LinkData{SourceObjectID} = $Row[0];
        $LinkData{SourceKey}      = $Row[1];
        $LinkData{TypeID}         = $Row[2];
        push @Data, \%LinkData;
    }

    # store results
    for my $LinkData (@Data) {

        # lookup object name
        my $SourceObject = $Self->ObjectLookup(
            ObjectID => $LinkData->{SourceObjectID},
            UserID   => $Param{UserID},
        );

        # get type data
        my %TypeData = $Self->TypeGet(
            TypeID => $LinkData->{TypeID},
            UserID => $Param{UserID},
        );

        $TypePointedList{ $TypeData{Name} } = $TypeData{Pointed};

        # store the result
        $Links{$SourceObject}->{ $TypeData{Name} }->{Source}->{ $LinkData->{SourceKey} } = 1;
    }

    # merge source target pairs into source for unpointed link types
    for my $Object ( sort keys %Links ) {

        TYPE:
        for my $Type ( sort keys %{ $Links{$Object} } ) {

            next TYPE if $TypePointedList{$Type};

            # extract source target pair
            my $SourceTarget = $Links{$Object}->{$Type};

            next TYPE if !$SourceTarget->{Target};

            # set empty hash reference as default
            $SourceTarget->{Source} ||= {};

            # merge the data
            my %MergedIDs = ( %{ $SourceTarget->{Source} }, %{ $SourceTarget->{Target} } );
            $SourceTarget->{Source} = \%MergedIDs;

            # delete target hash
            delete $SourceTarget->{Target};
        }
    }

    return \%Links if !$Param{Object2} && !$Param{Direction};

    # removed not needed elements
    OBJECT:
    for my $Object ( sort keys %Links ) {

        # removed not needed object
        if ( $Param{Object2} && $Param{Object2} ne $Object ) {
            delete $Links{$Object};
            next OBJECT;
        }

        next OBJECT if !$Param{Direction};

        # removed not needed direction
        for my $Type ( sort keys %{ $Links{$Object} } ) {

            DIRECTION:
            for my $Direction ( sort keys %{ $Links{$Object}->{$Type} } ) {

                next DIRECTION if $Param{Direction} eq $Direction;
                next DIRECTION if $Param{Direction} ne 'Source' && $Param{Direction} ne 'Target';

                delete $Links{$Object}->{$Type}->{$Direction};
            }
        }
    }

    return \%Links;
}

=item LinkListWithData()

get all existing links for a given object with data of the other objects

Return
    $LinkList = {
        Ticket => {
            Normal => {
                Source => {
                    12  => $DataOfItem12,
                    212 => $DataOfItem212,
                    332 => $DataOfItem332,
                },
            },
            ParentChild => {
                Source => {
                    5 => $DataOfItem5,
                    9 => $DataOfItem9,
                },
                Target => {
                    4  => $DataOfItem4,
                    8  => $DataOfItem8,
                    15 => $DataOfItem15,
                },
            },
        },
        FAQ => {
            ParentChild => {
                Source => {
                    5 => $DataOfItem5,
                },
            },
        },
    };

    my $LinkList = $LinkObject->LinkListWithData(
        Object                          => 'Ticket',
        Key                             => '321',
        Object2                         => 'FAQ',         # (optional)
        State                           => 'Valid',
        Type                            => 'ParentChild', # (optional)
        Direction                       => 'Target',      # (optional) default Both (Source|Target|Both)
        UserID                          => 1,
        ObjectParameters                => {              # (optional) backend specific flags
            Ticket => {
                IgnoreLinkedTicketStateTypes => 0|1,
            },
        },
    );

=cut

sub LinkListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get the link list
    my $LinkList = $Self->LinkList(%Param);

    # check link list
    return if !$LinkList;
    return if ref $LinkList ne 'HASH';

    # add data to hash
    OBJECT:
    for my $Object ( sort keys %{$LinkList} ) {

        # get backend object
        my $BackendObject = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Object );

        # check backend object
        if ( !$BackendObject ) {
            delete $LinkList->{$Object};
            next OBJECT;
        }

        my %ObjectParameters = ();
        if (   ref $Param{ObjectParameters} eq 'HASH'
            && ref $Param{ObjectParameters}->{$Object} eq 'HASH' )
        {
            %ObjectParameters = %{ $Param{ObjectParameters}->{$Object} };
        }

        # add backend data
        my $Success = $BackendObject->LinkListWithData(
            LinkList => $LinkList->{$Object},
            UserID   => $Param{UserID},
            %ObjectParameters,
        );

        next OBJECT if $Success;

        delete $LinkList->{$Object};
    }

    # clean the hash
    OBJECT:
    for my $Object ( sort keys %{$LinkList} ) {

        LINKTYPE:
        for my $LinkType ( sort keys %{ $LinkList->{$Object} } ) {

            DIRECTION:
            for my $Direction ( sort keys %{ $LinkList->{$Object}->{$LinkType} } ) {

                next DIRECTION if %{ $LinkList->{$Object}->{$LinkType}->{$Direction} };

                delete $LinkList->{$Object}->{$LinkType}->{$Direction};
            }

            next LINKTYPE if %{ $LinkList->{$Object}->{$LinkType} };

            delete $LinkList->{$Object}->{$LinkType};
        }

        next OBJECT if %{ $LinkList->{$Object} };

        delete $LinkList->{$Object};
    }

    return $LinkList;
}

=item LinkKeyList()

return a hash with all existing links of a given object

Return
    %LinkKeyList = (
        5   => 1,
        9   => 1,
        12  => 1,
        212 => 1,
        332 => 1,
    );

    my %LinkKeyList = $LinkObject->LinkKeyList(
        Object1   => 'Ticket',
        Key1      => '321',
        Object2   => 'FAQ',
        State     => 'Valid',
        Type      => 'ParentChild', # (optional)
        Direction => 'Target',      # (optional) default Both (Source|Target|Both)
        UserID    => 1,
    );

=cut

sub LinkKeyList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object1 Key1 Object2 State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get the link list
    my $LinkList = $Self->LinkList(
        %Param,
        Object => $Param{Object1},
        Key    => $Param{Key1},
    );

    # check link list
    return if !$LinkList;
    return if ref $LinkList ne 'HASH';

    # extract typelist
    my $TypeList = $LinkList->{ $Param{Object2} };

    # add data to hash
    my %LinkKeyList;
    for my $Type ( sort keys %{$TypeList} ) {

        # extract direction list
        my $DirectionList = $TypeList->{$Type};

        for my $Direction ( sort keys %{$DirectionList} ) {

            for my $Key ( sort keys %{ $DirectionList->{$Direction} } ) {

                # add key to list
                $LinkKeyList{$Key} = $DirectionList->{$Direction}->{$Key};
            }
        }
    }

    return %LinkKeyList;
}

=item LinkKeyListWithData()

return a hash with all existing links of a given object

Return
    %LinkKeyList = (
        5   => $DataOfItem5,
        9   => $DataOfItem9,
        12  => $DataOfItem12,
        212 => $DataOfItem212,
        332 => $DataOfItem332,
    );

    my %LinkKeyList = $LinkObject->LinkKeyListWithData(
        Object1   => 'Ticket',
        Key1      => '321',
        Object2   => 'FAQ',
        State     => 'Valid',
        Type      => 'ParentChild', # (optional)
        Direction => 'Target',      # (optional) default Both (Source|Target|Both)
        UserID    => 1,
    );

=cut

sub LinkKeyListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object1 Key1 Object2 State UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get the link list
    my $LinkList = $Self->LinkListWithData(
        %Param,
        Object => $Param{Object1},
        Key    => $Param{Key1},
    );

    # check link list
    return if !$LinkList;
    return if ref $LinkList ne 'HASH';

    # extract typelist
    my $TypeList = $LinkList->{ $Param{Object2} };

    # add data to hash
    my %LinkKeyList;
    for my $Type ( sort keys %{$TypeList} ) {

        # extract direction list
        my $DirectionList = $TypeList->{$Type};

        for my $Direction ( sort keys %{$DirectionList} ) {

            for my $Key ( sort keys %{ $DirectionList->{$Direction} } ) {

                # add key to list
                $LinkKeyList{$Key} = $DirectionList->{$Direction}->{$Key};
            }
        }
    }

    return %LinkKeyList;
}

=item ObjectLookup()

lookup a link object

    $ObjectID = $LinkObject->ObjectLookup(
        Name   => 'Ticket',
        UserID => 1,
    );

    or

    $Name = $LinkObject->ObjectLookup(
        ObjectID => 12,
        UserID   => 1,
    );

=cut

sub ObjectLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ObjectID or Name!',
        );
        return;
    }

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{ObjectID} ) {

        # check cache
        my $CacheKey = 'ObjectLookup::ObjectID::' . $Param{ObjectID};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # ask the database
        return if !$DBObject->Prepare(
            SQL => '
                SELECT name
                FROM link_object
                WHERE id = ?',
            Bind  => [ \$Param{ObjectID} ],
            Limit => 1,
        );

        # fetch the result
        my $Name;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Name = $Row[0];
        }

        # check the name
        if ( !$Name ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link object id '$Param{ObjectID}' not found in the database!",
            );
            return;
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $Name,
        );

        return $Name;
    }
    else {

        # check cache
        my $CacheKey = 'ObjectLookup::Name::' . $Param{Name};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        # investigate the object id
        my $ObjectID;
        TRY:
        for my $Try ( 1 .. 3 ) {

            # ask the database
            return if !$DBObject->Prepare(
                SQL => '
                    SELECT id
                    FROM link_object
                    WHERE name = ?',
                Bind  => [ \$Param{Name} ],
                Limit => 1,
            );

            # fetch the result
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $ObjectID = $Row[0];
            }

            last TRY if $ObjectID;

            # cleanup the given name
            $CheckItemObject->StringClean(
                StringRef => \$Param{Name},
            );

            # check if name is valid
            if ( !$Param{Name} || $Param{Name} =~ m{ :: }xms || $Param{Name} =~ m{ \s }xms ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid object name '$Param{Name}' is given!",
                );
                return;
            }

            next TRY if $Try == 1;

            # insert the new object
            return if !$DBObject->Do(
                SQL  => 'INSERT INTO link_object (name) VALUES (?)',
                Bind => [ \$Param{Name} ],
            );
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $ObjectID,
        );

        return $ObjectID;
    }
}

=item TypeLookup()

lookup a link type

    $TypeID = $LinkObject->TypeLookup(
        Name   => 'Normal',
        UserID => 1,
    );

    or

    $Name = $LinkObject->TypeLookup(
        TypeID => 56,
        UserID => 1,
    );

=cut

sub TypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TypeID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TypeID or Name!',
        );
        return;
    }

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{TypeID} ) {

        # check cache
        my $CacheKey = 'TypeLookup::TypeID::' . $Param{TypeID};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # ask the database
        return if !$DBObject->Prepare(
            SQL   => 'SELECT name FROM link_type WHERE id = ?',
            Bind  => [ \$Param{TypeID} ],
            Limit => 1,
        );

        # fetch the result
        my $Name;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Name = $Row[0];
        }

        # check the name
        if ( !$Name ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link type id '$Param{TypeID}' not found in the database!",
            );
            return;
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $Name,
        );

        return $Name;
    }
    else {

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        # cleanup the given name
        $CheckItemObject->StringClean(
            StringRef => \$Param{Name},
        );

        # check cache
        my $CacheKey = 'TypeLookup::Name::' . $Param{Name};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # investigate the type id
        my $TypeID;
        TRY:
        for my $Try ( 1 .. 2 ) {

            # ask the database
            return if !$DBObject->Prepare(
                SQL   => 'SELECT id FROM link_type WHERE name = ?',
                Bind  => [ \$Param{Name} ],
                Limit => 1,
            );

            # fetch the result
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $TypeID = $Row[0];
            }

            last TRY if $TypeID;

            # check if name is valid
            if ( !$Param{Name} || $Param{Name} =~ m{ :: }xms || $Param{Name} =~ m{ \s }xms ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid type name '$Param{Name}' is given!",
                );
                return;
            }

            # insert the new type
            return if !$DBObject->Do(
                SQL => '
                    INSERT INTO link_type
                    (name, valid_id, create_time, create_by, change_time, change_by)
                    VALUES (?, 1, current_timestamp, ?, current_timestamp, ?)',
                Bind => [ \$Param{Name}, \$Param{UserID}, \$Param{UserID} ],
            );
        }

        # check the type id
        if ( !$TypeID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link type '$Param{Name}' not found in the database!",
            );
            return;
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $TypeID,
        );

        return $TypeID;
    }
}

=item TypeGet()

get a link type

Return
    $TypeData{TypeID}
    $TypeData{Name}
    $TypeData{SourceName}
    $TypeData{TargetName}
    $TypeData{Pointed}
    $TypeData{CreateTime}
    $TypeData{CreateBy}
    $TypeData{ChangeTime}
    $TypeData{ChangeBy}

    %TypeData = $LinkObject->TypeGet(
        TypeID => 444,
        UserID => 123,
    );

=cut

sub TypeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TypeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check cache
    return %{ $Self->{Cache}->{TypeGet}->{TypeID}->{ $Param{TypeID} } }
        if $Self->{Cache}->{TypeGet}->{TypeID}->{ $Param{TypeID} };

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, create_time, create_by, change_time, change_by
            FROM link_type
            WHERE id = ?',
        Bind  => [ \$Param{TypeID} ],
        Limit => 1,
    );

    # fetch the result
    my %Type;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Type{TypeID}     = $Row[0];
        $Type{Name}       = $Row[1];
        $Type{CreateTime} = $Row[2];
        $Type{CreateBy}   = $Row[3];
        $Type{ChangeTime} = $Row[4];
        $Type{ChangeBy}   = $Row[5];
    }

    # get config of all types
    my $ConfiguredTypes = $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::Type');

    # check the config
    if ( !$ConfiguredTypes->{ $Type{Name} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Linktype '$Type{Name}' does not exist!",
        );
        return;
    }

    # add source and target name
    $Type{SourceName} = $ConfiguredTypes->{ $Type{Name} }->{SourceName} || '';
    $Type{TargetName} = $ConfiguredTypes->{ $Type{Name} }->{TargetName} || '';

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # clean the names
    ARGUMENT:
    for my $Argument (qw(SourceName TargetName)) {
        $CheckItemObject->StringClean(
            StringRef         => \$Type{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );

        next ARGUMENT if $Type{$Argument};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "The $Argument '$Type{$Argument}' is invalid in SysConfig (LinkObject::Type)!",
        );
        return;
    }

    # add pointed value
    $Type{Pointed} = $Type{SourceName} ne $Type{TargetName} ? 1 : 0;

    # cache result
    $Self->{Cache}->{TypeGet}->{TypeID}->{ $Param{TypeID} } = \%Type;

    return %Type;
}

=item TypeList()

return a 2d hash list of all valid link types

Return
    $TypeList{
        Normal => {
            SourceName => 'Normal',
            TargetName => 'Normal',
        },
        ParentChild => {
            SourceName => 'Parent',
            TargetName => 'Child',
        },
    }

    my %TypeList = $LinkObject->TypeList(
        UserID => 1,
    );

=cut

sub TypeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get type list
    my $TypeListRef = $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::Type') || {};
    my %TypeList = %{$TypeListRef};

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # prepare the type list
    TYPE:
    for my $Type ( sort keys %TypeList ) {

        # check the source and target name
        ARGUMENT:
        for my $Argument (qw(SourceName TargetName)) {

            # set empty string as default value
            $TypeList{$Type}{$Argument} ||= '';

            # clean the argument
            $CheckItemObject->StringClean(
                StringRef         => \$TypeList{$Type}{$Argument},
                RemoveAllNewlines => 1,
                RemoveAllTabs     => 1,
            );

            next ARGUMENT if $TypeList{$Type}{$Argument};

            # remove invalid link type from list
            delete $TypeList{$Type};

            next TYPE;
        }
    }

    return %TypeList;
}

=item TypeGroupList()

return a 2d hash list of all type groups

Return
    %TypeGroupList = (
        001 => [
            'Normal',
            'ParentChild',
        ],
        002 => [
            'Normal',
            'DependsOn',
        ],
        003 => [
            'ParentChild',
            'RelevantTo',
        ],
    );

    my %TypeGroupList = $LinkObject->TypeGroupList(
        UserID => 1,
    );

=cut

sub TypeGroupList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get possible type groups
    my $TypeGroupListRef = $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::TypeGroup') || {};
    my %TypeGroupList = %{$TypeGroupListRef};

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # prepare the possible link list
    TYPEGROUP:
    for my $TypeGroup ( sort keys %TypeGroupList ) {

        # check the types
        TYPE:
        for my $Type ( @{ $TypeGroupList{$TypeGroup} } ) {

            # set empty string as default value
            $Type ||= '';

            # trim the argument
            $CheckItemObject->StringClean(
                StringRef => \$Type,
            );

            next TYPE if $Type && $Type !~ m{ :: }xms && $Type !~ m{ \s }xms;

            # log the error
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "The Argument '$Type' is invalid in SysConfig (LinkObject::TypeGroup)!",
            );

            # remove entry from list if it is invalid
            delete $TypeGroupList{$TypeGroup};

            next TYPEGROUP;
        }
    }

    # get type list
    my %TypeList = $Self->TypeList(
        UserID => $Param{UserID},
    );

    # check types
    TYPEGROUP:
    for my $TypeGroup ( sort keys %TypeGroupList ) {

        # check the types
        TYPE:
        for my $Type ( @{ $TypeGroupList{$TypeGroup} } ) {

            # set empty string as default value
            $Type ||= '';

            next TYPE if $TypeList{$Type};

            # log the error
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "The LinkType '$Type' is invalid in SysConfig (LinkObject::TypeGroup)!",
            );

            # remove entry from list if type doesn't exist
            delete $TypeGroupList{$TypeGroup};

            next TYPEGROUP;
        }
    }

    return %TypeGroupList;
}

=item PossibleType()

return true if both types are NOT together in a type group

    my $True = $LinkObject->PossibleType(
        Type1  => 'Normal',
        Type2  => 'ParentChild',
        UserID => 1,
    );

=cut

sub PossibleType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw( Type1 Type2 UserID )) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get type group list
    my %TypeGroupList = $Self->TypeGroupList(
        UserID => $Param{UserID},
    );

    # check all type groups
    TYPEGROUP:
    for my $TypeGroup ( sort keys %TypeGroupList ) {

        my %TypeList = map { $_ => 1 } @{ $TypeGroupList{$TypeGroup} };

        return if $TypeList{ $Param{Type1} } && $TypeList{ $Param{Type2} };

    }

    return 1;
}

=item StateLookup()

lookup a link state

    $StateID = $LinkObject->StateLookup(
        Name   => 'Valid',
        UserID => 1,
    );

    or

    $Name = $LinkObject->StateLookup(
        StateID => 56,
        UserID  => 1,
    );

=cut

sub StateLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StateID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need StateID or Name!',
        );
        return;
    }

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{StateID} ) {

        # check cache
        my $CacheKey = 'StateLookup::StateID::' . $Param{StateID};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # ask the database
        return if !$DBObject->Prepare(
            SQL => '
                SELECT name
                FROM link_state
                WHERE id = ?',
            Bind  => [ \$Param{StateID} ],
            Limit => 1,
        );

        # fetch the result
        my $Name;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Name = $Row[0];
        }

        # check the name
        if ( !$Name ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link state id '$Param{StateID}' not found in the database!",
            );
            return;
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $Name,
        );

        return $Name;
    }
    else {

        # check cache
        my $CacheKey = 'StateLookup::Name::' . $Param{Name};
        my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return $Cache if $Cache;

        # ask the database
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id
                FROM link_state
                WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );

        # fetch the result
        my $StateID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $StateID = $Row[0];
        }

        # check the state id
        if ( !$StateID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Link state '$Param{Name}' not found in the database!",
            );
            return;
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => $StateID,
        );

        return $StateID;
    }
}

=item StateList()

return a hash list of all valid link states

Return
    $StateList{
        4 => 'Valid',
        8 => 'Temporary',
    }

    my %StateList = $LinkObject->StateList(
        Valid  => 0,   # (optional) default 1 (0|1)
        UserID => 1,
    );

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # set valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # add valid part
    my $SQLWhere = '';
    if ( $Param{Valid} ) {

        # create the valid id string
        my $ValidIDs = join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

        $SQLWhere = "WHERE valid_id IN ( $ValidIDs )";
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    return if !$DBObject->Prepare(
        SQL => "SELECT id, name FROM link_state $SQLWhere",
    );

    # fetch the result
    my %StateList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $StateList{ $Row[0] } = $Row[1];
    }

    return %StateList;
}

=item ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $LinkObject->ObjectPermission(
        Object  => 'Ticket',
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get backend object
    my $BackendObject = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Param{Object} );

    return   if !$BackendObject;
    return 1 if !$BackendObject->can('ObjectPermission');

    return $BackendObject->ObjectPermission(
        %Param,
    );
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => '',
        Long   => '',
    );

    %Description = $LinkObject->ObjectDescriptionGet(
        Object  => 'Ticket',
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get backend object
    my $BackendObject = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Param{Object} );

    return if !$BackendObject;

    # get object description
    my %Description = $BackendObject->ObjectDescriptionGet(
        %Param,
    );

    return %Description;
}

=item ObjectSearch()

return a hash reference of the search results

Return
    $ObjectList = {
        Ticket => {
            NOTLINKED => {
                Source => {
                    12  => $DataOfItem12,
                    212 => $DataOfItem212,
                    332 => $DataOfItem332,
                },
            },
        },
    };

    $ObjectList = $LinkObject->ObjectSearch(
        Object       => 'ITSMConfigItem',
        SubObject    => 'Computer'         # (optional)
        SearchParams => $HashRef,          # (optional)
        UserID       => 1,
    );

=cut

sub ObjectSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get backend object
    my $BackendObject = $Kernel::OM->Get( 'Kernel::System::LinkObject::' . $Param{Object} );

    return if !$BackendObject;

    # search objects
    my $SearchList = $BackendObject->ObjectSearch(
        %Param,
    );

    my %ObjectList;
    $ObjectList{ $Param{Object} } = $SearchList;

    return \%ObjectList;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
