# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentSpelling.pm,v 1.5 2003-03-09 15:09:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use Kernel::System::Spelling;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
            $Param{Body} =~ s/^$_ /$Words{$_} /g;
            $Param{Body} =~ s/ $_$/ $Words{$_}/g;
            $Param{Body} =~ s/(\s)$_(\s|:|;|<|>|\/|\|\.|\!|%|&|\?)/$1$Words{$_}$2/gs;
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
        my $Output = $Self->{LayoutObject}->Header(Title => 'Spell Checker');
        $Output .= $Self->{LayoutObject}->Error(
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # -- 
    # start with page ...
    # --
    $Output .= $Self->{LayoutObject}->Header(Title => 'Spell Checker');
    $Output .= $Self->{LayoutObject}->AgentSpelling(
        SpellCheck => \%SpellCheck,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
