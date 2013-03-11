# --
# Kernel/System/Ticket/ArticleSearchIndex/StaticDB.pm - article search index backend static
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ArticleSearchIndex::StaticDB;

use strict;
use warnings;

use vars qw($VERSION);

sub ArticleIndexBuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Article = $Self->ArticleGet(
        ArticleID     => $Param{ArticleID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    for my $Key (qw(From To Cc Subject)) {
        if ( $Article{$Key} ) {
            $Article{$Key} = $Self->_ArticleIndexString(
                String        => $Article{$Key},
                WordLengthMin => 3,
                WordLengthMax => 60,
            );
        }
    }
    for my $Key (qw(Body)) {
        if ( $Article{$Key} ) {
            $Article{$Key} = $Self->_ArticleIndexString(
                String => $Article{$Key},
            );
        }
    }

    # update search index table
    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_search WHERE id = ?',
        Bind => [ \$Article{ArticleID}, ],
    );

    # return if no content exists
    return 1 if !$Article{Body};

    # insert search index
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO article_search (id, ticket_id, article_type_id, '
            . 'article_sender_type_id, a_from, a_to, a_cc, a_subject, a_message_id, '
            . 'a_body, incoming_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Article{ArticleID},    \$Article{TicketID}, \$Article{ArticleTypeID},
            \$Article{SenderTypeID}, \$Article{From},     \$Article{To},
            \$Article{Cc},           \$Article{Subject},  \$Article{MessageID}, \$Article{Body},
            \$Article{IncomingTime},
        ],
    );

    return 1;
}

sub ArticleIndexDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete articles
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_search WHERE id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    return 1;
}

sub ArticleIndexDeleteTicket {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete articles
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM article_search WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ],
    );

    return 1;
}

sub _ArticleIndexQuerySQL {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # use also article table if required
    for (
        qw(
        From To Cc Subject Body
        ArticleCreateTimeOlderMinutes ArticleCreateTimeNewerMinutes
        ArticleCreateTimeOlderDate ArticleCreateTimeNewerDate
        )
        )
    {
        if ( $Param{Data}->{$_} ) {
            return ' INNER JOIN article_search art ON st.id = art.ticket_id ';
        }
    }

    return '';
}

sub _ArticleIndexQuerySQLExt {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %FieldSQLMapFullText = (
        From    => 'art.a_from',
        To      => 'art.a_to',
        Cc      => 'art.a_cc',
        Subject => 'art.a_subject',
        Body    => 'art.a_body',
    );
    my $SQLExt      = '';
    my $FullTextSQL = '';
    for my $Key ( sort keys %FieldSQLMapFullText ) {
        next if !$Param{Data}->{$Key};

        # replace * by % for SQL like
        $Param{Data}->{$Key} =~ s/\*/%/gi;

        # check search attribute, we do not need to search for *
        next if $Param{Data}->{$Key} =~ /^\%{1,3}$/;

        if ($FullTextSQL) {
            $FullTextSQL .= ' ' . $Param{Data}->{ContentSearch} . ' ';
        }

        # check if search condition extension is used
        if ( $Param{Data}->{ConditionInline} ) {
            $FullTextSQL .= $Self->{DBObject}->QueryCondition(
                Key          => $FieldSQLMapFullText{$Key},
                Value        => $Param{Data}->{$Key},
                SearchPrefix => $Param{Data}->{ContentSearchPrefix},
                SearchSuffix => $Param{Data}->{ContentSearchSuffix},
                Extended     => 1,
            );
        }
        else {

            my $Field = $FieldSQLMapFullText{$Key};
            my $Value = $Param{Data}->{$Key};

            if ( $Param{Data}->{ContentSearchPrefix} ) {
                $Value = $Param{Data}->{ContentSearchPrefix} . $Value;
            }
            if ( $Param{Data}->{ContentSearchSuffix} ) {
                $Value .= $Param{Data}->{ContentSearchSuffix};
            }

            # replace %% by % for SQL
            $Param{Data}->{$Key} =~ s/%%/%/gi;

            # replace * with % (for SQL)
            $Value =~ s/\*/%/g;

            # db quote
            $Value = lc $Self->{DBObject}->Quote( $Value, 'Like' );

            if ( $Self->{DBObject}->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                $FullTextSQL .= " LCASE($Field) LIKE LCASE('$Value')";
            }
            else {
                $FullTextSQL .= " $Field LIKE '$Value'";
            }
        }
    }
    if ($FullTextSQL) {
        $SQLExt = ' AND (' . $FullTextSQL . ')';
    }

    return $SQLExt;
}

sub _ArticleIndexString {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Config = $Self->{ConfigObject}->Get('Ticket::SearchIndex::Attribute');
    my $WordCountMax = $Config->{WordCountMax} || 1000;

    # get words (use eval to prevend exits on damaged utf8 signs)
    my $ListOfWords = eval {
        $Self->_ArticleIndexStringToWord(
            String        => \$Param{String},
            WordLengthMin => $Param{WordLengthMin},
            WordLengthMax => $Param{WordLengthMax},
        );
    };
    return if !$ListOfWords;

    # find ranking of words
    my %List;
    my $IndexString = '';
    my $Count       = 0;
    for my $Word ( @{$ListOfWords} ) {
        $Count++;

        # only index the first 1000 words
        last if $Count > $WordCountMax;
        if ( $List{$Word} ) {
            $List{$Word}++;
            next;
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
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Config = $Self->{ConfigObject}->Get('Ticket::SearchIndex::Attribute');

    my %StopWord = (
        'der' => 1,
        'die' => 1,
        'und' => 1,
        'in'  => 1,
        'vom' => 1,
        'zu'  => 1,
        'im'  => 1,
        'den' => 1,
        'auf' => 1,
        'als' => 1,

        'the' => 1,
        'of'  => 1,
        'and' => 1,
        'in'  => 1,
        'to'  => 1,
        'a'   => 1,
        'is'  => 1,
        'for' => 1,
    );

    # get words
    my $LengthMin = $Param{WordLengthMin} || $Config->{WordLengthMin} || 3;
    my $LengthMax = $Param{WordLengthMax} || $Config->{WordLengthMax} || 30;
    my @ListOfWords = split /\s+/, ${ $Param{String} };
    my @ListOfWordsNew;
    for my $Word (@ListOfWords) {

        # remove some not needed chars
        #        $Word =~ s/[\d+\.,\-\&\-\_\<\>\?":\\\*\|\/;\[\]\(\)\+\$\^=]//g;
        $Word =~ s/[,\&\<\>\?"\!\*\|;\[\]\(\)\+\$\^=]//g;
        $Word =~ s/^('|:|\.)//g;
        $Word =~ s/(:|\.|')$//g;
        $Word = lc $Word;
        my $Length = length $Word;

        # only index words/strings with x or more chars
        if ( $Length < $LengthMin ) {
            next;
        }

        # do not index words/strings longer then x chars
        if ( $Length > $LengthMax ) {
            next;
        }

        if ( $Word && !$StopWord{$Word} ) {
            push @ListOfWordsNew, $Word;
            next;
        }
    }
    return \@ListOfWordsNew;
}

1;
