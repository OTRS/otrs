# --
# Kernel/System/LinkObject.pm - to link objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObject.pm,v 1.28 2008-05-15 18:31:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

=head1 NAME

Kernel::System::LinkObject - to link objects like tickets, faqs, ...

=head1 SYNOPSIS

All functions to link objects like tickets, faqs, ... configured
in Kernel/Config.pm.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::LinkObject;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $LinkObject = Kernel::System::LinkObject->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

    # load backends
    my %Objects = %{ $Self->{ConfigObject}->Get('LinkObject') };
    for my $Backend ( sort keys %Objects ) {
        my $GenericModule = "Kernel::System::LinkObject::$Backend";
        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            die "Can't load link backend module $GenericModule! $@";
        }
        $Self->{Backend}->{$Backend} = $GenericModule->new(%Param);
    }

    return $Self;
}

=item LinkObjects()

get all linkable objects

    my %LinkObjects = $LinkObject->LinkObjects(
        SourceObject => 'Ticket',
    );

=cut

sub LinkObjects {
    my ( $Self, %Param ) = @_;

    my %ObjectList = ();

    # check needed object
    if ( !$Param{SourceObject} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need SourceObject!' );
        return;
    }

    # get config options
    if ( !$Self->{ConfigObject}->Get('LinkObject') ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No LinkObject in Config!",
        );
        return;
    }

    # get objects
    my %Objects = %{ $Self->{ConfigObject}->Get('LinkObject') };
    if ( !$Objects{ $Param{SourceObject} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Object '$Param{SourceObject}' configured!",
        );
        return;
    }

    # get linkable objects
    if ( $Objects{ $Param{SourceObject} }->{LinkObjects} ) {
        for ( @{ $Objects{ $Param{SourceObject} }->{LinkObjects} } ) {
            if ( $Objects{$_} ) {
                $ObjectList{$_} = $Objects{$_}->{Name};
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "No LinkObject '$_' configured!",
                );
            }
        }
    }

    return %ObjectList;
}

# just for compat.
sub LoadBackend {
    my ( $Self, %Param ) = @_;
    return 1;
}

=item LinkObject()

link objects

    $LinkObject->LinkObject(
        LinkType    => 'Normal', # Normal|Parent|Child
        LinkID1     => 1,
        LinkObject1 => 'Ticket',
        LinkID2     => 2,
        LinkObject2 => 'Ticket',
    );

=cut

