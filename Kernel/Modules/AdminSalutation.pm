# --
# Kernel/Modules/AdminSalutation.pm - to add/update/delete salutations
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminSalutation.pm,v 1.19 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSalutation;

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

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
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
    $Param{NextScreen} = 'AdminSalutation';

    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # db quote
        $ID = $Self->{DBObject}->Quote($ID, 'Integer');

        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my $SQL = "SELECT name, valid_id, comments, text " .
           " FROM " .
           " salutation " .
           " WHERE " .
           " id = $ID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->_Mask(
            ID => $ID,
            Name => $Data[0],
            Comment => $Data[2],
            Salutation => $Data[3],
            ValidID => $Data[1],
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Salutation');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        foreach (qw(ID ValidID)) {
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}, 'Integer');
        }
        my $SQL = "UPDATE salutation SET name = '$GetParam{Name}', text = '$GetParam{Salutation}', " .
        " comments = '$GetParam{Comment}', valid_id = $GetParam{ValidID}, " .
  	" change_time = current_timestamp, change_by = $Self->{UserID} " .
	" WHERE id = $GetParam{ID}";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
        }
    }
    # add new user
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'ValidID', 'Salutation');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        foreach (qw(ID ValidID)) {
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}, 'Integer');
        }
        my $SQL = "INSERT INTO salutation (name, valid_id, comments, text, create_time, create_by, change_time, change_by)" .
		" VALUES " .
		" ('$GetParam{Name}', $GetParam{ValidID}, '$GetParam{Comment}', '$GetParam{Salutation}', " .
		" current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
             $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
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
    $Param{SalutationOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 0,
            Clamp => 0,
            Table => 'salutation',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminSalutationForm', Data => \%Param);
}
# --
1;

