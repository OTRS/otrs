# --
# AdminCharset.pm - to add/update/delete system charsets
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCharset.pm,v 1.1 2002-05-05 12:59:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCharset;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
    ) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $NextScreen = 'AdminCharset';

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # get queue data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header(Title => 'System address change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my $SQL = "SELECT name, charset, comment, valid_id " .
           " FROM " .
           " charset " .
           " WHERE " .
           " id = $ID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminCharsetForm(
                ID => $ID,
                Name => $Data[0],
                Charset => $Data[1],
                Comment => $Data[2], 
                ValidID => $Data[3],
            );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Charset');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        my $SQL = "UPDATE charset SET name = '$GetParam{Name}', charset = '$GetParam{Charset}', " .
          " comment = '$GetParam{Comment}', valid_id = $GetParam{ValidID}, " . 
          " change_time = current_timestamp, change_by = $Self->{UserID} " .
          " WHERE id = $GetParam{ID}";
        if ($Self->{DBObject}->Do(SQL => $SQL)) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$NextScreen");
        }
        else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
          $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Name', 'Comment', 'ValidID', 'Charset');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my $SQL = "INSERT INTO charset (name, charset, valid_id, comment, " .
		" create_time, create_by, change_time, change_by)" .
		" VALUES " .
		" ('$GetParam{Name}', '$GetParam{Charset}', $GetParam{ValidID}, " .
		" '$GetParam{Comment}', " .
		" current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {        
             $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$NextScreen");
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
        $Output .= $Self->{LayoutObject}->Header(Title => 'System charset add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminCharsetForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

