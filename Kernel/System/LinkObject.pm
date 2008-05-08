# --
# Kernel/System/LinkObject.pm - to link objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObject.pm,v 1.25 2008-05-08 09:36:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.25 $) [1];

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

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO object_link'
            . ' (object_link_a_id, object_link_b_id, object_link_a_object, object_link_b_object, object_link_type)'
            . ' VALUES (?, ?, ?, ?, ?)',
        Bind => [
            \$Param{LinkID1}, \$Param{LinkID2}, \$Param{LinkObject1}, \$Param{LinkObject2},
            \$Param{LinkType}
        ],
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

    my $SQLExt = '';
    if ( $Param{LinkType} eq 'Parent' || $Param{LinkType} eq 'Child' ) {
        $SQLExt = "object_link_type IN ('Parent', 'Child')";
    }
    else {
        $Param{LinkType} = $Self->{DBObject}->Quote( $Param{LinkType} );
        $SQLExt = "object_link_type = '$Param{LinkType}'";
    }

    return if !$Self->{DBObject}->Do(
        SQL => "DELETE FROM object_link WHERE"
            . " (object_link_a_id = ? AND object_link_b_id = ? AND"
            . " object_link_a_object = ? AND object_link_b_object = ? AND"
            . " $SQLExt ) OR"
            . " (object_link_a_id = ? AND object_link_b_id = ? AND"
            . " object_link_a_object = ? AND object_link_b_object = ? AND"
            . " $SQLExt)",
        Bind => [
            \$Param{LinkID1}, \$Param{LinkID2}, \$Param{LinkObject1}, \$Param{LinkObject2},
            \$Param{LinkID2}, \$Param{LinkID1}, \$Param{LinkObject2}, \$Param{LinkObject1},
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

    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM object_link WHERE'
            . ' (object_link_a_id = ? AND object_link_a_object = ?) OR'
            . ' (object_link_b_id = ? AND object_link_b_object = ?)',
        Bind => [
            \$Param{ID}, \$Param{Object}, \$Param{ID}, \$Param{Object},
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

    my %Linked    = ();
    my @LinkedIDs = ();
    my $SQLA      = '';
    my $SQLB      = '';

    if ( !$Param{LinkType} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need LinkType!' );
        return;
    }

    # get parents
    if (
        $Param{LinkType} eq 'Parent'
        && ( !$Param{LinkID2} || !$Param{LinkObject2} || !$Param{LinkObject1} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID2, LinkObject2 and LinkObject1 for $Param{LinkType}!",
        );
        return;
    }

    # get childs
    elsif (
        $Param{LinkType} eq 'Child'
        && ( !$Param{LinkID1} || !$Param{LinkObject1} || !$Param{LinkObject2} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }

    # get sisters
    elsif (
        $Param{LinkType} eq 'Normal'
        && ( !$Param{LinkID1} || !$Param{LinkObject1} || !$Param{LinkObject2} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }

    my @BindA = ();
    my @BindB = ();
    if ( $Param{LinkType} eq 'Parent' ) {
        $SQLA = 'SELECT object_link_a_id, object_link_a_object FROM object_link WHERE '
            . ' object_link_b_id = ? AND object_link_b_object = ? AND '
            . ' object_link_a_object = ? AND object_link_type = ?';
        push @BindA, \$Param{LinkID2}, \$Param{LinkObject2}, \$Param{LinkObject1},
            \$Param{LinkType};
        $SQLB = 'SELECT object_link_a_id, object_link_a_object FROM object_link WHERE'
            . ' object_link_b_id = ? AND object_link_b_object = ? AND '
            . ' object_link_a_object = ? AND object_link_type = \'Child\'';
        push @BindB, \$Param{LinkID2}, \$Param{LinkObject2}, \$Param{LinkObject1};
    }
    elsif ( $Param{LinkType} eq 'Child' ) {
        $SQLA = 'SELECT object_link_b_id, object_link_b_object FROM object_link WHERE '
            . ' object_link_a_id = ? AND object_link_a_object = ? AND '
            . ' object_link_b_object = ? AND object_link_type = \'Parent\'';
        push @BindA, \$Param{LinkID1}, \$Param{LinkObject1}, \$Param{LinkObject2};
        $SQLB = 'SELECT object_link_b_id, object_link_b_object FROM object_link WHERE '
            . ' object_link_a_id = ? AND object_link_a_object = ? AND '
            . ' object_link_b_object = ? AND object_link_type = ?';
        push @BindB, \$Param{LinkID1}, \$Param{LinkObject1}, \$Param{LinkObject2},
            \$Param{LinkType};
    }
    elsif ( $Param{LinkType} eq 'Normal' ) {
        $SQLA = 'SELECT object_link_a_id, object_link_a_object FROM object_link WHERE '
            . ' object_link_b_id = ? AND object_link_b_object = ? AND '
            . ' object_link_a_object = ? AND object_link_type = ?';
        push @BindA, \$Param{LinkID1}, \$Param{LinkObject1}, \$Param{LinkObject2},
            \$Param{LinkType};
        $SQLB = 'SELECT object_link_b_id, object_link_b_object FROM object_link WHERE '
            . ' object_link_a_id = ? AND object_link_a_object = ? AND '
            . ' object_link_b_object = ? AND object_link_type = ?';
        push @BindB, \$Param{LinkID1}, \$Param{LinkObject1}, \$Param{LinkObject2},
            \$Param{LinkType};
    }

    $Self->{DBObject}->Prepare( SQL => $SQLA, Bind => \@BindA );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @LinkedIDs, [ $Row[0], $Row[1], ];
    }
    $Self->{DBObject}->Prepare( SQL => $SQLB, Bind => \@BindB );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @LinkedIDs, [ $Row[0], $Row[1], ];
    }

    # fill up data
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

    my %Links = ();
    for (qw(Object ObjectID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get objects
    my %Objects = %{ $Self->{ConfigObject}->Get('LinkObject') };
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.25 $ $Date: 2008-05-08 09:36:19 $

=cut
