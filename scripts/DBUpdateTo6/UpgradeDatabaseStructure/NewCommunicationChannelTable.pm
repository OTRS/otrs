# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
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
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
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
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
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
ArticleDataIsDroppable: 0
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

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string (only for new tables)
        if ( $XMLString =~ m{ <Table \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # check if table exists already
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            next XMLSTRING if $TableExists;
        }

        # extract table name from XML string (for insert statements)
        elsif ( $XMLString =~ m{ <Insert \s+ Table="([^"]+)" }xms ) {

            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract id column and value for auto increment fields
            if ( $XMLString =~ m{ <Data \s+ Key="([^"]+)" \s+ Type="AutoIncrement"> (\d+) }xms ) {

                my $ColumnName  = $1;
                my $ColumnValue = $2;

                next XMLSTRING if !$ColumnName;
                next XMLSTRING if !$ColumnValue;

                my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

                # check if value exists already
                return if !$DBObject->Prepare(
                    SQL   => "SELECT $ColumnName FROM $TableName WHERE $ColumnName = ?",
                    Bind  => [ \$ColumnValue ],
                    Limit => 1,
                );

                my $Exists;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $Exists = $Row[0];
                }

                # skip this entry if it exists already
                next XMLSTRING if $Exists;
            }
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
