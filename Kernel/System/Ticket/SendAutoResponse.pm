# --
# Kernel/System/Ticket/SendAutoResponse.pm - send auto responses to customers
# Copyright (C) 2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendAutoResponse.pm,v 1.2 2003-01-27 16:15:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::SendAutoResponse;
    
use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub SendAutoResponse {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Text Realname Address CustomerMessageParams TicketNumber TicketID UserID HistoryType)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    $Param{Body} = $Param{Text} || 'No Std. Body found!';
    my %GetParam = %{$Param{CustomerMessageParams}};
   
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
    # --
    # replace all scaned email x-headers with <OTRS_CUSTOMER_X-HEADER>
    # --
    foreach (keys %GetParam) {
        if (defined $GetParam{$_}) {
            $Param{Body} =~ s/<OTRS_CUSTOMER_$_>/$GetParam{$_}/gi;
        }
    }
    # --
    # replace some special stuff
    #  --
    $Param{Body} =~ s/<OTRS_TICKET_NUMBER>/$Param{TicketNumber}/gi;
    $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/gi;
    # prepare customer realname
    if ($Param{Body} =~ /<OTRS_CUSTOMER_REALNAME>/) {
        # get realname 
        my $From = $GetParam{From} || '';
        $From =~ s/<.*>|\(.*\)|\"|;|,//g;
        $From =~ s/( $)|(  $)//g;
        $Param{Body} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
    }

    # --
    # Arnold Ligtvoet - otrs@ligtvoet.org
    # get OTRS_CUSTOMER_SUBJECT from body
    # --
    if ($Param{Body} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $TicketHook2 = $Self->{ConfigObject}->Get('TicketHook');
        my $SubRep = $GetParam{Subject} || 'No Std. Subject found!';
        my $SubjectChar = $1;
        $SubRep =~ s/\[$TicketHook2: $Param{TicketNumber}\] //g;
        $SubRep =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Param{Body} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$SubRep/g;
    }
    
    # --
    # Arnold Ligtvoet - otrs@ligtvoet.org
    # get OTRS_EMAIL_DATE from body and replace with received date
    # --
    use POSIX qw(strftime);
    if ($Param{Body} =~ /<OTRS_EMAIL_DATE\[(.*)\]>/) {
        my $EmailDate = strftime('%A, %B %e, %Y at %T ', localtime);
        my $TimeZone = $1;
        $EmailDate .= "($TimeZone)";
        $Param{Body} =~ s/<OTRS_EMAIL_DATE\[.*\]>/$EmailDate/g;
    }

    # --
    # check reply to
    # --
    if ($GetParam{ReplyTo}) {
        $GetParam{From} = $GetParam{ReplyTo};
    }
    # --
    # prepare subject (insert old subject)
    # --
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $Subject = $Param{Subject} || 'No Std. Subject found!';
    if ($Subject =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $GetParam{Subject} =~ s/\[$TicketHook: $Param{TicketNumber}\] //g;
        $GetParam{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Subject =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$GetParam{Subject}/g;
    }
    $Subject = "[$TicketHook: $Param{TicketNumber}] $Subject";
    # --
    # prepare body (insert old email)
    # --
    if ($Param{Body} =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
        my $Line = $1;
        my @Body = split(/\n/, $GetParam{Body});
        my $NewOldBody = '';
        foreach (my $i = 0; $i < $Line; $i++) {
            # 2002-06-14 patch of Pablo Ruiz Garcia
            # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
            if ($#Body >= $i) {
                $NewOldBody .= "> $Body[$i]\n";
            }
        }
        chomp $NewOldBody;
        $Param{Body} =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
    }
    # --
    # send email
    # --
    my $ArticleID = $Self->SendArticle(
        ArticleType => 'email-external',
        SenderType => 'system',
        TicketID => $Param{TicketID},
        HistoryType => $Param{HistoryType}, 
        HistoryComment => "Sent auto response to '$GetParam{From}'",
        From => "$Param{Realname} <$Param{Address}>",
        Email => $Param{Address},
        To => $GetParam{From},
        RealName => $Param{Realname},
        Charset => $Param{Charset},
        Subject => $Subject,
        UserID => $Param{UserID},
        Body => $Param{Body},
        InReplyTo => $GetParam{'Message-ID'},
        Loop => 1,
    );
    # --
    # log
    # --
    $Self->{LogObject}->Log(
        Message => "Sent auto reply ($Param{HistoryType}) for Ticket [$Param{TicketNumber}]".
         " (TicketID=$Param{TicketID}, ArticleID=$ArticleID) to '$GetParam{From}'."
    );

    return 1;
}
# --

1;
