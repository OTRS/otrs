# --
# Kernel/System/EmailSend.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailSend.pm,v 1.19 2003-01-03 16:14:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::EmailSend;

use strict;
use MIME::Words qw(:all);
use Mail::Internet;
use Kernel::System::StdAttachment;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    foreach (qw(ConfigObject LogObject DBObject TicketObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    # just in case if we got no TicketObject (for compat)
    if (! $Self->{TicketObject}) {
        require Kernel::System::Ticket;
        $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);
    }
    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);

    return $Self;
}
# --
sub Send {
    my $Self = shift;
    my %Param = @_;
    my $Time = time();
    my $Random = rand(999999);
    my $ToOrig = $Param{To} || '';
    my $Charset = $Param{Charset} || 'iso-8859-1';
    my $InReplyTo = $Param{InReplyTo} || '';
    my $RetEmail = $Param{Email};
    my $Loop = $Param{Loop} || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';

    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID From Body Email)) {
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
    if ($Param{ArticleID} = $Self->{TicketObject}->CreateArticle(
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
    foreach (qw(From To Cc Subject)) {
        if ($Param{$_}) {
            $Param{$_} = encode_mimewords($Param{$_}, Charset => $Charset) || '';
        }
    }
    # build header
    my $Header = {
        From => $Param{From},
        To => $Param{To},
        Cc => $Param{Cc},
        Bcc => $Self->{SendmailBcc},
        Subject => $Param{Subject},
        'Message-ID' => $MessageID,
        'In-Reply-To' => $InReplyTo,
        'X-Mailer' => "OTRS Mail Service ($VERSION)",
        'X-Powered-By' => 'OTRS - Open Ticket Request System (http://otrs.org/)',
        'X-MimeTools' => MIME::Tools->version,
        Organization => $Self->{Organization},
        Type => 'text/plain; charset='.$Charset,
        Encoding => '8bit',
    }; 
    if ($Loop) {
        $$Header{Precedence} = 'bulk';
        $$Header{'X-Loop'} = 'bulk';
    }
    my $Entity = MIME::Entity->build(%{$Header}, Data => $Param{Body});
    # --
    # attachments
    # --
    if ($Param{UploadFilename}) {
        $Entity->attach(
            Path     => $Param{UploadFilename},
            Type     => $Param{UploadContentType},
            Encoding => "base64",
        );
    }
    # --
    # std attachments
    # --
    if ($Param{StdAttachmentIDs}) {
        foreach my $ID (@{$Param{StdAttachmentIDs}}) {
            my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet(ID => $ID);
            foreach (qw(FileName ContentType Content)) {
                if (!$Data{$_}) {
                    $Self->{LogObject}->Log(
                        Priority => 'error', 
                        Message => "No $_ found for std. attachment id $ID!",
                    );
                }
            }
            open(TMPOUT, "> /tmp/$Data{FileName}");
            print TMPOUT $Data{Content};
            close (TMPOUT);
            $Entity->attach(
                Path     => "/tmp/$Data{FileName}",
                Type     => $Data{ContentType},
                Encoding => "base64",
            );
        }
    }
    # --
    # add In-Reply-To header
    # --
    my $head = $Entity->head;
    $head->add('In-Reply-To', $InReplyTo);
    # --
    # send mail
    # --
    if (open( MAIL, "|$Self->{Sendmail} '$RetEmail' " )) {
        my @Mail = ($head->as_string, "\n", $Entity->body_as_string);
        print MAIL @Mail;
        close(MAIL);
        # -- 
        # write article to fs
        # -- 
        if (!$Self->{TicketObject}->WriteArticle(
            ArticleID => $Param{ArticleID}, 
            Email => \@Mail,
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
          Message => "Sent email to '$ToOrig' from '$Param{From}'. HistoryType => $HistoryType, Subject => $Param{Subject};",
        );

        return $Param{ArticleID};
    }
    else {
         $Self->{LogObject}->Log(
           Priority => 'error', 
           Message => "Can't use $Self->{Sendmail}: $!!",
         );
         return;
    }
}
# --
sub Bounce {
    my $Self = shift;
    my %Param = @_;
    my $Time = time();
    my $Random = rand(999999);
    my $UserID = $Param{UserID} || 0;
    my $From = $Param{From} || '';
    my $To = $Param{To} || '';
    my $ToOrig = $To;
    my $Cc = $Param{Cc} || '';
    my $HistoryType = $Param{HistoryType} || 'Bounce';
    my $RetEmail = $Param{Email};
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
    my $NewMessageID = "<$Time.$Random.$Param{TicketID}.0.$UserID\@$Self->{FQDN}>";
    my $OldMessageID = $HeaderObject->get('Message-ID') || '??';
    $HeaderObject->replace('Message-ID', $NewMessageID);
    $HeaderObject->replace('ReSent-Message-ID', $OldMessageID);
    $HeaderObject->replace('Resent-To', $To);
    $HeaderObject->replace('Resent-From', $From);
    my $Body = $EmailObject->body();

    # --
    # pipe all into sendmail
    # --
    if (open( MAIL, "|$Self->{Sendmail} '$RetEmail' " )) {
        print MAIL $HeaderObject->as_string;
        print MAIL "\n";
        foreach (@{$Body}) {
            print MAIL $_."\n";
        }
        close(MAIL);
    }
    else {
        print STDERR "$!\n";
        return;
    }

    # --
    # write history
    # --
    if ($Self->{TicketObject}) {
        $Self->{TicketObject}->AddHistoryRow(
          TicketID => $Param{TicketID},
          ArticleID => $Param{ArticleID},
          HistoryType => $HistoryType,
          Name => "Bounced email to '$To'.",
          CreateUserID => $UserID,
        );
    }
    return 1;
}
# --
sub SendNormal {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Subject Body)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{To} && !$Param{Cc} && !$Param{Bcc}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need To, Cc or Bcc!");
        return;
    }
    if (!$Param{From}) {
        $Param{From} = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';
    }
    # --
    # send mail
    # --
    if (open( MAIL, "|".$Self->{ConfigObject}->Get('Sendmail')." '$Param{From}' " )) {
            print MAIL "From: $Param{From}\n";
            foreach (qw(To Cc Bcc)) {
                print MAIL "$_: $Param{$_}\n" if ($Param{$_});
            }
            print MAIL "Subject: $Param{Subject}\n";
            print MAIL "X-Mailer: OTRS Mail Service ($VERSION)\n";
            print MAIL "X-Powered-By: OTRS - Open Ticket Request System (http://otrs.org/)\n";
            print MAIL "\n";
            print MAIL "$Param{Body}\n";
            close(MAIL);
            return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't use ".$Self->{ConfigObject}->Get('Sendmail').": $!!",
        );
        return;
    }
}
# --

1;
