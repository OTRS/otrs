# --
# Kernel/Modules/CustomerTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerTicketZoom.pm,v 1.3 2005-10-17 20:27:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketZoom;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject
        ConfigObject UserObject SessionObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{TicketObject}->TicketQueueID(TicketID => $Self->{TicketID});
    # check needed stuff
    if (!$Self->{TicketID} || !$QueueID) {
        $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        return $Self->{LayoutObject}->CustomerError(Message => 'Need TicketID!');
    }
    # check permissions
    if (!$Self->{TicketObject}->CustomerPermission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
    }
    # store last screen
    if ($Self->{Subaction} ne 'ShowHTMLeMail') {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
    }
    # --
    # fetch all std. responses
    # --
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    $Ticket{TmpCounter} = 0;
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(
        TicketID => $Ticket{TicketID},
    );
    # get all atricle of this ticket
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    # get article attachments
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    # --
    # genterate output
    # --
    $Output .= $Self->{LayoutObject}->CustomerHeader(Value => $Ticket{TicketNumber});
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # --
    # show ticket
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, drop normal header
        $Ticket{ShowHTMLeMail} = 1;
        $Output = '';
    }
    $Output .= $Self->_Mask(
        NextStates => $Self->_GetNextStates(),
        TicketID => $Self->{TicketID},
        QueueID => $QueueID,
        ArticleBox => \@ArticleBox,
        ArticleID => $Self->{ArticleID},
        %Ticket
    );
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, return here
        $Ticket{ShowHTMLeMail} = 1;
        return $Output;
    }
    # add footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return output
    return $Output;
}
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'CustomerPanelDefaultNextCompose',
        TicketID => $Self->{TicketID},
        CustomerUserID => $Self->{UserID},
    );
    return \%NextStates;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'ComposeStateID',
        Selected => $Self->{ConfigObject}->Get('CustomerPanelDefaultNextComposeType')
    );
    # do some html quoting
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # build article stuff
    my $SelectedArticleID = $Param{ArticleID} || '';
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "TicketID=$Self->{TicketID}&QueueID=$Self->{QueueID}&";
    my @ArticleBox = @{$Param{ArticleBox}};
    # get last customer article
    my $CounterArray = 0;
    my $LastCustomerArticleID;
    my $LastCustomerArticle = $#ArticleBox;
    my $ArticleID = '';
    foreach my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;
        # if it is a customer article
        if ($Article{SenderType} eq 'customer') {
            $LastCustomerArticleID = $Article{'ArticleID'};
            $LastCustomerArticle = $CounterArray;
        }
        $CounterArray++;
        if ($SelectedArticleID eq $Article{ArticleID}) {
            $ArticleID = $Article{ArticleID};
        }
    }
    # try to use the latest customer article
    if (!$ArticleID && $LastCustomerArticleID) {
        $ArticleID = $LastCustomerArticleID;
    }
    # try to use the latest non internal agent article
    if (!$ArticleID) {
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleTmp->{StateType} eq 'merged' || $ArticleTmp->{ArticleType} !~ /int/) {
                $ArticleID = $ArticleTmp->{ArticleID};
            }
        }
    }
    # build thread string
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    $Param{ArticleStrg} = '';
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      if ($Article{ArticleType} !~ /int/) {
        if ($LastSenderType ne $Article{SenderType}) {
            $Counter .= "&nbsp;&nbsp;&nbsp;&nbsp;";
            $Space = "$Counter |-->";
        }
        $LastSenderType = $Article{SenderType};
        $ThreadStrg .= "$Space";
        # if this is the shown article -=> add <b>
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= ">><b><i><u>";
        }
        # the full part thread string
        $ThreadStrg .= "<A HREF=\"$BaseLink"."Action=CustomerTicketZoom&ArticleID=$Article{ArticleID}\" ";
        $ThreadStrg .= 'onmouseover="window.status=\'$Text{"Zoom"}\'; return true;" onmouseout="window.status=\'\';">';
        $ThreadStrg .= "\$Text{\"$Article{SenderType}\"} (\$Text{\"$Article{ArticleType}\"})</A> ";
        $ThreadStrg .= ' $TimeLong{"'.$Article{Created}.'"}';
        $ThreadStrg .= "<BR>";
        # if this is the shown article -=> add </b>
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= "</u></i></b>";
        }
      }
    }
    $ThreadStrg .= '';
    $Param{ArticleStrg} .= $ThreadStrg;

    my $ArticleOB = $ArticleBox[$LastCustomerArticle];
    my %Article = %$ArticleOB;

    my $ArticleArray = 0;
    foreach my $ArticleTmp (@ArticleBox) {
        my %ArticleTmp1 = %$ArticleTmp;
        if ($ArticleID eq $ArticleTmp1{ArticleID}) {
            %Article = %ArticleTmp1;
        }
    }
    # check show article type
    if ($Article{StateType} ne 'merged' && $Article{ArticleType} =~ /int/) {
        return $Self->{LayoutObject}->CustomerError(Message => 'No permission!');
    }
    # get attacment string
    my %AtmIndex = ();
    if ($Article{Atms}) {
        %AtmIndex = %{$Article{Atms}};
    }
    my $ATMStrg = '';
    foreach my $FileID (keys %AtmIndex) {
        my %File = %{$AtmIndex{$FileID}};
        $File{Filename} = $Self->{LayoutObject}->Ascii2Html(Text => $File{Filename});
        $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=CustomerTicketAttachment&'.
          'ArticleID='.$Article{ArticleID}.'&FileID='.$FileID.'" target="attachment" '.
          "onmouseover=\"window.status='\$Text{\"Download\"}: $File{Filename}';".
          ' return true;" onmouseout="window.status=\'\';">'.
          "$File{Filename}</a> $File{Filesize}<br>";
    }
    # just body if html email
    if ($Param{"ShowHTMLeMail"}) {
        # generate output
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('Ticket::Hook')."-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{ContentCharset}",
            Content => $Article{Body},
        );
    }
    # check if just a only html email
    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article)) {
        $Param{"Article::TextNote"} = $MimeTypeText;
        $Param{"Article::Text"} = '';
    }
    else {
        # html quoting
        $Param{"Article::Text"} = $Self->{LayoutObject}->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('DefaultViewNewLine') || 85,
            Text => $Article{Body},
            VMax => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
        );
        # link quoting
        $Param{"Article::Text"} = $Self->{LayoutObject}->LinkQuote(Text => $Param{"Article::Text"});
        # do charset check
        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            ContentCharset => $Article{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Article{ArticleID} )) {
            $Param{"Article::TextNote"} = $CharsetText;
        }
    }
    # get article id
    $Param{"Article::ArticleID"} = $Article{ArticleID};
    # select the output template
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketZoom',
        Data => {
            %Article,
            %Param,
        },
    );
}
# --
1;
