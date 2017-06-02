# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
        'Test database could not be provided, skipping test'
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute XML files'
);

# Run preparation for this test
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Add chat entries.
return if !$DBObject->Prepare(
    SQL => "
        SELECT id
        FROM article_type
        WHERE name = 'chat-internal'
            OR name = 'chat-external'
    ",
);

# Look for the chat channel id
my %ArticleTypes;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $ArticleTypes{ $Row[0] } = 1;
}

ARTICLE_TYPE_NAME:
for my $ArticleTypeName (qw(chat-internal chat-external)) {

    next ARTICLE_TYPE_NAME if $ArticleTypes{$ArticleTypeName};    # article type exists, do noting

    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO article_type ( name, valid_id, create_time, create_by, change_time, change_by )
            VALUES (?, 1, current_timestamp, 1, current_timestamp, 1)',
        Bind => [ \$ArticleTypeName ],
    );
}

# Load the upgrade XML file.
my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/test/sample/DBUpdate/otrs5-initial_insert_chat.xml",
);

# Execute the the upgrade XML file.
$Helper->DatabaseXMLExecute(
    XML => ${$XMLString},
);

# Check tables are not present before migration script
my @Tables = $DBObject->ListTables();

my @NewTablesName = ( 'article_data_mime', 'article_data_otrs_chat' );

my %CurrentTables = map { lc($_) => 1 } @Tables;

# New tables shouldn't exist.
for my $TableName (@NewTablesName) {
    $Self->False(
        $CurrentTables{$TableName},
        "Table $TableName is not present in database!",
    );
}

# Load the upgrade XML file.
$XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/database/update/otrs-upgrade-to-6.xml",
);

# Execute the the upgrade XML file.
$Helper->DatabaseXMLExecute(
    XML => ${$XMLString},
);

# Get new tables list.
@Tables = $DBObject->ListTables();
%CurrentTables = map { lc($_) => 1 } @Tables;

# New tables might exist in database.
for my $TableName (@NewTablesName) {
    $Self->True(
        $CurrentTables{$TableName},
        "Table $TableName is present in database!",
    );
}

my $ArticleMigrateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::OCBIMigrateArticleData');
$Self->True(
    $ArticleMigrateObject,
    'Article migrate object successfully created!'
);

my $MigrateSuccess = $ArticleMigrateObject->Run();

$Self->Is(
    1,
    $MigrateSuccess,
    'ArticleMigrateObject ran without problems.'
);

# Init real test.
# On previous step article table was renamed
# then in next step a new article table and
# communication_channel table should be created

my $CheckData = sub {
    my %Param = @_;

    my $Test     = $Param{Test};
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => 'SELECT id, name FROM communication_channel',
    );

    # Look for the chat channel id
    my $ChatChannelID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[1] =~ /Chat/i ) {
            $ChatChannelID = $Row[0];
        }
    }

    my $ArticleChatCount = 0;
    my $ChatCount        = 0;

    # Get amount of article entries
    $DBObject->Prepare(
        SQL => '
            SELECT COUNT(*) FROM article_data_mime
            WHERE
                article_id IN (
                    SELECT id
                    FROM article
                    WHERE communication_channel_id = ?
                ) ',
        Bind => [ \$ChatChannelID ]
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleChatCount = $Row[0] || 0;
    }

    # Get amount of article entries
    $DBObject->Prepare(
        SQL => "SELECT COUNT(*) FROM article_data_otrs_chat",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ChatCount = $Row[0] || 0;
    }

    if ( $Test eq 'Is' ) {

        $Self->Is(
            $ArticleChatCount,
            0,
            'The article table should be empty - Article Count'
        );
        $Self->IsNot(
            $ChatCount,
            0,
            'The chat table should not be empty - Count'
        );

        $Self->IsNot(
            $ArticleChatCount,
            $ChatCount,
            "The same amount of rows should NOT be present in article_data_mime($ArticleChatCount) and article_data_otrs_chat($ChatCount) tables.",
        );
        $Self->True(
            1,
            'The article_data_mime and article_data_otrs_chat tables have not chat rows.'
        );
    }
    else {
        $Self->IsNot(
            $ArticleChatCount,
            $ChatCount,
            'In article_data_mime and article_data_otrs_chat should not be the same amount of data.'
        );
        $Self->IsNot(
            $ArticleChatCount,
            0,
            'The article table should not be empty - Article Count'
        );
        $Self->Is(
            $ChatCount,
            0,
            'The chat table should be empty - Count'
        );

    }

};

$CheckData->(
    Test => 'IsNot',
);

my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::OCBIMigrateChatData');
$Self->True(
    $DBUpdateObject,
    'Database update object successfully created!'
);

my $RunSuccess = $DBUpdateObject->Run();

$Self->True(
    $RunSuccess,
    'DBUpdateObject ran with problems information present in tables.'
);

$CheckData->(
    Test => 'Is',
);

# Run module again

$RunSuccess = $DBUpdateObject->Run();

$Self->True(
    $RunSuccess,
    'DBUpdateObject ran a second time with problems information present in tables.'
);

$CheckData->(
    Test => 'Is',
);

# Cleanup is done by TmpDatabaseCleanup().

1;
