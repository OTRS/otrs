# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentSpelling.pm,v 1.9 2004-01-08 22:09:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use Kernel::System::Spelling;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject 
      ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{SpellingObject} = Kernel::System::Spelling->new(%Param);
    # --
    # get params
    # --
    foreach (qw(Body)) {
        my $Value = $Self->{ParamObject}->GetParam(Param => $_);
        $Self->{$_} = defined $Value ? $Value : '';
    }
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    
    $Param{Body} = $Self->{ParamObject}->GetParam(Param => 'Body');
    $Param{SpellLanguage} = $Self->{ParamObject}->GetParam(Param => 'SpellLanguage') ||
        $Self->{UserSpellDict} || $Self->{ConfigObject}->Get('SpellCheckerDictDefault');
    # --
    # get all wrong words
    # --
    my %Words = ();
    foreach ($Self->{ParamObject}->GetArray(Param => 'SpellCheckReplace')) { 
        my ($Word, $Value) = split(/::/, $_);
        my $OrWord = $Self->{ParamObject}->GetParam(Param => "SpellCheckOrReplace::$Word") || '';
        if ($OrWord) { 
            $Value = $OrWord;
        }
        $Words{$Word} = $Value;
    }
    # --
    # replace all wrong words
    # --
    foreach (keys %Words) {
        if ($Words{$_} && $Self->{ParamObject}->GetParam(Param => "SpellCheck::$_") eq "Replace") {
            $Param{Body} =~ s/^$_$/$Words{$_}/g;
            $Param{Body} =~ s/^$_( |\n|\r|\s)/$Words{$_}$1/g;
            $Param{Body} =~ s/ $_$/ $Words{$_}/g;
            $Param{Body} =~ s/(\s)$_(\n|\r)/$1$Words{$_}$2/g;
            $Param{Body} =~ s/(\s)$_(\s|:|;|<|>|\/|\\|\.|\!|%|&|\?)/$1$Words{$_}$2/gs;
        }
    }
    # --
    # do spell check
    # --
    my %SpellCheck = $Self->{SpellingObject}->Check(
        Text => $Param{Body},
        SpellLanguage => $Param{SpellLanguage},
    );
    # --
    # check error
    # --
    if ($Self->{SpellingObject}->Error()) {
        my $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Spell Checker');
        $Output .= $Self->{LayoutObject}->Error(
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # -- 
    # start with page ...
    # --
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Spell Checker');
    $Output .= $Self->_Mask(
        SpellCheck => \%SpellCheck,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # do html quoteing
    foreach (qw(Body)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_});
    }
    # spellcheck
    if ($Param{SpellCheck}) {
      $Param{SpellCheckString} = '<table border="0" width="580" cellspacing="0" cellpadding="1">'.
        '<tr><th width="50">$Text{"Line"}</th><th width="100">$Text{"Word"}</th>'.
        '<th width="330"colspan="2">$Text{"replace with"}</th>'.
        '<th width="50">$Text{"Change"}</th><th width="50">$Text{"Ignore"}</th></tr>';
      $Param{SpellCounter} = 0;
      foreach (sort {$a <=> $b} keys %{$Param{SpellCheck}}) {
        my $WrongWord = $Param{SpellCheck}->{$_}->{Word};
        if ($WrongWord) {
          $Param{SpellCounter} ++;
          if ($Param{SpellCounter} <= 300) {
            $Param{SpellCheckString} .= "<tr><td align='center'>$Param{SpellCheck}->{$_}->{Line}</td><td><font color='red'>$WrongWord</font></td><td>";
            my %ReplaceWords = ();
            if ($Param{SpellCheck}->{$_}->{Replace}) {
              foreach my $ReplaceWord (@{$Param{SpellCheck}->{$_}->{Replace}}) {
                $ReplaceWords{$WrongWord."::".$ReplaceWord} = $ReplaceWord;
              }
            }
            else {
                $ReplaceWords{$WrongWord.'::0'} = 'No suggestions';
            }
            $Param{SpellCheckString}  .= $Self->{LayoutObject}->OptionStrgHashRef(
               Data => \%ReplaceWords,
               Name => "SpellCheckReplace",
               OnChange => "change_selected($Param{SpellCounter})"
            ).
              '</td><td> or '.
              '<input type="text" name="SpellCheckOrReplace::'.$WrongWord.'" value="" size="16" onchange="change_selected('.$Param{SpellCounter}.')">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Replace">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Ignore" checked="checked">'.
              '</td></tr>'."\n";
          }
        }
      }
      $Param{SpellCheckString} .= '</table>';
      if ($Param{SpellCounter} == 0) {
        $Param{SpellCheckString} = '';
      }
    }
    # dict language selection
    $Param{SpellLanguageString}  .= $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('PreferencesGroups')->{SpellDict}->{Data},
        Name => "SpellLanguage",
        SelectedID => $Param{SpellLanguage},
    );
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentSpelling', Data => \%Param);
}
# --
1;
