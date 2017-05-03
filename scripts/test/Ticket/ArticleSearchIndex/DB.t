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

#
# This test should make sure that after switching from StaticDB to RuntimeDB,
# tickets with stale entries in article_search can still be deleted (see bug#11677).
#

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

# create some content
my $TicketID = $TicketObject->TicketCreate(
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
    'TicketCreate()'
);

my %ArticleIDs;

for my $Count ( 1 .. 3 ) {

    $ArticleIDs{$Count} = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 1,
        From                 => "Some Agent $RandomID <email\@example.com>",
        To                   => "Some Customer $RandomID <customer\@example.com>",
        Subject              => "some short description $RandomID",
        Body                 => "the message text
    Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.",
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => "Some free text $RandomID!",
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True(
        $ArticleIDs{$Count},
        'ArticleCreate()'
    );

    my $IndexBuiltSuccess = $ArticleObject->ArticleIndexBuild(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs{$Count},
        UserID    => 1,
    );
    $Self->True(
        $IndexBuiltSuccess,
        "Search index was created (Article $Count)."
    );
}

my @ArticleIndexTests = (
    {
        Name => 'article search index MIMEBase_From',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            MIMEBase_From       => 'spam@example.com',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index MIMEBase_From ON art.id = MIMEBase_From.article_id AND MIMEBase_From.article_key = 'MIMEBase_From' ",
        Conditions => " AND ( MIMEBase_From.article_value LIKE '\%spam\@example.com\%') ",
    },
    {
        Name => 'article search index MIMEBase_To',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            MIMEBase_To         => 'spam@example.com',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index MIMEBase_To ON art.id = MIMEBase_To.article_id AND MIMEBase_To.article_key = 'MIMEBase_To' ",
        Conditions => " AND ( MIMEBase_To.article_value LIKE '\%spam\@example.com\%') ",
    },
    {
        Name => 'article search index MIMEBase_Cc',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            MIMEBase_Cc         => 'spam@example.com',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index MIMEBase_Cc ON art.id = MIMEBase_Cc.article_id AND MIMEBase_Cc.article_key = 'MIMEBase_Cc' ",
        Conditions => " AND ( MIMEBase_Cc.article_value LIKE '\%spam\@example.com\%') ",
    },
    {
        Name => 'article search index MIMEBase_Subject',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            MIMEBase_Subject    => 'VIRUS 32',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index MIMEBase_Subject ON art.id = MIMEBase_Subject.article_id AND MIMEBase_Subject.article_key = 'MIMEBase_Subject' ",
        Conditions => " AND ( MIMEBase_Subject.article_value LIKE '\%virus 32\%') ",
    },
    {
        Name => 'article search index MIMEBase_Body',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            MIMEBase_Body       => 'VIRUS 32',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index MIMEBase_Body ON art.id = MIMEBase_Body.article_id AND MIMEBase_Body.article_key = 'MIMEBase_Body' ",
        Conditions => " AND ( MIMEBase_Body.article_value LIKE '\%virus 32\%') ",
    },
    {
        Name => 'article search index Chat_MessageText',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            Chat_MessageText    => 'Some Message Text',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index Chat_MessageText ON art.id = Chat_MessageText.article_id AND Chat_MessageText.article_key = 'Chat_MessageText' ",
        Conditions => " AND ( Chat_MessageText.article_value LIKE '\%some message text\%') ",
    },
    {
        Name => 'article search index Chat_MessageText with doubled percentages',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            Chat_MessageText    => '%Some Message Text%',
        },
        Needed => 1,
        Joins =>
            " LEFT JOIN article_search_index Chat_MessageText ON art.id = Chat_MessageText.article_id AND Chat_MessageText.article_key = 'Chat_MessageText' ",
        Conditions => " AND ( Chat_MessageText.article_value LIKE '\%some message text\%') ",
    },
    {
        Name => 'article search index not needed',
        Data => {
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
        },
        Needed     => undef,
        Joins      => ' ',
        Conditions => '',
    },
);

for my $Test (@ArticleIndexTests) {

    my $Needed = $ArticleObject->ArticleSearchIndexNeeded(
        Data => $Test->{Data},
    );
    $Self->Is(
        $Needed,
        $Test->{Needed},
        'ArticleSearchIndexNeeded - ' . $Test->{Name},
    );

    my $SQLJoins = $ArticleObject->ArticleSearchIndexJoin(
        Data => $Test->{Data},
    );
    $Self->Is(
        $SQLJoins,
        $Test->{Joins},
        'ArticleSearchIndexJoin - ' . $Test->{Name},
    );

    my $SQLConditions = $ArticleObject->ArticleSearchIndexCondition(
        Data => $Test->{Data},
    );
    $Self->Is(
        $SQLConditions,
        $Test->{Conditions},
        'ArticleSearchIndexCondition - ' . $Test->{Name},
    );
}

# remove the first article from search index
my $IndexDeleteSuccess = $ArticleObject->ArticleIndexDelete(
    TicketID  => $TicketID,
    ArticleID => $ArticleIDs{1},
    UserID    => 1,
);
$Self->True(
    $IndexDeleteSuccess,
    "Article was removed from the index."
);

# remove the first article from search index
my $IndexDeleteTicketSuccess = $ArticleObject->ArticleIndexDeleteTicket(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $IndexDeleteTicketSuccess,
    "All articles related to the ticket are removed from the index."
);

# Discard existing ticket object.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    'TicketDelete()'
);

# cleanup is done by RestoreDatabase.

1;
