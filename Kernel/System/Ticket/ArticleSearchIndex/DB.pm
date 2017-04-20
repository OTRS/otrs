# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ArticleSearchIndex::DB;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub ArticleIndexBuild {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
    );

    my %ArticleSearchableContent = $ArticleBackendObject->ArticleSearchableContentGet(
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # clear old data from search index table
    $DBObject->Do(
        SQL  => 'DELETE FROM article_search_index WHERE article_id = ?',
        Bind => [ \$Param{ArticleID}, ],
    );

    FIELD:
    for my $Field ( sort keys %ArticleSearchableContent ) {

        next FIELD if !$Field;
        next FIELD if !IsHashRefWithData( $ArticleSearchableContent{$Field} );

        if ( $ArticleSearchableContent{$Field}->{Filterable} ) {
            $ArticleSearchableContent{$Field}->{String} = $Self->_ArticleIndexString(
                %{ $ArticleSearchableContent{$Field} }
            );
        }

        $DBObject->Do(
            SQL => '
                INSERT INTO article_search_index (ticket_id, article_id, article_key, article_value)
                VALUES (?, ?, ?, ?)',
            Bind => [
                \$Param{TicketID}, \$Param{ArticleID}, \$ArticleSearchableContent{$Field}->{Key},
                \$ArticleSearchableContent{$Field}->{String},
            ],
        );
    }

    return 1;
}

sub ArticleIndexDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete articles
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_search_index WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    return 1;
}

sub ArticleIndexDeleteTicket {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete articles
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM article_search_index WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ],
    );

    return 1;
}

sub _ArticleIndexQuerySQL {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data!"
        );
        return;
    }

    my @BackendSearchableFields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendSearchableFieldsList();

    for (
        @BackendSearchableFields,
        qw(
        ArticleCreateTimeOlderMinutes ArticleCreateTimeNewerMinutes
        ArticleCreateTimeOlderDate ArticleCreateTimeNewerDate
        )
        )
    {
        if ( IsStringWithData( $Param{Data}->{$_} ) ) {
            return ' INNER JOIN article_search_index art ON st.id = art.ticket_id ';
        }
    }

    return '';
}

sub _ArticleIndexQuerySQLExt {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data!"
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQLExt   = '';
    my $SQLQuery = '';

    my @Fields = ('Fulltext');

    if ( !IsStringWithData( $Param{Data}->{Fulltext} ) ) {
        @Fields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendSearchableFieldsList();
    }

    FIELD:
    for my $Field (@Fields) {

        next FIELD if !$Field;
        next FIELD if !$Param{Data}->{$Field};

        # replace * by % for SQL like
        $Param{Data}->{$Field} =~ s/\*/%/gi;

        # check search attribute, we do not need to search for *
        next FIELD if $Param{Data}->{$Field} =~ /^\%{1,3}$/;

        if ($SQLQuery) {
            $SQLQuery .= ' ' . $Param{Data}->{ContentSearch} . ' ';
        }

        # check if search condition extension is used
        if ( $Param{Data}->{ConditionInline} ) {

            my $SQLFieldCondition;

            if ( $Field ne 'Fulltext' ) {
                $SQLFieldCondition = $DBObject->QueryCondition(
                    Key   => 'art.article_key',
                    Value => $Field,
                );
            }

            my $SQLQueryCondition = $DBObject->QueryCondition(
                Key           => 'art.article_value',
                Value         => lc $Param{Data}->{$Field},
                SearchPrefix  => $Param{Data}->{ContentSearchPrefix},
                SearchSuffix  => $Param{Data}->{ContentSearchSuffix},
                Extended      => 1,
                CaseSensitive => 1,                                     # data is already stored in lower cases
            );

            if ( IsStringWithData($SQLFieldCondition) ) {
                $SQLQuery .= "($SQLFieldCondition AND $SQLQueryCondition)";
                next FIELD;
            }

            $SQLQuery .= $SQLQueryCondition;
        }
        else {

            my $SQLFieldCondition;

            if ( $Field ne 'Fulltext' ) {

                $Field = $DBObject->Quote($Field);

                $SQLFieldCondition = "art.article_key = $Field";
            }

            my $Value = $Param{Data}->{$Field};

            if ( $Param{Data}->{ContentSearchPrefix} ) {
                $Value = $Param{Data}->{ContentSearchPrefix} . $Value;
            }
            if ( $Param{Data}->{ContentSearchSuffix} ) {
                $Value .= $Param{Data}->{ContentSearchSuffix};
            }

            # replace %% by % for SQL
            $Param{Data}->{$Field} =~ s/%%/%/gi;

            # replace * with % (for SQL)
            $Value =~ s/\*/%/g;

            $Value = lc $DBObject->Quote( $Value, 'Like' );

            if ( IsStringWithData($SQLFieldCondition) ) {
                $SQLQuery .= "($SQLFieldCondition AND art.article_value LIKE '$Value')";
                next FIELD;
            }

            $SQLQuery .= " art.article_value LIKE '$Value'";
        }
    }

    if ($SQLQuery) {
        $SQLExt = ' AND (' . $SQLQuery . ')';
    }

    return $SQLExt;
}

