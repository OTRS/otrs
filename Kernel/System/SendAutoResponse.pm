# --
# Kernel/System/SendAutoResponse.pm - send auto responses to customers
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendAutoResponse.pm,v 1.2 2002-10-03 17:50:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SendAutoResponse;
    
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

    $Self->{Debug} = 0; 
    # get all objects
    foreach (qw(DBObject ConfigObject LogObject TicketObject)) {
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
        }
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
    my $ArticleID = $Self->{EmailObject}->Send(
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
