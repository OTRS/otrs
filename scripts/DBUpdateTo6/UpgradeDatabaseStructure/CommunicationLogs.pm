# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::CommunicationLogs;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::CommunicationLogs - Add new tables for communication logs.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # log communications
        '<Table Name="communication_log">
            <Column Name="id" Required="true"  PrimaryKey="true" Type="BIGINT" AutoIncrement="true"/>
            <Column Name="insert_fingerprint" Required="false" Size="64" Type="VARCHAR"/>
            <Column Name="transport" Required="true" Type="VARCHAR" Size="200"/>
            <Column Name="direction" Required="true" Type="VARCHAR" Size="200"/>
            <Column Name="status" Required="true" Type="VARCHAR" Size="200"/>
            <Column Name="account_type" Required="false" Size="200" Type="VARCHAR"/>
            <Column Name="account_id" Required="false" Size="200" Type="VARCHAR"/>
            <Column Name="start_time" Required="true" Type="DATE"/>
            <Column Name="end_time" Required="false" Type="DATE"/>
            <Index Name="communication_transport">
                <IndexColumn Name="transport"/>
            </Index>
            <Index Name="communication_direction">
                <IndexColumn Name="direction"/>
            </Index>
            <Index Name="communication_status">
                <IndexColumn Name="status"/>
            </Index>
        </Table>',

        '<Table Name="communication_log_object">
            <Column Name="id" Required="true"  PrimaryKey="true" Type="BIGINT" AutoIncrement="true"/>
            <Column Name="insert_fingerprint" Required="false" Size="64" Type="VARCHAR"/>
            <Column Name="communication_id" Required="true" Type="BIGINT"/>
            <Column Name="object_type" Required="true" Type="VARCHAR" Size="50"/>
            <Column Name="status" Required="true" Type="VARCHAR" Size="200" />
            <Column Name="start_time" Required="true" Type="DATE"/>
            <Column Name="end_time" Required="false" Type="DATE"/>
            <ForeignKey ForeignTable="communication_log">
                <Reference Local="communication_id" Foreign="id"/>
            </ForeignKey>
            <Index Name="communication_log_object_object_type">
                <IndexColumn Name="object_type"/>
            </Index>
            <Index Name="communication_log_object_status">
                <IndexColumn Name="status"/>
            </Index>
        </Table>',

        '<Table Name="communication_log_object_entry">
            <Column Name="id" Required="true" PrimaryKey="true" Type="BIGINT" AutoIncrement="true"/>
            <Column Name="communication_log_object_id" Required="true" Type="BIGINT"/>
            <Column Name="log_key" Required="true" Type="VARCHAR" Size="200"/>
            <Column Name="log_value" Required="true" Type="VARCHAR" Size="1800000" />
            <Column Name="priority" Required="true" Type="VARCHAR" Size="50"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <ForeignKey ForeignTable="communication_log_object">
                <Reference Local="communication_log_object_id" Foreign="id"/>
            </ForeignKey>
            <Index Name="communication_log_object_entry_key">
                <IndexColumn Name="log_key"/>
            </Index>
        </Table>',

        # create new article search index table
        '<Table Name="mail_queue">
            <Column Name="id" Required="true"  PrimaryKey="true" Type="BIGINT" AutoIncrement="true"/>
            <Column Name="insert_fingerprint" Required="false" Size="64" Type="VARCHAR"/>
            <Column Name="article_id" Required="false" Type="BIGINT" />
            <Column Name="attempts" Required="true" Type="INTEGER" />
            <Column Name="sender" Type="VARCHAR" Size="200" />
            <Column Name="recipient" Required="true" Type="VARCHAR" Size="1800000" />
            <Column Name="raw_message" Required="true" Type="LONGBLOB" />
            <Column Name="due_time" Required="false" Type="DATE"/>
            <Column Name="last_smtp_code" Required="false" Type="INTEGER" />
            <Column Name="last_smtp_message" Required="false" Type="VARCHAR" Size="1800000" />
            <Column Name="create_time" Required="true" Type="DATE"/>
            <ForeignKey ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKey>
            <Index Name="mail_queue_attempts">
                <IndexColumn Name="attempts"/>
            </Index>
            <Unique Name="mail_queue_article_id">
                <UniqueColumn Name="article_id"/>
            </Unique>
            <Unique Name="mail_queue_insert_fingerprint">
                <UniqueColumn Name="insert_fingerprint"/>
            </Unique>
        </Table>',

        # article table to persistently track the status of sent messages.
        '<Table Name="article_data_mime_send_error">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
            <Column Name="article_id" Required="true" Type="BIGINT"/>
            <Column Name="message_id" Required="false" Type="VARCHAR" Size="200"/>
            <Column Name="log_message" Required="false" Type="VARCHAR" Size="1800000"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Index Name="article_data_mime_transmission_message_id">
                <IndexColumn Name="message_id"/>
            </Index>
            <Index Name="article_data_mime_transmission_article_id">
                <IndexColumn Name="article_id"/>
            </Index>
            <ForeignKey ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

 # Table that keeps track of relation between an OTRS object (article, mail-queue, etc.) and a communication log object.
        '<Table Name="communication_log_obj_lookup">
            <Column Name="id" Required="true" PrimaryKey="true" Type="BIGINT" AutoIncrement="true"/>
            <Column Name="communication_log_object_id" Required="true" Type="BIGINT"/>
            <Column Name="object_type" Required="true" Type="VARCHAR" Size="200"/>
            <Column Name="object_id" Required="true" Type="BIGINT"/>
            <ForeignKey ForeignTable="communication_log_object">
                <Reference Local="communication_log_object_id" Foreign="id"/>
            </ForeignKey>
            <Index Name="communication_log_obj_lookup_target">
                <IndexColumn Name="object_type"/>
                <IndexColumn Name="object_id"/>
            </Index>
        </Table>',

        # Create an Index for the column 'start_time' in table 'communication_log',
        #   used in the communication-log purge.
        '<TableAlter Name="communication_log">
            <IndexCreate Name="communication_start_time">
                <IndexColumn Name="start_time"/>
            </IndexCreate>
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
