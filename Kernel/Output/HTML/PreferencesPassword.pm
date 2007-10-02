# --
# Kernel/Output/HTML/PreferencesPassword.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PreferencesPassword.pm,v 1.13 2007-10-02 10:40:12 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesPassword;

use strict;
use warnings;

use Digest::MD5;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get env
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params = ();
    if ( $Self->{ConfigItem}->{Area} eq 'Agent' ) {
        if ( $Self->{ConfigObject}->Get('AuthModule') =~ /(LDAP|HTTPBasicAuth|Radius)/i ) {
            return ();
        }
    }
    elsif ( $Self->{ConfigItem}->{Area} eq 'Customer' ) {
        if ( $Self->{ConfigObject}->Get('Customer::AuthModule') =~ /(LDAP|HTTPBasicAuth|Radius)/i )
        {
            return ();
        }
    }
    push(
        @Params,
        {   %Param,
            Key   => 'New password',
            Name  => 'NewPw',
            Block => 'Password'
        },
        {   %Param,
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
        $Self->{Error} = "Can\'t update password, passwords dosn\'t match! Please try it again!";
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = "Password is needed!";
        return;
    }

    # check pw
    if ( $Self->{ConfigItem}->{PasswordRegExp} && $Pw !~ /$Self->{ConfigItem}->{PasswordRegExp}/ ) {
        $Self->{Error} = 'Can\'t update password, invalid characters!';
        return;
    }
    if (   $Self->{ConfigItem}->{PasswordMinSize}
        && $Pw !~ /^.{$Self->{ConfigItem}->{PasswordMinSize}}/ )
    {
        $Self->{Error} = 'Can\'t update password, need min. 8 characters!';
        return;
    }
    if ( $Self->{ConfigItem}->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z]/ || $Pw !~ /[a-z]/ ) )
    {
        $Self->{Error} = 'Can\'t update password, need 2 lower and 2 upper characters!';
        return;
    }
    if ( $Self->{ConfigItem}->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = 'Can\'t update password, need min. 1 digit!';
        return;
    }
    if ( $Self->{ConfigItem}->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = 'Can\'t update password, need min. 2 characters!';
        return;
    }

    # md5 sum for new pw, needed for password history
    my $MD5 = Digest::MD5->new();
    $MD5->add($Pw);
    my $MD5Pw = $MD5->hexdigest;

    if (   $Self->{ConfigItem}->{PasswordHistory}
        && $Param{UserData}->{UserLastPw}
        && ( $MD5Pw eq $Param{UserData}->{UserLastPw} ) )
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
