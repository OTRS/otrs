# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerUser.pm,v 1.1 2002-10-15 09:30:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
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

    return $Self;
}
# --
sub CustomerUserDataGet {
    my $Self = shift;
    my %Param = @_;
    my $User = $Param{User};
    my $UserID = $Param{UserID};
    my %Data;
    # --
    # get inital data
    # --
    my $SQL = "SELECT id, login, email, customer_id, pw, salutation, ".
        " first_name, last_name, comment, valid_id ".
        " FROM " .
        " customer_user " .
        " WHERE ";
    if ($User) {
        $SQL .= " login = '$User'";
    }
    else {
        $SQL .= " id = $UserID";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{UserID} = $RowTmp[0];
        $Data{UserLogin} = $RowTmp[1];
        $Data{UserEmail} = $RowTmp[2];
        $Data{UserCustomerID} = $RowTmp[3];
        $Data{UserPw} = $RowTmp[4];
        $Data{UserSalutation} = $RowTmp[5];
        $Data{UserFirstname} = $RowTmp[6];
        $Data{UserLastname} = $RowTmp[7];
        $Data{UserComment} = $RowTmp[8];
        $Data{ValidID} = $RowTmp[9];
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

    # return data
    return (%Data);
}
# --
sub CustomerUserAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Salutation Firstname Lastname Login Pw ValidID CustomerID Email Comment UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
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
    my $SQL = "INSERT INTO customer_user " .
       "(salutation, " .
       " first_name, " .
       " last_name, " .
       " login, " .
       " pw, " .
       " email, " .
       " customer_id, " .
       " comment, " .
       " valid_id, create_time, create_by, change_time, change_by)" .
       " VALUES " .
       " ('$Param{Salutation}', " .
       " '$Param{Firstname}', " .
       " '$Param{Lastname}', " .
       " '$Param{Login}', " .
       " '$Param{Pw}', " .
       " '$Param{Email}', " .
       " '$Param{CustomerID}', " .
       " '$Param{Comment}', " .
       " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
       " current_timestamp, $Param{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # get new user id
      # --
      $SQL = "SELECT id ".
        " FROM " .
        " customer_user " .
        " WHERE " .
        " login = '$Param{Login}'";
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
          Message => "CustomerUser: '$Param{Login}' ID: '$UserID' created successfully ($Param{UserID})!",
      );

      return $UserID; 
    }
    else {
        return;
    }
}
# --
sub CustomerUserUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Salutation Firstname Lastname Login Pw ValidID CustomerID Email UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get old user data (pw)
    # --
    my %UserData = $Self->CustomerUserDataGet(UserID => $Param{ID});
    # --
    # quote params
    # -- 
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # -- 
    # update db
    # --
    my $SQL = "UPDATE customer_user SET " .
        " salutation = '$Param{Salutation}', " .
        " first_name = '$Param{Firstname}'," .
        " last_name = '$Param{Lastname}', " .
        " login = '$Param{Login}', " .
        " email = '$Param{Email}', " .
        " customer_id = '$Param{CustomerID}', " .
        " comment = '$Param{Comment}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Param{UserID} " .
        " WHERE id = $Param{ID}";
  
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: '$Param{Login}' updated successfully ($Param{UserID})!",
        );
        # --
        # check pw
        # --
        my $GetPw = $UserData{UserPw} || '';
        if ($GetPw ne $Param{Pw}) {
            $Self->SetPassword(UserLogin => $Param{Login}, PW => $Param{Pw});
        }
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
    my $NewPw = crypt($Pw, $Param{UserLogin});
    # --
    # update db
    # --
    if ($Self->{DBObject}->Do(
            SQL => "UPDATE customer_user ".
               " SET ".
               " pw = '$NewPw' ".
               " WHERE ".
               " login = '$Param{UserLogin}'",
    )) {
        # --
        # log notice
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: '$Param{UserLogin}' changed password successfully!",
        );
        return 1;
    }
    else {
        return;
    }
}
# --
sub GetGroups {
    return;
}
# --

1;
