# --
# Kernel/Modules/AgentHistory.pm - to add notes to a ticket 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentHistory.pm,v 1.10 2003-04-12 17:24:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentHistory;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object    
    my $Self = {}; 
    bless ($Self, $Type);
    
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
      # --
      # error page
      # --
      $Output = $Self->{LayoutObject}->Header(Title => 'Error');
      $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't show history, no TicketID is given!",
          Comment => 'Please contact the admin.',
      );
      $Output .= $Self->{LayoutObject}->Footer();
      return $Output;
    } 
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # -- 
    # build header
    # --
    $Output .= $Self->{LayoutObject}->Header(Title => 'History');
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    # build NavigationBar 
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    my @Lines;
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
    my $SQL = "SELECT sh.name, sh.article_id, sh.create_time, sh.create_by, ".
        " ht.name, su.$Self->{ConfigObject}->{DatabaseUserTableUser} ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht, ".
        " $Self->{ConfigObject}->{DatabaseUserTable} su ".
        " WHERE ".
        " sh.ticket_id = $Self->{TicketID} ".
        " AND ".
        " ht.id = sh.history_type_id".
        " AND ".
        " sh.create_by = su.$Self->{ConfigObject}->{DatabaseUserTableUserID}".
        " ORDER BY sh.id";
#        " ORDER BY create_time";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray() ) {
          my %Data;
          $Data{TicketID} = $Self->{TicketID};
          $Data{ArticleID} = $Row[1]; 
          $Data{Name} = $Row[0];
          $Data{CreateBy} = $Row[5];
          $Data{CreateTime} = $Row[2]; 
          $Data{HistoryType} = $Row[4];
          push (@Lines, \%Data);
    }
    # get output
    $Output .= $Self->{LayoutObject}->AgentHistory(
        TicketNumber => $Tn, 
        TicketID => $Self->{TicketID},
        Data => \@Lines,
    );
    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}
# --

1;
