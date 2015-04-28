# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

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
        <Data Key="article_id">1</Data>
        <Data Key="article_key" Type="Quote">Seen</Data>
        <Data Key="article_value" Type="Quote">1</Data>
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
    my @XMLARRAY = $XMLObject->XMLParse( String => $Test );
    my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
    my @SQLPost = $DBObject->SQLProcessorPost( Database => \@XMLARRAY );

    for my $SQL ( @SQL, @SQLPost ) {
        $Self->True(
            $DBObject->Do( SQL => $SQL ) || 0,
            "$SQL",
        );
    }
}

1;
