# --
# Kernel/Modules/AdminSystemAddress.pm - to add/update/delete system addresses
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminSystemAddress.pm,v 1.18 2006-10-09 17:38:03 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSystemAddress;

use strict;
use Kernel::System::SystemAddress;

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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminSystemAddress';
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %Data = $Self->{SystemAddress}->SystemAddressGet(ID => $ID);
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(%Data);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Realname', 'QueueID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{SystemAddress}->SystemAddressUpdate(%GetParam, UserID => $Self->{UserID})) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'ValidID', 'Realname', 'QueueID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{SystemAddress}->SystemAddressAdd(%GetParam, UserID => $Self->{UserID}) ) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
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

    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, name',
                Table => 'queue',
                Valid => 1,
            )
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{SystemAddressOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, value1, value0',
                Valid => 0,
                Clamp => 1,
                Table => 'system_address',
            )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminSystemAddressForm', Data => \%Param);
}

1;
