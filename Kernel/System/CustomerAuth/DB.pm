# --
# Kernel/System/CustomerAuth/DB.pm - provides the db authentification 
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.6 2003-04-03 13:14:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# --

package Kernel::System::CustomerAuth::DB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
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
    my $SQL = "SELECT pw, login ".
      " FROM ".
      " customer_user ".
      " WHERE ". 
      " valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " login = '$User'";
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
    my $Salt = $GetPw;
    $Salt =~ s/^(..).*/$1/;
    if (crypt('root', 'root@localhost') eq 'roK20XGbWEsSM') {
        $CryptedPw = crypt($Pw, $Salt);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
        );
        my $TempSalt = $Salt;
        $TempSalt =~ s/'/\\'/g;
        my $TempPw = $Pw;
        $TempPw =~ s/'/\\'/g;
        my $CMD = "perl -e \"print crypt('$TempPw', '$TempSalt');\"";
        open (IO, " $CMD | ") || print STDERR "Can't open $CMD: $!";
        while (<IO>) {
            $CryptedPw .= $_;
        }
        close (IO);
        chomp $CryptedPw;
    }

    # --
    # just in case!
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: '$User' tried to login with Pw: '$Pw' ($UserID/$CryptedPw/$GetPw/$Salt/$RemoteAddr)",
        );
    }

    # --
    # just a note 
    # --
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }
    # --
    # login note
    # --
    elsif ((($GetPw)&&($User)&&($UserID)) && $CryptedPw eq $GetPw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $User logged in (REMOTE_ADDR: $RemoteAddr).",
        );
        return 1;
    }
    # --
    # just a note
    # --
    elsif (($UserID) && ($GetPw)) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $User with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
    # --
    # just a note
    # --
    else {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "CustomerUser: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        ); 
        return;
    }
}
# --

1;

