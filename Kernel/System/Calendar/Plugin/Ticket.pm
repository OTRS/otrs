# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Plugin::Ticket;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::LinkObject',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Calendar::Plugin::Ticket - Ticket plugin

=head1 DESCRIPTION

Ticket appointment plugin.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketPluginObject = $Kernel::OM->Get('Kernel::System::Calendar::Plugin::Ticket');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 LinkAdd()

adds a link from an appointment to the ticket

    my $Success = $TicketPluginObject->LinkAdd(
        AppointmentID => 123,
        PluginData    => $TicketID,
        UserID        => 1,
    );

=cut

sub LinkAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID PluginData UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check ticket id
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{PluginData},
        UserID   => $Param{UserID},
    );
    return if !%Ticket;

    my $Success = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
        SourceObject => 'Appointment',
        SourceKey    => $Param{AppointmentID},
        TargetObject => 'Ticket',
        TargetKey    => $Param{PluginData},
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => $Param{UserID},
    );

    return $Success;
}

=head2 LinkList()

returns a hash of linked tickets to an appointment

    my $Success = $TicketPluginObject->LinkList(
        AppointmentID => 123,
        UserID        => 1,
    );

=cut

sub LinkList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID UserID PluginURL)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %LinkKeyList = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkKeyListWithData(
        Object1 => 'Appointment',
        Key1    => $Param{AppointmentID},
        Object2 => 'Ticket',
        State   => 'Valid',
        UserID  => $Param{UserID},
    );

    my %Result = map {
        $_ => {
            LinkID   => $LinkKeyList{$_}->{TicketID},
            LinkName => $LinkKeyList{$_}->{TicketNumber} . ' ' . $LinkKeyList{$_}->{Title},
            LinkURL  => sprintf( $Param{PluginURL}, $LinkKeyList{$_}->{TicketID} ),
        }
    } keys %LinkKeyList;

    return \%Result;
}

=head2 Search()

search for ticket and return a hash of found tickets

    my $ResultList = $TicketPluginObject->Search(
        Search   => '**',   # search by ticket number or title
                            # or
        ObjectID => 1,      # search by ticket ID (single result)

        UserID => 1,
    );

=cut

sub Search {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !$Param{Search} && !$Param{ObjectID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either Search or ObjectID!',
        );
        return;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @TicketIDs;
    if ( $Param{Search} ) {

        # search the tickets by ticket number
        @TicketIDs = $TicketObject->TicketSearch(
            TicketNumber => $Param{Search},
            Limit        => 100,
            Result       => 'ARRAY',
            ArchiveFlags => ['n'],
            UserID       => $Param{UserID},
        );

        # try the title search if no results were found
        if ( !@TicketIDs ) {
            @TicketIDs = $TicketObject->TicketSearch(
                Title        => '%' . $Param{Search},
                Limit        => 100,
                Result       => 'ARRAY',
                ArchiveFlags => ['n'],
                UserID       => $Param{UserID},
            );
        }
    }
    elsif ( $Param{ObjectID} ) {
        @TicketIDs = $TicketObject->TicketSearch(
            TicketID     => $Param{ObjectID},
            Limit        => 100,
            Result       => 'ARRAY',
            ArchiveFlags => ['n'],
            UserID       => $Param{UserID},
        );
    }

    my %ResultList;

    # clean the results
    TICKET:
    for my $TicketID (@TicketIDs) {

        next TICKET if !$TicketID;

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );

        next TICKET if !%Ticket;

        # generate the ticket information string
        $ResultList{ $Ticket{TicketID} } = $Ticket{TicketNumber} . ' ' . $Ticket{Title};
    }

    return \%ResultList;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
