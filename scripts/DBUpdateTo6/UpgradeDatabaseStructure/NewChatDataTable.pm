# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewChatDataTable;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewChatDataTable - Adds new table for chat data.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # article data for Chat based backend
        '<Table Name="article_data_otrs_chat">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
            <Column Name="article_id" Required="true" Type="BIGINT"/>
            <Column Name="chat_participant_id" Required="true" Size="255" Type="VARCHAR" />
            <Column Name="chat_participant_name" Required="true" Size="255" Type="VARCHAR"/>
            <Column Name="chat_participant_type" Required="true" Size="255" Type="VARCHAR"/>
            <Column Name="message_text" Required="false" Size="3800" Type="VARCHAR" />
            <Column Name="system_generated" Required="true" Type="SMALLINT" />
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Index Name="article_data_otrs_chat_article_id">
                <IndexColumn Name="article_id"/>
            </Index>
            <ForeignKey ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKey>
        </Table>',
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
