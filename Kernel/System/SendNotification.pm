# --
# Kernel/System/SendNotification.pm - send notifications to agent
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendNotification.pm,v 1.1 2002-09-23 18:56:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SendNotification;
    
use strict;

use Kernel::System::EmailSend;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{Debug} = 0; 
    # get all objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
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
    foreach (qw(To CustomerMessageParams TicketNumber TicketID UserID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get ref of email params
    # --
    my %GetParam = %{$Param{CustomerMessageParams}};
    # --
    # get notify texts
    # --
    if ($Param{Type} eq 'FollowUp') {
        $Param{Subject} =  $Self->{ConfigObject}->Get('NotificationSubjectFollowUp') 
          || 'No subject found in Config.pm!';
        $Param{Body} = $Self->{ConfigObject}->Get('NotificationBodyFollowUp') 
          || 'No body found in Config.pm!';
    }
    else {
        $Param{Subject} = $Self->{ConfigObject}->Get('NotificationSubjectNewTicket') 
          || 'No subject found in Config.pm!';
        $Param{Body} = $Self->{ConfigObject}->Get('NotificationBodyNewTicket')
          || 'No body found in Config.pm!';
    }
    # --
    # prepare subject (insert old subject)
    # --
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $OldSubject = $GetParam{Subject} || 'Your email!';
    chomp $OldSubject; 
    if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $OldSubject =~ s/\[$TicketHook: $Param{TicketNumber}\] //g;
        $OldSubject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$OldSubject/g;
    }
    $Param{Subject} = "[$TicketHook: $Param{TicketNumber}] $Param{Subject}";

    # --
    # prepare body (insert old email)
    # -- 
    my $From = $GetParam{From} || '';
    $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
    $Param{Body} =~ s/<OTRS_QUEUE>/$Param{Queue}/g if ($Param{Queue});
    $Param{Body} =~ s/<OTRS_USERFIRSTNAME>/$Param{UserFirstname}/g if ($Param{UserFirstname});
    foreach (keys %GetParam) {
        $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi if ($GetParam{$_});
    }
    my $OldBody = $GetParam{Body} || 'Your Message!';
    if ($Param{Body} =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
        my $Line = $1;
        my @Body = split(/\n/, $OldBody);
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
