# --
# Kernel/System/PostMaster/Filter/Match.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Match.pm,v 1.11 2008-10-10 15:36:27 ho Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::Filter::Match;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config options
    my %Config = ();
    my %Match  = ();
    my %Set    = ();
    if ( $Param{JobConfig} && ref( $Param{JobConfig} ) eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
        }
    }

    # match 'Match => ???' stuff
    my $Matched    = '';
    my $MatchedNot = 0;
    for ( sort keys %Match ) {
        if ( $Param{GetParam}->{$_} && $Param{GetParam}->{$_} =~ /$Match{$_}/i ) {
	    # don't lose older match values if more than one header is
	    # used for matching.
	    if ($1) {
		$Matched = $1;
	    }
	    else {
		$Matched = '1';
	    }
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                );
            }
        }
        else {
            $MatchedNot = 1;
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched NOT!",
                );
            }
        }
    }

    # should I ignore the incoming mail?
    if ( $Matched && !$MatchedNot ) {
        for ( keys %Set ) {
            $Set{$_} =~ s/\[\*\*\*\]/$Matched/;
            $Param{GetParam}->{$_} = $Set{$_};
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
            );
        }
    }
    return 1;
}

1;
