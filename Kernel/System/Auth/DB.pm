# --
# Kernel/System/Auth/DB.pm - provides the db authentification 
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.5 2003-02-15 11:56:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# --

package Kernel::System::Auth::DB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }
 
    # --
    # Debug 0=off 1=on
    # --
    $Self->{Debug} = 0;

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

    return $Self;
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{User}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need User!");
      return;
    }
    # --
    # get params
    # --
    my $User = $Param{User} || ''; 
    my $Pw = $Param{Pw} || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID = '';
    my $GetPw = '';

    # --
    # sql query
    # --
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID} ".
      " FROM ".
      " $Self->{UserTable} ".
      " WHERE ". 
      " valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " $Self->{UserTableUser} = '$User'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) { 
        $GetPw = $RowTmp[0];
        $UserID = $RowTmp[1];
    }

    # --
    # crypt given pw (unfortunately there is a mod_perl2 bug on RH8 - check if 
    # crypt() is working correctly) :-/
    # --
    my $CryptedPw = '';
    if (crypt('root', 'root@localhost') eq 'roK20XGbWEsSM') {
        $CryptedPw = crypt($Pw, $User);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
        );
        my $TempUser = $User;
        $TempUser =~ s/'/\\'/g;
        my $TempPw = $Pw;
        $TempPw =~ s/'/\\'/g;
        my $CMD = "perl -e \"print crypt('$TempPw', '$TempUser');\"";
        open (IO, " $CMD | ") || print STDERR "Can't open $CMD: $!";
        while (<IO>) {
            $CryptedPw .= $_;
        }
        close (IO);
        chomp $CryptedPw;
    }
    # --
    # just in case for debug!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$User' tried to login with Pw: '$Pw' ($UserID/$CryptedPw/$GetPw/$RemoteAddr)",
        );
    }
    # --
    # just a note 
    # --
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }
    # --
    # login note
    # --
    elsif ((($GetPw)&&($User)&&($UserID)) && $CryptedPw eq $GetPw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User logged in (REMOTE_ADDR: $RemoteAddr).",
        );
        return 1;
    }
    # --
    # just a note
    # --
    elsif (($UserID) && ($GetPw)) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
    # --
    # just a note
    # --
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
}
# --

1;
