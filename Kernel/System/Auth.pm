# --
# Kernel/System/Auth.pm - provides the authentication
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Auth.pm,v 1.53 2012-01-17 16:14:47 te Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.53 $) [1];

=head1 NAME

Kernel::System::Auth - agent authentication module.

=head1 SYNOPSIS

The authentication module for the agent interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::User;
    use Kernel::System::Group;
    use Kernel::System::Auth;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $AuthObject = Kernel::System::Auth->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        UserObject   => $UserObject,
        GroupObject  => $GroupObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(LogObject ConfigObject DBObject UserObject GroupObject MainObject EncodeObject TimeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    # load auth module
    for my $Count ( '', 1 .. 10 ) {
        my $GenericModule = $Self->{ConfigObject}->Get("AuthModule$Count");
        next if !$GenericModule;

        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"AuthBackend$Count"} = $GenericModule->new( %Param, Count => $Count );
    }

    # load sync module
    for my $Count ( '', 1 .. 10 ) {
        my $GenericModule = $Self->{ConfigObject}->Get("AuthSyncModule$Count");
        next if !$GenericModule;

        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"AuthSyncBackend$Count"} = $GenericModule->new( %Param, Count => $Count );
    }

    return $Self;
}

=item GetOption()

Get module options. Currently there is just one option, "PreAuth".

    if ( $AuthObject->GetOption( What => 'PreAuth' ) ) {
        print "No login screen is needed. Authentication is based on some other options. E. g. $ENV{REMOTE_USER}\n";
    }

=cut

sub GetOption {
    my ( $Self, %Param ) = @_;

    return $Self->{AuthBackend}->GetOption(%Param);
}

=item Auth()

The authentication function.

    if ( $AuthObject->Auth( User => $User, Pw => $Pw ) ) {
        print "Auth ok!\n";
    }
    else {
        print "Auth invalid!\n";
    }

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    # brutforce prevention
    my $UserID = $Self->{UserObject}->UserLookup(
        UserLogin => $Param{User},
    );

    if ( !$UserID ) {
        return;
    }

    my %User = $Self->{UserObject}->GetUserData(
        UserID => $UserID,
        Valid  => 1,
        Cached => 1,
    );

    if ( !%User ) {
        return;
    }
    else {
        my $Config     = $Self->{ConfigObject}->Get('PreferencesGroups');
        my $SystemTime = $Self->{TimeObject}->SystemTime();
        my $PasswordMaxLoginFailed;
        my $NextPossibleLoginTime;

        if (
            $User{UserLoginFailed}
            && $User{UserLastLoginFailed}
            && $Config
            && $Config->{Password}
            && $Config->{Password}->{PasswordMaxLoginFailed}
            && $Config->{Password}->{PasswordMaxLoginFailedTimeout}
            )
        {
            $PasswordMaxLoginFailed = $Config->{Password}->{PasswordMaxLoginFailed};
            $NextPossibleLoginTime
                = $User{UserLastLoginFailed} + $Config->{Password}->{PasswordMaxLoginFailedTimeout};
        }

        if (
            $PasswordMaxLoginFailed
            && $NextPossibleLoginTime
            && $User{UserLoginFailed} >= $PasswordMaxLoginFailed
            && $NextPossibleLoginTime >= $SystemTime
            )
        {
            my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $NextPossibleLoginTime,
                Type       => 'Short',
            );
            $Self->{LogObject}->Log(
                Priority => 'Info',
                Message =>
                    "BruteForce attack for user '$Param{User}' detected. Next possible login at $TimeStamp!",
            );
            return;
        }
    }

    # use all 11 auth backends and return on first true
    my $User;
    for my $Count ( '', 1 .. 10 ) {

        # return on no config setting
        next if !$Self->{"AuthBackend$Count"};

        # check auth backend
        $User = $Self->{"AuthBackend$Count"}->Auth(%Param);

        # next on no success
        next if !$User;

        # configured auth sync backend
        my $AuthSyncBackend = $Self->{ConfigObject}->Get("AuthModule${Count}::UseSyncBackend");

        # sync with configured auth backend
        if ( defined $AuthSyncBackend ) {

            # if $AuthSyncBackend is defined but empty, don't sync with any backend
            if ($AuthSyncBackend) {

                # sync configured backend
                $Self->{$AuthSyncBackend}->Sync( %Param, User => $User );
            }
        }

        # use all 11 sync backends
        else {
            for my $Count ( '', 1 .. 10 ) {

                # return on no config setting
                next if !$Self->{"AuthSyncBackend$Count"};

                # sync backend
                $Self->{"AuthSyncBackend$Count"}->Sync( %Param, User => $User );
            }
        }

        # remember auth backend
        my $UserID = $Self->{UserObject}->UserLookup(
            UserLogin => $User,
        );
        if ($UserID) {
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserAuthBackend',
                Value  => $Count,
                UserID => $UserID,
            );
        }

        # last if user is true
        last if $User;
    }

    # return if no auth user
    if ( !$User ) {

        # remember failed logins
        if ($UserID) {
            my $Count = $User{UserLoginFailed} || 0;
            $Count++;
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserLoginFailed',
                Value  => $Count,
                UserID => $UserID,
            );

            # last login failed preferences update
            $Self->{UserObject}->SetPreferences(
                Key    => 'UserLastLoginFailed',
                Value  => $Self->{TimeObject}->SystemTime(),
                UserID => $UserID,
            );
        }
        return;
    }

    # remember login attributes
    if ($UserID) {

        # reset failed logins
        $Self->{UserObject}->SetPreferences(
            Key    => 'UserLoginFailed',
            Value  => 0,
            UserID => $UserID,
        );

        # last login preferences update
        $Self->{UserObject}->SetPreferences(
            Key    => 'UserLastLogin',
            Value  => $Self->{TimeObject}->SystemTime(),
            UserID => $UserID,
        );

        # last login preferences update
        $Self->{UserObject}->SetPreferences(
            Key    => 'UserLastLoginTimestamp',
            Value  => $Self->{TimeObject}->CurrentTimestamp(),
            UserID => $UserID,
        );
    }

    # return auth user
    return $User;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.53 $ $Date: 2012-01-17 16:14:47 $

=cut
