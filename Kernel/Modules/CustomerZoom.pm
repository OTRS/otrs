# --
# Kernel/Modules/CustomerZoom.pm - to get a closer view
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerZoom.pm,v 1.12 2003-11-26 00:52:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerZoom;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    # get common objects 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject 
        ConfigObject UserObject SessionObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $Self->{TicketID});
    # check needed stuff
    if (!$Self->{TicketID} || !$QueueID) {
      $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
      $Output .= $Self->{LayoutObject}->CustomerError();
      $Output .= $Self->{LayoutObject}->CustomerFooter();
      return $Output;
    }
    # check permissions
    if (!$Self->{TicketObject}->CustomerPermission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
    }  
    # store last screen
    if ($Self->{Subaction} ne 'ShowHTMLeMail') {
      if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreen',
        Value => $Self->{RequestedURL},
      )) {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
      }  
    }
    # --
    # fetch all std. responses
    # --
    my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
    $Ticket{TmpCounter} = 0;
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->GetAccountedTime(
        TicketID => $Ticket{TicketID},
    );
    # get all atricle of this ticket
    my @ArticleBox = $Self->{TicketObject}->GetArticleContentIndex(TicketID => $Self->{TicketID});
    # get article attachments
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->{TicketObject}->GetArticleAtmIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    # --
    # genterate output
    # --
    $Output .= $Self->{LayoutObject}->CustomerHeader(Title => "Zoom Ticket $Ticket{TicketNumber}");
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # --
    # show ticket
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, drop normal header
        $Ticket{ShowHTMLeMail} = 1;
        $Output = '';
    }
    $Output .= $Self->{LayoutObject}->CustomerTicketZoom(
        NextStates => $Self->_GetNextStates(),
        TicketID => $Self->{TicketID},
        QueueID => $QueueID,
        ArticleBox => \@ArticleBox,
        ArticleID => $Self->{ArticleID},
        %Ticket
    );
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, return here
        $Ticket{ShowHTMLeMail} = 1;
        return $Output;
    }
    # add footer 
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return output
    return $Output;
}
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    # --
    # get next states
    # --
    my %NextStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'CustomerPanelDefaultNextCompose',
        Result => 'HASH',
    );
    return \%NextStates;
}
# --

1;
