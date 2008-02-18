# --
# Kernel/System/Auth/DB.pm - provides the db authentification
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.18.2.1 2008-02-18 16:49:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Auth::DB;

use strict;
use Kernel::System::Valid;
use Crypt::PasswdMD5 qw(unix_md5_crypt);

use vars qw($VERSION);
$VERSION = '$Revision: 1.18.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get user table
    $Self->{UserTable} = $Self->{ConfigObject}->Get('DatabaseUserTable'.$Param{Count})
        || 'system_user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID'.$Param{Count})
        || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW'.$Param{Count})
        || 'pw';
    $Self->{UserTableUser} = $Self->{ConfigObject}->Get('DatabaseUserTableUser'.$Param{Count})
        || 'login';

    return $Self;
}

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
        " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) ".
        " AND ".
        " $Self->{UserTableUser} = '".$Self->{DBObject}->Quote($User)."'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $GetPw = $Row[0];
        $UserID = $Row[1];
    }
    # crypt given pw
    my $CryptedPw = '';
    my $Salt = $GetPw;
    if ($Self->{ConfigObject}->Get('AuthModule::DB::CryptType') &&
        $Self->{ConfigObject}->Get('AuthModule::DB::CryptType') eq 'plain') {
        $CryptedPw = $Pw;
    }
    # md5 pw
    elsif ($GetPw !~ /^.{13}$/) {
        # strip Salt
        $Salt =~ s/^\$.+?\$(.+?)\$.*$/$1/;
        $CryptedPw = unix_md5_crypt($Pw, $Salt);
    }
    # crypt pw
    else {
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

1;
