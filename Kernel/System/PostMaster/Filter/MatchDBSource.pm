# --
# Kernel/System/PostMaster/Filter/MatchDBSource.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: MatchDBSource.pm,v 1.4 2006-11-02 12:20:57 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::Filter::MatchDBSource;

use strict;
use Kernel::System::PostMaster::Filter;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{PostMasterFilter} = Kernel::System::PostMaster::Filter->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # get config options
    my %Config = ();
    my %Match = ();
    my %Set = ();

    my %JobList = $Self->{PostMasterFilter}->FilterList();
    foreach (sort keys %JobList) {
        %Config = $Self->{PostMasterFilter}->FilterGet(Name => $_);
        if ($Config{Match}) {
            %Match = %{$Config{Match}};
        }
        if ($Config{Set}) {
            %Set = %{$Config{Set}};
        }
        my $Prefix = '';
        if ($Config{Name}) {
            $Prefix = "Filter: '$Config{Name}' ";
        }
        # match 'Match => ???' stuff
        my $Matched = '';
        my $MatchedNot = 0;
        foreach (keys %Match) {
            if ($Param{GetParam}->{$_} && $Param{GetParam}->{$_} =~ /$Match{$_}/i) {
                $Matched = $1 || '1';
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched!",
                    );
                }
            }
            else {
                $MatchedNot = 1;
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "$Prefix'$Param{GetParam}->{$_}' =~ /$Match{$_}/i matched NOT!",
                    );
                }
            }
        }
        # should I ignore the incoming mail?
        if ($Matched && !$MatchedNot) {
            foreach (keys %Set) {
                if ($Set{$_} =~ /\[\*\*\*\]/i) {
                    $Set{$_} = $Matched;
                }
                $Param{GetParam}->{$_} = $Set{$_};
                    $Self->{LogObject}->Log(
                      Priority => 'notice',
                       Message => $Prefix."Set param '$_' to '$Set{$_}' (Message-ID: $Param{GetParam}->{'Message-ID'}) ",
                );
            }
        }
    }
    return 1;
}

1;
