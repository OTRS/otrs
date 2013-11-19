# --
# Kernel/Output/HTML/PreferencesPassword.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: PreferencesPassword.pm,v 1.27 2010-09-06 07:23:05 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesPassword;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.27 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem MainObject))
    {
        die "Got no $_!" if !$Self->{$_};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if we need to show password change option
    if ( $Self->{ConfigItem}->{Area} eq 'Agent' ) {

        # get auth module
        my $Module      = $Self->{ConfigObject}->Get('AuthModule');
        my $AuthBackend = $Param{UserData}->{UserAuthBackend};
        if ($AuthBackend) {
            $Module = $Self->{ConfigObject}->Get( 'AuthModule' . $AuthBackend );
        }

        # return on no pw reset backends
        return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;
    }

    # check if we need to show password change option
    elsif ( $Self->{ConfigItem}->{Area} eq 'Customer' ) {

        # get auth module
        my $Module      = $Self->{ConfigObject}->Get('Customer::AuthModule');
        my $AuthBackend = $Param{UserData}->{UserAuthBackend};
        if ($AuthBackend) {
            $Module = $Self->{ConfigObject}->Get( 'Customer::AuthModule' . $AuthBackend );
        }

        # return on no pw reset backends
        return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;
    }
    my @Params;
    push(
        @Params,
        {
            %Param,
            Key   => 'New password',
            Name  => 'NewPw',
            Block => 'Password'
        },
        {
            %Param,
            Key   => 'Verify password',
            Name  => 'NewPw1',
            Block => 'Password'
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # pref update db
    return 1 if $Self->{ConfigObject}->Get('DemoSystem');

    # get password from form
    my $Pw;
    if ( $Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0] ) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    my $Pw1;
    if ( $Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0] ) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error}
            = 'Can\'t update password, your new passwords do not match. Please try again!';
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = 'Please supply your new password!';
        return;
    }

    # check pw
    my $Config = $Self->{ConfigItem};

    # check if password is not matching PasswordRegExp
    if ( $Config->{PasswordRegExp} && $Pw !~ /$Config->{PasswordRegExp}/ ) {
        $Self->{Error} = 'Can\'t update password, it contains invalid characters!';
        return;
    }

    # check min size of password
    if ( $Config->{PasswordMinSize} && length $Pw < $Config->{PasswordMinSize} ) {
        $Self->{Error} = (
            'Can\'t update password, it must be at least %s characters long!", "'
                . $Config->{PasswordMinSize}
        );
        return;
    }

    # check min 1 lower and 1 upper char
    if ( $Config->{PasswordMin2Lower2UpperCharacters} && ( $Pw !~ /[A-Z]/ || $Pw !~ /[a-z]/ ) ) {
        $Self->{Error}
            = 'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!';
        return;
    }

    # check min 1 digit password
    if ( $Config->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = 'Can\'t update password, it must contain at least 1 digit!';
        return;
    }

    # check min 2 char password
    if ( $Config->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = 'Can\'t update password, it must contain at least 2 characters!';
        return;
    }

    # md5 sum for new pw, needed for password history
    my $MD5Pw = $Self->{MainObject}->MD5sum(
        String => $Pw,
    );
    if ( $Param{UserData}->{UserLastPw} && ( $MD5Pw eq $Param{UserData}->{UserLastPw} ) ) {
        $Self->{Error}
            = "Can\'t update password, this password has already been used. Please choose a new one!";
        return;
    }

    # set new password
    my $Success = $Self->{UserObject}->SetPassword(
        UserLogin => $Param{UserData}->{UserLogin},
        PW        => $Pw,
    );
    return if !$Success;

    # set current session data for UserLastPw
    if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {

        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserLastPw',
            Value     => $MD5Pw,
        );
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