sub LinkObject {
    my ( $Self, %Param ) = @_;

    for (qw(LinkType LinkID1 LinkObject1 LinkID2 LinkObject2)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $SourceObject = $Param{LinkObject1};
    my $SourceKey    = $Param{LinkID1};
    my $TargetObject = $Param{LinkObject2};
    my $TargetKey    = $Param{LinkID2};
    my $Type         = 'Normal';

    if ( $Param{LinkType} eq 'Parent' || $Param{LinkType} eq 'Child' ) {
        $Type = 'ParentChild';
    }

    # lookup the object type id
    my $TypeID = $Self->LinkTypeLookup(
        Name => $Type,
    );

    # lookup the object state id
    my $StateID = $Self->LinkStateLookup(
        Name => 'Valid',
    );

    # add the link
    return if !$Self->LinkAdd(
        SourceObject => $SourceObject,
        SourceKey    => $SourceKey,
        TargetObject => $TargetObject,
        TargetKey    => $TargetKey,
        TypeID       => $TypeID,
        StateID      => $StateID,
        UserID       => 1,
    );

    return if !$Self->{Backend}->{ $Param{LinkObject1} }->BackendLinkObject(%Param);
    return if !$Self->{Backend}->{ $Param{LinkObject2} }->BackendLinkObject(%Param);

    return 1;
}

=item UnlinkObject()

unlink objects

    $LinkObject->UnlinkObject(
        LinkType    => 'Normal', # Normal|Parent|Child
        LinkID1     => 1,
        LinkObject1 => 'Ticket',
        LinkID2     => 2,
        LinkObject2 => 'Ticket',
    );

=cut

sub UnlinkObject {
    my ( $Self, %Param ) = @_;

    for (qw(LinkType LinkID1 LinkObject1 LinkID2 LinkObject2)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $TypeID;
    if ( $Param{LinkType} eq 'Parent' || $Param{LinkType} eq 'Child' ) {

        # lookup the object type id
        $TypeID = $Self->LinkTypeLookup(
            Name => 'ParentChild',
        );
    }
    else {

        # lookup the object type id
        $TypeID = $Self->LinkTypeLookup(
            Name => 'Normal',
        );
    }

    my $SQLExt = "type_id = $TypeID";

    # lookup the object 1 id
    my $Object1ID = $Self->LinkObjectLookup(
        Name => $Param{LinkObject1},
    );

    # lookup the object 2 id
    my $Object2ID = $Self->LinkObjectLookup(
        Name => $Param{LinkObject2},
    );

    return if !$Self->{DBObject}->Do(
        SQL => "DELETE FROM link_relation WHERE"
            . " (source_key = ? AND target_key = ? AND"
            . " source_object_id = ? AND target_object_id = ? AND"
            . " $SQLExt ) OR"
            . " (source_key = ? AND target_key = ? AND"
            . " source_object_id = ? AND target_object_id = ? AND"
            . " $SQLExt)",
        Bind => [
            \$Param{LinkID1}, \$Param{LinkID2}, \$Object1ID, \$Object2ID,
            \$Param{LinkID2}, \$Param{LinkID1}, \$Object2ID, \$Object1ID,
        ],
    );

    return if !$Self->{Backend}->{ $Param{LinkObject1} }->BackendUnlinkObject(%Param);
    return if !$Self->{Backend}->{ $Param{LinkObject2} }->BackendUnlinkObject(%Param);

    return 1;
}

=item RemoveLinkObject()

remove all links from an objects

    $LinkObject->RemoveLinkObject(
        ID1    => 1,
        Object => 'Ticket',
    );

=cut

sub RemoveLinkObject {
    my ( $Self, %Param ) = @_;

    for (qw(Object ID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # lookup the object id
    my $ObjectID = $Self->LinkObjectLookup(
        Name => $Param{Object},
    );

    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM link_relation WHERE'
            . ' (source_key = ? AND source_object_id = ?) OR'
            . ' (target_key = ? AND target_object_id = ?)',
        Bind => [
            \$Param{ID}, \$ObjectID, \$Param{ID}, \$ObjectID,
        ],
    );
}

=item LinkedObjects()

get a hash of all linked object ids

    my %Objects = $LinkObject->LinkedObjects(
        LinkType    => 'Normal',
        LinkID1     => 1,
        LinkObject1 => 'Ticket'
        LinkObject2 => 'Ticket',
    );

    2 => {
        Text         => 'T: 2008032100001',
        Number       => '2008032100001',
        Title        => 'Some Title',
        ID           => 2,
        Object       => 'Ticket',
        FrontendDest => "Action=AgentTicketZoom&TicketID=",
    },
    3 => {
        Text         => 'T: 3008033100001',
        Number       => '3008033100001',
        Title        => 'Some Title',
        ID           => 3,
        Object       => 'Ticket',
        FrontendDest => "Action=AgentTicketZoom&TicketID=",
    },

=cut

sub LinkedObjects {
    my ( $Self, %Param ) = @_;

    for (qw(LinkType LinkObject1 LinkObject2)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( $Param{LinkType} eq 'Parent' && !$Param{LinkID2} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID2, LinkObject2 and LinkObject1 for $Param{LinkType}!",
        );
        return;
    }
    elsif ( $Param{LinkType} eq 'Child' && !$Param{LinkID1} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }
    elsif ( $Param{LinkType} eq 'Normal' && !$Param{LinkID1} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }

    # lookup the object 1 id
    my $Object1ID = $Self->LinkObjectLookup(
        Name => $Param{LinkObject1},
    );

    # lookup the object 2 id
    my $Object2ID = $Self->LinkObjectLookup(
        Name => $Param{LinkObject2},
    );

    # lookup the object state id
    my $StateID = $Self->LinkStateLookup(
        Name => 'Valid',
    );

    # get parents
    my $SQLA;
    my $SQLB;
    my @BindA;
    my @BindB;
    my @LinkedIDs;
    if ( $Param{LinkType} eq 'Parent' ) {

        # lookup the object type id
        my $TypeID = $Self->LinkTypeLookup(
            Name => 'ParentChild',
        );

        $SQLA = 'SELECT source_key, source_object_id FROM link_relation WHERE '
            . 'target_key = ? AND '
            . 'target_object_id = ? AND '
            . 'source_object_id = ? AND '
            . 'type_id = ? AND '
            . 'state_id = ?';

        @BindA = ( \$Param{LinkID2}, \$Object2ID, \$Object1ID, \$TypeID, \$StateID );
    }

    # get childs
    elsif ( $Param{LinkType} eq 'Child' ) {

        # lookup the object type id
        my $TypeID = $Self->LinkTypeLookup(
            Name => 'ParentChild',
        );

        $SQLA = 'SELECT target_key, target_object_id FROM link_relation WHERE '
            . 'source_key = ? AND '
            . 'source_object_id = ? AND '
            . 'target_object_id = ? AND '
            . 'type_id = ? AND '
            . 'state_id = ?';

        @BindA = ( \$Param{LinkID1}, \$Object1ID, \$Object2ID, \$TypeID, \$StateID );
    }

    # get sisters
    elsif ( $Param{LinkType} eq 'Normal' ) {

        # lookup the object type id
        my $TypeID = $Self->LinkTypeLookup(
            Name => 'Normal',
        );

        $SQLA = 'SELECT source_key, source_object_id FROM link_relation WHERE '
            . 'target_key = ? AND '
            . 'target_object_id = ? AND '
            . 'source_object_id = ? AND '
            . 'type_id = ? AND '
            . 'state_id = ?';

        @BindA = ( \$Param{LinkID1}, \$Object1ID, \$Object2ID, \$TypeID, \$StateID );

        $SQLB = 'SELECT target_key, target_object_id FROM link_relation WHERE '
            . 'source_key = ? AND '
            . 'source_object_id = ? AND '
            . 'target_object_id = ? AND '
            . 'type_id = ? AND '
            . 'state_id = ?';

        @BindB = ( \$Param{LinkID1}, \$Object1ID, \$Object2ID, \$TypeID, \$StateID );
    }

    $Self->{DBObject}->Prepare( SQL => $SQLA, Bind => \@BindA );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @LinkedIDs, [ $Row[0], $Row[1], ];
    }

    if ($SQLB) {
        $Self->{DBObject}->Prepare( SQL => $SQLB, Bind => \@BindB );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push @LinkedIDs, [ $Row[0], $Row[1], ];
        }
    }

    for my $Link (@LinkedIDs) {

        # lookup the object 2 id
        $Link->[1] = $Self->LinkObjectLookup(
            ObjectID => $Link->[1],
        );
    }

    # fill up data
    my %Linked;
    for my $Link (@LinkedIDs) {
        next if !$Self->{Backend}->{ $Link->[1] };

        my %Hash = $Self->{Backend}->{ $Link->[1] }->FillDataMap(
            ID     => $Link->[0],
            UserID => $Self->{UserID},
        );

        # delete links if object exists not anymore
        if ( !%Hash ) {
            if ( $Param{LinkID1} ) {
                $Self->UnlinkObject(
                    LinkType    => $Param{LinkType},
                    LinkID1     => $Param{LinkID1},
                    LinkObject1 => $Param{LinkObject1},
                    LinkID2     => $Link->[0],
                    LinkObject2 => $Param{LinkObject2},
                    UserID      => 1,
                );
            }
            elsif ( $Param{LinkID2} ) {
                $Self->UnlinkObject(
                    LinkType    => $Param{LinkType},
                    LinkID1     => $Link->[0],
                    LinkObject1 => $Param{LinkObject1},
                    LinkID2     => $Param{LinkID2},
                    LinkObject2 => $Param{LinkObject2},
                    UserID      => 1,
                );
            }
        }

        $Linked{ $Link->[0] } = \%Hash;
    }

    return %Linked;
}

=item AllLinkedObjects()

get a hash of all linked object ids

    my %Objects = $LinkObject->AllLinkedObjects(
        ObjectID => 1,
        Object   => 'Ticket'
    );

    Normal => {
        Ticket => {
            2 => {
                Text         => 'T: 2008032100001',
                Number       => '2008032100001',
                Title        => 'Some Title',
                ID           => 2,
                Object       => 'Ticket',
                FrontendDest => "Action=AgentTicketZoom&TicketID=",
            },
            3 => {
                Text         => 'T: 3008033100001',
                Number       => '3008033100001',
                Title        => 'Some Title',
                ID           => 3,
                Object       => 'Ticket',
                FrontendDest => "Action=AgentTicketZoom&TicketID=",
            },
        }
    },
    Child => {
        Ticket => {
            4 => {
                Text         => 'T: 2008032100004',
                Number       => '2008032100004',
                Title        => 'Some Title',
                ID           => 4,
                Object       => 'Ticket',
                FrontendDest => "Action=AgentTicketZoom&TicketID=",
            },
        }
    },
    Parent => {
        # ...
    }

=cut

sub AllLinkedObjects {
    my ( $Self, %Param ) = @_;

    for (qw(Object ObjectID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get objects
    my %Objects = %{ $Self->{ConfigObject}->Get('LinkObject') };

    my %Links;
    for my $Object ( keys %Objects ) {

        my %CLinked = $Self->LinkedObjects(
            LinkType    => 'Child',
            LinkObject1 => $Param{Object},
            LinkID1     => $Param{ObjectID},
            LinkObject2 => $Object,
        );
        $Links{Child}->{$Object} = \%CLinked;

        my %PLinked = $Self->LinkedObjects(
            LinkType    => 'Parent',
            LinkObject2 => $Param{Object},
            LinkID2     => $Param{ObjectID},
            LinkObject1 => $Object,
        );
        $Links{Parent}->{$Object} = \%PLinked;

        my %NLinked = $Self->LinkedObjects(
            LinkType    => 'Normal',
            LinkObject1 => $Param{Object},
            LinkID1     => $Param{ObjectID},
            LinkObject2 => $Object,
        );
        $Links{Normal}->{$Object} = \%NLinked;
    }

    return %Links;
}

sub LinkSearchParams {
    my ( $Self, %Param ) = @_;
    return $Self->{Backend}->{ $Param{Object} }->LinkSearchParams(%Param);
}

sub LinkSearch {
    my ( $Self, %Param ) = @_;
    return $Self->{Backend}->{ $Param{Object} }->LinkSearch(%Param);
}

sub LinkItemData {
    my ( $Self, %Param ) = @_;
    return $Self->{Backend}->{ $Param{Object} }->LinkItemData(%Param);
}

=item LinkAdd()

add a link

    $True = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => '321',
        TargetObject => 'FAQ',
        TargetKey    => '5',
        TypeID       => 2,
        StateID      => 1,
        UserID       => 1,
    );

=cut

sub LinkAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SourceObject SourceKey TargetObject TargetKey TypeID StateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # cleanup given params
    for my $Argument (qw(SourceObject SourceKey TargetObject TargetKey)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }

    # lookup the object id
    OBJECT:
    for my $Object (qw(SourceObject TargetObject)) {

        $Param{$Object . 'ID'} = $Self->LinkObjectLookup(
            Name => $Param{$Object},
        );
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO link_relation '
            . '(source_object_id, source_key, target_object_id, target_key, type_id, state_id, create_time, create_by) '
            . 'VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?)',
        Bind => [
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$Param{TypeID}, \$Param{StateID}, \$Param{UserID},
        ],
    );

    return 1;
}

=item LinkTypeLookup()

lookup a link type

    $TypeID = $LinkObject->LinkTypeLookup(
        Name => 'Normal',
    );

=cut

sub LinkTypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    # ask the database
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM link_type WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $TypeID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TypeID = $Row[0];
    }

    # check the type id
    if ( !$TypeID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Link type '$Param{Name}' not found in the database!",
        );
        return;
    }

    return $TypeID;
}

