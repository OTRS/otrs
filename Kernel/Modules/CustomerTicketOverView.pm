# --   
# Kernel/Modules/CustomerTicketOverView.pm - status for all open tickets
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code at otrs.org>
# --   
# $Id: CustomerTicketOverView.pm,v 1.21 2004-03-12 18:42:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketOverView;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};   
    }
    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # state object
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    # all static variables
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes')
          || die 'No Config entry "ViewableSenderTypes"!';
    # get params 
    $Self->{ShowClosedTickets} = $Self->{ParamObject}->GetParam(Param => 'ShowClosedTickets') || 0;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Up';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 0; 
    $Self->{Type} = $Self->{ParamObject}->GetParam(Param => 'Type') || 'MyTickets'; 
    if ($Self->{StartHit} >= 1000) {
        $Self->{StartHit} = 1000;
    }
    $Self->{PageShown} = $Self->{UserShowTickets} || $Self->{ConfigObject}->Get('CustomerPreferencesGroups')->{ShownTickets}->{DataSelected} || 1;  
 
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # store last screen
    if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreen',
        Value => $Self->{RequestedURL},
    )) {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # check needed CustomerID
    if (!$Self->{UserCustomerID}) {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(Message => 'Need CustomerID!!!');
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # starting with page ...
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Title => $Self->{Type},
        Refresh => $Refresh,
    );
    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # to get the output faster!
    print $Output; $Output = '';
    # check if just open tickets should be shown
    my $SQLExt = '';
    my $ShowClosed = 0;
    if ((defined($Self->{UserShowClosedTickets}) && !$Self->{UserShowClosedTickets}) 
      || (!defined $Self->{UserShowClosedTickets} && !$Self->{ConfigObject}->Get('CustomerPreferencesGroups')->{ClosedTickets}->{DataSelected})) {
        $ShowClosed = 0;
    }
    if ($Self->{ShowClosedTickets}) {
        $ShowClosed = 1;
    }
    # get data (viewable tickets...)
    my $Open = 0;
    if (!$ShowClosed) {
       $Open = 1;
    }

    my @ViewableTickets = $Self->{TicketObject}->GetCustomerTickets(
        CustomerID => $Self->{UserCustomerID},
        CustomerUserID => $Self->{UserID},
        ShowJustOpenTickets => $Open,
        SortBy => $Self->{SortBy},
        Order => $Self->{Order},
        Type => $Self->{Type},
    );
    my $AllTickets = @ViewableTickets;
    # show ticket's
    my $OutputTable = "";
    my $Counter = 0;
    foreach my $TicketID (@ViewableTickets) {
      $Counter++;
      if ($Counter > $Self->{StartHit} && $Counter <= ($Self->{PageShown}+$Self->{StartHit})) {
        $OutputTable .= $Self->ShowTicketStatus(TicketID => $TicketID);
      }
    }
    $Output .= $Self->{LayoutObject}->CustomerStatusView(
        StatusTable => $OutputTable, 
        SortBy => $Self->{SortBy},
        Order => $Self->{Order},
        PageShown => $Self->{PageShown},
        AllHits => $AllTickets,
        StartHit => $Self->{StartHit},
        ShowClosed => $ShowClosed,
        Type => $Self->{Type},
    );
    # get page footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    
    # return page
    return $Output;
}
# --
# ShowTicket
# --
sub ShowTicketStatus {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID} || return;
    # get last article
    my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $TicketID);
    # condense down the subject
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $Subject = $Article{Subject};
    $Subject =~ s/^RE://i;
    $Subject =~ s/\[${TicketHook}:.*\]//;
    # return ticket
    return $Self->{LayoutObject}->CustomerStatusViewTable(
        %Article,
        Subject => $Subject,
    );
}
# --

1;
