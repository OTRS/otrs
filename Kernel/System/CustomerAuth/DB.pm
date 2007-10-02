# --
# Kernel/System/CustomerAuth/DB.pm - provides the db authentification
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.20 2007-10-02 10:36:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerAuth::DB;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # config options
    $Self->{Table} = $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::Table' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::Table$Param{Count} in Kernel/Config.pm!";
    $Self->{Key}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::CustomerKey' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::CustomerKey$Param{Count} in Kernel/Config.pm!";
    $Self->{Pw}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::CustomerPassword' . $Param{Count} )
        || die "Need CustomerAuthModule::DB::CustomerPw$Param{Count} in Kernel/Config.pm!";
    $Self->{CryptType}
        = $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::CryptType' . $Param{Count} )
        || '';

    if ( $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} ) ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            DatabaseDSN =>
                $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} ),
            DatabaseUser =>
                $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::User' . $Param{Count} ),
            DatabasePw =>
                $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::Password' . $Param{Count} ),
            Type => $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::Type' . $Param{Count} )
                || '',
            )
            || die "Can't connect to "
            . $Self->{ConfigObject}->Get( 'Customer::AuthModule::DB::DSN' . $Param{Count} );

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

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
    my $SQL
        = "SELECT $Self->{Pw}, $Self->{Key}"
        . " FROM "
        . " $Self->{Table} "
        . " WHERE "
        . " $Self->{Key} = '"
        . $Self->{DBObject}->Quote($User) . "'";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GetPw  = $Row[0];
        $UserID = $Row[1];
    }

    # check if user exists in auth table
    if ( !$UserID ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: No auth record in '$Self->{Table}' for '$User' "
                . "(REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # crypt given pw
    my $CryptedPw = '';
    my $Salt      = $GetPw;

    # md5 pw
    if ( $Self->{CryptType} eq 'plain' ) {
        $CryptedPw = $Pw;
    }
    elsif ( $GetPw !~ /^.{13}$/ ) {

        # strip Salt
        $Salt =~ s/^\$.+?\$(.+?)\$.*$/$1/;
        $CryptedPw = unix_md5_crypt( $Pw, $Salt );
    }

    # crypt pw
    else {

        # strip Salt only for (Extended) DES, not for any of Modular crypt's
        if ( $Salt !~ /^\$\d\$/ ) {
            $Salt =~ s/^(..).*/$1/;
        }

        # and do this check only in such case (unfortunately there is a mod_perl2
        # bug on RH8 - check if crypt() is working correctly) :-/
        if ( ( $Salt =~ /^\$\d\$/ ) || ( crypt( 'root', 'root@localhost' ) eq 'roK20XGbWEsSM' ) ) {
            $CryptedPw = crypt( $Pw, $Salt );
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
            );
            my $TempSalt = quotemeta($Salt);
            my $TempPw   = quotemeta($Pw);
            my $CMD      = "perl -e \"print crypt('$TempPw', '$TempSalt');\"";
            open( IO, " $CMD | " ) || print STDERR "Can't open $CMD: $!";
            while (<IO>) {
                $CryptedPw .= $_;
            }
            close(IO);
            chomp $CryptedPw;
        }
    }

    # just in case!
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$User' tried to authentificate with Pw: '$Pw' "
                . "($UserID/$CryptedPw/$GetPw/$Salt/$RemoteAddr)",
        );
    }

    # just a note
    if ( !$Pw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "CustomerUser: $User authentification without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # login note
    elsif ( ( ($GetPw) && ($User) && ($UserID) ) && $CryptedPw eq $GetPw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User authentification ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }

    # just a note
    elsif ( ($UserID) && ($GetPw) ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "CustomerUser: $User authentification with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }

    # just a note
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "CustomerUser: $User doesn't exist or is invalid!!! (REMOTE_ADDR: $RemoteAddr)"
        );
        return;
    }
}

sub DESTROY {
    my ($Self) = @_;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }
    return 1;
}

1;
