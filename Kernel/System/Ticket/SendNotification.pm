# --
# Kernel/System/Ticket/SendNotification.pm - send notifications to agent
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendNotification.pm,v 1.14 2004-04-05 17:10:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::SendNotification;
    
use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub SendNotification {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CustomerMessageParams TicketID UserID Type UserData)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # comapt Type
    if ($Param{Type} =~/(EmailCustomer|PhoneCallCustomer|WebRequestCustomer)/) {
        $Param{Type} = 'NewTicket';
    }
    # get old article for quoteing
    my %Article = $Self->GetLastCustomerArticle(TicketID => $Param{TicketID});
    my %User = %{$Param{UserData}};
    # check recipients
    if (!$User{UserEmail}) {
        return;
    }
    # get user language
    my $Language = $User{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
    # get notification data
    my %Notification = $Self->{NotificationObject}->NotificationGet(Name => $Language.'::Agent::'.$Param{Type});
    # get ref of email params
    my %GetParam = %{$Param{CustomerMessageParams}};
    # get notify texts
    foreach (qw(Subject Body)) {
        $Param{$_} = $Notification{$_} || "No Notifiaction $_ for $Param{Type} found!";
    }
    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    if ($Article{CustomerUserID}) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );
        # replace customer stuff with tags 
        foreach (keys %CustomerUser) {
            if ($CustomerUser{$_}) {
                $Param{Body} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
                $Param{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
            }
        }
    }
    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Param{Body} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
    $Param{Subject} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    # replace article stuff with tags 
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
    # get owner data and replace it with <OTRS_OWNER_...
    my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Article{UserID});
    foreach (keys %Preferences) {
        if ($Preferences{$_}) {
            $Param{Body} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
            $Param{Subject} =~ s/<OTRS_OWNER_$_>/$Preferences{$_}/gi;
        }
    }
    # get current user data
    my %CurrentUser = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
    foreach (keys %CurrentUser) {
        if ($CurrentUser{$_}) {
            $Param{Body} =~ s/<OTRS_CURRENT_$_>/$CurrentUser{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentUser{$_}/gi;
        }
    }
    # replace it with given user params
    foreach (keys %User) {
        if ($User{$_}) {
            $Param{Body} =~ s/<OTRS_$_>/$User{$_}/gi;
            $Param{Subject} =~ s/<OTRS_$_>/$User{$_}/gi;
        }
    }
    # get ticket hook
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    # prepare subject (insert old subject)
    if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $GetParam{Subject} =~ s/\[$TicketHook: $Article{TicketNumber}\] //g;
        $GetParam{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$GetParam{Subject}/g;
    }
    $Param{Subject} = "[$TicketHook: $Article{TicketNumber}] $Param{Subject}";
    # prepare body (insert old email)
    $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
    $Param{Body} =~ s/<OTRS_TICKET_NUMBER>/$Article{TicketNumber}/g;
    $Param{Body} =~ s/<OTRS_QUEUE>/$Article{Queue}/g; 
    $Param{Body} =~ s/<OTRS_COMMENT>/$GetParam{Comment}/g if (defined $GetParam{Comment});
    # replace it with article data
    foreach (keys %Article) {
        if (defined($Article{$_})) {
            $Param{Subject} =~ s/<OTRS_$_>/$Article{$_}/gi;
            $Param{Body} =~ s/<OTRS_$_>/$Article{$_}/gi;
        }
        else {
            # cleanup
            $Param{Subject} =~ s/<OTRS_$_>//gi;
            $Param{Body} =~ s/<OTRS_$_>//gi;
        }
    }
   
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
    # replace config options
    $Param{Body} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Param{Subject} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;

    # send notify 
    $Self->{SendmailObject}->Send(
        From => $Self->{ConfigObject}->Get('NotificationSenderName').
             ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>',
        To => $User{UserEmail},
        Subject => $Param{Subject},
        ContentType => "text/plain; charset=$Notification{Charset}",
        Body => $Param{Body},
        Loop => 1,
    );

    # write history
    $Self->HistoryTicketAdd(
        TicketID => $Param{TicketID},
        HistoryType => 'SendAgentNotification',
        Name => "Sent '$Param{Type}' notification to '$User{UserEmail}'.",
        CreateUserID => $Param{UserID},
    );

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "Sent agent '$Param{Type}' notification to '$User{UserEmail}'.",
    );

    return 1;
}
# --
sub SendCustomerNotification {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CustomerMessageParams TicketID UserID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get notify texts
    $Param{Subject} = $Self->{ConfigObject}->Get("CustomerNotificationSubject$Param{Type}") 
      || "No CustomerNotificationSubject$Param{Type} found in Config.pm!";
    $Param{Body} = $Self->{ConfigObject}->Get("CustomerNotificationBody$Param{Type}")
      || "No CustomerNotificationBody$Param{Type} found in Config.pm!";
    # get old article for quoteing
    my %Article = $Self->GetLastCustomerArticle(TicketID => $Param{TicketID});
    foreach (keys %Article) {
        if ($Article{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
        }
    }
    # check if notification should be send
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
    # get owner data
    my ($OwnerID, $Owner) = $Self->OwnerCheck(TicketID => $Param{TicketID});
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
    # get ticket hook
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    # prepare subject (insert old subject)
    if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $Article{Subject} =~ s/\[$TicketHook: $Article{TicketNumber}\] //g;
        $Article{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Article{Subject}/g;
    }
    $Param{Subject} = "[$TicketHook: $Article{TicketNumber}] $Param{Subject}";
    # prepare body (insert old email)
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
    # get ref of email params
    my %GetParam = %{$Param{CustomerMessageParams}};
    foreach (keys %GetParam) {
        if ($GetParam{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
        }
    }
    # set new To address if customer user id is used
    if ($Article{CustomerUserID}) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );
        if ($CustomerUser{UserEmail}) {
            $Article{From} = $CustomerUser{UserEmail};
        }
    }
    # send notify 
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

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "Sent customer '$Param{Type}' notification to '$Article{From}'.",
    );

    return 1;
}
# --

1;
