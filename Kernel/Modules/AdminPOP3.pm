# --
# Kernel/Modules/AdminPOP3.pm - to add/update/delete POP3 acounts
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPOP3.pm,v 1.11 2004-09-24 10:05:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPOP3;

use strict;
use Kernel::System::POP3Account;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
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

    $Self->{POP3Account} = Kernel::System::POP3Account->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminPOP3';
    my @Params = (qw(ID Login Password Host Comment ValidID QueueID Trusted DispatchingBy));
    # get data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my $Delete = $Self->{ParamObject}->GetParam(Param => 'Delete') || '';
        if ($Delete) {
            $Self->{POP3Account}->POP3AccountDelete(ID => $ID);
            return $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            my %Data = $Self->{POP3Account}->POP3AccountGet(ID => $ID);
            my %List = $Self->{POP3Account}->POP3AccountList(Valid => 0);
            $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'POP3 Account');
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
            $Output .= $Self->_Mask(%Data, POP3AccountList => \%List);
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if ($Self->{POP3Account}->POP3AccountUpdate(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Comment => 'Click back and check your selection!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
        return $Output;
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if ($Self->{POP3Account}->POP3AccountAdd(%GetParam, UserID => $Self->{UserID}) ) {
             return $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
            $Output .= $Self->{LayoutObject}->Error(
                Comment => 'Click back and check your selection!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
        return $Output;
    }
    # else ! print form
    else {
        my %List = $Self->{POP3Account}->POP3AccountList(Valid => 0);
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'POP3 Account');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
        $Output .= $Self->_Mask(POP3AccountList => \%List);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
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

    $Param{'TrustedOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Trusted',
        SelectedID => $Param{Trusted},
    );

    $Param{'DispatchingOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            From => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
    );

    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          ),
          '' => '-',
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{POP3AccountOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{POP3AccountList},
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminPOP3Form', Data => \%Param);
}
# --
1;