=item LinkStateLookup()

lookup a link state

    $StateID = $LinkObject->LinkStateLookup(
        Name => 'Normal',
    );

=cut

sub LinkStateLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    # ask the database
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM link_state WHERE name = ?',
        Bind => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $StateID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $StateID = $Row[0];
    }

    # check the state id
    if ( !$StateID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Link state '$Param{Name}' not found in the database!",
        );
        return;
    }

    return $StateID;
}

=item LinkObjectLookup()

lookup a link object

    $ObjectID = $LinkObject->LinkObjectLookup(
        Name => 'Ticket',
    );

    or

    $Name = $LinkObject->LinkObjectLookup(
        ObjectID => 12,
    );

=cut

sub LinkObjectLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ObjectID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ObjectID or Name!',
        );
        return;
    }

    if ( $Param{ObjectID} ) {

        # check cache
        return $Self->{Cache}->{LinkObjectLookup}->{ObjectID}->{ $Param{ObjectID} }
            if $Self->{Cache}->{LinkObjectLookup}->{ObjectID}->{ $Param{ObjectID} };

        # ask the database
        $Self->{DBObject}->Prepare(
            SQL   => 'SELECT name FROM link_object WHERE id = ?',
            Bind  => [ \$Param{ObjectID} ],
            Limit => 1,
        );

        # fetch the result
        my $Name;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Name = $Row[0];
        }

        # check the name
        if ( !$Name ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Link object id '$Param{ObjectID}' not found in the database!",
            );
            return;
        }

        # cache result
        $Self->{Cache}->{LinkObjectLookup}->{ObjectID}->{ $Param{ObjectID} } = $Name;

        return $Name;
    }
    else {

        # check cache
        return $Self->{Cache}->{LinkObjectLookup}->{Name}->{ $Param{Name} }
            if $Self->{Cache}->{LinkObjectLookup}->{Name}->{ $Param{Name} };

        # ask the database
        $Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM link_object WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );

        # fetch the result
        my $ObjectID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ObjectID = $Row[0];
        }

        if ( !$ObjectID ) {

            # insert the new object
            $Self->{DBObject}->Do(
                SQL  => 'INSERT INTO link_object (name) VALUES (?)',
                Bind => [ \$Param{Name} ],
            );

            $Self->{DBObject}->Prepare(
                SQL   => 'SELECT id FROM link_object WHERE name = ?',
                Bind  => [ \$Param{Name} ],
                Limit => 1,
            );

            # fetch the result
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $ObjectID = $Row[0];
            }
        }

        # cache result
        $Self->{Cache}->{LinkObjectLookup}->{Name}->{ $Param{Name} } = $ObjectID;

        return $ObjectID;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.28 $ $Date: 2008-05-15 18:31:47 $

=cut
