# --
# AdminResponse.pm - provides admin std response module
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminResponse.pm,v 1.2 2002-04-08 20:40:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminResponse;

use strict;

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
    foreach ('ParamObject', 'DBObject', 'LayoutObject', 'ConfigObject', 'LogObject') {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction} || ''; 
    $Param{UserID} = $Self->{UserID} || '';
    $Param{NextScreen} = 'AdminResponse';

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # get user data 2 form
    if ($Param{Subaction} eq 'Change') {
        $Param{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header(Title => 'Response change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my $SQL = "SELECT name, valid_id, comment, text " .
           " FROM " .
           " standard_response " .
           " WHERE " .
           " id = $Param{ID}";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminResponseForm(
                Name => $Data[0],
                Comment => $Data[2], 
                Response => $Data[3],
                ValidID => $Data[1],
                %Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Response');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        my $SQL = "UPDATE standard_response SET name = '$GetParam{Name}', text = '$GetParam{Response}', " .
          " comment = '$GetParam{Comment}', valid_id = $GetParam{ValidID}, " . 
          " change_time = current_timestamp, change_by = $Param{UserID} " .
          " WHERE id = $GetParam{ID}";

        if ($Self->{DBObject}->Do(SQL => $SQL)) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # add new user
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        $GetParam{Pw} = '';
        $GetParam{Pw} = crypt($GetParam{Pw}, $Param{UserID});
        my @Params = ('Name', 'Comment', 'ValidID', 'Response');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my $SQL = "INSERT INTO standard_response (name, valid_id, comment, text, ".
          " create_time, create_by, change_time, change_by)" .
          " VALUES " .
          " ('$GetParam{Name}', $GetParam{ValidID}, '$GetParam{Comment}', '$GetParam{Response}', " .
          " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {        
             $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Response add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminResponseForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

