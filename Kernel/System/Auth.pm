# --
# Auth.pm - provides the authentification and user data
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Auth.pm,v 1.4 2002-04-08 13:37:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth; 

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # check needed objects
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get user table
    $Self->{DatabaseUserTable} = $Self->{ConfigObject}->Get('DatabaseUserTable') 
      || 'user';

    return $Self;
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User} || return;
    my $Pw = $Param{Pw} || return;
    my $UserID = '';
    my $GetPw = '';
    my $SQL = "SELECT pw, id FROM $Self->{DatabaseUserTable} WHERE login = '$User'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) { 
        $GetPw = $RowTmp[0];
        $UserID = $RowTmp[1];
    }

    # --
    # just in case!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: '$User' tried to login with Pw: '$Pw' ($UserID/$GetPw)",
        );
    }

    # --
    # just a note 
    # --
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User without Pw!!!",
        );
        return;
    }
    # --
    # login note
    # --
    elsif ((($GetPw)&&($User)&&($UserID)) && crypt($Pw, $User) eq $GetPw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User logged in.",
        );
        return 1;
    }
    # --
    # just a note
    # --
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "User: $User with wrong Pw!!!"
        ); 
        return;
    }
}
# --
sub GetUserData {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User};
    my %Data;

    my $SQL = "SELECT su.id, su.salutation, su.first_name, su.last_name, sl.language, ".
        " su.language_id, sc.charset, su.charset_id, st.theme ,su.theme_id " .
        " FROM " .
        " $Self->{DatabaseUserTable} as su, language as sl, charset as sc, theme as st " .
        " WHERE " .
        " su.login = '$User'" .
        " AND " .
        " su.language_id = sl.id" .
        " AND " .
        " st.id = su.theme_id ".
        " AND " .
        " su.charset_id = sc.id";

    $Self->{DBObject}->Prepare(SQL => $SQL);

    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $RowTmp[0];
        $Data{UserLogin} = $User;
        $Data{UserFirstname} = $RowTmp[2];
        $Data{UserLastname} = $RowTmp[3];
        $Data{UserLanguage} = $RowTmp[4];
        $Data{UserLanguageID} = $RowTmp[5];
        $Data{UserCharset} = $RowTmp[6];
        $Data{UserCharsetID} = $RowTmp[7];
        $Data{UserTheme} = $RowTmp[8];
        $Data{UserThemeID} = $RowTmp[9];
    }

    if (! exists $Data{UserID}) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "Panic! No UserData for user: '$User'!!!",
        );
        return;    
    }

    return %Data;
}
# --

1;

