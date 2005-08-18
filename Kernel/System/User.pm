# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.46 2005-08-18 06:57:52 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;
use Kernel::System::CheckItem;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.46 $';
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
    # check needed stuff
    if (!$Param{User} && !$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User or UserID!");
        return;
    }
    # check if result is cached
    if ($Param{Cached}) {
        if ($Param{User} && $Self->{'GetUserData::User::'.$Param{User}}) {
            return %{$Self->{'GetUserData::User::'.$Param{User}}};
        }
        elsif ($Param{UserID} && $Self->{'GetUserData::UserID::'.$Param{UserID}}) {
            return %{$Self->{'GetUserData::UserID::'.$Param{UserID}}};
        }
    }
    my %Data;
    # get inital data
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, ".
        " salutation, first_name, last_name, $Self->{UserTableUserPW}, valid_id ".
        " FROM " .
        " $Self->{UserTable} " .
        " WHERE ";
    if ($Param{User}) {
        $SQL .= " $Self->{UserTableUser} = '".$Self->{DBObject}->Quote($Param{User})."'";
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = ".$Self->{DBObject}->Quote($Param{UserID})."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $Row[0];
        $Data{UserLogin} = $Row[1];
        $Data{UserSalutation} = $Row[2];
        $Data{UserFirstname} = $Row[3];
        $Data{UserLastname} = $Row[4];
        $Data{UserPw} = $Row[5];
        $Data{ValidID} = $Row[6];
    }
    # check data
    if (!$Data{UserID}) {
        if ($Param{User}) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Panic! No UserData for user: '$Param{User}'!!!",
            );
            return;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Panic! No UserData for user id: '$Param{UserID}'!!!",
            );
            return;
        }
    }
    # check valid, return if there is locked for valid users
    if ($Param{Valid}) {
        my $Hit = 0;
        foreach ($Self->{DBObject}->GetValidIDs()) {
            if ($_ eq $Data{ValidID}) {
                $Hit = 1;
            }
        }
        if (!$Hit) {
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
    if ($Param{User} && $Self->{'GetUserData::User::'.$Param{User}}) {
        $Self->{'GetUserData::User::'.$Param{User}} = {%Data, %Preferences};
    }
    elsif ($Param{UserID} && $Self->{'GetUserData::UserID::'.$Param{UserID}}) {
        $Self->{'GetUserData::UserID::'.$Param{UserID}} = {%Data, %Preferences};
    }
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
    foreach (qw(ID Firstname Lastname Login ValidID UserID Email)) {
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
        if ($Param{Pw}) {
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
sub UserSearch {
    my $Self = shift;
    my %Param = @_;
    my %Users = ();
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;
    # check needed stuff
    if (!$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Search, UserLogin or PostMasterSearch!");
        return;
    }
    # build SQL string 1/2
    my $SQL = "SELECT $Self->{UserTableUser} ";
    my @Fields = ('first_name', 'last_name', 'email');
    if (@Fields) {
        foreach my $Entry (@Fields) {
            $SQL .= ", $Entry";
        }
    }
    # build SQL string 2/2
    $SQL .= " FROM " .
      " $Self->{UserTable} ".
      " WHERE ";
    if ($Param{Search}) {
        my $Count = 0;
        my @Parts = split(/\+/, $Param{Search}, 6);
        foreach my $Part (@Parts) {
            $Part = $Self->{SearchPrefix}.$Part.$Self->{SearchSuffix};
            $Part =~ s/\*/%/g;
            $Part =~ s/%%/%/g;
            if ($Count) {
                $SQL .= " AND ";
            }
            $Count ++;
            if (@Fields) {
                my $SQLExt = '';
                foreach (@Fields) {
                    if ($SQLExt) {
                        $SQLExt .= ' OR ';
                    }
                    $SQLExt .= " LOWER($_) LIKE LOWER('".$Self->{DBObject}->Quote($Part)."') ";
                }
                if ($SQLExt) {
                    $SQL .= "($SQLExt)";
                }
            }
        }
    }
    elsif ($Param{PostMasterSearch}) {
        my %UserID = $Self->SearchPreferences(
            Key => 'UserEmail',
            Value => $Param{PostMasterSearch},
        );
        foreach (sort keys %UserID) {
            my %User = $Self->GetUserData(
                UserID => $_,
                Valid => $Param{Valid},
            );
            if (%User) {
                return %UserID;
            }
        }
        return ();
    }
    elsif ($Param{UserLogin}) {
        $Param{UserLogin} =~ s/\*/%/g;
        $SQL .= " LOWER($Self->{UserTableUser}) LIKE LOWER('".$Self->{DBObject}->Quote($Param{UserLogin})."')";
    }
    # add valid option
    if ($Valid) {
        $SQL .= "AND valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ";
    }
    # get data
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{UserSearchListLimit});
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
         foreach (1..8) {
             if ($Row[$_]) {
                  $Users{$Row[0]} .= $Row[$_].' ';
             }
         }
         $Users{$Row[0]} =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
    }
    return %Users;
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
    # set pw history
    $Self->SetPreferences(UserID => $User{UserID}, Key => 'UserLastPw', Value => $CryptedPw);
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
sub SearchPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SearchPreferences(@_);
}
# --

1;
