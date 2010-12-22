# --
# Helper.pm - unit test helper functions
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Helper.pm,v 1.2 2010-12-22 10:39:07 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Helper;

use strict;

use Kernel::Config;
use Kernel::System::User;
use Kernel::System::SysConfig;

=head1 NAME

Kernel::System::UnitTest::Helper - unit test helper functions

=over 4

=cut

=item new()

construct a helper object.

    use Kernel::System::UnitTest::Helper;

    my $Helper = Kernel::System::UnitTest::Helper->new(
        %{$Self},
        RestoreSystemConfiguration => 1,        # optional, save ZZZAuto.pm and restore it in the destructor
    );
=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for my $Needed (qw(UnitTestObject DBObject LogObject TimeObject MainObject EncodeObject)) {
        if ( $Param{$Needed} ) {
            $Self->{$Needed} = $Param{$Needed};
        }
        else {
            die "Got no $Needed!";
        }
    }

    # use local Config object because it will be modified
    $Self->{ConfigObject} = Kernel::Config->new();

    # disable email checks to create new user
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    $Self->{UserObject} = Kernel::System::User->new(
        %{ $Self->{UnitTestObject} },
        ConfigObject => $Self->{ConfigObject},
    );

    #
    # Make backup of system configuration if needed
    #
    if ( $Param{RestoreSystemConfiguration} ) {
        $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );

        $Self->{SysConfigBackup} = $Self->{SysConfigObject}->Download();

        $Self->{UnitTestObject}->True( 1, 'Creating backup of the system configuration' );
    }

    return $Self;
}

=item TestUserCreate()

creates a test user that can be used in the Selenium tests. It will
be set to invalid automatically during the constructor. Returns
the login name of the new user, the password is the same.

    my $TestUserLogin = $sel->TestUserCreate();

=cut

sub TestUserCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw()) {
        if ( !defined $Param{$Needed} ) {
            $Self->{UnitTestObject}->True( 0, "Cannot create test user: need $Needed!" );
            die "Cannot create test user: need $Needed!";
        }
    }

    # create test user
    my $TestUserLogin = 'selenium-test-user' . int( rand(1000000) );

    my $TestUserID = $Self->{UserObject}->UserAdd(
        UserFirstname => $TestUserLogin,
        UserLastname  => $TestUserLogin,
        UserLogin     => $TestUserLogin,
        UserPw        => $TestUserLogin,
        UserEmail     => $TestUserLogin . '@example.com',
        ValidID       => 1,
        ChangeUserID  => 1,
    ) || die "Could not create test user";

    # Remember UserID of the test user to later set it to invalid
    #   in the destructor.
    $Self->{TestUsers} ||= [];
    push( @{ $Self->{TestUsers} }, $TestUserID );

    $Self->{UnitTestObject}->True( 1, "Created test user $TestUserID" );

    return $TestUserLogin;
}

sub DESTROY {
    my $Self = shift;

    #
    # Restore system configuration if needed
    #
    if ( $Self->{SysConfigBackup} ) {

        $Self->{SysConfigObject}->Upload( Content => $Self->{SysConfigBackup} );

        $Self->{UnitTestObject}->True( 1, 'Restored the system configuration' );
    }

    # invalidate test users
    if ( ref $Self->{TestUsers} eq 'ARRAY' && @{ $Self->{TestUsers} } ) {
        for my $TestUser ( @{ $Self->{TestUsers} } ) {

            # make test user invalid
            $Self->{UserObject}->UserUpdate(
                UserID        => $TestUser,
                UserFirstname => 'Firstname Test1',
                UserLastname  => 'Lastname Test1',
                UserLogin     => $TestUser,
                UserEmail     => $TestUser . '@example.com',
                ValidID       => 2,
                ChangeUserID  => 1,
            ) || die "Could not invalidate test user";

            $Self->{UnitTestObject}->True( 1, "Set test user $TestUser to invalid" );
        }
    }
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

$Revision: 1.2 $ $Date: 2010-12-22 10:39:07 $

=cut
