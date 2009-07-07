# --
# Kernel/Output/HTML/PreferencesPassword.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PreferencesPassword.pm,v 1.22 2009-07-07 15:45:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesPassword;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

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

    my @Params = ();
    if ( $Self->{ConfigItem}->{Area} eq 'Agent' ) {

        # get auth module
        my $Module      = $Self->{ConfigObject}->Get('AuthModule');
        my $AuthBackend = $Param{UserData}->{UserAuthBackend};
        if ($AuthBackend) {
            $Module = $Self->{ConfigObject}->Get( 'AuthModule' . $AuthBackend );
        }

        # return on no pw reset backends
        if ( $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i ) {
            return ();
        }
    }
    elsif ( $Self->{ConfigItem}->{Area} eq 'Customer' ) {

        # get auth module
        my $Module      = $Self->{ConfigObject}->Get('Customer::AuthModule');
        my $AuthBackend = $Param{UserData}->{UserAuthBackend};
        if ($AuthBackend) {
            $Module = $Self->{ConfigObject}->Get( 'Customer::AuthModule' . $AuthBackend );
        }

        # return on no pw reset backends
        if ( $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i ) {
            return ();
        }
    }
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
            Key   => 'New password again',
            Name  => 'NewPw1',
            Block => 'Password'
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # pref update db
    if ( $Self->{ConfigObject}->Get('DemoSystem') ) {
        return 1;
    }

    my $Pw  = '';
    my $Pw1 = '';

    if ( $Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0] ) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    if ( $Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0] ) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error}
            = 'Can\'t update password, your new passwords do not match! Please try again!';
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = "Please supply your new password!";
        return;
    }

    # check pw
    if ( $Self->{ConfigItem}->{PasswordRegExp} && $Pw !~ /$Self->{ConfigItem}->{PasswordRegExp}/ ) {
        $Self->{Error} = 'Can\'t update password, invalid characters!';
        return;
    }
    if (
        $Self->{ConfigItem}->{PasswordMinSize}
        && length $Pw < $Self->{ConfigItem}->{PasswordMinSize}
        )
    {
        $Self->{Error} = (
            'Can\'t update password, must be at least %s characters!", "'
                . $Self->{ConfigItem}->{PasswordMinSize}
        );
        return;
    }
    if (
        $Self->{ConfigItem}->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z]/ || $Pw !~ /[a-z]/ )
        )
    {
        $Self->{Error} = 'Can\'t update password, must contain 2 lower and 2 upper characters!';
        return;
    }
    if ( $Self->{ConfigItem}->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = 'Can\'t update password, needs at least 1 digit!';
        return;
    }
    if ( $Self->{ConfigItem}->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = 'Can\'t update password, needs at least 2 characters!';
        return;
    }

    # md5 sum for new pw, needed for password history
    my $MD5Pw = $Self->{MainObject}->MD5sum(
        String => $Pw,
    );

    if (
        $Self->{ConfigItem}->{PasswordHistory}
        && $Param{UserData}->{UserLastPw}
        && ( $MD5Pw eq $Param{UserData}->{UserLastPw} )
        )
    {
        $Self->{Error} = "Password is already used! Please use an other password!";
        return;
    }

    if ( $Self->{UserObject}->SetPassword( UserLogin => $Param{UserData}->{UserLogin}, PW => $Pw ) )
    {
        if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {

            # update SessionID
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'UserLastPw',
                Value     => $Param{UserData}->{UserPw},
            );

            # encode output, needed by crypt() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Param{UserData}->{UserLogin} );
            $Self->{EncodeObject}->EncodeOutput( \$Pw );

            # update SessionID
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'UserPw',
                Value     => crypt( $Pw, $Param{UserData}->{UserLogin} ),
            );
        }
        $Self->{Message} = "Preferences updated successfully!";
        return 1;
    }
    return;
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
