# --
# Helper.pm - unit test helper functions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Helper;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Kernel::System::SysConfig;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
    'Kernel::System::Main',
    'Kernel::System::UnitTest',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::UnitTest::Helper - unit test helper functions

=over 4

=cut

=item new()

construct a helper object.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::UnitTest::Helper' => {
            RestoreSystemConfiguration => 1,        # optional, save ZZZAuto.pm
                                                    # and restore it in the destructor
        },
    );
    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{UnitTestObject} = $Kernel::OM->Get('Kernel::System::UnitTest');

    # make backup of system configuration if needed
    if ( $Param{RestoreSystemConfiguration} ) {
        $Self->{SysConfigObject} = Kernel::System::SysConfig->new();

        $Self->{SysConfigBackup} = $Self->{SysConfigObject}->Download();

        $Self->{UnitTestObject}->True( 1, 'Creating backup of the system configuration' );
    }

    # set environment variable to skip SSL certificate verification if needed
    if ( $Param{SkipSSLVerify} ) {

        # remember original value
        $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME} = $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME};

        # set environment value to 0
        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

        $Self->{RestoreSSLVerify} = 1;
        $Self->{UnitTestObject}->True( 1, 'Skipping SSL certificates verification' );
    }

    return $Self;
}

=item GetRandomID()

creates a random ID that can be used in tests as a unique identifier.

=cut

# Make sure that every RandomID is only generated once in a process to
#   ensure predictability for unit test runs.
my %SeenRandomIDs;

sub GetRandomID {
    my ( $Self, %Param ) = @_;

    LOOP:
    for ( 1 .. 1_000 ) {
        my $RandomID = 'test' . time() . int( rand(1_000_000_000) );
        if ( !$SeenRandomIDs{$RandomID}++ ) {
            return $RandomID;
        }
    }

    die "Could not generate RandomID!\n";
}

=item TestUserCreate()

creates a test user that can be used in tests. It will
be set to invalid automatically during the destructor. Returns
the login name of the new user, the password is the same.

    my $TestUserLogin = $Helper->TestUserCreate(
        Groups => ['admin', 'users'],           # optional, list of groups to add this user to (rw rights)
        Language => 'de'                        # optional, defaults to 'en' if not set
    );

=cut

sub TestUserCreate {
    my ( $Self, %Param ) = @_;

    # create test user
    my $TestUserLogin = $Self->GetRandomID();

    # disable email checks to create new user
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
        UserFirstname => $TestUserLogin,
        UserLastname  => $TestUserLogin,
        UserLogin     => $TestUserLogin,
        UserPw        => $TestUserLogin,
        UserEmail     => $TestUserLogin . '@localunittest.com',
        ValidID       => 1,
        ChangeUserID  => 1,
    ) || die "Could not create test user";

    # Remember UserID of the test user to later set it to invalid
    #   in the destructor.
    $Self->{TestUsers} ||= [];
    push( @{ $Self->{TestUsers} }, $TestUserID );

    $Self->{UnitTestObject}->True( 1, "Created test user $TestUserID" );

    # Add user to groups
    GROUP_NAME:
    for my $GroupName ( @{ $Param{Groups} || [] } ) {

        # get group object
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $GroupID = $GroupObject->GroupLookup( Group => $GroupName );
        die "Cannot find group $GroupName" if ( !$GroupID );

        $GroupObject->GroupMemberAdd(
            GID        => $GroupID,
            UID        => $TestUserID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                owner     => 1,
                priority  => 1,
                rw        => 1,
            },
            UserID => 1,
        ) || die "Could not add test user $TestUserLogin to group $GroupName";

        $Self->{UnitTestObject}->True( 1, "Added test user $TestUserLogin to group $GroupName" );
    }

    # set user language
    my $UserLanguage = $Param{Language} || 'en';
    $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
        UserID => $TestUserID,
        Key    => 'UserLanguage',
        Value  => $UserLanguage,
    );
    $Self->{UnitTestObject}->True( 1, "Set user UserLanguage to $UserLanguage" );

    return $TestUserLogin;
}

=item TestCustomerUserCreate()

creates a test customer user that can be used in tests. It will
be set to invalid automatically during the destructor. Returns
the login name of the new customer user, the password is the same.

    my $TestUserLogin = $Helper->TestCustomerUserCreate(
        Language => 'de',   # optional, defaults to 'en' if not set
    );

=cut

