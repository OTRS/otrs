# --
# Kernel/System/PostMaster/Filter/MatchDBSource.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: MatchDBSource.pm,v 1.15 2008-10-24 11:23:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PostMaster::Filter::MatchDBSource;

use strict;
use warnings;

use Kernel::System::PostMaster::Filter;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    for (qw(ConfigObject LogObject DBObject ParserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{PostMasterFilter} = Kernel::System::PostMaster::Filter->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %JobList = $Self->{PostMasterFilter}->FilterList();
    for ( sort keys %JobList ) {

        # get config options
        my %Config = $Self->{PostMasterFilter}->FilterGet( Name => $_ );
        my %Match  = ();
        my %Set    = ();
        if ( $Config{Match} ) {
            %Match = %{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            %Set = %{ $Config{Set} };
        }
        my $StopAfterMatch = $Config{StopAfterMatch} || 0;
        my $Prefix = '';
        if ( $Config{Name} ) {
            $Prefix = "Filter: '$Config{Name}' ";
        }

        # match 'Match => ???' stuff
        my $Matched    = '';
        my $MatchedNot = 0;
        for ( keys %Match ) {
            if ( $Param{GetParam}->{$_} && $Match{$_} =~ /^EMAILADDRESS:(.*)$/ ) {
                my $SearchEmail    = $1;
                my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                    Line => $Param{GetParam}->{$_},
                );
                my $LocalMatched;
                for my $RawEmail (@EmailAddresses) {
                    my $Email = $Self->{ParserObject}->GetEmailAddress( Email => $RawEmail );
                    if ( $Email =~ /^$SearchEmail$/i ) {
                        $LocalMatched = $SearchEmail || 1;
                        if ( $Self->{Debug} > 1 ) {
                            $Self->{LogObject}->Log(
                                Priority => 'debug',
                                Message =>
                                    "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                            );
                        }
                        last;
                    }
                }
                if ( !$LocalMatched ) {
                    $MatchedNot = 1;
                }
                else {
                    $Matched = $LocalMatched;
                }
            }
            elsif ( $Param{GetParam}->{$_} && $Param{GetParam}->{$_} =~ /$Match{$_}/i ) {

                # don't lose older match values if more than one header is
                # used for matching.
                if ($1) {
                    $Matched = $1;
                }
                else {
                    $Matched = $Matched || '1';
                }
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                    );
                }
            }
            else {
                $MatchedNot = 1;
                if ( $Self->{Debug} > 1 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched NOT!",
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
                    Message  => $Prefix
                        . "Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
            }

            # stop after match
            if ($StopAfterMatch) {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => $Prefix
                        . "Stopped filter procesing because of used 'StopAfterMatch' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
                return 1;
            }
        }
    }
    return 1;
}

1;
