# --
# Kernel/Modules/AdminState.pm - to add/update/delete system states
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminState.pm,v 1.16 2006-10-09 17:38:03 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminState;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # state object
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminState';
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my %Data = $Self->{StateObject}->StateGet(ID => $ID);
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'TypeID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        if ($Self->{StateObject}->StateUpdate(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new state
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'ValidID', 'TypeID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{StateObject}->StateAdd(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, name',
                Table => 'valid',
                Valid => 0,
            )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );
    $Param{StateOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, name, id',
                Valid => 0,
                Clamp => 1,
                Table => 'ticket_state',
            )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    $Param{StateTypeOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, name',
                Valid => 0,
                Table => 'ticket_state_type',
            )
        },
        Name => 'TypeID',
        SelectedID => $Param{TypeID},
    );
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminStateForm', Data => \%Param);
}

1;
