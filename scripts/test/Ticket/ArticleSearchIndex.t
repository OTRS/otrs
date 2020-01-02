# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Tests for article search index modules.
for my $Module (qw(DB)) {

    # Make sure that the ticket and article objects get recreated for each loop.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::Ticket',
            'Kernel::System::Ticket::Article',
        ],
    );

    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );

    # Make sure indexed text is filtered on start.
    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndex::ForceUnfilteredStorage',
        Value => 0,
    );

    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

    $Self->Is(
        $ArticleObject->{ArticleSearchIndexModule},
        'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
        'ArticleObject loaded the correct backend'
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
        'TicketCreate()'
    );

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer@example.com>',
        Subject              => 'some short description',
        Body                 => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
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

    # Since article search indexing is now run as an async call, make sure to call the index build method directly.
    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # search
    my %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Subject => '%short%',
        Result           => 'HASH',
        Limit            => 100,
        UserID           => 1,
        Permission       => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Subject)'
    );

    $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer@example.com>',
        Subject              => 'Fax Agreement laalala',
        Body                 => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
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

    # Since article search indexing is now run as an async call, make sure to call the index build method directly.
    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Subject => '%fax agreement%',
        Result           => 'HASH',
        Limit            => 100,
        UserID           => 1,
        Permission       => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Subject)'
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Body => '%HELP%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Body)'
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Body => '%HELP_NOT_FOUND%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        !$TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Body)'
    );

    # Try to find ticket by including obvious stop words in search query.
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Body => '%a range of features%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        !$TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Body)'
    );

    # Force unfiltered indexing
    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndex::ForceUnfilteredStorage',
        Value => 1,
    );

    # Since article search indexing is now run as an async call, make sure to call the index build method directly.
    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # Try again to find ticket by searching for same query.
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Body => '%a range of features%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Body)'
    );

    # Turn back on filtering of indexed text.
    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndex::ForceUnfilteredStorage',
        Value => 0,
    );

    # use full text search on ticket with Cyrillic characters
    # see bug #11791 ( http://bugs.otrs.org/show_bug.cgi?id=11791 )
    $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer@example.com>',
        Subject              => 'Испытуемый',
        Body                 => 'Это полный приговор',
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
        NoAgentNotify        => 1,
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()'
    );

    # Since article search indexing is now run as an async call, make sure to call the index build method directly.
    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Subject => '%испытуемый%',
        Result           => 'HASH',
        Limit            => 100,
        UserID           => 1,
        Permission       => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Subject)'
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        MIMEBase_Body => '%полный%',
        Result        => 'HASH',
        Limit         => 100,
        UserID        => 1,
        Permission    => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:MIMEBase_Body)'
    );

    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Delete,
        'TicketDelete()'
    );
}

my @Tests = (
    {
        Name   => 'Regular string',
        String => 'Regular subject string',
        Result => [
            'regular',
            'subject',
            'string',
        ],
    },
    {
        Name   => 'Filtered characters',
        String => 'Test characters ,&<>?"!*|;[]()+$^=',
        Result => [
            'test',
            'characters',
        ],
    },
    {
        Name   => 'String with quotes',
        String => '"String with quotes"',
        Result => [
            'string',
            'quotes',
        ],
    },
    {
        Name   => 'Sentence',
        String => 'This is a full sentence',
        Result => [
            'full',
            'sentence',
        ],
    },
    {
        Name   => 'English - Stop words',
        String => 'is a the of for and',
        Result => [
        ],
    },
    {
        Name   => 'German - Stop words',
        String => 'ist eine der von für und',
        Result => [
        ],
    },
    {
        Name   => 'Dutch - Stop words',
        String => 'goed tijd hebben voor gaan',
        Result => [
        ],
    },
    {
        Name   => 'Spanish - Stop words',
        String => 'también algún siendo arriba',
        Result => [
        ],
    },
    {
        Name   => 'French - Stop words',
        String => 'là pièce étaient où',
        Result => [
        ],
    },
    {
        Name   => 'Italian - Stop words',
        String => 'avevano consecutivo meglio nuovo',
        Result => [
        ],
    },
    {
        Name   => 'Word too short',
        String => 'Word x',
        Result => [
            'word',
        ],
    },
    {
        Name   => 'Word too long',
        String => 'Word ' . 'x' x 50,
        Result => [
            'word',
        ],
    },
    {
        Name   => '# @ Characters alone',
        String => '# Word @ Something',
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
        Name   => 'Cyrillic Serbian string',
        String => 'Чудесна жута шума',
        Result => [
            'чудесна',
            'жута',
            'шума',
        ],
    },
    {
        Name   => 'Latin Croatian string',
        String => 'Čudesna žuta šuma',
        Result => [
            'čudesna',
            'žuta',
            'šuma',
        ],
    },
    {
        Name   => 'Cyrillic Russian string',
        String => 'Это полный приговор',
        Result => [
            'это',
            'полный',
            'приговор',
        ],
    },
    {
        Name   => 'Chinese string',
        String => '这是一个完整的句子',
        Result => [
            '这是一个完整的句子',
        ],
    },
);

for my $Module (qw(DB)) {
    for my $Test (@Tests) {

        my $IndexObject = $Kernel::OM->Get( 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module );

        my $ListOfWords = $IndexObject->_ArticleSearchIndexStringToWord(
            String => \$Test->{String},
        );

        $Self->IsDeeply(
            $ListOfWords,
            $Test->{Result},
            "$Test->{Name} - _ArticleSearchIndexStringToWord result"
        );
    }
}

# cleanup is done by RestoreDatabase

1;
