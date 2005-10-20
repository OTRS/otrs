# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.49 2005-10-20 21:27:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;
use Kernel::System::CheckItem;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.49 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::User - user lib

=head1 SYNOPSIS

All user functions. E. g. to add and updated user and other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::User;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $UserObject = Kernel::System::User->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # get user table
    $Self->{UserTable} = $Self->{ConfigObject}->Get('DatabaseUserTable')
      || 'user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID')
      || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW')
      || 'pw';
    $Self->{UserTableUser} = $Self->{ConfigObject}->Get('DatabaseUserTableUser')
      || 'login';
    # load generator customer preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('User::PreferencesModule')
      || 'Kernel::System::User::Preferences::DB';
    eval "require $GeneratorModule";
    $Self->{PreferencesObject} = $GeneratorModule->new(%Param);

    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);

    return $Self;
}

=item GetUserData()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $UserObject->GetUserData(
        UserID => 123,
        Cached => 1, # not required -> 0|1
    );

    or

    my %User = $UserObject->GetUserData(
        User => 'franz',
        Cached => 1, # not required -> 0|1
    );

=cut

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
    if ($Param{User}) {
        $Self->{'GetUserData::User::'.$Param{User}} = {%Data, %Preferences};
    }
    elsif ($Param{UserID}) {
        $Self->{'GetUserData::UserID::'.$Param{UserID}} = {%Data, %Preferences};
    }
    # return data
    return (%Data, %Preferences);
}

=item UserAdd()

to add new users

  my $UserID = $UserObject->UserAdd(
      Firstname => 'Huber',
      Lastname => 'Manfred',
      Login => 'mhuber',
      Pw => 'some-pass', # not required
      Email => 'email@example.com',
      ValidID => 1,
      UserID => 123,
  );

=cut

sub UserAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Firstname Lastname Login ValidID UserID Email)) {
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
    # check password
    if (!$Param{Pw}) {
        $Param{Pw} = $Self->GenerateRandomPassword();
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
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $UserID = $Row[0];
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

=item UserUpdate()

to update users

  $UserObject->UserUpdate(
      ID => 4321,
      Firstname => 'Huber',
      Lastname => 'Manfred',
      Login => 'mhuber',
      Pw => 'some-pass', # not required
      Email => 'email@example.com',
      ValidID => 1,
      UserID => 123,
  );

=cut

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

=item UserSearch()

to search users

  my %List = $UserObject->UserSearch(
      Search => '*some*', # also 'hans+huber' possible
      ValidID => 1, # not required
  );

  my %List = $UserObject->UserSearch(
      UserLogin => '*some*',
      ValidID => 1, # not required
  );

  my %List = $UserObject->UserSearch(
      PostMasterSearch => 'email@example.com',
      ValidID => 1, # not required
  );

=cut

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

=item SetPassword()

to set users passwords

  $UserObject->SetPassword(
      UserLogin => 'some-login',
      PW => 'some-new-password'
  );

=cut

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
# just for compat. - not longer used
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
# just for compat. - not longer used
sub GetUserByID {
    my $Self = shift;
    my %Param = @_;
    my $User = '';
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
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

=item UserName()

get user name

  my $Name = $UserObject->UserName(
      UserLogin => 'some-login',
  );

  or

  my $Name = $UserObject->UserName(
      UserID => 123,
  );

=cut

sub UserName {
    my $Self = shift;
    my %Param = @_;
    my %User = $Self->GetUserData(%Param);
    if (%User) {
        return "$User{UserFirstname} $User{UserLastname}";
    }
    else {
        return;
    }
}

=item UserList()

return a hash with all users

  my %List = $UserObject->UserList(
      Type => 'Short', # Short|Long
      Valid => 1, # not required
  );

=cut

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

=item GenerateRandomPassword()

generate a random password

  my $Password = $UserObject->GenerateRandomPassword();

  or

  my $Password = $UserObject->GenerateRandomPassword(
      Size => 16,
  );

=cut

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

=item SetPreferences()

set user preferences

  $UserObject->SetPreferences(
      Key => 'UserComment',
      Value => 'some comment',
      UserID => 123,
  );

=cut

sub SetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SetPreferences(@_);
}

=item GetPreferences()

get user preferences

  my %Preferences = $UserObject->GetPreferences(
      UserID => 123,
  );

=cut

sub GetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->GetPreferences(@_);
}

=item SearchPreferences()

search in user preferences

  my %UserList = $Self->SearchPreferences(
      Key => 'UserEmail',
      Value => 'email@example.com',
  );

=cut

sub SearchPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SearchPreferences(@_);
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.49 $ $Date: 2005-10-20 21:27:51 $

=cut
