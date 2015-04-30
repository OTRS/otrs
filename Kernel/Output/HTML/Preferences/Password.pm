# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::Password;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Auth',
    'Kernel::System::CustomerAuth',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if we need to show password change option

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthModule'
        : 'Customer::AuthModule';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get auth module
    my $Module      = $ConfigObject->Get($AuthModule);
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $ConfigObject->Get( $AuthModule . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    my @Params;
    push(
        @Params,
        {
            %Param,
            Key   => 'Current password',
            Name  => 'CurPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => 'New password',
            Name  => 'NewPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => 'Verify password',
            Name  => 'NewPw1',
            Raw   => 1,
            Block => 'Password'
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # pref update db
    return 1 if $ConfigObject->Get('DemoSystem');

    # get password from form
    my $CurPw;
    if ( $Param{GetParam}->{CurPw} && $Param{GetParam}->{CurPw}->[0] ) {
        $CurPw = $Param{GetParam}->{CurPw}->[0];
    }
    my $Pw;
    if ( $Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0] ) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    my $Pw1;
    if ( $Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0] ) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'Auth'
        : 'CustomerAuth';

    my $AuthObject = $Kernel::OM->Get( 'Kernel::System::' . $AuthModule );
    return 1 if !$AuthObject;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # validate current password
    if (
        !$AuthObject->Auth(
            User => $Param{UserData}->{UserLogin},
            Pw   => $CurPw
        )
        )
    {
        $Self->{Error}
            = $LayoutObject->{LanguageObject}->Translate('The current password is not correct. Please try again!');
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = $LayoutObject->{LanguageObject}->Translate('Please supply your new password!');
        return;
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error} = $LayoutObject->{LanguageObject}
            ->Translate('Can\'t update password, your new passwords do not match. Please try again!');
        return;
    }

    # check pw
    my $Config = $Self->{ConfigItem};

    # check if password is not matching PasswordRegExp
    if ( $Config->{PasswordRegExp} && $Pw !~ /$Config->{PasswordRegExp}/ ) {
        $Self->{Error}
            = $LayoutObject->{LanguageObject}->Translate('Can\'t update password, it contains invalid characters!');
        return;
    }

    # check min size of password
    if ( $Config->{PasswordMinSize} && length $Pw < $Config->{PasswordMinSize} ) {
        $Self->{Error} = $LayoutObject->{LanguageObject}->Translate(
            'Can\'t update password, it must be at least %s characters long!',
            $Config->{PasswordMinSize}
        );
        return;
    }

    # check min 2 lower and 2 upper char
    if (
        $Config->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z].*[A-Z]/ || $Pw !~ /[a-z].*[a-z]/ )
        )
    {
        $Self->{Error} = $LayoutObject->{LanguageObject}
            ->Translate('Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!');
        return;
    }

    # check min 1 digit password
    if ( $Config->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error}
            = $LayoutObject->{LanguageObject}->Translate('Can\'t update password, it must contain at least 1 digit!');
        return;
    }

    # check min 2 char password
    if ( $Config->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = $LayoutObject->{LanguageObject}
            ->Translate('Can\'t update password, it must contain at least 2 characters!');
        return;
    }

    # set new password
    my $Success = $Self->{UserObject}->SetPassword(
        UserLogin => $Param{UserData}->{UserLogin},
        PW        => $Pw,
    );
    return if !$Success;

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
