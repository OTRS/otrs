# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentSpelling.pm,v 1.18 2007-01-20 18:50:39 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use Kernel::System::Spelling;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{SpellingObject} = Kernel::System::Spelling->new(%Param);

    # get params
    foreach (qw(Body)) {
        my $Value = $Self->{ParamObject}->GetParam(Param => $_);
        $Self->{$_} = defined $Value ? $Value : '';
    }
    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    $Param{Body} = $Self->{ParamObject}->GetParam(Param => 'Body');
    $Param{Field} = $Self->{ParamObject}->GetParam(Param => 'Field') || 'Body';
    $Param{SpellLanguage} = $Self->{ParamObject}->GetParam(Param => 'SpellLanguage') ||
        $Self->{UserSpellDict} || $Self->{ConfigObject}->Get('SpellCheckerDictDefault');
    # get and replace all wrong words
    my %Words = ();
    foreach (0..300) {
        my $Replace = $Self->{ParamObject}->GetParam(Param => "SpellCheck::Replace::$_");
        if ($Replace) {
            my $Old = $Self->{ParamObject}->GetParam(Param => "SpellCheckOld::$_");
            my $New = $Self->{ParamObject}->GetParam(Param => "SpellCheckOrReplace::$_") ||
                $Self->{ParamObject}->GetParam(Param => "SpellCheckOption::$_");
            if ($Old && $New) {
                $Param{Body} =~ s/^$Old$/$New/g;
                $Param{Body} =~ s/^$Old( |\n|\r|\s)/$New$1/g;
                $Param{Body} =~ s/ $Old$/ $New/g;
                $Param{Body} =~ s/(\s)$Old(\n|\r)/$1$New$2/g;
                $Param{Body} =~ s/(\s)$Old(\s|:|;|<|>|\/|\\|\.|\!|%|&|\?)/$1$New$2/gs;
                $Param{Body} =~ s/(\W)$Old(\W)/$1$New$2/g;
            }
        }
    }
    # do spell check
    my %SpellCheck = $Self->{SpellingObject}->Check(
        Text => $Param{Body},
        SpellLanguage => $Param{SpellLanguage},
    );
    # check error
    if ($Self->{SpellingObject}->Error()) {
        return $Self->{LayoutObject}->ErrorScreen();
    }
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(Type => 'Small');
    $Output .= $Self->_Mask(
        SpellCheck => \%SpellCheck,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer(Type => 'Small');
    return $Output;
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # do html quoteing
    foreach (qw(Body)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_});
    }
    # spellcheck
    if ($Param{SpellCheck}) {
        $Param{SpellCounter} = 0;
        foreach (sort {$a <=> $b} keys %{$Param{SpellCheck}}) {
            if ($Param{SpellCheck}->{$_}->{Word} && $Param{SpellCounter} <= 300) {
                $Param{SpellCounter}++;
                my %ReplaceWords = ();
                if ($Param{SpellCheck}->{$_}->{Replace}) {
                    foreach my $ReplaceWord (@{$Param{SpellCheck}->{$_}->{Replace}}) {
                        $ReplaceWords{$ReplaceWord} = $ReplaceWord;
                    }
                }
                else {
                    $ReplaceWords{''} = 'No suggestions';
                }
                $Param{SpellCheckString} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => \%ReplaceWords,
                    Name => "SpellCheckOption::$Param{SpellCounter}",
                    OnChange => "change_selected($Param{SpellCounter})"
                );
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        %{$Param{SpellCheck}->{$_}},
                        OptionList => $Param{SpellCheckString},
                        Count => $Param{SpellCounter},
                    },
                );
            }
        }
    }
    # dict language selection
    $Param{SpellLanguageString} .= $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('PreferencesGroups')->{SpellDict}->{Data},
        Name => "SpellLanguage",
        SelectedID => $Param{SpellLanguage},
    );
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentSpelling', Data => \%Param);
}

1;