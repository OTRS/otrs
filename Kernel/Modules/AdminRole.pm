# --
# Kernel/Modules/AdminRole.pm - to add/update/delete roles
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminRole.pm,v 1.11.2.1 2007-11-07 09:41:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminRole;

use strict;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject GroupObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || $Self->{ParamObject}->GetParam( Param => 'RoleID' ) || '';
        my %Data = $Self->{GroupObject}->RoleGet(
            ID => $ID,
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => "Change",
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRoleForm',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my $Note = '';
        my %GetParam;
        foreach (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # update group
        if ($Self->{GroupObject}->RoleUpdate(%GetParam, UserID => $Self->{UserID})) {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify(Info => 'Role updated!');
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminRoleForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify(Priority => 'Error');
            $Self->_Edit(
                Action => "Change",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminRoleForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Add') {
        my %GetParam = ();
        foreach (qw(Name)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => "Add",
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRoleForm',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'AddAction') {
        my $Note = '';
        my %GetParam;
        foreach (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # add role
        if (my $RoleID = $Self->{GroupObject}->RoleAdd(%GetParam, UserID => $Self->{UserID})) {
            $Self->_Overview();
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify(Info => 'Role added!');
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminRoleForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify(Priority => 'Error');
            $Self->_Edit(
                Action => "Add",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminRoleForm',
                Data => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRoleForm',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _Edit {
    my $Self = shift;
    my %Param = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );
    return 1;
}

sub _Overview {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{GroupObject}->RoleList(
        ValidID => 0,
    );
    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    my $CssClass = '';
    foreach (sort {$List{$a} cmp $List{$b}}  keys %List) {
        # set output class
        if ($CssClass && $CssClass eq 'searchactive') {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }
        my %Data = $Self->{GroupObject}->RoleGet(
            ID => $_,
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid => $ValidList{$Data{ValidID}},
                CssClass => $CssClass,
                %Data,
            },
        );
    }
    return 1;
}

1;
