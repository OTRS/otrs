# --
# Kernel/Modules/AgentHistory.pm - to add notes to a ticket 
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentHistory.pm,v 1.16 2004-04-15 08:35:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentHistory;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
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
    foreach (qw(DBObject TicketObject LayoutObject LogObject UserObject ConfigObject)) {
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
      # error page
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
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # -- 
    # build header
    # --
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'History');
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    # build NavigationBar 
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    my @Lines = $Self->{TicketObject}->HistoryGet(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    # get shown user info
    my @NewLines = ();
    my $Table = '';
    foreach my $DataTmp (@Lines) {
        my %Data = %{$DataTmp};
        # replace text 
        if ($Data{Name} && $Data{Name} =~ /^%%/) {
#print STDERR "lll $Data{Name} - $Data{HistoryType}\n";
            my %Info = ();
            $Data{Name} =~ s/^%%//g;
            my @Values = split(/%%/, $Data{Name});
            $Data{Name} = '';
            foreach (@Values) {
                if ($Data{Name}) {
                    $Data{Name} .= "\", ";
                }
                $Data{Name} .= "\"$_";
            }
            if (!$Data{Name}) {
                $Data{Name} = '" ';
            }
#print STDERR "asdasd $Data{Name} asd \n";
            $Data{Name} = $Self->{LayoutObject}->{LanguageObject}->Get('History::'.$Data{HistoryType}.'", '.$Data{Name});
        }
        $Table .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentHistoryRow', 
            Data => {%Data},
        );
    }
    # get output
    $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentHistoryForm', 
            Data => {
                TicketNumber => $Tn, 
                TicketID => $Self->{TicketID},
                History => $Table,
            },
        );
    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}
# --

1;
