# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketIndexUpdate;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketIndexUpdate - recreate table to have the ticket's create_time instead of create_time_unix

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        '<TableDrop Name="ticket_index"/>',
        '<TableCreate Name="ticket_index">
            <Column Name="ticket_id" Required="true" Type="BIGINT"/>
            <Column Name="queue_id" Required="true" Type="INTEGER"/>
            <Column Name="queue" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="group_id" Required="true" Type="INTEGER"/>
            <Column Name="s_lock" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="s_state" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Index Name="ticket_index_ticket_id">
                <IndexColumn Name="ticket_id"/>
            </Index>
            <Index Name="ticket_index_queue_id">
                <IndexColumn Name="queue_id"/>
            </Index>
            <Index Name="ticket_index_group_id">
                <IndexColumn Name="group_id"/>
            </Index>
            <ForeignKey ForeignTable="ticket">
                <Reference Local="ticket_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="queue">
                <Reference Local="queue_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="groups">
                <Reference Local="group_id" Foreign="id"/>
            </ForeignKey>
        </TableCreate>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
