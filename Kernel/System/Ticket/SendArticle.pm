# --
# Kernel/System/Ticket::SendArticle.pm - the global email send module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendArticle.pm,v 1.15 2004-01-27 09:26:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::SendArticle;

use strict;
use MIME::Words qw(:all);
use MIME::Entity;
use Mail::Internet;
use Kernel::System::StdAttachment;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub InitSendArticle {
    my $Self = shift;
    my %Param = @_;
    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

    return $Self;
}
# --
sub SendArticle {
    my $Self = shift;
    my %Param = @_;
    my $Time = time();
    my $Random = rand(999999);
    my $ToOrig = $Param{To} || '';
    my $Charset = $Param{Charset} || 'iso-8859-1';
    my $InReplyTo = $Param{InReplyTo} || '';
    my $Loop = $Param{Loop} || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';

    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID From Body)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{ArticleType} && !$Param{ArticleTypeID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleType or ArticleTypeID!");
        return;
    }
    if (!$Param{SenderType} && !$Param{SenderTypeID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need SenderType or SenderTypeID!");
        return;
    }
    # --
    # clean up
    # --
    $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
    $Param{Body} =~ s/\r/\n/g;
    # --
    # create article
    # --
    my $MessageID = "<$Time.$Random.$Param{TicketID}.$Param{UserID}\@$Self->{FQDN}>";
    if ($Param{ArticleID} = $Self->CreateArticle(
        %Param,
        MessageID => $MessageID, 
    )) {
      ####
    }
    else {
      return;
    }

    # --
    # build mail ...
    # --
    # do some encode
    foreach (qw(From To Cc Bcc Subject)) {
        if ($Param{$_}) {
            $Param{$_} = encode_mimewords($Param{$_}, Charset => $Charset) || '';
        }
    }
    # check bcc
    if ($Self->{SendmailBcc}) {
        $Param{Bcc} .= ", $Self->{SendmailBcc}";
    }
    # build header
    my $Header = {
        From => $Param{From},
        To => $Param{To},
        Cc => $Param{Cc},
        Bcc => $Param{Bcc},
        Subject => $Param{Subject},
        'Message-ID' => $MessageID,
        'In-Reply-To:' => $InReplyTo,
        'References' => $InReplyTo,
        'X-Mailer' => "OTRS Mail Service ($VERSION)",
        'X-Powered-By' => 'OTRS - Open Ticket Request System (http://otrs.org/)',
        Organization => $Self->{Organization},
        Type => 'text/plain; charset='.$Charset,
        Encoding => '8bit',
    }; 
    if ($Loop) {
        $$Header{'Precedence:'} = 'bulk';
        $$Header{'X-Loop'} = 'bulk';
    }
    my $Entity = MIME::Entity->build(%{$Header}, Data => $Param{Body});
    # --
    # attachments
    # --
    if ($Param{Attach}) {
        foreach my $Tmp (@{$Param{Attach}}) {
            my %Upload = %{$Tmp};
            if ($Upload{Content} && $Upload{Filename}) {
              # --
              # add attachments to article
              # --
              $Self->WriteArticlePart(
                %Upload,
                ArticleID => $Param{ArticleID},
                UserID => $Param{UserID},
              );
              # --
              # attach file to email
              # --
              $Entity->attach(
                Filename => $Upload{Filename},
                Data     => $Upload{Content},
                Type     => $Upload{ContentType},
                Encoding => "base64",
              );
            }
        }
    }
    # --
    # std attachments
    # --
    if ($Param{StdAttachmentIDs}) {
        foreach my $ID (@{$Param{StdAttachmentIDs}}) {
            my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet(ID => $ID);
            foreach (qw(Filename ContentType Content)) {
                if (!$Data{$_}) {
                    $Self->{LogObject}->Log(
                        Priority => 'error', 
                        Message => "No $_ found for std. attachment id $ID!",
                    );
                }
            }
            # --
            # attach file to email
            # --
            $Entity->attach(
                Filename => $Data{Filename},
                Data     => $Data{Content},
                Type     => $Data{ContentType},
                Encoding => "base64",
            );
            # --
            # add attachments to article
            # --
            $Self->WriteArticlePart(
                %Data,
                ArticleID => $Param{ArticleID},
                UserID => $Param{UserID},
            );
        }
    }
    # --
    # get header
    # --
    my $head = $Entity->head;
    # --
    # send mail
    # --
    if ($Self->{SendmailObject}->Send(
        From => $Param{From},
        To => $Param{To},
        Cc => $Param{Cc},
        Bcc => $Param{Bcc},
        Subject => $Param{Subject},
        Header => $head->as_string(),
        Body => $Entity->body_as_string(),
    )) {
        # -- 
        # write article to fs
        # -- 
        if (!$Self->WriteArticlePlain(
            ArticleID => $Param{ArticleID}, 
            Email => $head->as_string."\n".$Entity->body_as_string,
            UserID => $Param{UserID})
        ) {
            return; 
        }
        # --
        # delete attacment(s) and dir
        # --
        if ($Param{UploadFilename}) {
            $Param{UploadFilename} =~ s/(^.*\/).*?$/$1/;
            File::Path::rmtree([$Param{UploadFilename}]);
        }
        # -- 
        # log
        # -- 
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Sent email to '$ToOrig' from '$Param{From}'. HistoryType => $HistoryType, Subject => $Param{Subject};",
        );
        return $Param{ArticleID};
    }
    else {
         # error
         return;
    }
}
# --
sub BounceArticle {
    my $Self = shift;
    my %Param = @_;
    my $Time = time();
    my $Random = rand(999999);
    my $From = $Param{From} || '';
    my $To = $Param{To} || '';
    my $ToOrig = $To;
    my $Cc = $Param{Cc} || '';
    my $HistoryType = $Param{HistoryType} || 'Bounce';
    # --
    # check needed stuff
    # --
    foreach (qw(From To UserID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # build bounce mail ...
    # --
    # get old email
    my $Email = $Param{EmailPlain} || return;
    # split body && header
    my @EmailPlain = split(/\n/, $Email);
    my $EmailObject = new Mail::Internet(\@EmailPlain);
    # --
    # add ReSent header
    # --
    my $HeaderObject = $EmailObject->head();
    my $NewMessageID = "<$Time.$Random.$Param{TicketID}.0.$Param{UserID}\@$Self->{FQDN}>";
    my $OldMessageID = $HeaderObject->get('Message-ID') || '??';
    $HeaderObject->replace('Message-ID', $NewMessageID);
    $HeaderObject->replace('ReSent-Message-ID', $OldMessageID);
    $HeaderObject->replace('Resent-To', $To);
    $HeaderObject->replace('Resent-From', $From);
    my $Body = $EmailObject->body();
    my $BodyAsSting = '';
    foreach (@{$Body}) {
        $BodyAsSting .= $_."\n";
    }
    # --
    # pipe all into sendmail
    # --
    if (!$Self->{SendmailObject}->Send(
        From => $Param{From},
        To => $Param{To},
        Cc => $Param{Cc},
        Bcc => $Self->{SendmailBcc},
        Header => $HeaderObject->as_string(),
        Body => $BodyAsSting,
    )) {
        return;
    }
    # --
    # write history
    # --
    $Self->AddHistoryRow(
        TicketID => $Param{TicketID},
        ArticleID => $Param{ArticleID},
        HistoryType => $HistoryType,
        Name => "Bounced email to '$To'.",
        CreateUserID => $Param{UserID},
    );
    return 1;
}
# --

1;
