# --
# Kernel/System/Auth.pm - provides the authentication
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA);

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

    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    # load auth module
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        my $GenericModule = $Self->{ConfigObject}->Get("AuthModule$Count");

        next COUNT if !$GenericModule;

        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
        }

        $Self->{"AuthBackend$Count"} = $GenericModule->new( %Param, Count => $Count );
    }

    # load sync module
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        my $GenericModule = $Self->{ConfigObject}->Get("AuthSyncModule$Count");

        next COUNT if !$GenericModule;

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
        my $AuthSyncBackend = $Self->{ConfigObject}->Get("AuthModule::UseSyncBackend$Count");
        if (! defined $AuthSyncBackend) {
          $AuthSyncBackend = $Self->{ConfigObject}->Get("AuthModule{$Count}::UseSyncBackend");
        }

    # for backwards compatibility, OTRS 3.1.1, 3.1.2 and 3.1.3 used this wrong format (see bug#8387)

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
        my $UserID = $Self->{UserObject}->UserLookup(
            UserLogin => $Param{User},
        );

        return if !$UserID;

        my %User = $Self->{UserObject}->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );

        my $Count = $User{UserLoginFailed} || 0;
        $Count++;

        $Self->{UserObject}->SetPreferences(
            Key    => 'UserLoginFailed',
            Value  => $Count,
            UserID => $UserID,
        );

        # set agent to invalid-temporarily if max failed logins reached
        my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
        my $PasswordMaxLoginFailed;

        if ( $Config && $Config->{Password} && $Config->{Password}->{PasswordMaxLoginFailed} ) {
            $PasswordMaxLoginFailed = $Config->{Password}->{PasswordMaxLoginFailed};
        }

        return if !%User;
        return if !$PasswordMaxLoginFailed;
        return if $Count < $PasswordMaxLoginFailed;

        my $ValidID = $Self->{ValidObject}->ValidLookup( Valid => 'invalid-temporarily' );

        my $Update = $Self->{UserObject}->UserUpdate(
            %User,
            ValidID      => $ValidID,
            ChangeUserID => 1,
        );

        return if !$Update;

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Login failed $Count times. Set $User{UserLogin} to "
                . "'invalid-temporarily'.",
        );

        return;
    }

    # remember login attributes
    my $UserID = $Self->{UserObject}->UserLookup(
        UserLogin => $User,
    );

    return $User if !$UserID;

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
