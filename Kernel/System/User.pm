# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.41 2004-08-01 10:29:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;
use Kernel::System::CheckItem;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.41 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
sub GetUserData {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User} || '';
    my $UserID = $Param{UserID} || '';
    # check if result is cached 
    if ($Param{Cached} && $Self->{'GetUserData'.$User.$UserID}) {
        return %{$Self->{'GetUserData'.$User.$UserID}};
    }
    my %Data;
    # get inital data
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, ".
        " salutation, first_name, last_name, $Self->{UserTableUserPW}, valid_id ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE ";
    if ($User) {
        $SQL .= " $Self->{UserTableUser} = '".$Self->{DBObject}->Quote($User)."'";
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = '".$Self->{DBObject}->Quote($UserID)."'";
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
    # check data
    if (! exists $Data{UserID} && ! $UserID) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Panic! No UserData for user: '$User'!!!",
        );
        return;
    }
    # check valid 
    if ($Param{Valid}) {
        if ($Data{ValidID} ne 1) {
            return;
        }
    }
    # get preferences
    my %Preferences = $Self->GetPreferences(UserID => $Data{UserID});
    # check compat stuff
    if (!$Preferences{UserEmail}) {
        $Preferences{UserEmail} = $Data{UserLogin};
    }
    # cache user result
    $Self->{'GetUserData'.$User.$UserID} = {%Data, %Preferences}; 
    # return data
    return (%Data, %Preferences);
}
# --
sub UserAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Firstname Lastname Login Pw ValidID UserID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check email address
    if ($Param{Email} && !$Self->{CheckItemObject}->CheckEmail(Address => $Param{Email})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Email address ($Param{Email}) not valid (".
              $Self->{CheckItemObject}->CheckError().")!",
        );
        return;
    }
    # quote params
    foreach (keys %Param) {
       $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # sql
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
      # get new user id
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
      # log notice
      $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' ID: '$UserID' created successfully ($Param{UserID})!",
      );
      # set password
      $Self->SetPassword(UserLogin => $Param{Login}, PW => $Param{Pw});
      # set email address
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
    # check needed stuff
    foreach (qw(ID Firstname Lastname Login Pw ValidID UserID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check email address
    if ($Param{Email} && !$Self->{CheckItemObject}->CheckEmail(Address => $Param{Email})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Email address ($Param{Email}) not valid (".
                $Self->{CheckItemObject}->CheckError().")!",
        );
        return;
    }
    # get old user data (pw)
    my %UserData = $Self->GetUserData(UserID => $Param{ID});
    # check if user name is changed (set new password)
    my $GetPw = $UserData{UserPw} || '';
    if ($UserData{UserLogin} ne $Param{Login} && $GetPw eq $Param{Pw}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "If the login name is changed, you need also to set a new password!",
        );
        return;
    }
    # quote params
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # update db
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
        # log notice
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{Login}' updated successfully ($Param{UserID})!",
        );
        # check pw
        my $GetPw = $UserData{UserPw} || '';
        if ($GetPw ne $Param{Pw}) {
            $Self->SetPassword(UserLogin => $Param{Login}, PW => $Param{Pw});
        }
        # set email address
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
    # check needed stuff
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserLogin!");
        return;
    }
    # get old user data
    my %User = $Self->GetUserData(User => $Param{UserLogin});
    if (!$User{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such User!");
        return;
    }
    # crypt given pw (unfortunately there is a mod_perl2 bug on RH8 - check if 
    # crypt() is working correctly) :-/
    my $CryptedPw = '';
    if (crypt('root', 'root@localhost') eq 'roK20XGbWEsSM') {
        $CryptedPw = crypt($Pw, $Param{UserLogin});
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
        );
        my $TempUser = quotemeta($Param{UserLogin});
        my $TempPw = quotemeta($Pw);
        my $CMD = "perl -e \"print crypt('$TempPw', '$TempUser');\"";
        open (IO, " $CMD | ") || print STDERR "Can't open $CMD: $!";
        while (<IO>) {
            $CryptedPw .= $_;
        }
        close (IO);
        chomp $CryptedPw;
    }
    # check pw
    if ($CryptedPw eq $User{UserPw}) {
        $Self->{LogObject}->Log(
            Priority => 'notice', 
            Message => "Not possible to use the same password again!",
        );
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $NewPw = $Self->{DBObject}->Quote($CryptedPw);
    # update db
    if ($Self->{DBObject}->Do(
            SQL => "UPDATE $Self->{UserTable} ".
               " SET ".
               " $Self->{UserTableUserPW} = '$NewPw' ".
               " WHERE ".
               " $Self->{UserTableUser} = '$Param{UserLogin}'",
    )) {
        # log notice
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
    # check needed stuff
    if (!$Param{User}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # build sql query
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
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    # build sql query
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
    my $Valid = $Param{Valid} || 0;
    my $Type = $Param{Type} || 'Short';
    if ($Type eq 'Short') {
        $Param{What} = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
            " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }
    else {
        $Param{What} = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
            " last_name, first_name, ".
            " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }
    my %Users = $Self->{DBObject}->GetTableData(
        What => $Param{What},
        Table => $Self->{ConfigObject}->{DatabaseUserTable},
        Clamp => 1,
        Valid => $Valid,
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
sub SyncLDAP2Database {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{User}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User!");
        return;
    }
    # check if we run LDAP and add aproperiate data into the RDBMS
    if ($Self->{ConfigObject}->Get('AuthModule') ne 'Kernel::System::Auth::LDAP') {
        return 1;
    }
    # get LDAP variables
    if (eval {'require Net::LDAP;'}) {
        $Self->{Host} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Host')
          || die "Need AuthModule::LDAPHost in Kernel/Config.pm";
        $Self->{BaseDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::BaseDN')
          || die "Need AuthModule::LDAPBaseDN in Kernel/Config.pm";
        $Self->{UID} = $Self->{ConfigObject}->Get('AuthModule::LDAP::UID')
          || die "Need AuthModule::LDAPBaseDN in Kernel/Config.pm";
        $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserDN') || '';
        $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('AuthModule::LDAP::SearchUserPw') || '';
        $Self->{GroupDN} = $Self->{ConfigObject}->Get('AuthModule::LDAP::GroupDN') || '';
        $Self->{AccessAttr} = $Self->{ConfigObject}->Get('AuthModule::LDAP::AccessAttr') || '';
        # Net::LDAP new params
        if ($Self->{ConfigObject}->Get('AuthModule::LDAP::Params')) {
            $Self->{Params} = $Self->{ConfigObject}->Get('AuthModule::LDAP::Params');
        }
        else {
            $Self->{Params} = {};
        }
        # bind to LDAP
        my $LDAP = Net::LDAP->new($Self->{Host}, %{$Self->{Params}}) or die "$@";
        if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "First LDAP bind failed!",
            );
            return;
        }
        # --
        # perform user search
        # --
        my $Filter = "($Self->{UID}=$Param{User})";
        my $Result = $LDAP->search (
            base   => $Self->{BaseDN},
            filter => $Filter,
        );
        # --
        # get whole user data
        # --
        my $UserDN = '';
        my $UserPassword = '';
        my %SyncUser = ();
        foreach my $Entry ($Result->all_entries) {
            $UserDN = $Entry->dn();
            foreach (keys %{$Self->{ConfigObject}->Get('UserSyncLDAPMap')}) {
                $SyncUser{$_} = $Entry->get_value($Self->{ConfigObject}->Get('UserSyncLDAPMap')->{$_});
            }
            $UserPassword = $Entry->get_value('userPassword') || $Self->GenerateRandomPassword();
        }
        if ($Self->UserAdd(
            Salutation => 'Mr/Mrs',
            Login => $Param{User},
            Pw => $UserPassword,
            %SyncUser,
            UserType => 'User',
            ValidID => 1,
            UserID => 1,
        )) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Data for '$Param{User} ($UserDN)' created in RDBMS, proceed.",
            );
            return 1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't create user '$Param{User} ($UserDN)' in RDBMS!",
            );
            return;
        }
    }
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
