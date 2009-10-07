# --
# Kernel/System/Ticket/ArticleSearchIndex/RuntimeDB.pm - article search index backend runtime
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: RuntimeDB.pm,v 1.9 2009-10-07 13:19:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub ArticleIndexBuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

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
    my $SQL    = '';
    my $SQLExt = '';
    for (
        qw(
        From To Cc Subject Body
        ArticleCreateTimeOlderMinutes ArticleCreateTimeNewerMinutes
        ArticleCreateTimeOlderDate ArticleCreateTimeNewerDate
        )
        )
    {

        if ( $Param{Data}->{$_} ) {
            $SQL    = ', article art ';
            $SQLExt = ' AND st.id = art.ticket_id';
            last;
        }
    }

    return $SQL, $SQLExt;
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
    for my $Key ( keys %FieldSQLMapFullText ) {
        next if !$Param{Data}->{$Key};

        # replace * by % for SQL like
        $Param{Data}->{$Key} =~ s/\*/%/gi;

        # check search attribute, we do not need to search for *
        next if $Param{Data}->{$Key} =~ /^\%{1,3}$/;

        if ($FullTextSQL) {
            $FullTextSQL .= ' ' . $Param{Data}->{ContentSearch} . ' ';
        }

        # check if search condition extention is used
        if (
            $Param{Data}->{ConditionInline}
            && $Param{Data}->{$Key} =~ /(&&|\|\||\!|\+|AND|OR)/
            )
        {
            $FullTextSQL .= $Self->{DBObject}->QueryCondition(
                Key          => $FieldSQLMapFullText{$Key},
                Value        => $Param{Data}->{$Key},
                SearchPrefix => $Param{Data}->{ContentSearchPrefix},
                SearchSuffix => $Param{Data}->{ContentSearchSuffix},
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

            # db quote
            $Value = $Self->{DBObject}->Quote( $Value, 'Like' );

            # check if database supports LIKE in large text types (in this case for body)
            if ( $Self->{DBObject}->GetDatabaseFunction('NoLowerInLargeText') ) {
                $FullTextSQL .= " $Field LIKE '$Value'";
            }
            elsif ( $Self->{DBObject}->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                $FullTextSQL .= " LCASE($Field) LIKE LCASE('$Value')";
            }
            elsif ( $Self->{DBObject}->GetDatabaseFunction('Type') eq 'ingres' ) {
                $FullTextSQL .= " LOWER(VARCHAR($Field)) LIKE LOWER('$Value')";
            }
            else {
                $FullTextSQL .= " LOWER($Field) LIKE LOWER('$Value')";
            }
        }
    }
    if ($FullTextSQL) {
        $SQLExt = ' AND (' . $FullTextSQL . ')';
    }

    return $SQLExt;
}

1;
