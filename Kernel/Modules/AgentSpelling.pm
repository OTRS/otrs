# --
# Kernel/Modules/AgentSpelling.pm - spelling module
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentSpelling.pm,v 1.2 2003-01-03 16:17:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentSpelling;

use strict;
use Kernel::System::Spelling;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach (
      'TicketObject',
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
    ) {
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
    $Param{SpellLanguage} = $Self->{ParamObject}->GetParam(Param => 'SpellLanguage');
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
    my %SpellCheck = $Self->{SpellingObject}->Ckeck(
        Text => $Param{Body},
        SpellLanguage => $Param{SpellLanguage},
    );
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
