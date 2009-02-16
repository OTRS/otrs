# --
# Kernel/System/LinkObject/Ticket.pm - to link ticket objects
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.32 2009-02-16 11:48:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject::Ticket;

use strict;
use warnings;

use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.32 $) [1];

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

=item LinkListWithData()

fill up the link list with data

    $Success = $LinkObjectBackend->LinkListWithData(
        LinkList => $HashRef,
        UserID   => 1,
    );

=cut

sub LinkListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkList UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check link list
    if ( ref $Param{LinkList} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'LinkList must be a hash reference!',
        );
        return;
    }

    for my $LinkType ( keys %{ $Param{LinkList} } ) {

        for my $Direction ( keys %{ $Param{LinkList}->{$LinkType} } ) {

            TICKETID:
            for my $TicketID ( keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get ticket data
                my %TicketData = $Self->{TicketObject}->TicketGet(
                    TicketID => $TicketID,
                    UserID   => $Param{UserID},
                );

                # remove id from hash if ticket can not get
                if ( !%TicketData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$TicketID};
                    next TICKETID;
                }

                # add ticket data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$TicketID} = \%TicketData;
            }
        }
    }

    return 1;
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => "Ticket# 1234455",
        Long   => "Ticket# 1234455: The Ticket Title",
    );

    %Description = $LinkObject->ObjectDescriptionGet(
        Key     => 123,
        Mode    => 'Temporary',  # (optional)
        UserID  => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # create description
    my %Description = (
        Normal => 'Ticket',
        Long   => 'Ticket',
    );

    return %Description if $Param{Mode} && $Param{Mode} eq 'Temporary';

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{Key},
        UserID   => 1,
    );

    return if !%Ticket;

    # create description
    %Description = (
        Normal => "Ticket# $Ticket{TicketNumber}",
        Long   => "Ticket# $Ticket{TicketNumber}: $Ticket{Title}",
    );

    return %Description;
}

=item ObjectSearch()

return a hash list of the search results

Return
    $SearchList = {
        NOTLINKED => {
            Source => {
                12  => $DataOfItem12,
                212 => $DataOfItem212,
                332 => $DataOfItem332,
            },
        },
    };

    $SearchList = $LinkObjectBackend->ObjectSearch(
        SubObject    => 'Bla',     # (optional)
        SearchParams => $HashRef,  # (optional)
        UserID       => 1,
    );

=cut

sub ObjectSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default params
    $Param{SearchParams} ||= {};

    # set focus
    my %Search;
    if ( $Param{SearchParams}->{TicketFulltext} ) {
        %Search = (
            From          => '*' . $Param{SearchParams}->{TicketFulltext} . '*',
            To            => '*' . $Param{SearchParams}->{TicketFulltext} . '*',
            Cc            => '*' . $Param{SearchParams}->{TicketFulltext} . '*',
            Subject       => '*' . $Param{SearchParams}->{TicketFulltext} . '*',
            Body          => '*' . $Param{SearchParams}->{TicketFulltext} . '*',
            ContentSearch => 'OR',
        );
    }
    if ( $Param{SearchParams}->{Title} ) {
        $Search{Title} = '*' . $Param{SearchParams}->{Title} . '*';
    }

    # search the tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        %{ $Param{SearchParams} },
        %Search,
        Limit           => 50,
        Result          => 'ARRAY',
        ConditionInline => 1,
        FullTextIndex   => 1,
        OrderBy         => 'Down',
        SortBy          => 'Age',
        UserID          => $Param{UserID},
    );

    my %SearchList;
    TICKETID:
    for my $TicketID (@TicketIDs) {

        # get ticket data
        my %TicketData = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );

        next TICKETID if !%TicketData;

        # add ticket data
        $SearchList{NOTLINKED}->{Source}->{$TicketID} = \%TicketData;
    }

    return \%SearchList;
}

=item LinkAddPre()

link add pre event module

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'Ticket',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'Ticket',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkAddPost()

link add pre event module

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'Ticket',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'Ticket',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    if ( $Param{SourceObject} && $Param{SourceObject} eq 'Ticket' && $Param{SourceKey} ) {

        # lookup ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{SourceKey},
            UserID   => $Param{UserID},
        );

        # add ticket history entry
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{Key},
            CreateUserID => $Param{UserID},
            HistoryType  => 'TicketLinkAdd',
            Name         => "\%\%$TicketNumber\%\%$Param{SourceKey}\%\%$Param{Key}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketSlaveLinkAdd' . $Param{Type},
            UserID   => $Param{UserID},
            TicketID => $Param{Key},
        );

        return 1;
    }

    if ( $Param{TargetObject} && $Param{TargetObject} eq 'Ticket' && $Param{TargetKey} ) {

        # lookup ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{TargetKey},
            UserID   => $Param{UserID},
        );

        # add ticket history entry
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{Key},
            CreateUserID => $Param{UserID},
            HistoryType  => 'TicketLinkAdd',
            Name         => "\%\%$TicketNumber\%\%$Param{TargetKey}\%\%$Param{Key}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketMasterLinkAdd' . $Param{Type},
            UserID   => $Param{UserID},
            TicketID => $Param{Key},
        );

        return 1;
    }

    return 1;
}

=item LinkDeletePre()

link delete pre event module

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        SourceObject => 'Ticket',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        TargetObject => 'Ticket',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePost()

link delete post event module

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        SourceObject => 'Ticket',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        TargetObject => 'Ticket',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1 if $Param{State} eq 'Temporary';

    if ( $Param{SourceObject} && $Param{SourceObject} eq 'Ticket' && $Param{SourceKey} ) {

        # lookup ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{SourceKey},
            UserID   => $Param{UserID},
        );

        # add ticket history entry
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{Key},
            CreateUserID => $Param{UserID},
            HistoryType  => 'TicketLinkDelete',
            Name         => "\%\%$TicketNumber\%\%$Param{SourceKey}\%\%$Param{Key}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketSlaveLinkDelete' . $Param{Type},
            UserID   => $Param{UserID},
            TicketID => $Param{Key},
        );

        return 1;
    }

    if ( $Param{TargetObject} && $Param{TargetObject} eq 'Ticket' && $Param{TargetKey} ) {

        # lookup ticket number
        my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{TargetKey},
            UserID   => $Param{UserID},
        );

        # add ticket history entry
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{Key},
            CreateUserID => $Param{UserID},
            HistoryType  => 'TicketLinkDelete',
            Name         => "\%\%$TicketNumber\%\%$Param{TargetKey}\%\%$Param{Key}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketMasterLinkDelete' . $Param{Type},
            UserID   => $Param{UserID},
            TicketID => $Param{Key},
        );

        return 1;
    }

    return 1;
}

1;
