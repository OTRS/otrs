# --
# AgentQueueView.pm - the queue view of all tickets
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentQueueView.pm,v 1.1 2001-12-16 01:45:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentQueueView;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    if (!$Self->{ConfigObject}) {
        die "Got no ConfigObject!";
    }
    if (!$Self->{LogObject}) {
        die "Got no LogObject!";
    }

    # --
    # get config data
    # --

    # default viewable tickets a page
    $Self->{ViewableTickets} = $Self->{ConfigObject}->Get('ViewableTickets');

    # default reload time
    $Self->{Refresh} = $Self->{ConfigObject}->Get('Refresh');
 
    # viewable tickets a page
    $Self->{Limit} = $Self->{ParamObject}->GetParam(Param => 'Limit')
        || $Self->{ViewableTickets};

    # sure is sure!
    $Self->{MaxLimit} = $Self->{ConfigObject}->Get('MaxLimit') || 300;
    if ($Self->{Limit} > $Self->{MaxLimit}) {
        $Self->{Limit} = $Self->{MaxLimit};
    }

    # --
    # all static variables
    # --

    # - all shown and counted values-
    my @ViewableLocks = ("'unlock'", "'tmp_lock'");
    $Self->{ViewableLocks} = \@ViewableLocks;

    my @ViewableStats = ("'open'", "'new'");
    $Self->{ViewableStats} = \@ViewableStats;

    my @ViewableSenderTypes = ("'customer'");
    $Self->{ViewableSenderTypes} = \@ViewableSenderTypes;

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # get test page header
    my $Output = $Self->{LayoutObject}->Header( 
        Title => "OpenTRS Queue View ()",
        Refresh => $Self->{Refresh},
    );

    # get page 
    $Output .= $Self->{LayoutObject}->NavigationBar();
    # get test page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return test page
    return $Output;
}
# --
 
