# --
# Kernel/Output/HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Agent.pm,v 1.148 2004-09-16 22:03:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Agent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.148 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    $Param{Message} = 'No Permission!' if (!$Param{Message});

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
    my $ShownType = 1;
    if (ref($Param{Data}) ne 'HASH') {
        $Self->FatalError(Message => 'Need Hash ref in Data param');
    }
    elsif (ref($Param{Data}) eq 'HASH' && !%{$Param{Data}}) {
        return '$Text{"none"}';
    }
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Param{Type} && $Param{Type} eq 'Lite') {
        $ShownType = 2;
        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        foreach my $Field (@{$Map}) {
            if ($Field->[3] == 2) {
                $Used = 1;
            }
        }
        if (!$Used) {
            $ShownType = 1;
        }
    }
    # build html table
    foreach my $Field (@{$Map}) {
        if ($Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{$Field->[0]}) {
            my %Record = ();
            if ($Field->[6]) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\">";
                $Record{LinkStop} = "</a>";
            }
            if ($Field->[0]) {
                $Record{ValueShort} = $Self->Ascii2Html(Text => $Param{Data}->{$Field->[0]}, Max => $Param{Max});
            }
            $Self->Block(
                    Name => 'Row',
                    Data => {
                        Key => $Field->[1],
                        Value => $Param{Data}->{$Field->[0]},
                        %Record,
                    },
            );
        }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerTableView', Data => \%Param);
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
    my %SelectData = ();
    my %Ticket = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Ticket}) {
        %Ticket = %{$Param{Ticket}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach (1..10) {
        # key
        if (ref($Config{"TicketFreeKey$_"}) eq 'HASH' && %{$Config{"TicketFreeKey$_"}}) {
            my $Counter = 0;
            my $LastKey = '';
            foreach (keys %{$Config{"TicketFreeKey$_"}}) {
                $Counter++;
                $LastKey = $_;
            }
            if ($Counter > 1 || $Param{NullOption}) {
                $Data{"TicketFreeKeyField$_"} = $Self->OptionStrgHashRef(
                    Data => {
                        %NullOption,
                        %{$Config{"TicketFreeKey$_"}},
                    },
                    Name => "TicketFreeKey$_",
                    SelectedID => $Ticket{"TicketFreeKey$_"},
                    SelectedIDRefArray => $Ticket{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                    HTMLQuote => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey}.
                      '<input type="hidden" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $LastKey).'">';
                }
            }
        }
        else {
            if (defined($Ticket{"TicketFreeKey$_"})) {
                if (ref($Ticket{"TicketFreeKey$_"}) eq 'ARRAY') {
                    if ($Ticket{"TicketFreeKey$_"}->[0]) {
                        $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
                    }
                    else {
                       $Ticket{"TicketFreeKey$_"} = '';
                    }
                }
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Ticket{"TicketFreeKey$_"}).'" size="20">';
            }
            else {
                $Data{"TicketFreeKeyField$_"} = '<input type="text" name="TicketFreeKey'.$_.'" value="" size="20">';
            }
        }
        # value
        if (ref($Config{"TicketFreeText$_"}) eq 'HASH') {
            $Data{"TicketFreeTextField$_"} = $Self->OptionStrgHashRef(
                Data => {
                    %NullOption,
                    %{$Config{"TicketFreeText$_"}},
                },
                Name => "TicketFreeText$_",
                SelectedID => $Ticket{"TicketFreeText$_"},
                SelectedIDRefArray => $Ticket{"TicketFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote => 1,
                %SelectData,
            );
        }
        else {
            if (defined($Ticket{"TicketFreeText$_"})) {
                if (ref($Ticket{"TicketFreeText$_"}) eq 'ARRAY') {
                    if ($Ticket{"TicketFreeText$_"}->[0]) {
                        $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeText$_"} = '';
                    }
                }
                $Data{"TicketFreeTextField$_"} = '<input type="text" name="TicketFreeText'.$_.'" value="'.$Self->{LayoutObject}->Ascii2Html(Text => $Ticket{"TicketFreeText$_"}).'" size="30">';
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
