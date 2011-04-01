# --
# Kernel/System/CustomerAuth/DB.pm - provides the db authentication
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.32.2.1 2011-04-01 07:06:45 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerAuth::DB;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt);
use Digest::SHA::PurePerl qw(sha1_hex sha256_hex);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.32.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject EncodeObject)) {
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
            EncodeObject => $Param{EncodeObject},
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
    my $SQL = "SELECT $Self->{Pw}, $Self->{Key} FROM $Self->{Table} WHERE "
        . " $Self->{Key} = '" . $Self->{DBObject}->Quote($User) . "'";
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

    if ( $Self->{CryptType} eq 'plain' ) {
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
            $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
        }

        # sha2 pw
        elsif ( $GetPw =~ m{\A .{64} \z}xms ) {

            # encode output, needed by sha256_hex() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );

            $CryptedPw = sha256_hex($Pw);
            $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
        }

        # sha1 pw
        else {

            # encode output, needed by sha1_hex() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );

            $CryptedPw = sha1_hex($Pw);
            $Self->{EncodeObject}->EncodeInput( \$CryptedPw );

        }
    }

    # crypt pw
    else {

        # strip salt only for (Extended) DES, not for any of modular crypt's
        if ( $Salt !~ /^\$\d\$/ ) {
            $Salt =~ s/^(..).*/$1/;
        }

        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Salt );

        # encode output, needed by crypt() only non utf8 signs
        $CryptedPw = crypt( $Pw, $Salt );
        $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
    }

    # just in case!
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$User' tried to authenticate with Pw: '$Pw' "
                . "($UserID/$CryptedPw/$GetPw/$Salt/$RemoteAddr)",
        );
    }

    # just a note
    if ( !$Pw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "CustomerUser: $User authentication without Pw!!! (REMOTE_ADDR: $RemoteAddr)",
        );
        return;
    }

    # login note
    elsif ( ( $GetPw && $User && $UserID ) && $CryptedPw eq $GetPw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: $User Authentication ok (REMOTE_ADDR: $RemoteAddr).",
        );
        return $User;
    }

    # just a note
    elsif ( $UserID && $GetPw ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "CustomerUser: $User Authentication with wrong Pw!!! (REMOTE_ADDR: $RemoteAddr)"
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

# NOTE - Partial fix for bug 7112 in comment because still failing in some cases
#sub SetPassword {
#    my ( $Self, %Param ) = @_;
#    my %Params = %{$Param{Data}};
#
#    # check needed stuff
#    if ( !$Params{UserLogin} ) {
#        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
#        return;
#    }
#
#    my $Login = $Params{UserLogin};
#    my $Pw = $Params{PW} || '';
#
#    my $CryptedPw = '';
#
#    # crypt plain (no crypt at all)
#    if ( $Self->{CryptType} eq 'plain' ) {
#        $CryptedPw = $Pw;
#    }
#
#    # crypt with unix crypt
#    elsif ( $Self->{CryptType} eq 'crypt' ) {
#
#        # encode output, needed by crypt() only non utf8 signs
#        $Self->{EncodeObject}->EncodeOutput( \$Pw );
#        $Self->{EncodeObject}->EncodeOutput( \$Login );
#
#        $CryptedPw = crypt( $Pw, $Login );
#        $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
#    }
#
#    # crypt with md5 crypt
#    elsif ( $Self->{CryptType} eq 'md5' || !$Self->{CryptType} ) {
#
#        # encode output, needed by unix_md5_crypt() only non utf8 signs
#        $Self->{EncodeObject}->EncodeOutput( \$Pw );
#        $Self->{EncodeObject}->EncodeOutput( \$Login );
#
#        $CryptedPw = unix_md5_crypt( $Pw, $Login );
#        $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
#    }
#
#    # crypt with sha1
#    elsif ( $Self->{CryptType} eq 'sha1' ) {
#
#        # encode output, needed by sha1_hex() only non utf8 signs
#        $Self->{EncodeObject}->EncodeOutput( \$Pw );
#
#        $CryptedPw = sha1_hex($Pw);
#    }
#
#    # crypt with sha2
#    # if CrypType is set to anything else, including sha2
#    else {
#
#        # encode output, needed by sha256_hex() only non utf8 signs
#        $Self->{EncodeObject}->EncodeOutput( \$Pw );
#
#        $CryptedPw = sha256_hex($Pw);
#
#    }
#
#    # update db
#    if ( $Self->{Table} && $Self->{Pw} && $Self->{Key} ) {
#        my $SQL = "UPDATE $Self->{Table} SET "
#                . " $Self->{Pw} = '" . $Self->{DBObject}->Quote($CryptedPw) . "' "
#                . " WHERE ";
#
#        # check if CustomerKey is var or int
#        for my $Entry ( @{ $Params{Config}->{Map} } ) {
#            if ( $Entry->[0] eq 'UserLogin' && $Entry->[5] =~ /^int$/i ) {
#                $Self->{CustomerKeyInteger} = 1;
#                last;
#            }
#        }
#
#        if ( $Self->{CustomerKeyInteger} ) {
#
#            # return if login is no integer
#            return if $Login !~ /^(\+|\-|)\d{1,16}$/;
#
#            $SQL
#                .= "$Self->{Key} = " . $Self->{DBObject}->Quote( $Login, 'Integer' );
#        }
#        else {
#            if ( $Params{Config}->{Params}->{CaseSensitive} ) {
#                $SQL .= "$Self->{Key} = '"
#                    . $Self->{DBObject}->Quote( $Login ) . "'";
#            }
#            else {
#                $SQL .= "LOWER($Self->{Key}) = LOWER('"
#                    . $Self->{DBObject}->Quote( $Login ) . "')";
#            }
#
#        }
#
#        return if !$Self->{DBObject}->Do( SQL => $SQL );
#
#        # log notice
#        $Self->{LogObject}->Log(
#            Priority => 'notice',
#            Message  => "CustomerUser: '$Login' changed password successfully!",
#        );
#    }
#
#    # need no pw to set
#    return;
#}
#
#sub CheckUser {
#    my ( $Self, %Param ) = @_;
#
#    # check needed stuff
#    if ( !$Param{UserLogin} ) {
#        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User!" );
#        return;
#    }
#
#    # get params
#    my $User       = $Param{UserLogin}      || '';
#    my $UserID     = '';
#
#    # sql query
#    my $SQL =
#        "SELECT $Self->{Key} FROM $Self->{Table} WHERE "
#      . " $Self->{Key} = '"
#      . $Self->{DBObject}->Quote($User) . "'";
#
#    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
#
#    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
#        $UserID = $Row[0];
#    }
#    return $UserID;
#
#}

sub DESTROY {
    my $Self = shift;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }
    return 1;
}

1;
