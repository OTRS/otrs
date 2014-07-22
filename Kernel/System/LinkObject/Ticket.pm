# --
# Kernel/System/LinkObject/Ticket.pm - to link ticket objects
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject::Ticket;

use strict;
use warnings;

=head1 NAME

Kernel::System::LinkObject::Ticket

=head1 SYNOPSIS

Ticket backend for the ticket link object.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::LinkObject::Ticket;

    my $TicketObject = Kernel::System::LinkObject::Ticket->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {
        $Kernel::OM->ObjectHash(
            Objects => [
                qw( ConfigObject LogObject TicketObject )
            ],
        ),
    };
    bless( $Self, $Type );

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

    for my $LinkType ( sort keys %{ $Param{LinkList} } ) {

        for my $Direction ( sort keys %{ $Param{LinkList}->{$LinkType} } ) {

            TICKETID:
            for my $TicketID ( sort keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get ticket data
                my %TicketData = $Self->{TicketObject}->TicketGet(
                    TicketID      => $TicketID,
                    UserID        => $Param{UserID},
                    DynamicFields => 0,
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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return $Self->{TicketObject}->TicketPermission(
        Type     => 'ro',
        TicketID => $Param{Key},
        UserID   => $Param{UserID},
    );
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
        TicketID      => $Param{Key},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    return if !%Ticket;

    my $ParamHook = $Self->{ConfigObject}->Get('Ticket::Hook') || 'Ticket#';

    # create description
    %Description = (
        Normal => $ParamHook . "$Ticket{TicketNumber}",
        Long   => $ParamHook . "$Ticket{TicketNumber}: $Ticket{Title}",
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
        Limit               => 50,
        Result              => 'ARRAY',
        ConditionInline     => 1,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => 1,
        OrderBy             => 'Down',
        SortBy              => 'Age',
        UserID              => $Param{UserID},
    );

    my %SearchList;
    TICKETID:
    for my $TicketID (@TicketIDs) {

        # get ticket data
        my %TicketData = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            UserID        => $Param{UserID},
            DynamicFields => 0,
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
        $Self->{TicketObject}->EventHandler(
            Event => 'TicketSlaveLinkAdd' . $Param{Type},
            Data  => {
                TicketID => $Param{Key},
            },
            UserID => $Param{UserID},
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
        $Self->{TicketObject}->EventHandler(
            Event  => 'TicketMasterLinkAdd' . $Param{Type},
            UserID => $Param{UserID},
            Data   => {
                TicketID => $Param{Key},
            },
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
        $Self->{TicketObject}->EventHandler(
            Event => 'TicketSlaveLinkDelete' . $Param{Type},
            Data  => {
                TicketID => $Param{Key},
            },
            UserID => $Param{UserID},
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
        $Self->{TicketObject}->EventHandler(
            Event => 'TicketMasterLinkDelete' . $Param{Type},
            Data  => {
                TicketID => $Param{Key},
            },
            UserID => $Param{UserID},
        );

        return 1;
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
