# --
# Kernel/Modules/AgentTicketPrint.pm - to get a closer view
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPrint.pm,v 1.10 2004-04-14 15:56:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPrint;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      QueueObject ConfigObject UserObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{TicketObject}->TicketQueueID(TicketID => $Self->{TicketID});
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID} || !$QueueID) {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }  
    # get content
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my %TicketLink = $Self->{TicketObject}->TicketLinkGet(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->GetAccountedTime(TicketID => $Ticket{TicketID});
    # article attachments
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    # user info
    my %UserInfo = $Self->{UserObject}->GetUserData(
        User => $Ticket{Owner},
        Cached => 1
    );
    # genterate output
    $Output .= $Self->{LayoutObject}->PrintHeader(Title => $Ticket{TicketNumber});
    $Output .= $Self->_MaskHeader(
        %UserInfo,
        %Ticket,
        %TicketLink,
    );
    # show ticket
    $Output .= $Self->_Mask(
        TicketID => $Self->{TicketID},
        QueueID => $QueueID,
        ArticleBox => \@ArticleBox,
        %UserInfo,
        %Ticket,
        %TicketLink,
    );
    # add footer 
    $Output .= $Self->{LayoutObject}->PrintFooter();

    # return output
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build article stuff
    my $SelectedArticleID = $Param{ArticleID} || '';
    my @ArticleBox = @{$Param{ArticleBox}};
    # get last customer article
    my $Output = '';
    foreach my $ArticleTmp (@ArticleBox) {
        my %Article = %{$ArticleTmp};
        # get attacment string
        my %AtmIndex = ();
        if ($Article{Atms}) {
            %AtmIndex = %{$Article{Atms}};
        }
        $Param{"Article::ATM"} = '';
        foreach (keys %AtmIndex) {
          $AtmIndex{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $AtmIndex{$_});
          $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
            "ArticleID=$Article{ArticleID}&FileID=$_\" target=\"attachment\" ".
            "onmouseover=\"window.status='\$Text{\"Download\"}: $AtmIndex{$_}';".
             ' return true;" onmouseout="window.status=\'\';">'.
             $AtmIndex{$_}.'</a><br> ';
        }
        foreach (qw(To Cc From Subject FreeKey1 FreeKey2 FreeKey3 FreeValue1 FreeValue2 
          FreeValue3 CreateTime SenderType ArticleType)) {
            $Article{$_} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
                Text => $Article{$_},
                From => $Article{ContentCharset},
            );
        }
        # check if just a only html email
        if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article, Action => 'AgentZoom')) {
            $Param{"TextNote"} = $MimeTypeText;
            $Article{"Body"} = '';
        }
        else {
            # charset quoting
            $Article{Body} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
                Text => $Article{Body},
                From => $Article{ContentCharset},
            );
            # html quoting
            $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
                NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
                Text => $Article{Body},
                VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesZoom') || 5000,
            );
            # do charset check
            if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
                Action => 'AgentZoom',
                ContentCharset => $Article{ContentCharset},
                TicketID => $Param{TicketID},
                ArticleID => $Article{ArticleID} )) {
                $Param{"Article::TextNote"} = $CharsetText;
            }
        }

        # select the output template
        if ($Article{ArticleType} ne 'email-notification-int') {
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPrint', Data => {%Param,%Article});
        }
    }
    # return output
    return $Output;
}
# --
sub _MaskHeader {
    my $Self = shift;
    my %Param = @_;
    # do some html quoting
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    if ($Param{UntilTime}) {
        $Param{PendingUntil} = $Self->{LayoutObject}->CustomerAge(Age => $Param{UntilTime}, Space => ' ');
    }
    else {
        $Param{PendingUntil} = '-';
    }
    # prepare escalation time (if needed)
    if ($Param{Answered}) {
        $Param{TicketOverTime} = '$Text{"none - answered"}';
    }
    elsif ($Param{TicketOverTime}) {
      $Param{TicketOverTime} = $Self->{LayoutObject}->CustomerAge(
          Age => $Param{TicketOverTime},
          Space => ' ',
      );
    }
    else {
        $Param{TicketOverTime} = '-';
    }
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPrintHeader', Data => \%Param);
}
# --
1;
