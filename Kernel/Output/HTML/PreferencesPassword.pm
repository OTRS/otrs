# --
# Kernel/Output/HTML/PreferencesPassword.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PreferencesPassword.pm,v 1.1 2004-12-28 01:19:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesPassword;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get env
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    push (@Params, {
            %Param,
            Key => 'New password',
            Name => 'NewPw',
            Block => 'Password'
        },
        {
            %Param,
            Key => 'New password again',
            Name => 'NewPw1',
            Block => 'Password'
        },
    );
    return @Params;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # pref update db
    if ($Self->{ConfigObject}->Get('DemoSystem')) {
#        $Self->{Error} = "Can't change password, it's a demo system!";
        return 1;
    }

    my $Pw = '';
    my $Pw1 = '';

    if ($Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0]) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    if ($Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0]) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    if ($Pw ne $Pw1) {
        $Self->{Error} = "Passwords dosn't match! Please try it again!";
        return;
    }
    # check pw
    if ($Pw !~ /[a-z]|[A-z]|[0-9]|\.|;|,|:|-|\+|#|!|\$|&|\?/) {
#        $Self->{Error} = 'Erlaubte Zeichen sind: a-zA-z0-9.;,:-+#!\$&?!';
#        return;
    }
    if ($Pw !~ /^......../) {
#        $Self->{Error} = 'Passwort muss min. 8 Zeichen lang sein!';
#       return;
    }
    if ($Pw !~ /[A-Z]/ || $Pw !~ /[a-z]/) {
#        $Self->{Error} = 'Im Passwort muss mindestens ein großgeschriebener und ein kleingeschriebener Buchstabe enthalten sein!';
#       return;
    }
    if ($Pw !~ /\d/) {
#        $Self->{Error} = 'Passwort muss mit eine Zahl enthalten!';
#       return;
    }
    if ($Pw !~ /[A-z][A-z]/) {
#        $Self->{Error} = 'Passwort muss zwei Buchstaben enthalten!';
#        return;
    }
    # check current pw
    if ($Param{UserData}->{UserPw} && (crypt($Pw, $Param{UserData}->{UserLogin}) eq $Param{UserData}->{UserPw})) {
        $Self->{Error} = 'Password is already in use! Please use an other password!';
        return;
    }
    # check last pw
    if ($Param{UserData}->{UserLastPw} && (crypt($Pw, $Param{UserData}->{UserLogin}) eq $Param{UserData}->{UserLastPw})) {
        $Self->{Error} = "Password is already used! Please use an other password!";
       return;
    }

    if ($Self->{UserObject}->SetPassword(UserLogin => $Param{UserData}->{UserLogin}, PW => $Pw)) {
       if ($Param{UserData}->{UserID} eq $Self->{UserID}) {
           # update SessionID
           $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => 'UserLastPw',
                Value => $Param{UserData}->{UserPw},
           );
           # update SessionID
           $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => 'UserPw',
                Value => crypt($Pw, $Param{UserData}->{UserLogin}),
           );
        }
        $Self->{Message} = "Preferences updated successfully!";
        return 1;
    }
    return;
}
sub Error {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Error} || '';
}
sub Message {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Message} || '';
}

1;
