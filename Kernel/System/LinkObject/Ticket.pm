# --
# Kernel/System/LinkObject/Ticket.pm - to link ticket objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.20 2008-06-02 11:56:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::Ticket;

use strict;
use warnings;

use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject LinkObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    return $Self;
}

=item PossibleObjectsSelectList()

return an array hash with selectable objects

Return
    @ObjectSelectList = (
        {
            Key   => 'Ticket',
            Value => 'Ticket',
        },
    );

    @ObjectSelectList = $LinkObject->PossibleObjectsSelectList();

=cut

sub PossibleObjectsSelectList {
    my $Self = shift;

    # get object description
    my %ObjectDescription = $Self->ObjectDescriptionGet(
        UserID => 1,
    );

    # object select list
    my @ObjectSelectList = (
        {
            Key   => $ObjectDescription{Object},
            Value => $ObjectDescription{Realname},
        },
    );

    return @ObjectSelectList;
}

=item ObjectDescriptionGet()

return a hash of object description data

    %ObjectDescription = $LinkObject->ObjectDescriptionGet(
        UserID => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # define object description
    my %ObjectDescription = (
        Object   => 'Ticket',
        Realname => 'Ticket',
        Overview => {
            Normal => {
                Key     => 'TicketNumber',
                Value   => 'Ticket#',
                Type    => 'Link',
                Subtype => 'Compact',
            },
            Complex => [
                {
                    Key   => 'TicketNumber',
                    Value => 'Ticket#',
                    Type  => 'Link',
                },
                {
                    Key   => 'Title',
                    Value => 'Title',
                    Type  => 'Text',
                },
                {
                    Key   => 'Queue',
                    Value => 'Queue',
                    Type  => 'Text',
                },
                {
                    Key   => 'State',
                    Value => 'State',
                    Type  => 'Text',
                },
                {
                    Key   => 'Age',
                    Value => 'Age',
                    Type  => 'Age',
                },
                {
                    Key   => 'LinkType',
                    Value => 'Already linked as',
                    Type  => 'LinkType',
                },
            ],
        },
    );

    return %ObjectDescription;
}

=item ObjectSearchOptionsGet()

return an array hash list with search options

    @SearchOptions = $LinkObject->ObjectSearchOptionsGet();

=cut

sub ObjectSearchOptionsGet {
    my ( $Self, %Param ) = @_;

    # define search params
    my @SearchOptions = (
        {
            Key   => 'TicketNumber',
            Value => 'Ticket#',
        },
        {
            Key   => 'Title',
            Value => 'Title',
        },
        {
            Key   => 'TicketFulltext',
            Value => 'Fulltext',
        },
    );

    return @SearchOptions;
}

=item ItemDescriptionGet()

return a hash of item description data

    %ItemDescription = $BackendObject->ItemDescriptionGet(
        Key    => '123',
        UserID => 1,
    );

=cut

sub ItemDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{Key},
        UserID   => 1,
    );

    return if !%Ticket;

    # lookup the valid state id
    my $ValidStateID = $Self->{LinkObject}->StateLookup(
        Name   => 'Valid',
        UserID => 1,
    );

    # get link data
    my $ExistingLinks = $Self->{LinkObject}->LinksGet(
        Object  => 'Ticket',
        Key     => $Param{Key},
        StateID => $Param{StateID} || $ValidStateID,
        UserID  => 1,
    ) || {};

    # define item description
    my %ItemDescription = (
        Identifier  => 'Ticket',
        Description => {
            Short  => "T:$Ticket{TicketNumber}",
            Normal => "Ticket# $Ticket{TicketNumber}",
            Long   => "Ticket# $Ticket{TicketNumber}: $Ticket{Title}",
        },
        ItemData => {
            %Ticket,
        },
        LinkData => {
            %{$ExistingLinks},
        },
    );

    return %ItemDescription;
}

=item ItemSearch()

return an array list of the search results

    @ItemKeys = $LinkObject->ItemSearch(
        SearchParams => $HashRef,  # (optional)
    );

=cut

sub ItemSearch {
    my ( $Self, %Param ) = @_;

    # set default params
    $Param{SearchParams} ||= {};

    # set focus
    my %Search;
    if ( $Param{Title} ) {
        $Param{Title} = '*' . $Param{Title} . '*';
    }

    if ( $Param{TicketFulltext} ) {
        $Param{TicketFulltext} = '*' . $Param{TicketFulltext} . '*';
        %Search = (
            From          => $Param{TicketFulltext},
            To            => $Param{TicketFulltext},
            Cc            => $Param{TicketFulltext},
            Subject       => $Param{TicketFulltext},
            Body          => $Param{TicketFulltext},
            ContentSearch => 'OR',
        );
    }

    # search the tickets
    my @ItemKeys = $Self->{TicketObject}->TicketSearch(
        Result => 'ARRAY',
        %{ $Param{SearchParams} },
        %Search,
        ConditionInline => 1,
        FullTextIndex   => 1,
        OrderBy         => 'Down',
        SortBy          => 'Age',
    );

    return @ItemKeys;
}

1;