sub _ArticleIndexString {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need String!",
        );
        return;
    }

    my $SearchIndexAttributes = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::Attribute');

    my $WordCountMax = $SearchIndexAttributes->{WordCountMax} || 1000;

    # get words (use eval to prevend exits on damaged utf8 signs)
    my $ListOfWords = eval {
        $Self->_ArticleIndexStringToWord(
            String        => \$Param{String},
            WordLengthMin => $Param{WordLengthMin} || $SearchIndexAttributes->{WordLengthMin} || 3,
            WordLengthMax => $Param{WordLengthMax} || $SearchIndexAttributes->{WordLengthMax} || 30,
        );
    };

    return if !$ListOfWords;

    # find ranking of words
    my %List;
    my $IndexString = '';
    my $Count       = 0;
    WORD:
    for my $Word ( @{$ListOfWords} ) {

        $Count++;

        # only index the first 1000 words
        last WORD if $Count > $WordCountMax;

        if ( $List{$Word} ) {

            $List{$Word}++;

            next WORD;
        }
        else {

            $List{$Word} = 1;

            if ($IndexString) {
                $IndexString .= ' ';
            }

            $IndexString .= $Word
        }
    }

    return $IndexString;
}

sub _ArticleIndexStringToWord {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need String!",
        );
        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SearchIndexAttributes = $ConfigObject->Get('Ticket::SearchIndex::Attribute');
    my @Filters               = @{ $ConfigObject->Get('Ticket::SearchIndex::Filters') || [] };
    my $StopWordRaw           = $ConfigObject->Get('Ticket::SearchIndex::StopWords') || {};

    # error handling
    if ( !$StopWordRaw || ref $StopWordRaw ne 'HASH' ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid config option Ticket::SearchIndex::StopWords! "
                . "Please reset the search index options to reactivate the factory defaults.",
        );

        return;
    }

    my %StopWord;
    LANGUAGE:
    for my $Language ( sort keys %{$StopWordRaw} ) {

        if ( !$Language || !$StopWordRaw->{$Language} || ref $StopWordRaw->{$Language} ne 'ARRAY' ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid config option Ticket::SearchIndex::StopWords###$Language! "
                    . "Please reset this option to reactivate the factory defaults.",
            );

            next LANGUAGE;
        }

        WORD:
        for my $Word ( @{ $StopWordRaw->{$Language} } ) {

            next WORD if !defined $Word || !length $Word;

            $Word = lc $Word;

            $StopWord{$Word} = 1;
        }
    }

    # get words
    my $LengthMin = $Param{WordLengthMin} || $SearchIndexAttributes->{WordLengthMin} || 3;
    my $LengthMax = $Param{WordLengthMax} || $SearchIndexAttributes->{WordLengthMax} || 30;
    my @ListOfWords;

    WORD:
    for my $Word ( split /\s+/, ${ $Param{String} } ) {

        # apply filters
        FILTER:
        for my $Filter (@Filters) {
            next FILTER if !defined $Word || !length $Word;
            $Word =~ s/$Filter//g;
        }

        next WORD if !defined $Word || !length $Word;

        # convert to lowercase to avoid LOWER()/LCASE() in the DB query
        $Word = lc $Word;

        next WORD if $StopWord{$Word};

        # only index words/strings within length boundaries
        my $Length = length $Word;

        next WORD if $Length < $LengthMin;
        next WORD if $Length > $LengthMax;

        push @ListOfWords, $Word;
    }

    return \@ListOfWords;
}

1;