sub TestCustomerUserCreate {
    my ( $Self, %Param ) = @_;

    # disable email checks to create new user
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # create test user
    my $TestUserLogin = $Self->GetRandomID();

    my $TestUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => $TestUserLogin,
        UserLastname   => $TestUserLogin,
        UserCustomerID => $TestUserLogin,
        UserLogin      => $TestUserLogin,
        UserPassword   => $TestUserLogin,
        UserEmail      => $TestUserLogin . '@localunittest.com',
        ValidID        => 1,
        UserID         => 1,
    ) || die "Could not create test user";

    # Remember UserID of the test user to later set it to invalid
    #   in the destructor.
    $Self->{TestCustomerUsers} ||= [];
    push( @{ $Self->{TestCustomerUsers} }, $TestUser );

    $Self->{UnitTestObject}->True( 1, "Created test customer user $TestUser" );

    # set customer user language
    my $UserLanguage = $Param{Language} || 'en';
    $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
        UserID => $TestUser,
        Key    => 'UserLanguage',
        Value  => $UserLanguage,
    );
    $Self->{UnitTestObject}->True( 1, "Set customer user UserLanguage to $UserLanguage" );

    return $TestUser;
}

my $FixedTime;

=item FixedTimeSet()

makes it possible to override the system time as long as this object lives.
You can pass an optional time parameter that should be used, if not,
the current system time will be used.

All regular perl calls to time(), localtime() and gmtime() will use this
fixed time afterwards. If this object goes out of scope, the 'normal' system
time will be used again.

=cut

sub FixedTimeSet {
    my ( $Self, $TimeToSave ) = @_;

    $FixedTime = $TimeToSave // CORE::time();

    # This is needed to reload objects that directly use the time functions
    #   to get a hold of the overrides.
    my @Objects = (
        'Kernel::System::Time',
        'Kernel::System::Cache::FileStorable',
        'Kernel::System::PID',
    );

    for my $Object (@Objects) {
        my $FilePath = $Object;
        $FilePath =~ s{::}{/}xmsg;
        $FilePath .= '.pm';
        if ( $INC{$FilePath} ) {
            no warnings 'redefine';
            delete $INC{$FilePath};
            $Kernel::OM->Get('Kernel::System::Main')->Require($Object);
        }
    }

    return $FixedTime;
}

=item FixedTimeUnset()

restores the regular system time behaviour.

=cut

sub FixedTimeUnset {
    my ($Self) = @_;

    undef $FixedTime;

    return;
}

=item FixedTimeAddSeconds()

adds a number of seconds to the fixed system time which was previously
set by FixedTimeSet(). You can pass a negative value to go back in time.

=cut

sub FixedTimeAddSeconds {
    my ( $Self, $SecondsToAdd ) = @_;

    return if ( !defined $FixedTime );
    $FixedTime += $SecondsToAdd;
    return;
}

# See http://perldoc.perl.org/5.10.0/perlsub.html#Overriding-Built-in-Functions
BEGIN {
    *CORE::GLOBAL::time = sub {
        return defined $FixedTime ? $FixedTime : CORE::time();
    };
    *CORE::GLOBAL::localtime = sub {
        my ($Time) = @_;
        if ( !defined $Time ) {
            $Time = defined $FixedTime ? $FixedTime : CORE::time();
        }
        return CORE::localtime($Time);
    };
    *CORE::GLOBAL::gmtime = sub {
        my ($Time) = @_;
        if ( !defined $Time ) {
            $Time = defined $FixedTime ? $FixedTime : CORE::time();
        }
        return CORE::gmtime($Time);
    };
}

sub DESTROY {
    my $Self = shift;

    # Reset time freeze
    FixedTimeUnset();

    #
    # Restore system configuration if needed
    #
    if ( $Self->{SysConfigBackup} ) {

        $Self->{SysConfigObject}->Upload( Content => $Self->{SysConfigBackup} );

        $Self->{UnitTestObject}->True( 1, 'Restored the system configuration' );
    }

    #
    # Restore environment variable to skip SSL certificate verification if needed
    #
    if ( $Self->{RestoreSSLVerify} ) {

        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME};

        $Self->{RestoreSSLVerify} = 0;

        $Self->{UnitTestObject}->True( 1, 'Restored SSL certificates verification' );
    }

    # disable email checks to create new user
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # invalidate test users
    if ( ref $Self->{TestUsers} eq 'ARRAY' && @{ $Self->{TestUsers} } ) {
        for my $TestUser ( @{ $Self->{TestUsers} } ) {

            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $TestUser,
            );

            # make test user invalid
            my $Success = $Kernel::OM->Get('Kernel::System::User')->UserUpdate(
                %User,
                ValidID      => 2,
                ChangeUserID => 1,
            );

            $Self->{UnitTestObject}->True( $Success, "Set test user $TestUser to invalid" );
        }
    }

    # invalidate test customer users
    if ( ref $Self->{TestCustomerUsers} eq 'ARRAY' && @{ $Self->{TestCustomerUsers} } ) {
        for my $TestCustomerUser ( @{ $Self->{TestCustomerUsers} } ) {

            my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $TestCustomerUser,
            );

            my $Success = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
                %CustomerUser,
                ID      => $CustomerUser{UserID},
                ValidID => 2,
                UserID  => 1,
            );

            $Self->{UnitTestObject}->True(
                $Success, "Set test customer user $TestCustomerUser to invalid"
            );
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
