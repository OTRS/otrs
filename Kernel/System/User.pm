# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.27 2003-01-14 20:00:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;
use Kernel::System::CheckItem;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.27 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # --
    # check needed objects
    # --
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # get user table
    # --
    $Self->{UserTable} = $Self->{ConfigObject}->Get('DatabaseUserTable')
      || 'user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID')
      || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW')
      || 'pw';
    $Self->{UserTableUser} = $Self->{ConfigObject}->Get('DatabaseUserTableUser')
      || 'login';
    # --
    # load generator customer preferences module
    # --
    my $GeneratorModule = $Self->{ConfigObject}->Get('User::PreferencesModule')
      || 'Kernel::System::User::Preferences::DB';
    eval "require $GeneratorModule";
    $Self->{PreferencesObject} = $GeneratorModule->new(%Param);

    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);

    return $Self;
}
# --
sub GetGroups {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    my %Groups = ();

    my $SQL = "SELECT g.id, g.name " .
    " FROM " .
    " groups g, group_user gu".
    " WHERE " .
    " g.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
    " AND ".
    " gu.user_id = $Param{UserID}".
    " AND " .
    " g.id = gu.group_id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
         $Groups{$RowTmp[0]} = $RowTmp[1];
    }

    return %Groups;
} 
# --
sub GetUserData {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User};
    my $UserID = $Param{UserID};
    my %Data;
    # --
    # get inital data
    # --
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, ".
        " salutation, first_name, last_name, $Self->{UserTableUserPW}, valid_id ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE ";
    if ($User) {
        $SQL .= " $Self->{UserTableUser} = '$User'";
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = '$UserID'";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $RowTmp[0];
        $Data{UserLogin} = $RowTmp[1];
        $Data{UserSalutation} = $RowTmp[2];
        $Data{UserFirstname} = $RowTmp[3];
        $Data{UserLastname} = $RowTmp[4];
        $Data{UserPw} = $RowTmp[5];
        $Data{ValidID} = $RowTmp[6];
    }
    # --
    # check data
    # --
    if (! exists $Data{UserID} && ! $UserID) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Panic! No UserData for user: '$User'!!!",
        );
        return;
    }
    # --
    # get preferences
    # --
    my %Preferences = $Self->GetPreferences(UserID => $Data{UserID});
    # check compat stuff
    if (!$Preferences{UserEmail}) {
        $Preferences{UserEmail} = $Data{UserLogin};
    }

    # return data
    return (%Data, %Preferences);
}
# --
sub UserAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Firstname Lastname Login Pw ValidID UserID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check email address
    # --
    if ($Param{Email} && !$Self->{CheckItemObject}->CkeckEmail(Address => $Param{Email})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Email address ($Param{Email}) not valid (".
              $Self->{CheckItemObject}->CheckError().")!",
        );
        return;
    }
    # --
    # quote params
    # -- 
    $Param{Pw} = crypt($Param{Pw}, $Param{Login});
    foreach (keys %Param) {
       $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # --
    # sql
    # -- 
    my $SQL = "INSERT INTO $Self->{UserTable} " .
       "(salutation, " .
       " first_name, " .
       " last_name, " .
       " $Self->{UserTableUser}, " .
       " $Self->{UserTableUserPW}, " .
       " valid_id, create_time, create_by, change_time, change_by)" .
       " VALUES " .
       " ('$Param{Salutation}', " .
       " '$Param{Firstname}', " .
       " '$Param{Lastname}', " .
       " '$Param{Login}', " .
       " '$Param{Pw}', " .
       " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
       " current_timestamp, $Param{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # get new user id
      # --
      $SQL = "SELECT $Self->{UserTableUserID} ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE " .
        " $Self->{UserTableUser} = '$Param{Login}'";
      my $UserID = '';
      $Self->{DBObject}->Prepare(SQL => $SQL);
      while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $UserID = $RowTmp[0];
      }
      # --
      # log notice
      # --
      $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' ID: '$UserID' created successfully ($Param{UserID})!",
      );
      # --
      # set email address
      # --
      $Self->SetPreferences(UserID => $UserID, Key => 'UserEmail', Value => $Param{Email});
      return $UserID; 
    }
    else {
        return;
    }
}
# --
sub UserUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Firstname Lastname Login Pw ValidID UserID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check email address
    # --
    if ($Param{Email} && !$Self->{CheckItemObject}->CkeckEmail(Address => $Param{Email})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Email address ($Param{Email}) not valid (".
                $Self->{CheckItemObject}->CheckError().")!",
        );
        return;
    }
    # --
    # get old user data (pw)
    # --
    my %UserData = $Self->GetUserData(UserID => $Param{ID});
    # --
    # check if user name is changed (set new password)
    # --
    my $GetPw = $UserData{UserPw} || '';
    if ($UserData{UserLogin} ne $Param{Login} && $GetPw eq $Param{Pw}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "If the login name is changed, you need also to set a new password!",
        );
        return;
    }
    # --
    # quote params
    # -- 
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # -- 
    # update db
    # --
    my $SQL = "UPDATE $Self->{UserTable} SET " .
        " salutation = '$Param{Salutation}', " .
        " first_name = '$Param{Firstname}'," .
        " last_name = '$Param{Lastname}', " .
        " $Self->{UserTableUser} = '$Param{Login}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Param{UserID} " .
        " WHERE $Self->{UserTableUserID} = $Param{ID}";
  
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' updated successfully ($Param{UserID})!",
        );
        # --
        # check pw
        # --
        my $GetPw = $UserData{UserPw} || '';
        if ($GetPw ne $Param{Pw}) {
            $Self->SetPassword(UserLogin => $Param{Login}, PW => $Param{Pw});
        }
        # --
        # set email address
        # --
        $Self->SetPreferences(UserID => $Param{ID}, Key => 'UserEmail', Value => $Param{Email});
        return 1;
    }
    else {
        return; 
    }
}   
# --
sub SetPassword {
    my $Self = shift;
    my %Param = @_;
    my $Pw = $Param{PW} || '';
    # --
    # check needed stuff
    # --
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserLogin!");
        return;
    }
    # --
    # crypt pw
    # --    
    my $NewPw = $Self->{DBObject}->Quote(crypt($Pw, $Param{UserLogin}));
    # --
    # update db
    # --
    if ($Self->{DBObject}->Do(
            SQL => "UPDATE $Self->{UserTable} ".
               " SET ".
               " $Self->{UserTableUserPW} = '$NewPw' ".
               " WHERE ".
               " $Self->{UserTableUser} = '$Param{UserLogin}'",
    )) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{UserLogin}' changed password successfully!",
        );
        return 1;
    }
    else {
        return;
    }
}
# --
sub GetUserIdByName {
    my $Self = shift;
    my %Param = @_;
    my $ID;
    # --
    # check needed stuff
    # --
    if (!$Param{User}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User!");
        return;
    }
    # --
    # build sql query
    # --
    my $SQL = sprintf (
    "select %s from %s where %s='%s'", 
       $Self->{UserTableUserID},
       $Self->{UserTable},
      $Self->{UserTableUser},
      $Param{User}
      );
    
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
       $ID = $Row[0];
    }
    # return
    if ($ID) {
      return $ID;
    }
    else {
      $Self->{LogObject}->Log(
        Priority => 'error',
        Message => "No UserID found with User $Param{User}!",
      );
      return;
    }
} 
# --
sub GetUserByID {
    my $Self = shift;
    my %Param = @_;
    my $User = '';
    # --
    # check needed stuff
    # --
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    # -- 
    # build sql query
    # --
    my $SQL = sprintf (
    "select %s from %s where %s='%s'", 
       $Self->{UserTableUser},
       $Self->{UserTable},
      $Self->{UserTableUserID},
      $Param{UserID}
      );
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
       $User = $Row[0];
    }
    # return
    if ($User) {
      return $User;
    }
    else {
      $Self->{LogObject}->Log(
        Priority => 'error',
        Message => "No User found with ID $Param{UserID}!",
      );
      return;
    }
} 
# --
sub UserList {
    my $Self = shift;
    my %Param = @_;
    my %Users = $Self->{DBObject}->GetTableData(
        What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
            " $Self->{ConfigObject}->{DatabaseUserTableUser}",
        Table => $Self->{ConfigObject}->{DatabaseUserTable},
        Valid => 1,
    );
    return %Users;
}
# --
sub GenerateRandomPassword {
    my $Self = shift;
    my %Param = @_;
    # Generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars = (0..9, 'A'..'Z', 'a'..'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*');

    # The number of characters in the list.
    my $PwCharsLen = scalar(@PwChars);

    # Generate the password.
    my $Password = '';
    for ( my $i=0 ; $i<$Size ; $i++ ) {
        $Password .= $PwChars[rand($PwCharsLen)];
    }

    # Return the password.
    return $Password;
}
# --
sub SetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SetPreferences(@_);
}
# --
sub GetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->GetPreferences(@_);
}
# --

1;
