# --
# Kernel/Modules/AdminPostmasterFilter.pm - to add/update/delete filters 
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPostMasterFilter.pm,v 1.2 2004-05-11 09:01:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPostMasterFilter;

use strict;
use Kernel::System::PostMaster::Filter;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{PostMasterFilter} = Kernel::System::PostMaster::Filter->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminPOP3';
    my %Params = ();
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    $Params{"Name"} = $Self->{ParamObject}->GetParam(Param => "Name") || '';
    $Params{"OldName"} = $Self->{ParamObject}->GetParam(Param => "OldName") || '';
    $Params{"Delete"} = $Self->{ParamObject}->GetParam(Param => "Delete") || '';
    foreach (1..8) {
        $Params{"MatchHeader$_"} = $Self->{ParamObject}->GetParam(Param => "MatchHeader$_");
        $Params{"MatchValue$_"} = $Self->{ParamObject}->GetParam(Param => "MatchValue$_");
        $Params{"SetHeader$_"} = $Self->{ParamObject}->GetParam(Param => "SetHeader$_");
        $Params{"SetValue$_"} = $Self->{ParamObject}->GetParam(Param => "SetValue$_");
    }
    # get data 2 form
    if ($Params{"Delete"}) {
        $Self->{PostMasterFilter}->FilterDelete(Name => $ID);
        return $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
    }
    elsif ($Self->{Subaction} eq 'Change') {
        my %List = $Self->{PostMasterFilter}->FilterList();
        my %Data = $Self->{PostMasterFilter}->FilterGet(Name => $ID);
        my $Counter = 0;
        if ($Data{Match}) {
            foreach (sort keys %{$Data{Match}}) {
              if ($_ && $Data{Match}->{$_}) {
                $Counter++;
                $Data{"MatchValue$Counter"} = $Data{Match}->{$_};
                $Data{"MatchHeader$Counter"} = $_;
              }
            }
        }
        $Counter = 0;
        if ($Data{Set}) {
            foreach (sort keys %{$Data{Set}}) {
              if ($_ && $Data{Set}->{$_}) {
                $Counter++;
                $Data{"SetValue$Counter"} = $Data{Set}->{$_};
                $Data{"SetHeader$Counter"} = $_;
              }
            }
        }
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'PostMaster Filter');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->_Mask(%Data, List => \%List);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %Match = ();
        my %Set = ();
        foreach (1..8) {
            if ($Params{"MatchHeader$_"} && $Params{"MatchValue$_"}) {
                $Match{$Params{"MatchHeader$_"}} = $Params{"MatchValue$_"};
            }
            if ($Params{"SetHeader$_"} && $Params{"SetValue$_"}) {
                $Set{$Params{"SetHeader$_"}} = $Params{"SetValue$_"};
            }
        }
        if (%Match && %Set) {
            $Self->{PostMasterFilter}->FilterDelete(Name => $Params{OldName});
            $Self->{PostMasterFilter}->FilterAdd(
                Name => $Params{Name},
                Match => \%Match,
                Set => \%Set,
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
    }
    # else ! print form 
    else {
        my %List = $Self->{PostMasterFilter}->FilterList();
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'PostMaster Filter');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->_Mask(List => \%List);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # all headers
    my %Header = ();
    foreach (@{$Self->{ConfigObject}->Get('PostmasterX-Header')}) {
            $Header{$_} = $_;
    }
    $Header{''} = '-';
    $Header{'Body'} = 'Body';
    # otrs header
    my %SetHeader = ();
    foreach (keys %Header) {
        if ($_ =~ /^x-otrs/i) {
            $SetHeader{$_} = $_;
        } 
    }
    $SetHeader{''} = '-';
    # build strings
    foreach (1..6) {
        $Param{"MatchHeader$_"} = $Self->{LayoutObject}->OptionStrgHashRef(
           Data => \%Header,
           Name => "MatchHeader$_",
           SelectedID => $Param{"MatchHeader$_"},
           LanguageTranslation => 0,
           HTMLQuote => 1,
        );
        $Param{"SetHeader$_"} = $Self->{LayoutObject}->OptionStrgHashRef(
           Data => \%SetHeader,
           Name => "SetHeader$_",
           SelectedID => $Param{"SetHeader$_"},
           LanguageTranslation => 0,
           HTMLQuote => 1,
        );
    }

    $Param{List} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{List},
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminPostMasterFilter', Data => \%Param);
}
# --
1;
