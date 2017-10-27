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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# tests for article search index modules
for my $Module (qw(StaticDB RuntimeDB)) {

    # make sure that the TicketObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->True(
        $TicketObject->isa( 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module ),
        "TicketObject loaded the correct backend",
    );

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
        'TicketCreate()',
    );

    # Create article without useful body for indexing.
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer@example.com>',
        Subject        => 'mountain ocean water',
        Body           => 'and again after',                        # just stop words to be filtered out
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()'
    );

    my %TicketIDs = $TicketObject->TicketSearch(
        FullTextIndex => 1,
        Subject       => '%mountain%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)'
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'some short description',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Subject    => '%short%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'Fax Agreement laalala',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Subject    => '%fax agreement%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body       => '%HELP%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body       => '%HELP_NOT_FOUND%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        !$TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    # use full text search on ticket with Cyrillic characters
    # see bug #11791 ( http://bugs.otrs.org/show_bug.cgi?id=11791 )
    $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer@example.com>',
        Subject        => 'Испытуемый',
        Body           => 'Это полный приговор',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Subject    => '%испытуемый%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body       => '%полный%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Delete,
        'TicketDelete()',
    );
}

my @Tests = (
    {
        Name   => "Regular string",
        String => 'Regular subject string',
        Result => [
            "regular",
            "subject",
            "string",
        ],
    },
    {
        Name   => "Filtered characters",
        String => 'Test characters ,&<>?"!*|;[]()+$^=',
        Result => [
            "test",
            "characters",
        ],
    },
    {
        Name   => "String with quotes",
        String => '"String with quotes"',
        Result => [
            "string",
            "quotes",
        ],
    },
    {
        Name   => "Sentence",
        String => 'This is a full sentence',
        Result => [
            "full",
            "sentence",
        ],
    },
    {
        Name   => "English - Stop words",
        String => 'is a the of for and',
        Result => [
        ],
    },
    {
        Name   => "German - Stop words",
        String => 'ist eine der von für und',
        Result => [
        ],
    },
    {
        Name   => "Dutch - Stop words",
        String => 'goed tijd hebben voor gaan',
        Result => [
        ],
    },
    {
        Name   => "Spanish - Stop words",
        String => 'también algún siendo arriba',
        Result => [
        ],
    },
    {
        Name   => "French - Stop words",
        String => 'là pièce étaient où',
        Result => [
        ],
    },
    {
        Name   => "Italian - Stop words",
        String => 'avevano consecutivo meglio nuovo',
        Result => [
        ],
    },
    {
        Name   => "Word too short",
        String => 'Word x',
        Result => [
            'word',
        ],
    },
    {
        Name   => "Word too long",
        String => 'Word ' . 'x' x 50,
        Result => [
            'word',
        ],
    },
    {
        Name   => '# @ Characters alone',
        String => "# Word @ Something",
        Result => [
            'word',
            'something',
        ],
    },
    {
        Name   => '# @ Characters with other words',
        String => '#Word @Something',
        Result => [
            '#word',
            '@something',
        ],
    },
    {
        Name   => "Cyrillic Serbian string",
        String => "Чудесна жута шума",
        Result => [
            "чудесна",
            "жута",
            "шума"
        ],
    },
    {
        Name   => "Latin Croatian string",
        String => "Čudesna žuta šuma",
        Result => [
            "čudesna",
            "žuta",
            "šuma"
        ],
    },
    {
        Name   => "Cyrillic Russian string",
        String => "Это полный приговор",
        Result => [
            "это",
            "полный",
            "приговор",
        ],
    },
    {
        Name   => "Chinese string",
        String => "这是一个完整的句子",
        Result => [
            "这是一个完整的句子",
        ],
    },
);

for my $Module (qw(StaticDB)) {
    for my $Test (@Tests) {

        # Make sure that the TicketObject gets recreated for each loop.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

        $ConfigObject->Set(
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $ListOfWords = $TicketObject->_ArticleIndexStringToWord(
            String => \$Test->{String}
        );

        $Self->IsDeeply(
            $ListOfWords,
            $Test->{Result},
            "$Test->{Name} - _ArticleIndexStringToWord result",
        );
    }
}

# cleanup is done by RestoreDatabase

1;
