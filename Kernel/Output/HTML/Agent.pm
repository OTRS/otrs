# --
# Kernel/Output/HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Agent.pm,v 1.140 2004-04-01 09:22:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Agent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.140 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub NavigationBar {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # run notification modules 
    if (ref($Self->{ConfigObject}->Get('Frontend::NotifyModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('Frontend::NotifyModule')};
        foreach my $Job (sort keys %Jobs) {
            # log try of load module
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Try to load module: $Jobs{$Job}->{Module}!",
                );
            }
            if (eval "require $Jobs{$Job}->{Module}") {
                my $Object = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    LayoutObject => $Self, 
                    UserID => $Self->{UserID},
                    Debug => $Self->{Debug},
                );
                # log loaded module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Module: $Jobs{$Job}->{Module} loaded!",
                    );
                }
                # run module 
                $Output .= $Object->Run(%Param, Config => $Jobs{$Job});
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't load module $Jobs{$Job}->{Module}!",
                );
            }
        }
    }
    # check lock count
    foreach (keys %{$Param{LockData}}) {
        $Param{$_} = $Param{LockData}->{$_} || 0; 
    }
    if ($Param{New}) {
        $Output .= $Self->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AgentMailbox&Subaction=New">'.
            $Self->{LanguageObject}->Get('You have %s new message(s)!", "'.$Param{New}).'</a>'
        );
    }
    if ($Param{Reminder}) {
        $Output .= $Self->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AgentMailbox&Subaction=Reminder">'.
           $Self->{LanguageObject}->Get('You have %s reminder ticket(s)!", "'.
           $Param{Reminder}).'</a>',
        );
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentNavigationBar', Data => \%Param).$Output;
}
# --
sub TicketStdResponseString {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(StdResponsesRef TicketID ArticleID)) {
        if (!$Param{$_}) {
            return "Need $_ in TicketStdResponseString()";
        } 
    }
    # get StdResponsesStrg
    if ($Self->{ConfigObject}->Get('StdResponsesMethod') eq 'Form') {
        # build html string
        $Param{StdResponsesStrg} .= '<form action="'.$Self->{CGIHandle}.'" method="post">'.
          '<input type="hidden" name="Action" value="AgentCompose">'.
          '<input type="hidden" name="ArticleID" value="'.$Param{ArticleID}.'">'.
          '<input type="hidden" name="TicketID" value="'.$Param{TicketID}.'">'.
          $Self->OptionStrgHashRef(
            Name => 'ResponseID',
            Data => $Param{StdResponsesRef},
          ).
          '<input class="button" type="submit" value="$Text{"Compose"}"></form>';
    }
    else {
        my %StdResponses = %{$Param{StdResponsesRef}};
        foreach (sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses) {
          # build html string
          $Param{StdResponsesStrg} .= "\n<li><a href=\"$Self->{Baselink}"."Action=AgentCompose&".
           "ResponseID=$_&TicketID=$Param{TicketID}&ArticleID=$Param{ArticleID}\" ".
           'onmouseover="window.status=\'$Text{"Compose"}\'; return true;" '.
           'onmouseout="window.status=\'\';">'.
           # html quote
           $Self->Ascii2Html(Text => $StdResponses{$_})."</A></li>\n";
        }
    }
    return $Param{StdResponsesStrg};
}
# --
sub TicketEscalation {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Message} = 'Please go away!' if (!$Param{Message});

    # create output
    $Output .= $Self->Output(TemplateFile => 'TicketEscalation', Data => \%Param);

    # return output
    return $Output;
}
# --
sub AgentCustomerView {
    my $Self = shift;
    my %Param = @_;
    $Param{Table} = $Self->AgentCustomerViewTable(%Param);
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerView', Data => \%Param);
}
# --
sub AgentCustomerViewTable {
    my $Self = shift;
    my %Param = @_;
    if (ref($Param{Data}) eq 'HASH' && %{$Param{Data}}) {
        my $Map = $Param{Data}->{Config}->{Map};
        # build html table
        $Param{Table} = '<table>';
        foreach my $Field (@{$Map}) {
            if ($Field->[3] && $Param{Data}->{$Field->[0]}) {
                $Param{Table} .= "<tr><td><b>\$Text{\"$Field->[1]\"}:</b></td><td>";
                if ($Field->[6]) {
                    $Param{Table} .= "<a href=\"$Field->[6]\">";
                }
                $Param{Table} .= '<div title="'.$Self->Ascii2Html(Text => $Param{Data}->{$Field->[0]}).'">'.$Self->Ascii2Html(Text => $Param{Data}->{$Field->[0]}, Max => $Param{Max}).'</div>';
                if ($Field->[6]) {
                    $Param{Table} .= "</a>";
                }
                $Param{Table} .= "</td></tr>";
            }
        }
        $Param{Table} .= '</table>';
    }
    else {
        $Param{Table} = '$Text{"none"}';
    }
    # create & return output
    return $Param{Table}; 
}
# --
sub AgentUtilSearchResult {
    my $Self = shift;
    my %Param = @_;
    my $Highlight = $Param{Highlight} || 0;
    my $HighlightStart = '<font color="orange"><b><i>';
    my $HighlightEnd = '</i></b></font>';

    $Self->{UtilSearchResultCounter}++;
    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->CheckMimeType(
        %Param, 
        Action => 'AgentZoom',
    )) {
        $Param{TextNote} = $MimeTypeText;
        $Param{Body} = '';
    }
    else {
        # charset convert
        $Param{Body} = $Self->{LanguageObject}->CharsetConvert(
            Text => $Param{Body},
            From => $Param{ContentCharset},
        );
        # do some strips
        $Param{Body} =~ s/^\s*\n//mg;
        # do some text quoting
        $Param{Body} = $Self->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Param{Body},
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesBySearch') || 15,
            HTMLResultMode => 1,
        );
        # --
        # do charset check
        # --
        if (my $CharsetText = $Self->CheckCharset(
            Action => 'AgentZoom',
            ContentCharset => $Param{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Param{ArticleID} )) {
            $Param{TextNote} = $CharsetText;
        }
    }

    # do some html quoting
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    foreach (qw(Priority State Queue Owner Lock CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    foreach (qw(From To Cc Subject)) {
#        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 150) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    $Param{Created} = $Self->{LanguageObject}->FormatTimeString($Param{Created});
    # do some html highlighting
    if ($Highlight && $Param{What}) {
        my @SParts = split('%', $Param{What});
        foreach (qw(Body From To Subject)) {
            if ($_) {
                $Param{$_} =~ s/(${\(join('|', @SParts))})/$HighlightStart$1$HighlightEnd/gi;
            }
        } 
    }
    # customer info string 
    $Param{CustomerTable} = $Self->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoQueueMaxSize'),
    );
    # create & return output
    return $Self->Output(TemplateFile => 'AgentUtilSearchResult', Data => \%Param);
}
# --
sub AgentPreferencesForm {
    my $Self = shift;
    my %Param = @_;

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('PreferencesView')}) { 
      foreach my $Group (@{$Self->{ConfigObject}->Get('PreferencesView')->{$Pref}}) {
        if ($Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Data};
          my $DataSelected = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{DataSelected} || '';
          my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{PreferencesGroups}->{$Group}};
          if ($Data) {
            if (ref($Data) eq 'HASH') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                Data => $Data, 
                Name => 'GenericTopic',
                SelectedID => $Self->{$PrefKey} || $DataSelected, 
              );
            }
            else {
                $PrefItem{'Option'} = '<input type="text" name="GenericTopic" value="'.
                     $Self->Ascii2Html(Text => $Self->{$PrefKey}) .'">';
            }
          } 
          elsif ($Type eq 'CustomQueue') {
            # prepar custom selection
            $PrefItem{'Option'} = $Self->AgentQueueListOption(
                Data => $Param{QueueData},
                Size => 12,
                Name => 'QueueID',
                SelectedIDRefArray => $Param{CustomQueueIDs},
                Multiple => 1,
                OnChangeSubmit => 0,
            );
          }
          elsif ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
                  Name => "GenericTopic",
                  SelectedID => $Self->{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage'),
                  HTMLQuote => 0,
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
          if ($Type eq 'Password' && ($Self->{ConfigObject}->Get('AuthModule') =~ /ldap/i ||
               $Self->{ConfigObject}->Get('DemoSystem'))) {
              # do nothing if the auth module is ldap
          }
          else {
              $Param{$Pref} .= $Self->Output(
                TemplateFile => 'AgentPreferences'.$Type, 
                Data => \%PrefItem, 
              );
          }
        }
      }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentPreferencesForm', Data => \%Param);
}
# --
sub TicketLocked {
    my $Self = shift;
    my %Param = @_;
    return $Self->Output(TemplateFile => 'AgentTicketLocked', Data => \%Param);
}
# --
sub AgentStatusView {
    my $Self = shift;
    my %Param = @_;
    if ($Param{AllHits} == 1 || $Param{AllHits} == 0) {
               $Param{Result} = $Param{AllHits};
    }
    elsif ($Param{AllHits} >= ($Param{StartHit}+$Param{PageShown})) {
        $Param{Result} = $Param{StartHit}."-".($Param{StartHit}+$Param{PageShown}-1);
    }
    else {
        $Param{Result} = "$Param{StartHit}-$Param{AllHits}";
    }
    my $Pages = int(($Param{AllHits} / $Param{PageShown}) + 0.99999);
    my $Page = int(($Param{StartHit} / $Param{PageShown}) + 0.99999);
    for (my $i = 1; $i <= $Pages; $i++) {
        $Param{PageNavBar} .= " <a href=\"$Self->{Baselink}Action=\$Env{\"Action\"}".
         "&StartHit=". (($i-1)*$Param{PageShown}+1) .= '&SortBy=$Data{"SortBy"}&'.
         'Order=$Data{"Order"}&Type=$Data{"Type"}">';
        if ($Page == $i) {
            $Param{PageNavBar} .= '<b>'.($i).'</b>';
        }
        else {
            $Param{PageNavBar} .= ($i);
        }
        $Param{PageNavBar} .= '</a> ';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentStatusView', Data => \%Param);
}
# --  
sub AgentStatusViewTable {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ') || 0;
    foreach (qw(State Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    # do html quoteing
    foreach (qw(State Queue Owner Lock CustomerID UserFirstname UserLastname CustomerName)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 10) || '';
    }
    $Param{CustomerName} = '('.$Param{CustomerName}.')' if ($Param{CustomerName});
    foreach (qw(From To Cc Subject)) {
        $Param{$_} = $Self->{LanguageObject}->CharsetConvert(
            Text => $Param{$_},
            From => $Param{ContentCharset},
        );
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 30) || '';
    }
    # create & return output
    if (!$Param{Answered}) {
        return $Self->Output(TemplateFile => 'AgentStatusViewTableNotAnswerd', Data => \%Param);
    }
    else {
        return $Self->Output(TemplateFile => 'AgentStatusViewTable', Data => \%Param);
    }
}
# --
sub AgentQueueListOption {
    my $Self = shift;
    my %Param = @_;
    my $Size = defined($Param{Size}) ? "size='$Param{Size}'" : ''; 
    my $MaxLevel = defined($Param{MaxLevel}) ? $Param{MaxLevel} : 10;
    my $SelectedID = defined($Param{SelectedID}) ? $Param{SelectedID} : '';
    my $Selected = defined($Param{Selected}) ? $Param{Selected} : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined($Param{OnChangeSubmit}) ? $Param{OnChangeSubmit} : 
     $Self->{ConfigObject}->Get('OnChangeSubmit');
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    if ($Param{OnChange}) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ($Self->{ConfigObject}->Get('QueueListType') eq 'list') {
        $Param{'MoveQueuesStrg'} = $Self->OptionStrgHashRef(
            %Param,
            HTMLQuote => 0,
#            OnChangeSubmit => 1,
        );
        return $Param{MoveQueuesStrg};
    }
    # build tree list
    $Param{MoveQueuesStrg} = '<select name="'.$Param{Name}."\" $Size $Multiple $OnChangeSubmit>";
    my %UsedData = ();
    my %Data = ();
    if ($Param{Data}) {
        %Data = %{$Param{Data}};
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }
    # add suffix for correct sorting
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        $Data{$_} .= '::';
    }
    # build selection string
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
      my @Queue = split(/::/, $Param{Data}->{$_});
      $UsedData{$Param{Data}->{$_}} = 1;
      my $UpQueue = $Param{Data}->{$_};
      $UpQueue =~ s/^(.*)::.+?$/$1/g;
      if (! $Queue[$MaxLevel]) {
        $Queue[$#Queue] = $Self->Ascii2Html(Text => $Queue[$#Queue], Max => 50-$#Queue);
        my $Space = '';
        for (my $i = 0; $i < $#Queue; $i++) {
            $Space .= '&nbsp;&nbsp;';
        }
        # check if SelectedIDRefArray exists
        if ($SelectedIDRefArray) {
            foreach my $ID (@{$SelectedIDRefArray}) {
                if ($ID eq $_) {
                    $Param{SelectedIDRefArrayOK}->{$_} = 1;
                }
            }
        }
        # build select string
        if ($UsedData{$UpQueue}) {
          if ($SelectedID eq $_ || $Selected eq $Param{Data}->{$_} || $Param{SelectedIDRefArrayOK}->{$_}) {
            $Param{MoveQueuesStrg} .= '<option selected value="'.$_.'">'.
                $Space.$Queue[$#Queue].'</option>';
          }
          else {
            $Param{MoveQueuesStrg} .= '<option value="'.$_.'">'.
                $Space.$Queue[$#Queue].'</option>';
          }
        }
      }
    }
    $Param{MoveQueuesStrg} .= '</select>';

    return $Param{MoveQueuesStrg};
}
# --
sub AgentCustomerMessage {
    my $Self = shift;
    my %Param = @_;
    # get output back
    my $Output .= $Self->Notify(
        Info => 
          $Self->{LanguageObject}->Get('You are the customer user of this message - customer modus!'), 
    );
    return $Output.$Self->Output(TemplateFile => 'AgentCustomerMessage', Data => \%Param);
}   
# --
sub AgentFreeText {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    $NullOption{''} = '-' if ($Param{NullOption});
    my %Data = ();
    foreach (1..20) {
        # key
        if (ref($Self->{ConfigObject}->Get("TicketFreeKey$_")) eq 'HASH' && %{$Self->{ConfigObject}->Get("TicketFreeKey$_")}) {
            my $Counter = 0;
            my $LastKey = '';
            foreach (keys %{$Self->{ConfigObject}->Get("TicketFreeKey$_")}) {
                $Counter++;
                $LastKey = $_;
            }
            if ($Counter > 1 || %NullOption) { 
                $Data{"TicketFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => { 
                        %NullOption, 
                        %{$Self->{ConfigObject}->Get("TicketFreeKey$_")},
                    },
                    Name => "TicketFreeKey$_",
                    SelectedID => $Param{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Self->{ConfigObject}->Get("TicketFreeKey$_")->{$LastKey}.
                      '<input type="hidden" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $LastKey).'">';
                }
            }
        }
        else {
            if (defined($Param{"TicketFreeKey$_"})) {
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Param{"TicketFreeKey$_"}).'" size="20">';
            }
            else {
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="" size="20">';
            }
        }
        # value
        if (ref($Self->{ConfigObject}->Get("TicketFreeText$_")) eq 'HASH') {
            $Data{"TicketFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => { 
                    %NullOption, 
                    %{$Self->{ConfigObject}->Get("TicketFreeText$_")},
                },
                Name => "TicketFreeText$_",
                SelectedID => $Param{"TicketFreeText$_"},
                LanguageTranslation => 0,
            );
        }
        else {
            if (defined($Param{"TicketFreeText$_"})) {
                $Data{"TicketFreeTextField$_"} = '<input type="text" name="TicketFreeText'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Param{"TicketFreeText$_"}).'" size="30">';
            }
            else {
                $Data{"TicketFreeTextField$_"} = '<input type="text" name="TicketFreeText'.$_.'" value="" size="30">';
            }
        }
    }
    return %Data;
}
# --

1;
