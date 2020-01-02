# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

=head1 NAME

Kernel::System::Ticket::ArticleSearchIndex::DB - DB based ticket article search index module

=head1 DESCRIPTION

This class provides functions to index articles for searching in the database.
The methods are currently documented in L<Kernel::System::Ticket::Article>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub ArticleSearchIndexBuild {
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

    return 1 if !%ArticleSearchableContent;

    # clear old data from search index table
    my $Success = $Self->ArticleSearchIndexDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not delete ArticleID '$Param{ArticleID}' from article search index!"
        );
        return;
    }

    my $ForceUnfilteredStorage = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::ForceUnfilteredStorage')
        // 0;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Use regular multi-inserts for MySQL and PostgreSQL:
    # INSERT INTO table (field1, field2) VALUES (?, ?), (?, ?);
    my $SQLStart  = 'INSERT INTO article_search_index (ticket_id, article_id, article_key, article_value) VALUES ';
    my $SQLInsert = '(?, ?, ?, ?) ';
    my $SQLInsertConnector = ', ';
    my $SQLEnd             = '';

    # Oracle has a special syntax:
    # INSERT ALL
    #   INTO suppliers (supplier_id, supplier_name) VALUES (1000, 'IBM')
    #   INTO suppliers (supplier_id, supplier_name) VALUES (2000, 'Microsoft')
    #   INTO suppliers (supplier_id, supplier_name) VALUES (3000, 'Google')
    # SELECT * FROM dual;
    if ( lc $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
        $SQLStart  = 'INSERT ALL ';
        $SQLInsert = '
            INTO article_search_index (
                ticket_id, article_id, article_key, article_value
            )
            VALUES (?, ?, ?, ?) ';
        $SQLInsertConnector = ' ';
        $SQLEnd             = 'SELECT * FROM DUAL';
    }

    my $SQL = $SQLStart;
    my $Counter;
    my @Bind;

    for my $FieldKey ( sort keys %ArticleSearchableContent ) {

        if (
            !$ForceUnfilteredStorage
            && $ArticleSearchableContent{$FieldKey}->{Filterable}
            )
        {
            $ArticleSearchableContent{$FieldKey}->{String} = $Self->_ArticleSearchIndexString(
                %{ $ArticleSearchableContent{$FieldKey} }
            );
        }

        # Indexed content will be saved lowercase, even if it is not filterable to avoid
        # LOWER() statements on search time, which increases the search performance.
        # (this will be done automatically on filterable fields)
        else {
            $ArticleSearchableContent{$FieldKey}->{String} = lc $ArticleSearchableContent{$FieldKey}->{String};
        }

        my @CurrentBind = (
            \$Param{TicketID},
            \$Param{ArticleID},
            \$ArticleSearchableContent{$FieldKey}->{Key},
            \$ArticleSearchableContent{$FieldKey}->{String},
        );

        $SQL .= $SQLInsertConnector if $Counter++;
        $SQL .= $SQLInsert;
        push @Bind, @CurrentBind;
    }

    $SQL .= $SQLEnd;

    return if !$DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

sub ArticleSearchIndexDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    if ( !$Param{ArticleID} && !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either ArticleID or TicketID!',
        );
        return;
    }

    # Delete articles.
    if ( $Param{ArticleID} ) {
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => 'DELETE FROM article_search_index WHERE article_id = ?',
            Bind => [ \$Param{ArticleID} ],
        );
    }
    elsif ( $Param{TicketID} ) {
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => 'DELETE FROM article_search_index WHERE ticket_id = ?',
            Bind => [ \$Param{TicketID} ],
        );
    }

    return 1;
}

sub ArticleSearchIndexSQLJoinNeeded {
    my ( $Self, %Param ) = @_;

    if ( !$Param{SearchParams} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SearchParams!',
        );
        return;
    }

    my %SearchableFields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchableFieldsList();

    for my $Field (
        sort keys %SearchableFields,
        qw(
        ArticleCreateTimeOlderMinutes ArticleCreateTimeNewerMinutes
        ArticleCreateTimeOlderDate ArticleCreateTimeNewerDate Fulltext
        )
        )
    {
        if ( IsStringWithData( $Param{SearchParams}->{$Field} ) ) {
            return 1;
        }
    }

    return;
}

sub ArticleSearchIndexSQLJoin {
    my ( $Self, %Param ) = @_;

    if ( !$Param{SearchParams} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SearchParams!',
        );
        return;
    }

    my $ArticleSearchIndexSQLJoin = ' ';

    # join article search table for fulltext searches
    if ( IsStringWithData( $Param{SearchParams}->{Fulltext} ) ) {
        $ArticleSearchIndexSQLJoin
            .= 'LEFT JOIN article_search_index ArticleFulltext ON art.id = ArticleFulltext.article_id ';
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Run through all article fields, that have assigned values and add additional LEFT JOINS
    # to the string, to access them later for the conditions.
    my %SearchableFields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchableFieldsList();

    ARTICLEFIELD:
    for my $ArticleField ( sort keys %SearchableFields ) {

        next ARTICLEFIELD if !IsStringWithData( $Param{SearchParams}->{$ArticleField} );

        my $Label = $ArticleField;
        $ArticleField = $DBObject->Quote($ArticleField);

        $ArticleSearchIndexSQLJoin
            .= "LEFT JOIN article_search_index $Label ON art.id = $Label.article_id AND $Label.article_key = '$ArticleField' ";
    }

    return $ArticleSearchIndexSQLJoin;
}

