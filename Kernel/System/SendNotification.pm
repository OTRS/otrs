# --
# Kernel/System/SendNotification.pm - send notifications to agent
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendNotification.pm,v 1.2 2002-10-03 17:49:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SendNotification;
    
use strict;

use Kernel::System::EmailSend;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);

    # get all objects
    foreach (qw(DBObject ConfigObject LogObject TicketObject UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_";
    }

    # create email object
    $Self->{EmailObject} = Kernel::System::EmailSend->new(%Param);

    return $Self;
}
# --
sub Send {
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
    my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $Param{TicketID});
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
    my ($OwnerID, $Owner) = $Self->{TicketObject}->CheckOwner(TicketID => $Param{TicketID});
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
    $Self->{EmailObject}->Send(
            ArticleType => 'email-notification-int',
            SenderType => 'system',
            TicketID => $Param{TicketID},
            HistoryType => 'SendAgentNotification',
            HistoryComment => "Sent notification to '$Param{To}'.",
            From => $Self->{ConfigObject}->Get('NotificationSenderName').
              ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>',
            Email => $Self->{ConfigObject}->Get('NotificationSenderEmail'),
            To => $Param{To},
            Subject => $Param{Subject},
            UserID => $Param{UserID},
            Body => $Param{Body},
            Loop => 1,
    );

    return 1;
}
# --

1;
