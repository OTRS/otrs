# --
# Kernel/Modules/AdminPostMasterFilter.pm - to add/update/delete filters
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPostMasterFilter.pm,v 1.8 2006-01-08 17:21:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPostMasterFilter;

use strict;
use Kernel::System::PostMaster::Filter;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{PostMasterFilter} = Kernel::System::PostMaster::Filter->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my %GetParam = ();
    my $Name = $Self->{ParamObject}->GetParam(Param => "Name") || '';
    my $OldName = $Self->{ParamObject}->GetParam(Param => "OldName") || '';
    foreach (1..8) {
        $GetParam{"MatchHeader$_"} = $Self->{ParamObject}->GetParam(Param => "MatchHeader$_");
        $GetParam{"MatchValue$_"} = $Self->{ParamObject}->GetParam(Param => "MatchValue$_");
        $GetParam{"SetHeader$_"} = $Self->{ParamObject}->GetParam(Param => "SetHeader$_");
        $GetParam{"SetValue$_"} = $Self->{ParamObject}->GetParam(Param => "SetValue$_");
    }
    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Delete') {
        if ($Self->{PostMasterFilter}->FilterDelete(Name => $Name)) {
            return $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
        }
        else {
           return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'AddAction') {
        if ($Self->{PostMasterFilter}->FilterAdd(
            Name => $Name,
            Match => { _TEST_ => '', },
            Set => { _TEST_ => '', })) {
            return $Self->{LayoutObject}->Redirect(
                OP => 'Action=$Env{"Action"}&Subaction=Update&Name='.$Name,
            );
        }
        else {
           return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Update') {
        my %Data = $Self->{PostMasterFilter}->FilterGet(Name => $Name);
        if (!%Data) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "No such filter: $Name");
        }
        else {
            return $Self->_MaskUpdate(Name => $Name, Data => \%Data);
        }
    }
    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'UpdateAction') {
        my %Match = ();
        my %Set = ();
        foreach (1..8) {
            if ($GetParam{"MatchHeader$_"} && $GetParam{"MatchValue$_"}) {
                $Match{$GetParam{"MatchHeader$_"}} = $GetParam{"MatchValue$_"};
            }
            if ($GetParam{"SetHeader$_"} && $GetParam{"SetValue$_"}) {
                $Set{$GetParam{"SetHeader$_"}} = $GetParam{"SetValue$_"};
            }
        }
        my %Invalid = ();
        if (%Match) {
            my $InvalidCount = 0;
            foreach (sort keys %Match) {
                $InvalidCount++;
                my $I = $Match{$_};
                if (!eval { $I =~ /(.|$Match{$_})/i }) {
                    $Invalid{'InvalidMatch'.$InvalidCount} = 'invalid';
                }
            }
        }
        if (!%Set) {
            $Invalid{'InvalidSet1'} = 'invalid';
        }
        if (!%Match) {
            $Invalid{'InvalidMatch1'} = 'invalid';
        }
        if (%Invalid) {
            return $Self->_MaskUpdate(
                Name => $Name,
                Data => {
                    %Invalid,
                    Name => $Name,
                    Set => \%Set,
                    Match => \%Match,
                },
            );
        }
        $Self->{PostMasterFilter}->FilterDelete(Name => $OldName);
        $Self->{PostMasterFilter}->FilterAdd(
            Name => $Name,
            Match => \%Match,
            Set => \%Set,
        );
        return $Self->{LayoutObject}->Redirect(OP => 'Action=$Env{"Action"}');
    }
    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my %List = $Self->{PostMasterFilter}->FilterList();

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => {
                %Param,
            },
        );
        foreach my $Key (sort keys %List) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Name => $Key,
                },
            );
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPostMasterFilter',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskUpdate {
    my $Self = shift;
    my %Param = @_;
    my %Data= %{$Param{Data}};
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
    $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
    );
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
            $Data{"MatchHeader$_"} = $Self->{LayoutObject}->OptionStrgHashRef(
               Data => \%Header,
               Name => "MatchHeader$_",
               SelectedID => $Data{"MatchHeader$_"},
               LanguageTranslation => 0,
               HTMLQuote => 1,
            );
            $Data{"SetHeader$_"} = $Self->{LayoutObject}->OptionStrgHashRef(
               Data => \%SetHeader,
               Name => "SetHeader$_",
               SelectedID => $Data{"SetHeader$_"},
               LanguageTranslation => 0,
               HTMLQuote => 1,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdate',
            Data => {
                %Param,
                %Data,
                OldName => $Data{Name},
            },
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPostMasterFilter',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
}

1;
