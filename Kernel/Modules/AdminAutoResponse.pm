# --
# AdminAutoResponse.pm - provides AdminAutoResponse HTML
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminAutoResponse.pm,v 1.1 2001-12-26 20:03:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminAutoResponse;

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
    foreach ('ParamObject', 'DBObject', 'QueueObject', 'LayoutObject', 'ConfigObject', 'LogObject') {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction};
    $Param{NextScreen} = 'AdminAutoResponse';
    
    # permission check
    if (!$Self->{PermissionObject}->Section(
            UserID => $Self->{UserID},
            Section => 'Admin',
        )) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
    
    # get user data 2 form
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my $SQL = "SELECT name, valid_id, comment, text0, text1, " .
        " type_id, system_address_id, charset_id " .
        " FROM " .
        " auto_response " .
        " WHERE " .
        " id = $ID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminAutoResponseForm(
            ID => $ID,
            Name => $Data[0],
            Comment => $Data[2],
            Response => $Data[3],
            ValidID => $Data[1],
            Subject => $Data[4],
            TypeID => $Data[5],
            AddressID => $Data[6],
            CharsetID => $Data[7],
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = (
            'ID',
            'Name',
            'Comment',
            'ValidID',
            'Response',
            'Subject',
            'TypeID',
            'AddressID',
            'CharsetID',
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        my $SQL = "UPDATE auto_response SET " .
        " name = '$GetParam{Name}', " .
        " text0 = '$GetParam{Response}', " .
        " comment = '$GetParam{Comment}', " .
        " text1 = '$GetParam{Subject}', " .
        " type_id = $GetParam{TypeID}, " .
        " system_address_id = $GetParam{AddressID}, " .
        " charset_id = $GetParam{CharsetID}, " .
        " valid_id = $GetParam{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Self->{UserID} " .
        " WHERE " .
        " id = $GetParam{ID}";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Error(
                MSG => 'DB Error!!',
                REASON => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # add new user
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = (
            'ID',
            'Name',
            'Comment',
            'ValidID',
            'Response',
            'Subject',
            'TypeID',
            'AddressID',
            'CharsetID',
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my $SQL = "INSERT INTO auto_response " .
        " (name, " .
            " valid_id, " .
            " comment, " .
            " text0, " .
            " text1, " .
            " type_id, " .
            " system_address_id, " .
            " charset_id, " .
            " create_time, " .
            " create_by, " .
            " change_time, " .
            " change_by)" .
            " VALUES " .
            " ('$GetParam{Name}', " .
            " $GetParam{ValidID}, " .
            " '$GetParam{Comment}', " .
            " '$GetParam{Response}', " .
            " '$GetParam{Subject}', " .
            " $GetParam{TypeID}, " .
            " $GetParam{AddressID}, " .
            " $GetParam{CharsetID}, " .
            " current_timestamp, " .
            " $Self->{UserID}, " .
            " current_timestamp, " .
            " $Self->{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                MSG => 'DB Error!!',
                REASON => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminAutoResponseForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
