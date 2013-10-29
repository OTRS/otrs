# --
# SpecialChars.t - database tests
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
# XML test 5 - INSERT special characters test
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_d">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
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

my @SpecialCharacters = qw( - _ . : ; ' " \ [ ] { } ( ) < > ? ! $ % & / + * = ' ^ | ö ス);
push @SpecialCharacters, ( ',', '#', 'otrs test', 'otrs_test' );
my $Counter = 0;

for my $Character (@SpecialCharacters) {
    $Self->{EncodeObject}->EncodeInput( \$Character );
    my $NameB = $DBObject->Quote($Character);

    # insert
    my $Result = $DBObject->Do(
        SQL => "INSERT INTO test_d (name_a, name_b) VALUES ( '$Counter', '$NameB' )",
    );
    $Self->True(
        $Result,
        "#5.$Counter Do() INSERT",
    );

    # select = $Counter
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_a = '$Counter'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT = \$Counter",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    # select = value
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_b = '$NameB'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT = value",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    # select like value
    $NameB = $DBObject->Quote( $Character, 'Like' );
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_b LIKE '$NameB'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT LIKE value",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        next if $Character eq '%';    # do not test %, because it's wanted as % for like
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    $Counter++;
}

# special test for like with _ (underscore)
{

    # select like value (with space)
    my $NameB = $DBObject->Quote( 'otrs test', 'Like' );
    my $SQL = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$NameB'";

    my $Result = $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT COUNT LIKE $NameB (space)",
    );
    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }
    $Self->Is(
        $Count,
        1,
        "#5.$Counter $SQL (space)",
    );

    # select like value (with underscore)
    $NameB = $DBObject->Quote( 'otrs_test', 'Like' );
    $SQL = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$NameB'";

    # proof of concept that oracle needs special treatment
    # with underscores in LIKE argument, it always needs the ESCAPE parameter
    # if you want to search for a literal _ (underscore)
    # get like escape string needed for some databases (e.g. oracle)
    # this does no harm for other databases, so it should always be used where
    # a LIKE search is used
    my $LikeEscapeString = $DBObject->GetDatabaseFunction('LikeEscapeString');
    $SQL .= $LikeEscapeString;

    $Result = $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT COUNT LIKE $NameB (underscore)",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }
    $Self->Is(
        $Count,
        1,
        "#5.$Counter $SQL (underscore)",
    );

    # do the same again for oracle but without the ESCAPE and expect this to fail
    if ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
        $SQL    = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$NameB'";
        $Result = $DBObject->Prepare(
            SQL   => $SQL,
            Limit => 1,
        );
        $Self->True(
            $Result,
            "#5.$Counter Prepare() SELECT COUNT LIKE $NameB (underscore)",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Count = $Row[0];
        }
        $Self->IsNot(
            $Count,
            1,
            "#5.$Counter $SQL (underscore)",
        );
    }
}

my @UTF8Tests = (
    {

        # composed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{E4}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E4}" ),
        ResultData => "\x{E4}",
    },
    {

        # decomposed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        SelectData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        ResultData => "\x{61}\x{308}",
    },
    {

        # decomposed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E4}" ),
        ResultData => undef,
    },
    {

        # composed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{E0}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E0}" ),
        ResultData => "\x{E0}",
    },
    {

        # decomposed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        SelectData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        ResultData => "\x{61}\x{300}",
    },
    {

        # decomposed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E0}" ),
        ResultData => undef,
    },
);

UTF8TEST:
for my $UTF8Test (@UTF8Tests) {

    # extract needed test data
    my %TestData = %{$UTF8Test};

    my $Result = $DBObject->Do(
        SQL => 'INSERT INTO test_d (name_a, name_b) VALUES (?, ?)',
        Bind => [ \$Counter, \$TestData{InsertData} ],
    );
    $Self->True(
        $Result,
        "#5.$Counter UTF8: insert test",
    );

    # check insert result
    next UTF8TEST if !$Result;

    $Result = $DBObject->Prepare(
        SQL   => 'SELECT name_b FROM test_d WHERE name_a = ? AND name_b = ?',
        Bind  => [ \$Counter, \$TestData{SelectData}, ],
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter UTF8: prepare SELECT stmt",
    );

    # check prepare result
    next UTF8TEST if !$Result;

    my @UTF8ResultSet;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @UTF8ResultSet, $Row[0];
    }

    $Self->Is(
        $UTF8ResultSet[0],
        $TestData{ResultData},
        "#5.$Counter UTF8: check result data",
    );
}
continue {
    $Counter++;
}

$XML      = '<TableDrop Name="test_d"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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
