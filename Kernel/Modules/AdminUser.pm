# --
# AdminUser.pm - to add/update/delete user
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUser.pm,v 1.2 2002-04-08 20:40:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUser;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    $Param{NextScreen} = 'AdminUser';
    
    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
    
    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header(Title => 'User ändern');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data
        my $SQL = "SELECT salutation, first_name, last_name, login, pw, language_id, " .
        " charset_id, theme_id, comment, valid_id, create_time, create_by, change_time, change_by" .
        " FROM " .
        " user " .
        " WHERE " .
        " id = $UserID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminUserForm(
            ID => $UserID,
            Salutation => $Data[0],
            Fristname => $Data[1],
            Lastname => $Data[2],
            Login => $Data[3],
            Pw => $Data[4],
            LanguageID => $Data[5],
            CharsetID => $Data[6],
            ThemeID => $Data[7],
            Comment => $Data[8],
            ValidID => $Data[9],
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID',
            'Salutation',
            'Login',
            'Fristname',
            'Lastname',
            'LanguageID',
            'ValidID',
            'CharsetID',
            'ThemeID', 
            'Comment',
            'Pw',
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        # get old pw
        my $GetPw = '';
        my $SQL = "SELECT pw FROM user WHERE id = $GetParam{ID}";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $GetPw = $RowTmp[0];
        }
        if ($GetPw ne $GetParam{Pw}) {
            $GetParam{Pw} = crypt($GetParam{Pw}, $GetParam{Login});
        }
        
        $SQL = "UPDATE user SET " .
        " salutation = '$GetParam{Salutation}', " .
        " first_name = '$GetParam{Fristname}'," .
        " last_name = '$GetParam{Lastname}', " .
        " login = '$GetParam{Login}', " .
        " pw = '$GetParam{Pw}', " .
        " language_id = $GetParam{LanguageID}, " .
        " charset_id = $GetParam{CharsetID}, " .
        " theme_id = $GetParam{ThemeID}, " .
        " comment = '$GetParam{Comment}', " .
        " valid_id = $GetParam{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Self->{UserID} " .
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
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = ('Salutation',
            'Login',
            'Fristname',
            'Lastname',
            'LanguageID',
            'ValidID',
            'ThemeID', 
            'CharsetID',
            'Comment',
            'Pw',
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        $GetParam{Pw} = crypt($GetParam{Pw}, $GetParam{Login});
        my $SQL = "INSERT INTO user " .
            "(salutation, " .
            " first_name, " .
            " last_name, " .
            " login, " .
            " pw, " .
            " language_id, " .
            " charset_id, " .
            " theme_id, " .
            " comment, " .
            " valid_id, create_time, create_by, change_time, change_by)" .
            " VALUES " .
            " ('$GetParam{Salutation}', " .
            " '$GetParam{Fristname}', " .
            " '$GetParam{Lastname}', " .
            " '$GetParam{Login}', " .
            " '$GetParam{Pw}', " .
            " $GetParam{LanguageID}, " .
            " $GetParam{CharsetID}, " .
            " $GetParam{ThemeID}, " .
            " '$GetParam{Comment}', " .
            " $GetParam{ValidID}, current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminUserForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
