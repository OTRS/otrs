# --
# Kernel/Modules/AgentTicketMailbox.pm - to view all locked tickets
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketMailbox.pm,v 1.2 2005-03-03 15:56:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketMailbox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject
      UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{QueueID};

    my $SortBy = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'CreateTime';
    my $OrderBy = $Self->{ParamObject}->GetParam(Param => 'OrderBy') || 'Up';

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenView',
        Value => $Self->{RequestedURL},
    );
    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenOverview',
        Value => $Self->{RequestedURL},
    );

    # --
    # check view type
    # --
    if (!$Self->{Subaction}) {
        $Self->{Subaction} = 'All';
    }
    # --
    # starting with page ...
    # --
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    $Output .= $Self->{LayoutObject}->Header(
        Area => 'Ticket',
        Title => 'Locked Tickets',
        Refresh => $Refresh,
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    $Self->{LayoutObject}->Block(
        Name => 'NavBar',
        Data => {
            %LockedData,
            SortBy => $SortBy,
            OrderBy => $OrderBy,
            ViewType => $Self->{Subaction},
        }
    );
    # --
    # get locked  viewable tickets...
    # --
    my @ViewableTickets = $Self->{TicketObject}->GetLockedTicketIDs(
        UserID => $Self->{UserID},
        SortBy => $SortBy,
        OrderBy => $OrderBy,
    );
    # --
    # get last sender type of article "LastSenderType"
    # --
    my %LastSenderType;
    my %LastSenderID;
    foreach  (@ViewableTickets) {
        my $SQL = "SELECT sdt.name, sa.create_by, st.until_time " .
          " FROM " .
          " article_sender_type sdt, article sa, ticket st " .
          " WHERE " .
          " st.id = $_ " .
          " AND " .
          " sa.ticket_id = st.id " .
          " AND " .
          " sdt.id = sa.article_sender_type_id" .
          " ORDER BY " .
          " sa.create_time";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
             $LastSenderType{$_} = $RowTmp[0];
             $LastSenderID{$_} = $RowTmp[1];
        }
    }
    # --
    # get article data
    # --
    my $Counter = 0;
    foreach my $TicketID (@ViewableTickets) {
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(TicketID => $TicketID);
        my $Shown = 0;
        my $Message = '';
        my $NewMessage = 0;
        # --
        # put all tickets to ToDo where last sender type is customer or ! UserID
        # --
        # show just unseen tickets as new
        if ($Self->{ConfigObject}->Get('Ticket::NewMessageMode') eq 'ArticleSeen') {
            my @Index = $Self->{TicketObject}->ArticleIndex(TicketID => $TicketID);
            my %Article = $Self->{TicketObject}->ArticleGet(ArticleID => $Index[$#Index]);
            my %Flag = $Self->{TicketObject}->ArticleFlagGet(
                ArticleID => $Article{ArticleID},
                UserID => $Self->{UserID},
            );
            if (!$Flag{seen}) {
                $NewMessage = 1;
                $Message = 'New message!';
            }
        }
        else {
            if ($LastSenderID{$Article{TicketID}} ne $Self->{UserID} ||
               $LastSenderType{$Article{TicketID}} eq 'customer') {
                $NewMessage = 1;
                $Message = 'New message!';
            }
        }
        if ($Self->{Subaction} eq 'New') {
            if ($NewMessage) {
                $Shown = 1;
            }
        }
        elsif ($Self->{Subaction} eq 'Pending') {
            if ($Article{StateType} =~ /^pending/i) {
                $Shown = 1;
            }
        }
        elsif ($Self->{Subaction} eq 'Reminder') {
            if ($Article{UntilTime} < 1 && $Article{StateType} =~ /^pending/i &&
                 $Article{State} !~ /^pending auto/i) {
                $Shown = 1;
            }
        }
        elsif ($Self->{Subaction} eq 'All') {
            $Shown = 1;
        }
        else {
            $Shown = 1;
            if ($Article{StateType} =~ /^pending/i) {
                $Shown = 0;
            }
        }
        if ($Shown) {
            $Counter++;
            $Self->MaskMailboxTicket(
              %Article,
              LastSenderType => $LastSenderType{$Article{TicketID}},
              LastSenderID => $LastSenderID{$Article{TicketID}},
              Message => $Message,
              Counter => $Counter,
            );
        }
    }
    # create & return output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketMailbox',
        Data => {%Param},
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
sub MaskMailboxTicket {
    my $Self = shift;
    my %Param = @_;
    $Param{Message} = $Self->{LayoutObject}->{LanguageObject}->Get($Param{Message}).' ';
    # get ack actions
    $Self->{TicketObject}->TicketAcl(
        Data => '-',
        Action => $Self->{Action},
        TicketID => $Param{TicketID},
        ReturnType => 'Action',
        ReturnSubType => '-',
        UserID => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();
    # check if the pending ticket is Over Time
    if ($Param{UntilTime} < 0 && $Param{State} !~ /^pending auto/i) {
        $Param{Message} .= $Self->{LayoutObject}->{LanguageObject}->Get('Timeover').' '.
          $Self->{LayoutObject}->CustomerAge(Age => $Param{UntilTime}, Space => ' ').'!';
    }
    # create PendingUntil string if UntilTime is < -1
    if ($Param{UntilTime}) {
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(
            Age => $Param{UntilTime},
            Space => '<br>',
        );
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    # do some strips && quoting
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    $Self->{LayoutObject}->Block(
        Name => 'Ticket',
        Data => {
            %Param,
            %AclAction,
        },
    );
    # ticket bulk block
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature')) {
        $Self->{LayoutObject}->Block(
            Name => "Bulk",
            Data => { %Param },
        );
    }
    # run ticket pre menu modules
    if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')) eq 'HASH') {
        my %Menus = %{$Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')};
        my $Counter = 0;
        foreach my $Menu (sort keys %Menus) {
            # load module
            if ($Self->{MainObject}->Require($Menus{$Menu}->{Module})) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    TicketID => $Self->{TicketID},
                );
                # run module
                $Counter = $Object->Run(
                    %Param,
                    Ticket => \%Param,
                    Counter => $Counter,
                    ACL => \%AclAction,
                    Config => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
}
# --
1;
