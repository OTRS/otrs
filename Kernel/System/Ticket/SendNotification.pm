# --
# Kernel/System/Ticket/SendNotification.pm - send notifications to agent
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendNotification.pm,v 1.5 2003-12-15 20:23:32 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::SendNotification;
    
use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub SendNotification {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(CustomerMessageParams TicketNumber TicketID UserID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check recipients
    # --
    if (!$Param{To} && !$Self->{ConfigObject}->Get("NotificationAlwaysCc$Param{Type}")) {
        return;
    }
    else {
        $Param{To} = $Param{To}.$Self->{ConfigObject}->Get("NotificationAlwaysCc$Param{Type}");
    }
    # --
    # get ref of email params
    # --
    my %GetParam = %{$Param{CustomerMessageParams}};
    # --
    # get notify texts
    # --
    $Param{Subject} = $Self->{ConfigObject}->Get("NotificationSubject$Param{Type}") 
      || "No NotificationSubject$Param{Type} found in Config.pm!";
    $Param{Body} = $Self->{ConfigObject}->Get("NotificationBody$Param{Type}")
      || "No NotificationBody$Param{Type} found in Config.pm!";
    # --
    # get old article for quoteing
    # --
    my %Article = $Self->GetLastCustomerArticle(TicketID => $Param{TicketID});
    foreach (qw(From To Cc Subject Body)) {
        if (!$GetParam{$_}) {
            $GetParam{$_} = $Article{$_} || '';
        }
        chomp $GetParam{$_};
    }
    foreach (keys %GetParam) {
        if ($GetParam{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
        }
    }
    # --
    # get owner data
    # --
    my ($OwnerID, $Owner) = $Self->CheckOwner(TicketID => $Param{TicketID});
    my %Preferences = $Self->{UserObject}->GetUserData(UserID => $OwnerID);
    foreach (keys %Preferences) {
        if ($Preferences{$_}) {
            $Param{Body} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
            $Param{Subject} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
        }
    }
    # --
    # get current user data
    # --
    my %CurrentPreferences = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
    foreach (keys %CurrentPreferences) {
        if ($CurrentPreferences{$_}) {
            $Param{Body} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
        }
    }
    # --
    # get ticket hook
    # --  
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    # --
    # prepare subject (insert old subject)
    # --
    if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $GetParam{Subject} =~ s/\[$TicketHook: $Param{TicketNumber}\] //g;
        $GetParam{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$GetParam{Subject}/g;
    }
    $Param{Subject} = "[$TicketHook: $Param{TicketNumber}] $Param{Subject}";
    # --
    # prepare body (insert old email)
    # -- 
    $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
    $Param{Body} =~ s/<OTRS_TICKET_NUMBER>/$Param{TicketNumber}/g;
    $Param{Body} =~ s/<OTRS_QUEUE>/$Param{Queue}/g if ($Param{Queue});
    $Param{Body} =~ s/<OTRS_COMMENT>/$GetParam{Comment}/g if (defined $GetParam{Comment});
    if ($Param{Body} =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
        my $Line = $1;
        my @Body = split(/\n/, $GetParam{Body});
        my $NewOldBody = ''; 
        foreach (my $i = 0; $i < $Line; $i++) {
            # 2002-06-14 patch of Pablo Ruiz Garcia
            # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
            if($#Body >= $i) {
                $NewOldBody .= "> $Body[$i]\n";
            }
        }
        chomp $NewOldBody;
        $Param{Body} =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
    }
    # --
    # send notify 
    # --
    $Self->SendArticle(
            ArticleType => 'email-notification-int',
            SenderType => 'system',
            TicketID => $Param{TicketID},
            HistoryType => 'SendAgentNotification',
            HistoryComment => "Sent notification to '$Param{To}'.",
            From => $Self->{ConfigObject}->Get('NotificationSenderName').
              ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>',
            To => $Param{To},
            Subject => $Param{Subject},
            UserID => $Param{UserID},
            Body => $Param{Body},
            Loop => 1,
    );

    return 1;
}
# --
sub SendCustomerNotification {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(CustomerMessageParams TicketID UserID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get notify texts
    # --
    $Param{Subject} = $Self->{ConfigObject}->Get("CustomerNotificationSubject$Param{Type}") 
      || "No CustomerNotificationSubject$Param{Type} found in Config.pm!";
    $Param{Body} = $Self->{ConfigObject}->Get("CustomerNotificationBody$Param{Type}")
      || "No CustomerNotificationBody$Param{Type} found in Config.pm!";
    # --
    # get old article for quoteing
    # --
    my %Article = $Self->GetLastCustomerArticle(TicketID => $Param{TicketID});
    foreach (keys %Article) {
        if ($Article{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
        }
    }
    # --
    # check if notification should be send
    # --
    my %Queue = $Self->{QueueObject}->QueueGet(ID => $Article{QueueID});
    if ($Param{Type} =~/^StateUpdate$/ && !$Queue{StateNotify}) {
        # need not notification
        return;
    }
    elsif ($Param{Type} =~/^OwnerUpdate$/ && !$Queue{OwnerNotify}) {
        # need not notification
        return;
    }
    elsif ($Param{Type} =~/^QueueUpdate$/ && !$Queue{MoveNotify}) {
        # need not notification
        return;
    }
    elsif ($Param{Type} =~/^LockUpdate$/ && !$Queue{LockNotify}) {
        # need not notification
        return;
    }
    # --
    # get owner data
    # --
    my ($OwnerID, $Owner) = $Self->CheckOwner(TicketID => $Param{TicketID});
    my %Preferences = $Self->{UserObject}->GetUserData(UserID => $OwnerID);
    foreach (keys %Preferences) {
        if ($Preferences{$_}) {
            $Param{Body} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
            $Param{Subject} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
        }
    }
    # --
    # get current user data
    # --
    my %CurrentPreferences = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
    foreach (keys %CurrentPreferences) {
        if ($CurrentPreferences{$_}) {
            $Param{Body} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
        }
    }
    # --
    # get ticket hook
    # --  
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    # --
    # prepare subject (insert old subject)
    # --
    if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $Article{Subject} =~ s/\[$TicketHook: $Article{TicketNumber}\] //g;
        $Article{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Article{Subject}/g;
    }
    $Param{Subject} = "[$TicketHook: $Article{TicketNumber}] $Param{Subject}";
    # --
    # prepare body (insert old email)
    # -- 
    $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
    $Param{Body} =~ s/<OTRS_TICKET_NUMBER>/$Article{TicketNumber}/g;
    $Param{Body} =~ s/<OTRS_QUEUE>/$Param{Queue}/g if ($Param{Queue});
    if ($Param{Body} =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
        my $Line = $1;
        my @Body = split(/\n/, $Article{Body});
        my $NewOldBody = ''; 
        foreach (my $i = 0; $i < $Line; $i++) {
            # 2002-06-14 patch of Pablo Ruiz Garcia
            # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
            if($#Body >= $i) {
                $NewOldBody .= "> $Body[$i]\n";
            }
        }
        chomp $NewOldBody;
        $Param{Body} =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
    }
    # --
    # get ref of email params
    # --
    my %GetParam = %{$Param{CustomerMessageParams}};
    foreach (keys %GetParam) {
        if ($GetParam{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
        }
    }
    # --
    # set new To address if customer user id is used
    # --
    if ($Article{CustomerUserID}) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );
        if ($CustomerUser{UserEmail}) {
            $Article{From} = $CustomerUser{UserEmail};
        }
    }
    # --
    # send notify 
    # --
    my %Address = $Self->{QueueObject}->GetSystemAddress(QueueID => $Article{QueueID});
    $Self->SendArticle(
            ArticleType => 'email-notification-ext',
            SenderType => 'system',
            TicketID => $Param{TicketID},
            HistoryType => 'SendCustomerNotification',
            HistoryComment => "Sent notification to '$Article{From}'.",
            From => "$Address{RealName} <$Address{Email}>", 
            To => $Article{From},
            Subject => $Param{Subject},
            UserID => $Param{UserID},
            Body => $Param{Body},
            Loop => 1,
    );

    return 1;
}
# --

1;
