# --
# ForeignKeys.t - database tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);
use Encode;

use Kernel::System::XML;

my $XMLObject = Kernel::System::XML->new( %{$Self} );
my $DBObject  = Kernel::System::DB->new( %{$Self} );


# ------------------------------------------------------------ #
# check foreign keys
# ------------------------------------------------------------ #
my $XML = '
<SQL>
    <TableCreate Name="test_foreignkeys_1">
        <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
        <Column Name="name_a" Required="true" Type="INTEGER" />
        <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
        <Unique>
            <UniqueColumn Name="name_a"/>
        </Unique>
    </TableCreate>
    <TableCreate Name="test_foreignkeys_2">
        <Column Name="name_a" Required="true" Type="INTEGER" />
        <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
        <ForeignKey ForeignTable="test_foreignkeys_1">
            <Reference Local="name_a" Foreign="name_a"/>
        </ForeignKey>
    </TableCreate>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">1</Data>
    </Insert>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">2</Data>
    </Insert>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">3</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">100</Data>
    </Insert>
        <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">101</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">200</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">201</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">300</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">301</Data>
    </Insert>
</SQL>
';

my @XMLARRAY = $XMLObject->XMLParse( String => $XML );

my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

@SQL = $DBObject->SQLProcessorPost();
$Self->True(
    $SQL[0],
    'SQLProcessorPost() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
    );
}

# remove the foreign key
$XML = '
<TableAlter Name="test_foreignkeys_2">
    <ForeignKeyDrop ForeignTable="test_foreignkeys_1">
        <Reference Local="name_a" Foreign="name_a"/>
    </ForeignKeyDrop>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
    );
}

# delete the column
$XML = '
<TableAlter Name="test_foreignkeys_1">
    <ColumnDrop Name="name_a"/>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
    );
}

# drop the test tables
$XML = '
<SQL>
    <TableDrop Name="test_foreignkeys_1"/>
    <TableDrop Name="test_foreignkeys_2"/>
</SQL>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}

1;
