# --
# EmailSend.pm - the global email send module
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailSend.pm,v 1.9 2002-06-16 20:43:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::EmailSend;

use strict;
use MIME::Words qw(:all);
use Mail::Internet;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
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
    foreach ('ConfigObject', 'LogObject', 'DBObject') {
        die "Got no $_" if (!$Self->{$_});
    }

    # get config data
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');

    return $Self;
}
# --
sub Send {
    my $Self = shift;
    my %Param = @_;
    my $From = $Param{From} || '';
    my $To = $Param{To} || '';
    my $ToOrig = $To;
    my $Cc = $Param{Cc} || '';
    my $Subject = $Param{Subject} || '';
    my $Charset = $Param{Charset} || 'iso-8859-1';
    my $Time = time();
    my $Random = rand(999999);
    my $UserID = $Param{UserID} || 0;
    my $TicketObject = $Param{TicketObject} || '';
    my $Body = $Param{Body};
    $Body =~ s/(\r\n|\n\r)/\n/g;
    $Body =~ s/\r/\n/g;
    my $InReplyTo = $Param{InReplyTo} || '';
    my $RetEmail = $Param{Email};
    my $Loop = $Param{Loop} || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';
    # do some encode
#    $To = encode_mimeword($To) if ($To);
#    $Cc = encode_mimeword($Cc) if ($Cc);
#    $Subject = encode_mimeword($Subject) if ($Subject);

    # --
    # create article
    # --
    if ($Param{ArticleObject} && $Param{TicketID} && $Param{ArticleType} &&
         $Param{ArticleSenderType} ) {

         $Param{ArticleID} = $Param{ArticleObject}->CreateArticleDB(
            TicketID => $Param{TicketID},
            ArticleType => $Param{ArticleType},
            SenderType => $Param{ArticleSenderType},
            From => $From,
            To => $To,
            Cc => $Cc,
            Subject => $Subject,
            MessageID => "<$Time.$Random.$Param{TicketID}.0.$UserID\@$Self->{FQDN}>",
            Body => $Body,
            CreateUserID => $UserID,
        );

    }

    foreach ('ArticleID', 'TicketID') {
        $Param{$_} = 0 if (!$Param{$_});
    }

    # --
    # build mail ...
    # --
    my @Mail = ("From: $From\n");
    push @Mail, "To: $To\n";
    push @Mail, "Cc: $Cc\n" if ($Cc);
    push @Mail, "Bcc: $Self->{SendmailBcc}\n" if ($Self->{SendmailBcc});
    push @Mail, "Subject: $Subject\n";
    push @Mail, "In-Reply-To: $InReplyTo\n" if ($InReplyTo);
    push @Mail, "Message-ID: <$Time.$Random.$Param{TicketID}.$Param{ArticleID}.$UserID\@$Self->{FQDN}>\n";
    push @Mail, "X-Mailer: Open-Ticket-Request-System Mail Service ($VERSION)\n";
    push @Mail, "X-Powered-By: OpenTRS (http://otrs.org/)\n";
    push @Mail, "X-OTRS-Loop: $RetEmail\n";
    push @Mail, "Precedence: bulk\nX-Loop: $RetEmail\n" if ($Loop);
    push @Mail, "Content-Type: TEXT/PLAIN; charset=$Charset\n";
    push @Mail, "Content-Transfer-Encoding: 8BIT\n";
    push @Mail, "Mime-Version: 1.0\n";
    push @Mail, "\n";
    push @Mail, $Body;
    push @Mail, "\n";

    # --
    # send mail
    # --
    open( MAIL, "|$Self->{Sendmail} '$RetEmail' " );
    print MAIL @Mail;
    close(MAIL);

    # --
    # write article to fs
    # --
    if ($Param{ArticleID}) {
        my $ArticleObject = Kernel::System::Article->new(
          DBObject => $Self->{DBObject},
          ConfigObject => $Self->{ConfigObject},
        );
        $ArticleObject->WriteArticle(ArticleID => $Param{ArticleID}, Email => \@Mail);
    }

    # --
    # write history
    # --
    if ($TicketObject) {
        $TicketObject->AddHistoryRow(
          TicketID => $Param{TicketID},
          ArticleID => $Param{ArticleID},
          HistoryType => $HistoryType,
          Name => "Sent email to '$ToOrig'.",
          CreateUserID => $UserID,
        );
    }

    # --
    # log
    # --
    $Self->{LogObject}->Log(
        MSG => "Sent email to '$ToOrig' from '$From'. HistoryType => $HistoryType, Subject => $Subject;",
    );

    if ($Param{ArticleID}) {
        return $Param{ArticleID};
    }
    else {
        return 1;
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
    my $TicketObject = $Param{TicketObject} || '';
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';
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
    if ($TicketObject) {
        $TicketObject->AddHistoryRow(
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

1;

 
