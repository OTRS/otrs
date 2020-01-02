# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesPreRename;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesPreRename - Change article table structure and
prepare renaming of article tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # mapping with old to new table names
    my %Old2NewTableNames = (
        'article'            => 'article_data_mime',
        'article_plain'      => 'article_data_mime_plain',
        'article_attachment' => 'article_data_mime_attachment',
    );

    my @XMLStrings = (

        # Increase column sizes, see bug#5420.
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_from" NameNew="a_from" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_reply_to" NameNew="a_reply_to" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_to" NameNew="a_to" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_cc" NameNew="a_cc" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_references" NameNew="a_references" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_in_reply_to" NameNew="a_in_reply_to" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',

        # Make article body and attachment content optional, see bug#10509.
        '<TableAlter Name="article">
            <ColumnChange NameOld="a_body" NameNew="a_body" Required="false" Size="1800000" Type="VARCHAR"/>
        </TableAlter>',

        # Make article body and attachment content optional, see bug#10509.
        '<TableAlter Name="article_attachment">
            <ColumnChange NameOld="content" NameNew="content" Required="false" Type="LONGBLOB"/>
        </TableAlter>',

        # Make article body and attachment content optional, see bug#10509.
        '<TableAlter Name="virtual_fs_db">
            <ColumnChange NameOld="content" NameNew="content" Required="false" Type="LONGBLOB"/>
        </TableAlter>',

        # Before renaming, drop foreign keys and indexes of the article table.
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="valid">
                <Reference Local="valid_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="ticket">
                <Reference Local="ticket_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="article_type">
                <Reference Local="article_type_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="article_sender_type">
                <Reference Local="article_sender_type_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article">
            <IndexDrop Name="article_ticket_id"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <IndexDrop Name="article_article_type_id"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <IndexDrop Name="article_article_sender_type_id"/>
        </TableAlter>',
        '<TableAlter Name="article">
            <IndexDrop Name="article_message_id_md5"/>
        </TableAlter>',

        # Before renaming, drop foreign keys and indexes of the article_plain table
        '<TableAlter Name="article_plain">
            <ForeignKeyDrop ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_plain">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_plain">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_plain">
            <IndexDrop Name="article_plain_article_id"/>
        </TableAlter>',

        # Before renaming, drop foreign keys and indexes of the article_attachment table
        '<TableAlter Name="article_attachment">
            <ForeignKeyDrop ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_attachment">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_attachment">
            <ForeignKeyDrop ForeignTable="users">
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_attachment">
            <IndexDrop Name="article_attachment_article_id"/>
        </TableAlter>',

        # Drop foreign keys pointing to the current article table,
        # due in some cases these are automatically redirected to the renamed table.
        '<TableAlter Name="ticket_history">
            <ForeignKeyDrop ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="article_flag">
            <ForeignKeyDrop ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
        '<TableAlter Name="time_accounting">
            <ForeignKeyDrop ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyDrop>
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray          => \@XMLStrings,
        Old2NewTableNames => \%Old2NewTableNames,
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
