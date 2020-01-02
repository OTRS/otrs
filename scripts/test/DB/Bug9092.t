# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create test ticket and article
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
)->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);
$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

# create test user
my $UserObject = $Kernel::OM->Get('Kernel::System::User');
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();

=cut
This test is supposed to verify the solution for bug#9092, which showed
that on certain versions of MySQL with InnoDB, dropping indices causes
problems because the indices actually contain foreign key constraint data.

A workaround is to first drop the foreign key constraints, then drop the indices, and
then re-add the foreign keyconstraints again.
=cut

my @Tests = (

    # article flag table as defined in OTRS 3.1
    '<Table Name="bug9092">
        <Column Name="article_id" Required="true" Type="BIGINT"/>
        <Column Name="article_key" Required="true" Size="50" Type="VARCHAR"/>
        <Column Name="article_value" Required="false" Size="50" Type="VARCHAR"/>
        <Column Name="create_time" Required="true" Type="DATE"/>
        <Column Name="create_by" Required="true" Type="INTEGER"/>
        <Index Name="bug9092_article_id_create_by">
            <IndexColumn Name="article_id"/>
            <IndexColumn Name="create_by"/>
        </Index>
        <Index Name="bug9092_article_id_article_key">
            <IndexColumn Name="article_id"/>
            <IndexColumn Name="article_key"/>
        </Index>
        <Index Name="bug9092_create_by">
            <IndexColumn Name="create_by"/>
        </Index>
        <Index Name="bug9092_article_id">
            <IndexColumn Name="article_id"/>
        </Index>
        <ForeignKey ForeignTable="article">
            <Reference Local="article_id" Foreign="id"/>
        </ForeignKey>
        <ForeignKey ForeignTable="users">
            <Reference Local="create_by" Foreign="id"/>
        </ForeignKey>
    </Table>',

    # insert test data
    '<Insert Table="bug9092">
        <Data Key="article_id">' . $ArticleID . '</Data>
        <Data Key="article_key" Type="Quote">Seen</Data>
        <Data Key="article_value" Type="Quote">' . $UserID . '</Data>
        <Data Key="create_time" Type="">current_timestamp</Data>
        <Data Key="create_by">1</Data>
    </Insert>',

    # drop foreign keys
    '<TableAlter Name="bug9092">
        <ForeignKeyDrop ForeignTable="article">
            <Reference Local="article_id" Foreign="id"/>
        </ForeignKeyDrop>
        <ForeignKeyDrop ForeignTable="users">
            <Reference Local="create_by" Foreign="id"/>
        </ForeignKeyDrop>
    </TableAlter>',

    # drop unneeded indices
    '<TableAlter Name="bug9092">
        <IndexDrop Name="bug9092_create_by"/>
        <IndexDrop Name="bug9092_article_id_article_key"/>
    </TableAlter>',

    # recreate foreign keys
    '<TableAlter Name="bug9092">
        <ForeignKeyCreate ForeignTable="article">
            <Reference Local="article_id" Foreign="id"/>
        </ForeignKeyCreate>
        <ForeignKeyCreate ForeignTable="users">
            <Reference Local="create_by" Foreign="id"/>
        </ForeignKeyCreate>
    </TableAlter>',

    # cleanup test table
    '<TableDrop Name="bug9092"/>',
);

for my $Test (@Tests) {
    my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $Test );
    my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
    my @SQLPost  = $DBObject->SQLProcessorPost( Database => \@XMLARRAY );

    for my $SQL ( @SQL, @SQLPost ) {
        $Self->True(
            $DBObject->Do( SQL => $SQL ) || 0,
            "$SQL",
        );
    }
}

# cleanup is done by RestoreDatabase.

1;
