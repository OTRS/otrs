# --
# Kernel/System/Auth.pm - provides the authentification
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Auth.pm,v 1.33 2009-02-16 11:58:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Auth;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.33 $) [1];

=head1 NAME

Kernel::System::Auth - agent autentification module.

=head1 SYNOPSIS

The autentification module for the agent interface.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::User;
    use Kernel::System::Group;
    use Kernel::System::Auth;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

    my $AuthObject = Kernel::System::Auth->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        UserObject   => $UserObject,
        GroupObject  => $GroupObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject UserObject GroupObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

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

Get module options. Currently exists just one option, "PreAuth".

    if ($AuthObject->GetOption(What => 'PreAuth')) {
        print "No login screen is needed. Autentificaion is based on some other options. E. g. $ENV{REMOTE_USER}\n";
    }

=cut

sub GetOption {
    my ( $Self, %Param ) = @_;

    return $Self->{AuthBackend}->GetOption(%Param);
}

=item Auth()

The autentificaion function.

    if ($AuthObject->Auth(User => $User, Pw => $Pw)) {
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

        # use all 11 sync backends
        for my $Count ( '', 1 .. 10 ) {

            # return on no config setting
            next if !$Self->{"AuthSyncBackend$Count"};

            # sync backend
            $Self->{"AuthSyncBackend$Count"}->Sync( %Param, User => $User );
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
    return if !$User;

    # return auth user
    return $User;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.33 $ $Date: 2009-02-16 11:58:56 $

=cut
