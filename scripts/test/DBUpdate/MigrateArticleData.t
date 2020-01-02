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

my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @DatabaseXMLFiles = (
    "$Home/scripts/test/sample/DBUpdate/otrs5-schema.xml",
    "$Home/scripts/test/sample/DBUpdate/otrs5-initial_insert.xml",
);

my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => \@DatabaseXMLFiles,
);
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute XML files',
);

# Run preparation for this test
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Check tables are not present before migration script
my @Tables = $DBObject->ListTables();

my @OldTablesName = ( 'article',           'article_plain',           'article_attachment' );
my @NewTablesName = ( 'article_data_mime', 'article_data_mime_plain', 'article_data_mime_attachment' );

my %CurrentTables = map { lc($_) => 1 } @Tables;

# Old tables should exist and new ones not yet.
for my $TableName (@OldTablesName) {
    $Self->True(
        $CurrentTables{$TableName},
        "Table $TableName is present in database!",
    );
}

# New tables shouldn't exist.
for my $TableName (@NewTablesName) {
    $Self->False(
        $CurrentTables{$TableName},
        "Table $TableName is not present in database!",
    );
}

my $XMLString = <<"EOF";
<?xml version="1.0" encoding="utf-8" ?>
<database Name="otrs">
    <Insert Table="ticket">
        <Data Key="id">2</Data>
        <Data Key="tn" Type="Quote">2017050210100001</Data>
        <Data Key="queue_id">2</Data>
        <Data Key="ticket_lock_id">1</Data>
        <Data Key="user_id">1</Data>
        <Data Key="responsible_user_id">1</Data>
        <Data Key="ticket_priority_id">3</Data>
        <Data Key="ticket_state_id">1</Data>
        <Data Key="title" Type="Quote">Article data migration test</Data>
        <Data Key="create_time_unix">1436949031</Data>
        <Data Key="timeout">0</Data>
        <Data Key="until_time">0</Data>
        <Data Key="escalation_time">0</Data>
        <Data Key="escalation_response_time">0</Data>
        <Data Key="escalation_update_time">0</Data>
        <Data Key="escalation_solution_time">0</Data>
        <Data Key="create_by">1</Data>
        <Data Key="create_time">current_timestamp</Data>
        <Data Key="change_by">1</Data>
        <Data Key="change_time">current_timestamp</Data>
    </Insert>
EOF

for my $Index ( 1 .. 40 ) {

    my $ArticleID = $Index + 3;
    $XMLString .= <<"EOF";
    <Insert Table="article">
        <Data Key="id">$ArticleID</Data>
        <Data Key="ticket_id">2</Data>
        <Data Key="article_type_id">1</Data>
        <Data Key="article_sender_type_id">1</Data>
        <Data Key="a_body" Type="Quote">Test.</Data>
        <Data Key="incoming_time">1436949031</Data>
        <Data Key="valid_id">1</Data>
        <Data Key="create_by">1</Data>
        <Data Key="create_time">current_timestamp</Data>
        <Data Key="change_by">1</Data>
        <Data Key="change_time">current_timestamp</Data>
    </Insert>
EOF
}

$XMLString .= <<"EOF";
</database>
EOF

# Execute the the article insert XML string.
$Helper->DatabaseXMLExecute(
    XML => $XMLString,
);

# Delete some article entries in order to test what happend
# if not all the autoincremental values are present
$Success = $DBObject->Do(
    SQL => "DELETE FROM article WHERE id in (13, 17, 29, 35)",
);
$Self->True(
    $Success,
    'Delete some article entries for creating empty records in tha table!',
);

my $UpgradeSuccess = $Kernel::OM->Create('scripts::DBUpdateTo6::UpgradeDatabaseStructure')->Run();

$Self->Is(
    1,
    $UpgradeSuccess,
    'Upgrade database structure to latest version.',
);

# Get new tables list.
@Tables        = $DBObject->ListTables();
%CurrentTables = map { lc($_) => 1 } @Tables;

# Old tables should not exist any more
OLDTABLES:
for my $TableName (@OldTablesName) {

    # New article table should exist.
    next OLDTABLES if $TableName eq 'article';

    $Self->False(
        $CurrentTables{$TableName},
        "Table $TableName is not present in database!",
    );
}

# New article table should exist.
push @NewTablesName, 'article';

# New tables might exist in database.
for my $TableName (@NewTablesName) {
    $Self->True(
        $CurrentTables{$TableName},
        "Table $TableName is present in database!",
    );
}

# Init real test.
# On previous step article table was renamed
# then in next step a new article table and
# communication_channel table should be created

my $CheckData = sub {
    my %Param = @_;

    my $Test     = $Param{Test};
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TablesData = (
        'article' => {
            MaxID => 0,
            Count => 0,
        },
        'article_data_mime' => {
            MaxID => 0,
            Count => 0,
        },
    );

    for my $TableName ( sort keys %TablesData ) {

        # Get last id.
        return if !$DBObject->Prepare(
            SQL => "SELECT MAX(id) FROM $TableName",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TablesData{$TableName}->{MaxID} = $Row[0] || 0;
        }

        # Get amount of entries
        return if !$DBObject->Prepare(
            SQL => "SELECT COUNT(*) FROM $TableName",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TablesData{$TableName}->{Count} = $Row[0] || 0;
        }
    }

    if ( $Test eq 'Is' ) {

        $Self->Is(
            $TablesData{article}->{Count},
            $TablesData{article_data_mime}->{Count},
            'The same amount of rows should be present in article and article_data_mime tables.',
        );
        $Self->Is(
            $TablesData{article}->{MaxID},
            $TablesData{article_data_mime}->{MaxID},
            'The last included ID on each table (article and article_data_mime) should be the same.',
        );

        # TODO:OCBI: Insert a new record, ID should be the next after MAXID
        # Currently is not possible due data migration is already done, including
        # new article data structure
    }
    else {
        $Self->IsNot(
            $TablesData{article}->{Count},
            $TablesData{article_data_mime}->{Count},
            'In article and article_data_mime should not be the same amount of data.',
        );
        $Self->IsNot(
            $TablesData{article}->{MaxID},
            $TablesData{article_data_mime}->{MaxID},
            'The last included ID on each table (article and article_data_mime) should not be the same.',
        );
        $Self->Is(
            $TablesData{article}->{MaxID},
            0,
            'The article table should be empty - MaxID',
        );
        $Self->Is(
            $TablesData{article}->{Count},
            0,
            'The article table should be empty - Count',
        );

    }

};

$CheckData->(
    Test => 'IsNot',
);

my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateArticleData');
$Self->True(
    $DBUpdateObject,
    'Database update object successfully created!',
);

my $RunSuccess = $DBUpdateObject->Run(
    RowsPerLoop        => 10,
    CommandlineOptions => {
        Verbose => 1,
    },
);

$Self->Is(
    1,
    $RunSuccess,
    'DBUpdateObject ran without problems.',
);

$CheckData->(
    Test => 'Is',
);

# Cleanup is done by TmpDatabaseCleanup().

1;
