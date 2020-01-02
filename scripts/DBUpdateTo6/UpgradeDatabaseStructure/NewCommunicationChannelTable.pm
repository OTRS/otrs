# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewCommunicationChannelTable;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewCommunicationChannelTable - Adds table and data for communication channel

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (
        '<Table Name="communication_channel">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
            <Column Name="name" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="module" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="package_name" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="channel_data" Required="true" Type="LONGBLOB"/>
            <Column Name="valid_id" Required="true" Type="SMALLINT"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <Unique Name="communication_channel_name">
                <UniqueColumn Name="name"/>
            </Unique>

            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="valid">
                <Reference Local="valid_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

        '<Insert Table="communication_channel">
            <Data Key="id" Type="AutoIncrement">1</Data>
            <Data Key="name" Type="Quote">Email</Data>
            <Data Key="module" Type="Quote">Kernel::System::CommunicationChannel::Email</Data>
            <Data Key="package_name" Type="Quote">Framework</Data>
            <Data Key="channel_data" Type="Quote">---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
            </Data>
            <Data Key="valid_id">1</Data>
            <Data Key="create_by">1</Data>
            <Data Key="create_time">current_timestamp</Data>
            <Data Key="change_by">1</Data>
            <Data Key="change_time">current_timestamp</Data>
        </Insert>',

        '<Insert Table="communication_channel">
            <Data Key="id" Type="AutoIncrement">2</Data>
            <Data Key="name" Type="Quote">Phone</Data>
            <Data Key="module" Type="Quote">Kernel::System::CommunicationChannel::Phone</Data>
            <Data Key="package_name" Type="Quote">Framework</Data>
            <Data Key="channel_data" Type="Quote">---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
</Data>
            <Data Key="valid_id">1</Data>
            <Data Key="create_by">1</Data>
            <Data Key="create_time">current_timestamp</Data>
            <Data Key="change_by">1</Data>
            <Data Key="change_time">current_timestamp</Data>
        </Insert>',

        '<Insert Table="communication_channel">
            <Data Key="id" Type="AutoIncrement">3</Data>
            <Data Key="name" Type="Quote">Internal</Data>
            <Data Key="module" Type="Quote">Kernel::System::CommunicationChannel::Internal</Data>
            <Data Key="package_name" Type="Quote">Framework</Data>
            <Data Key="channel_data" Type="Quote">---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
            </Data>
            <Data Key="valid_id">1</Data>
            <Data Key="create_by">1</Data>
            <Data Key="create_time">current_timestamp</Data>
            <Data Key="change_by">1</Data>
            <Data Key="change_time">current_timestamp</Data>
        </Insert>',

        '<Insert Table="communication_channel">
            <Data Key="id" Type="AutoIncrement">4</Data>
            <Data Key="name" Type="Quote">Chat</Data>
            <Data Key="module" Type="Quote">Kernel::System::CommunicationChannel::Chat</Data>
            <Data Key="package_name" Type="Quote">Framework</Data>
            <Data Key="channel_data" Type="Quote">---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_otrs_chat
            </Data>
            <Data Key="valid_id">1</Data>
            <Data Key="create_by">1</Data>
            <Data Key="create_time">current_timestamp</Data>
            <Data Key="change_by">1</Data>
            <Data Key="change_time">current_timestamp</Data>
        </Insert>',
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
