# --
# Kernel/Modules/AdminGroup.pm - to add/update/delete groups
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminGroup.pm,v 1.19 2005-11-11 16:00:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminGroup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # allocate new hash for objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{NextScreen} = 'AdminGroup';
    my %Groups = $Self->{GroupObject}->GroupList(Valid => 0);
    # get group data
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %GroupData = $Self->{GroupObject}->GroupGet(ID => $ID);
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            %GroupData,
            GroupList => \%Groups
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if ($Self->{GroupObject}->GroupUpdate(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add group
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'ValidID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        if (my $Id = $Self->{GroupObject}->GroupAdd(%GetParam, UserID => $Self->{UserID})) {
            # redirect
            if (!$Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup} &&
                $Self->{ConfigObject}->Get('Frontend::Module')->{AdminRoleGroup}) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminRoleGroup&Subaction=Group&ID=$Id",
                );
            }
            if ($Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup}) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminUserGroup&Subaction=Group&ID=$Id",
                );
            }
            else {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminGroup",
                );
            }
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(GroupList => \%Groups);
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

    $Param{GroupOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{GroupList},
        Size => 15,
        Name => 'ID',
        LanguageTranslation => 0,
        SelectedID => $Param{ID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminGroupForm', Data => \%Param);
}
# --
1;
