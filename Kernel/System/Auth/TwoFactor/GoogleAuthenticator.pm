# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth::TwoFactor::GoogleAuthenticator;

use strict;
use warnings;

use Digest::SHA qw(sha1);
use Digest::HMAC qw(hmac_hex);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Count} = $Param{Count} || '';

    return $Self;
}

sub Auth {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(User UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $SecretPreferencesKey = $ConfigObject->Get("AuthTwoFactorModule$Self->{Count}::SecretPreferencesKey") || '';
    if ( !$SecretPreferencesKey ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no configuration for SecretPreferencesKey in AuthTwoFactorModule.",
        );
        return;
    }

    # check if user has secret stored in preferences
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Param{UserID},
    );
    if ( !$UserPreferences{$SecretPreferencesKey} ) {

        # if login without a stored secret key is permitted, this counts as passed
        if ( $ConfigObject->Get("AuthTwoFactorModule$Self->{Count}::AllowEmptySecret") ) {
            return 1;
        }

        # otherwise login counts as failed
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no SecretPreferencesKey for user $Param{User}.",
        );
        return;
    }

    # if we get to here (user has preference), we need a passed token
    if ( !$Param{TwoFactorToken} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TwoFactorToken!"
        );
        return;
    }

    # generate otp based on secret from preferences
    my $OTP = $Self->_GenerateOTP(
        Secret => $UserPreferences{$SecretPreferencesKey},
    );

    # compare against user provided otp
    if ( $Param{TwoFactorToken} ne $OTP ) {

        # check if previous token is also to be accepted
        return if !$ConfigObject->Get("AuthTwoFactorModule$Self->{Count}::AllowPreviousToken");

        # try again with previous otp (from 30 seconds ago)
        $OTP = $Self->_GenerateOTP(
            Secret   => $UserPreferences{$SecretPreferencesKey},
            Previous => 1,
        );
        return if $Param{TwoFactorToken} ne $OTP;
    }

    # log success
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "User: $Param{User} two factor authentication ok.",
    );

    return 1;
}

sub _GenerateOTP {
    my ( $Self, %Param ) = @_;

    # algorithm based on RfC 6238

    # get unix timestamp divided by 30
    my $TimeStamp = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    $TimeStamp = int( $TimeStamp / 30 );

    # on request use previous 30-second time period
    if ( $Param{Previous} ) {
        --$TimeStamp;
    }

    # extend to 16 character hex value
    my $PaddedTimeStamp = sprintf "%016x", $TimeStamp;

    # encrypt timestamp with secret
    my $PackedTimeStamp = pack 'H*', $PaddedTimeStamp;
    my $Base32Secret = $Self->_DecodeBase32( Secret => $Param{Secret} );
    my $HMAC = hmac_hex( $PackedTimeStamp, $Base32Secret, \&sha1 );

    # now treat hmac to get 6 numerical digits

    # Use 4 last bits as offset, then truncate to 4 bytes starting at the offset and remove most significant bit
    my $Offset = hex( substr( $HMAC, -1 ) );
    my $TruncatedHMAC = hex( substr( $HMAC, $Offset * 2, 8 ) ) & 0x7fffffff;

    # use last 6 digits (modulo 1.000.000) as token
    my $Token = $TruncatedHMAC % 1000000;

    # make sure to use all 6 digits (0-padded)
    return sprintf( "%06d", $Token );
}

sub _DecodeBase32 {
    my ( $Self, %Param ) = @_;

    # based on RfC 3548, code inspired by MIME::Base32

    # convert all characters to upper case and remove whitespace (not allowed for base32)
    my $Key = uc $Param{Secret};
    $Key =~ s{ [ ]+ }{}xmsg;

    # turn into binary characters
    $Key =~ tr|A-Z2-7|\0-\37|;

    # unpack into binary
    $Key = unpack 'B*', $Key;

    # cut three most significant bits for each byte
    $Key =~ s{ 0{3} ( .{5} ) }{$1}xmsg;

    # trim string to full 8 bit units
    my $Length = length $Key;
    if ( $Length % 8 ) {
        $Key = substr( $Key, 0, $Length - $Length % 8 );
    }

    # pack back up
    $Key = pack 'B*', $Key;
    return $Key;
}

1;
