# --
# HTML/Customer.pm - provides generic customer HTML output
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Customer.pm,v 1.4 2002-11-27 14:32:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Customer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub CustomerLogin {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # add cookies if exists
    # --
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    $Self->Output(TemplateFile => 'CustomerLogin', Data => \%Param);
    # --
    # get language options
    # --
    $Param{Language} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
        Name => 'Lang',
        SelectedID => $Self->{UserLanguage},
        OnChange => 'submit()'
    );
    # --
    # get lost password output
    # --
    if ($Self->{ConfigObject}->Get('CustomerPanelLostPassword')) {
        $Param{LostPassword} = $Self->Output(TemplateFile => 'CustomerLostPassword', Data => \%Param);
    }
    # --
    # get lost password output
    # --
    if ($Self->{ConfigObject}->Get('CustomerPanelCreateAccount')) {
        $Param{CreateAccount} = $Self->Output(TemplateFile => 'CustomerCreateAccount', Data => \%Param);
    }
    # --
    # create & return output
    # --
    $Output .= $Self->Output(TemplateFile => 'CustomerLogin', Data => \%Param);
    return $Output;
}
# --
sub CustomerHeader {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # add cookies if exists
    # --
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # --
    # create & return output
    # --
    $Output .= $Self->Output(TemplateFile => 'CustomerHeader', Data => \%Param);
    return $Output;
}
# --
sub CustomerFooter {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'CustomerFooter', Data => \%Param);
}
# --
sub CustomerNavigationBar {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'CustomerNavigationBar', Data => \%Param);
}
# --
sub CustomerStatusView {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'CustomerStatusView', Data => \%Param);
}
# --  
sub CustomerStatusViewTable {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ') || 0;
    # do html quoteing
    foreach (qw(State Queue Owner Lock)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 16);
    }
    foreach (qw(Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 30);
    }
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerStatusViewTable', Data => \%Param);
}
# --
sub CustomerError {
    my $Self = shift;
    my %Param = @_;

    # get backend error messages
    foreach (qw(Message Subroutine Line Version)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->Error($_) || '';
    }
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 

    # get frontend error messages
    ($Param{Package}, $Param{Filename}, $Param{Line}, $Param{Subroutine}) = caller(0);
    ($Param{Package1}, $Param{Filename1}, $Param{Line1}, $Param{Subroutine1}) = caller(1);
    ($Param{Package2}, $Param{Filename2}, $Param{Line2}, $Param{Subroutine2}) = caller(2);
    $Param{Version} = eval("\$$Param{Package}". '::VERSION');
    
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerError', Data => \%Param);
}
# --
sub CustomerTicketZoom {
    my $Self = shift;
    my %Param = @_;

    # --
    # do some html quoting
    # --
    foreach (qw(Priority State Owner CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 16) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    # --
    # build article stuff
    # --
    my $SelectedArticleID = $Param{ArticleID} || '';
    my $BaseLink = $Self->{Baselink} . "TicketID=$Self->{TicketID}&QueueID=$Self->{QueueID}&";
    my @ArticleBox = @{$Param{ArticleBox}};
    # --
    # get last customer article
    # --
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
    if (!$ArticleID) {
        $ArticleID = $LastCustomerArticleID;
    }
    # --
    # build thread string
    # --
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    $Param{ArticleStrg} = '';
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      if ($Article{ArticleType} ne 'email-notification-int' && 
          $Article{ArticleType} ne 'email-internal' && 
          $Article{ArticleType} ne 'note-internal') {
        if ($LastSenderType ne $Article{SenderType}) {
            $Counter .= "&nbsp;&nbsp;&nbsp;&nbsp;";
            $Space = "$Counter |-->";
        }
        $LastSenderType = $Article{SenderType};
        $ThreadStrg .= "$Space";
        # --
        # if this is the shown article -=> add <b>
        # --
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= ">><B>";
        }
        # --
        # the full part thread string
        # --
        $ThreadStrg .= "<A HREF=\"$BaseLink"."Action=CustomerZoom&ArticleID=$Article{ArticleID}\" ";
        $ThreadStrg .= 'onmouseover="window.status=\'$Text{"Zoom"}\'; return true;" onmouseout="window.status=\'\';">';
        $ThreadStrg .= "$Article{SenderType} ($Article{ArticleType})</A> ";
        $ThreadStrg .= " $Article{CreateTime}";
        $ThreadStrg .= "<BR>";
        # --
        # if this is the shown article -=> add </b>
        # --
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= "</B>";
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
    # --
    # check show article type
    # --
    if ($Article{ArticleType} eq 'email-notification-int' || 
          $Article{ArticleType} eq 'email-internal' || 
          $Article{ArticleType} eq 'note-internal') {
        my $Output .= $Self->{LayoutObject}->CustomerError(Message => 'No permission!');
        return $Output;
    }
    # --
    # get attacment string
    # --
    my $ATMsTmp = $Article{Atms};
    my @ATMs = ();
    @ATMs = @$ATMsTmp if ($ATMsTmp);
    my $ATMStrg = '';
    foreach (@ATMs) {
        my $FileName = $Self->LinkEncode($_) || '???';
        $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
          'ArticleID='.$Article{ArticleID}.'&File='.$FileName.'" target="attachment">'.$_.'</a><br> ';
    }
    # --
    # just body if html email
    # --
    if ($Param{"ShowHTMLeMail"}) {
        # generate output
        my $Output = "Content-Disposition: attachment; filename=";
        $Output .= $Self->{ConfigObject}->Get('TicketHook')."-$Param{TicketNumber}-";
        $Output .= "$Param{TicketID}-$Article{ArticleID}\n";
        $Output .= "Content-Type: $Article{MimeType}; charset=$Article{ContentCharset}\n";
        $Output .= "\n";
        $Output .= $Article{"Text"};
        return $Output;
    }

    # --
    # do some strips && quoting
    # --
    foreach (qw(To Cc From Subject FreeKey1 FreeKey2 FreeKey3 FreeValue1 FreeValue2 FreeValue3)) {
        $Param{"Article::$_"} = $Self->Ascii2Html(Text => $Article{$_}, Max => 200);
    }

    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->CheckMimeType(%Param, %Article)) {
        $Param{"Article::TextNote"} = $MimeTypeText;
        $Param{"Article::Text"} = '';
    }
    else {
        # --
        # html quoting
        # --
        $Param{"Article::Text"} = $Self->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Article{Text},
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesZoom') || 5000,
        );
        # --
        # link quoting
        # --
        $Param{"Article::Text"} = $Self->LinkQuote(Text => $Param{"Article::Text"});
        # --
        # do charset check
        # --
        if (my $CharsetText = $Self->CheckCharset(
            ContentCharset => $Article{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Article{ArticleID} )) {
            $Param{"Article::TextNote"} = $CharsetText;
        }
    }

    # get article id
    $Param{"Article::ArticleID"} = $Article{ArticleID};
    # select the output template
    return $Self->Output(TemplateFile => 'CustomerTicketZoom', Data => \%Param);
}
# --
sub CustomerMessage {
    my $Self = shift;
    my %Param = @_;

    # get output back
    return $Self->Output(TemplateFile => 'CustomerMessage', Data => \%Param);
}
# --
sub CustomerMessageNew {
    my $Self = shift;
    my %Param = @_;
    # build to string
    $Param{'ToStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{To},
        Name => 'NewQueueID',
    );
    # build priority string
    $Param{'PriorityStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultPriority') || '3 normal',
    );
    if ($Self->{ConfigObject}->Get('CustomerPriority')) {
        $Param{'PriorityString'} = '<tr><td>$Text{"Priority"}:</td><td>$Data{"PriorityStrg"}</td></tr>';
    }
    # get output back
    return $Self->Output(TemplateFile => 'CustomerMessageNew', Data => \%Param);
}
# --
sub CustomerPreferencesForm {
    my $Self = shift;
    my %Param = @_;

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
      foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
        if ($Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Data};
          my $Type = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}};
          if ($Data) { 
            $PrefItem{'Option'} = $Self->OptionStrgHashRef(
              Data => $Data, 
              Name => 'GenericTopic',
              SelectedID => $Self->{$PrefKey},
            );
          } 
          elsif ($PrefKey eq 'UserCharset') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'charset, charset',
                      Table => 'charset',
                      Valid => 1,
                    )
                  },
                  Name => 'GenericTopic',
                  Selected => $Self->{UserCharset} || $Self->{ConfigObject}->Get('DefaultCharset'),
              );
          }
          elsif ($PrefKey eq 'UserTheme') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'theme, theme',
                      Table => 'theme',
                      Valid => 1,
                    )
                  },
                  Name => 'GenericTopic',
                  Selected => $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme'),
              );
          }
          if ($Type eq 'Password' && $Self->{ConfigObject}->Get('AuthModule') =~ /ldap/i) {
              # do nothing if the auth module is ldap
          }
          else {
              $Param{$Pref} .= $Self->Output(
                TemplateFile => 'CustomerPreferences'.$Type,
                Data => \%PrefItem,
              );
          }
        }
      }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerPreferencesForm', Data => \%Param);
}
# --
sub CustomerWarning {
    my $Self = shift;
    my %Param = @_;

    # get backend error messages
    foreach (qw(Message Subroutine Line Version)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->Error($_) || '';
    }
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerWarning', Data => \%Param);
}
# --

1;
 
