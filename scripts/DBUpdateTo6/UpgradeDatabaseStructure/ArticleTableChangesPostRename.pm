# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesPostRename;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesPostRename
    - Create new article table and change some table structures after renaming of article tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # create new article table
        '<Table Name="article">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
            <Column Name="ticket_id" Required="true" Type="BIGINT"/>
            <Column Name="article_sender_type_id" Required="true" Type="SMALLINT"/>
            <Column Name="communication_channel_id" Required="true" Type="BIGINT"/>
            <Column Name="is_visible_for_customer" Required="true" Type="SMALLINT"/>
            <Column Name="search_index_needs_rebuild" Required="true" Type="SMALLINT" Default="1"/>
            <Column Name="insert_fingerprint" Required="false" Size="64" Type="VARCHAR"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <Index Name="article_ticket_id">
                <IndexColumn Name="ticket_id"/>
            </Index>
            <Index Name="article_article_sender_type_id">
                <IndexColumn Name="article_sender_type_id"/>
            </Index>
            <Index Name="article_communication_channel_id">
                <IndexColumn Name="communication_channel_id"/>
            </Index>
            <Index Name="article_search_index_needs_rebuild">
                <IndexColumn Name="search_index_needs_rebuild"/>
            </Index>

            <ForeignKey ForeignTable="ticket">
                <Reference Local="ticket_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="communication_channel">
                <Reference Local="communication_channel_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="article_sender_type">
                <Reference Local="article_sender_type_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </Table>',

        # Add new fields to the article storage table:
        #   - article_id
        #   - a_bcc
        '<TableAlter Name="article_data_mime">
            <ColumnAdd Name="article_id" Required="true" Type="BIGINT"/>
        </TableAlter>',
        '<TableAlter Name="article_data_mime">
            <ColumnAdd Name="a_bcc" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
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
