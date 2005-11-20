# --
# Kernel/System/Auth/DB.pm - provides the db authentification
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.11.2.1 2005-11-20 20:23:23 martin Exp $
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
$VERSION = '$Revision: 1.11.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get user table
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
sub GetOption {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{What}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need What!");
        return;
    }
    # module options
    my %Option = (
        PreAuth => 0,
    );
    # return option
    return $Option{$Param{What}};
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{User}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User!");
        return;
    }
    # get params
    my $User = $Param{User} || '';
    my $Pw = $Param{Pw} || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID = '';
    my $GetPw = '';
    # sql query
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID} ".
      " FROM ".
      " $Self->{UserTable} ".
      " WHERE ".
      " valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " $Self->{UserTableUser} = '".$Self->{DBObject}->Quote($User)."'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $GetPw = $RowTmp[0];
        $UserID = $RowTmp[1];
    }

    # crypt given pw
    my $CryptedPw = '';
    my $Salt = $GetPw;
    # strip Salt only for (Extended) DES, not for any of Modular crypt's
    if ($Salt !~ /^\$\d\$/) {
        $Salt =~ s/^(..).*/$1/;
    }
    # and do this check only in such case (unfortunately there is a mod_perl2
    # bug on RH8 - check if crypt() is working correctly) :-/
    if (($Salt =~ /^\$\d\$/) || (crypt('root', 'root@localhost') eq 'roK20XGbWEsSM')) {
        $CryptedPw = crypt($Pw, $Salt);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
        );
        my $TempSalt = quotemeta($Salt);
        my $TempPw = quotemeta($Pw);
        my $CMD = "perl -e \"print crypt('$TempPw', '$TempSalt');\"";
        open (IO, " $CMD | ") || print STDERR "Can't open $CMD: $!";
        while (<IO>) {
            $CryptedPw .= $_;
        }
        close (IO);
        chomp $CryptedPw;
    }
    # just in case for debug!
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$User' tried to authenticate with Pw: '$Pw' ($UserID/$CryptedPw/$GetPw/$Salt/$RemoteAddr)",
        );
    }
    # just a note
    if (!$Pw) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }
    # login note
    elsif ((($GetPw)&&($User)&&($UserID)) && $CryptedPw eq $GetPw) {
        # maybe check if pw is expired
        # if () {
#           $Self->{LogObject}->Log(
#               Priority => 'info',
#               Message => "Password is expired!",
#           );
#            return;
#        }
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }
    # just a note
    elsif (($UserID) && ($GetPw)) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $User authentication with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }
    # just a note
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