sub ArticleSearchIndexWhereCondition {
    my ( $Self, %Param ) = @_;

    if ( !$Param{SearchParams} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SearchParams!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQLCondition = '';
    my $SQLQuery     = '';

    my %SearchableFields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchableFieldsList();
    my @Fields           = keys %SearchableFields;

    push @Fields, 'Fulltext' if IsStringWithData( $Param{SearchParams}->{Fulltext} );

    FIELD:
    for my $Field (@Fields) {

        next FIELD if !IsStringWithData( $Param{SearchParams}->{$Field} );

        # replace * by % for SQL like
        $Param{SearchParams}->{$Field} =~ s/\*/%/gi;

        # check search attribute, we do not need to search for *
        next FIELD if $Param{SearchParams}->{$Field} =~ /^\%{1,3}$/;

        if ($SQLQuery) {
            $SQLQuery .= ' ' . $Param{SearchParams}->{ContentSearch} . ' ';
        }

        # check if search condition extension is used
        if ( $Param{SearchParams}->{ConditionInline} ) {

            $SQLQuery .= $DBObject->QueryCondition(
                Key => $Field eq 'Fulltext' ? [ 'ArticleFulltext.article_value', 'st.title' ] : "$Field.article_value",
                Value         => lc $Param{SearchParams}->{$Field},
                SearchPrefix  => $Param{SearchParams}->{ContentSearchPrefix},
                SearchSuffix  => $Param{SearchParams}->{ContentSearchSuffix},
                Extended      => 1,
                CaseSensitive => 1,
            );
        }
        else {

            my $Label = $Field eq 'Fulltext' ? 'ArticleFulltext' : $Field;
            my $Value = $Param{SearchParams}->{$Field};

            if ( $Param{SearchParams}->{ContentSearchPrefix} ) {
                $Value = $Param{SearchParams}->{ContentSearchPrefix} . $Value;
            }
            if ( $Param{SearchParams}->{ContentSearchSuffix} ) {
                $Value .= $Param{SearchParams}->{ContentSearchSuffix};
            }

            # replace * with % (for SQL)
            $Value =~ s/\*/%/g;

            # replace %% by % for SQL
            $Value =~ s/%%/%/gi;

            $Value = lc $DBObject->Quote( $Value, 'Like' );

            $SQLQuery .= " $Label.article_value LIKE '$Value'";

            if ( $Field eq 'Fulltext' ) {
                $SQLQuery .= " OR st.title LIKE '$Value'";
            }
        }
    }

    if ($SQLQuery) {
        $SQLCondition = ' AND (' . $SQLQuery . ') ';
    }

    return $SQLCondition;
}

sub SearchStringStopWordsFind {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(SearchStrings)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $StopWordRaw = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::StopWords') || {};
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

    my $SearchIndexAttributes = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::Attribute');
    my $WordLengthMin         = $SearchIndexAttributes->{WordLengthMin} || 3;
    my $WordLengthMax         = $SearchIndexAttributes->{WordLengthMax} || 30;

    my %StopWordsFound;
    SEARCHSTRING:
    for my $Key ( sort keys %{ $Param{SearchStrings} } ) {
        my $SearchString = $Param{SearchStrings}->{$Key};
        my %Result       = $Kernel::OM->Get('Kernel::System::DB')->QueryCondition(
            'Key'      => '.',             # resulting SQL is irrelevant
            'Value'    => $SearchString,
            'BindMode' => 1,
        );

        next SEARCHSTRING if !%Result || ref $Result{Values} ne 'ARRAY' || !@{ $Result{Values} };

        my %Words;
        for my $Value ( @{ $Result{Values} } ) {
            my @Words = split '\s+', $$Value;
            for my $Word (@Words) {
                $Words{ lc $Word } = 1;
            }
        }

        @{ $StopWordsFound{$Key} }
            = grep { $StopWord{$_} || length $_ < $WordLengthMin || length $_ > $WordLengthMax } sort keys %Words;
    }

    return \%StopWordsFound;
}

sub SearchStringStopWordsUsageWarningActive {
    my ( $Self, %Param ) = @_;

    my $WarnOnStopWordUsage = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::WarnOnStopWordUsage') || 0;

    return 1 if $WarnOnStopWordUsage;

    return 0;
}

sub _ArticleSearchIndexString {
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
        $Self->_ArticleSearchIndexStringToWord(
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

            $IndexString .= $Word;
        }
    }

    return $IndexString;
}

sub _ArticleSearchIndexStringToWord {
    my ( $Self, %Param ) = @_;

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
