# --
# Kernel/System/CustomerAuth.pm - provides the authentication
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerAuth;

use strict;
use warnings;

use Kernel::System::CustomerUser;

=head1 NAME

Kernel::System::CustomerAuth - customer authentication module.

=head1 SYNOPSIS

The authentication module for the customer interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::CustomerAuth;

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
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $AuthObject = Kernel::System::CustomerAuth->new(
        EncodeObject => $EncodeObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject MainObject EncodeObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get customer user object to validate customers
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # load generator auth module
    for my $Count ( '', 1 .. 10 ) {
        my $GenericModule = $Self->{ConfigObject}->Get("Customer::AuthModule$Count");
        next if !$GenericModule;

        if ( !$Self->{MainObject}->Require($GenericModule) ) {
            $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"Backend$Count"} = $GenericModule->new( %{$Self}, Count => $Count );
    }

    return $Self;
}

=item GetOption()

Get module options. Currently there is just one option, "PreAuth".

    if ($AuthObject->GetOption(What => 'PreAuth')) {
        print "No login screen is needed. Authentication is based on other options. E. g. $ENV{REMOTE_USER}\n";
    }

=cut

sub GetOption {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->GetOption(%Param);
}

=item Auth()

The authentication function.

    if ($AuthObject->Auth(User => $User, Pw => $Pw)) {
        print "Auth ok!\n";
    }
    else {
        print "Auth invalid!\n";
    }

=cut

sub Auth {
    my ( $Self, %Param ) = @_;

    # use all 11 backends and return on first auth
    my $User;
    for ( '', 1 .. 10 ) {

        # next on no config setting
        next if !$Self->{"Backend$_"};

        # check auth backend
        $User = $Self->{"Backend$_"}->Auth(%Param);

        # remember auth backend
        if ($User) {
            $Self->{CustomerUserObject}->SetPreferences(
                Key    => 'UserAuthBackend',
                Value  => $_,
                UserID => $User,
            );
            last;
        }
    }

    # check if record exists
    if ( !$User ) {
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $Param{User} );
        if (%CustomerData) {
            my $Count = $CustomerData{UserLoginFailed} || 0;
            $Count++;
            $Self->{CustomerUserObject}->SetPreferences(
                Key    => 'UserLoginFailed',
                Value  => $Count,
                UserID => $CustomerData{UserLogin},
            );
        }
        return;
    }

    # check if user is valid
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $User );
    if ( defined $CustomerData{ValidID} && $CustomerData{ValidID} ne 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$User' is set to invalid, can't login!",
        );
        return;
    }

    return $User if !%CustomerData;

    # reset failed logins
    $Self->{CustomerUserObject}->SetPreferences(
        Key    => 'UserLoginFailed',
        Value  => 0,
        UserID => $CustomerData{UserLogin},
    );

    # last login preferences update
    $Self->{CustomerUserObject}->SetPreferences(
        Key    => 'UserLastLogin',
        Value  => $Self->{TimeObject}->SystemTime(),
        UserID => $CustomerData{UserLogin},
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
