# --
# Kernel/System/SendAutoResponse.pm - send auto responses to customers
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendAutoResponse.pm,v 1.1 2002-09-23 18:56:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SendAutoResponse;
    
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
    foreach (qw(Text Realname Address CustomerMessageParams TicketNumber TicketID UserID HistoryType)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %GetParam = %{$Param{CustomerMessageParams}};


    # --
    # prepare subject (insert old subject)
    # --
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $Subject = $Param{Subject} || 'No Std. Subject found!';
    my $OldSubject = $GetParam{Subject} || 'Your email!';
    chomp $OldSubject;
    if ($Subject =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
        my $SubjectChar = $1;
        $OldSubject =~ s/\[$TicketHook: $Param{TicketNumber}\] //g;
        $OldSubject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Subject =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$OldSubject/g;
    }
    $Subject = "[$TicketHook: $Param{TicketNumber}] $Subject";


    # --
    # prepare body (insert old email)
    # --
    my $Body = $Param{Text} || 'No Std. Body found!';
    my $OldBody = $GetParam{Body} || 'Your Message!';
    if ($Body =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
        my $Line = $1;
        my @Body = split(/\n/, $OldBody);
        my $NewOldBody = '';
        foreach (my $i = 0; $i < $Line; $i++) {
            # 2002-06-14 patch of Pablo Ruiz Garcia
            # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
            if ($#Body >= $i) {
                $NewOldBody .= "> $Body[$i]\n";
            }
        }
        chomp $NewOldBody;
        $Body =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
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
        Body => $Body,
        InReplyTo => $GetParam{'Message-ID'},
        Loop => 1,
    );


    # do log
    $Self->{LogObject}->Log(
        Message => "Sent auto reply ($Param{HistoryType}) for Ticket [$Param{TicketNumber}]".
         " (TicketID=$Param{TicketID}, ArticleID=$ArticleID) to '$GetParam{From}'."
    );

    return 1;
}
# --

1;
