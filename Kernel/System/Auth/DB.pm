# --
# Kernel/System/Auth/DB.pm - provides the db authentication
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth::DB;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt);

use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get user table
    $Self->{UserTable} = $Self->{ConfigObject}->Get( 'DatabaseUserTable' . $Param{Count} )
        || 'users';
    $Self->{UserTableUserID}
        = $Self->{ConfigObject}->Get( 'DatabaseUserTableUserID' . $Param{Count} )
        || 'id';
    $Self->{UserTableUserPW}
        = $Self->{ConfigObject}->Get( 'DatabaseUserTableUserPW' . $Param{Count} )
        || 'pw';
    $Self->{UserTableUser} = $Self->{ConfigObject}->Get( 'DatabaseUserTableUser' . $Param{Count} )
        || 'login';

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need What!" );
        return;
    }

    # module options
    my %Option = ( PreAuth => 0, );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User!" );
        return;
    }

    # get params
    my $User       = $Param{User}      || '';
    my $Pw         = $Param{Pw}        || '';
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    my $UserID     = '';
    my $GetPw      = '';

    # sql query
    my $SQL = "SELECT $Self->{UserTableUserPW}, $Self->{UserTableUserID} "
        . " FROM "
        . " $Self->{UserTable} "
        . " WHERE "
        . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) AND "
        . " $Self->{UserTableUser} = '" . $Self->{DBObject}->Quote($User) . "'";
    $Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GetPw  = $Row[0];
        $UserID = $Row[1];
    }

    # crypt given pw
    my $CryptedPw = '';
    my $Salt      = $GetPw;
    if (
        $Self->{ConfigObject}->Get('AuthModule::DB::CryptType')
        && $Self->{ConfigObject}->Get('AuthModule::DB::CryptType') eq 'plain'
        )
    {
        $CryptedPw = $Pw;
    }

    # md5 or sha pw
    elsif ( $GetPw !~ /^.{13}$/ ) {

        # md5 pw
        if ( $GetPw =~ m{\A \$.+? \$.+? \$.* \z}xms ) {

            # strip Salt
            $Salt =~ s/^\$.+?\$(.+?)\$.*$/$1/;

            # encode output, needed by unix_md5_crypt() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );
            $Self->{EncodeObject}->EncodeOutput( \$Salt );

            $CryptedPw = unix_md5_crypt( $Pw, $Salt );
        }

        # sha256 pw
        elsif ( $GetPw =~ m{\A .{64} \z}xms ) {

            my $SHAObject;
            if ( $Self->{MainObject}->Require('Digest::SHA') ) {
                $SHAObject = Digest::SHA->new('sha256');
            }
            else {
                $Self->{MainObject}->Require('Digest::SHA::PurePerl');
                $SHAObject = Digest::SHA::PurePerl->new('sha256');
            }

            # encode output, needed by sha256_hex() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );

            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
        }

        # sha1 pw
        else {

            my $SHAObject;
            if ( $Self->{MainObject}->Require('Digest::SHA') ) {
                $SHAObject = Digest::SHA->new('sha1');
            }
            else {
                $Self->{MainObject}->Require('Digest::SHA::PurePerl');
                $SHAObject = Digest::SHA::PurePerl->new('sha1');
            }

            # encode output, needed by sha1_hex() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );

            $SHAObject->add($Pw);
            $CryptedPw = $SHAObject->hexdigest();
        }
    }

    # crypt pw
    else {

        # strip Salt only for (Extended) DES, not for any of Modular crypt's
        if ( $Salt !~ /^\$\d\$/ ) {
            $Salt =~ s/^(..).*/$1/;
        }

        # encode output, needed by crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Salt );
        $CryptedPw = crypt( $Pw, $Salt );
    }

    # just in case for debug!
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "User: '$User' tried to authenticate with Pw: '$Pw' ($UserID/$CryptedPw/$GetPw/$Salt/$RemoteAddr)",
        );
    }

    # just a note
    if ( !$Pw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # login note
    elsif ( ( ($GetPw) && ($User) && ($UserID) ) && $CryptedPw eq $GetPw ) {

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }

    # just a note
    elsif ( ($UserID) && ($GetPw) ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User authentication with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }

    # just a note
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "User: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }
}

1;
