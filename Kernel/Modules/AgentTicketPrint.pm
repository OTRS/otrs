# --
# Kernel/Modules/AgentTicketPrint.pm - to get a closer view
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPrint.pm,v 1.22 2005-09-18 13:35:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPrint;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

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
        return $Self->{LayoutObject}->Error(Message => 'Need TicketID!');
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # get linked objects
    my %Links = $Self->{LinkObject}->AllLinkedObjects(
        Object => 'Ticket',
        ObjectID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    foreach my $LinkType (sort keys %Links) {
        my %ObjectType = %{$Links{$LinkType}};
        foreach my $Object (sort keys %ObjectType) {
            my %Data = %{$ObjectType{$Object}};
            foreach my $Item (sort keys %Data) {
                $Self->{LayoutObject}->Block(
                    Name => "Link$LinkType",
                    Data => $Data{$Item},
                );
            }
        }
    }
    # get content
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(TicketID => $Ticket{TicketID});
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
    # customer info
    my %CustomerData = ();
    if ($Ticket{CustomerUserID}) {
        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );
    }
    elsif ($Ticket{CustomerID}) {
        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            CustomerID => $Ticket{CustomerID},
        );
    }
    if (%CustomerData) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => \%CustomerData,
            Max => 100,
        );
    }
    # genterate output
    $Output .= $Self->{LayoutObject}->PrintHeader(Value => $Ticket{TicketNumber});
    # do some html quoting
    $Ticket{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Ticket{Age}, Space => ' ');
    if ($Ticket{UntilTime}) {
        $Ticket{PendingUntil} = $Self->{LayoutObject}->CustomerAge(Age => $Ticket{UntilTime}, Space => ' ');
    }
    else {
        $Ticket{PendingUntil} = '-';
    }
    # prepare escalation time (if needed)
    if ($Ticket{TicketOverTime}) {
      $Ticket{TicketOverTime} = $Self->{LayoutObject}->CustomerAge(
          Age => $Ticket{TicketOverTime},
          Space => ' ',
      );
    }
    else {
        $Ticket{TicketOverTime} = '-';
    }
    # show ticket
    $Output .= $Self->_Mask(
        TicketID => $Self->{TicketID},
        QueueID => $QueueID,
        ArticleBox => \@ArticleBox,
        %Param,
        %UserInfo,
        %Ticket,
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
        foreach my $FileID (keys %AtmIndex) {
          my %File = %{$AtmIndex{$FileID}};
          $File{Filename} = $Self->{LayoutObject}->Ascii2Html(Text => $File{Filename});
          $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentTicketAttachment&'.
            "ArticleID=$Article{ArticleID}&FileID=$FileID\" target=\"attachment\" ".
            "onmouseover=\"window.status='\$Text{\"Download\"}: $File{Filename}';".
             ' return true;" onmouseout="window.status=\'\';">'.
             "$File{Filename}</a> $File{Filesize}<br>";
        }
        # check if just a only html email
        if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article, Action => 'AgentTicketZoom')) {
            $Param{"TextNote"} = $MimeTypeText;
            $Article{"Body"} = '';
        }
        else {
            # html quoting
            $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
                NewLine => $Self->{ConfigObject}->Get('DefaultViewNewLine') || 85,
                Text => $Article{Body},
                VMax => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
            );
            # do charset check
            if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
                Action => 'AgentTicketZoom',
                ContentCharset => $Article{ContentCharset},
                TicketID => $Param{TicketID},
                ArticleID => $Article{ArticleID} )) {
                $Param{"Article::TextNote"} = $CharsetText;
            }
        }

        # select the output template
        if ($Article{ArticleType} ne 'email-notification-int') {
            $Self->{LayoutObject}->Block(
                Name => 'Article',
                Data => {%Param,%Article},
            );
        }
        # do some strips && quoting
        foreach (qw(From To Cc Subject)) {
            if ($Article{$_}) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        Key => $_,
                        Value => $Article{$_},
                    },
                );
            }
        }
        # show accounted article time
        if ($Self->{ConfigObject}->Get('Ticket::ZoomTimeDisplay')) {
            my $ArticleTime = $Self->{TicketObject}->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
            $Self->{LayoutObject}->Block(
                Name => "Row",
                Data => {
                    Key => 'Time',
                    Value => $ArticleTime,
                },
            );
        }
        # show article free text
        foreach (qw(1 2 3 4 5)) {
            if ($Article{"FreeText$_"}) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleFreeText',
                    Data => {
                        Key => $Article{"FreeKey$_"},
                        Value => $Article{"FreeText$_"},
                    },
                );
            }
        }
    }
    # return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPrint', Data => {%Param});
}
# --
1;
