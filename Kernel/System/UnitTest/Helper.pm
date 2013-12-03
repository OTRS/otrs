# --
# Helper.pm - unit test helper functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Helper;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerUser;
use Kernel::System::SysConfig;

=head1 NAME

Kernel::System::UnitTest::Helper - unit test helper functions

=over 4

=cut

=item new()

construct a helper object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::UnitTest::Helper;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
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

    $Self->{GroupObject} = Kernel::System::Group->new(
        %{ $Self->{UnitTestObject} },
        ConfigObject => $Self->{ConfigObject},
        UserObject   => $Self->{UserObject},
    );

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(
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

    #
    # Set environment variable to skip SSL certificate verification if needed
    #
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

sub GetRandomID {
    my ( $Self, %Param ) = @_;

    return 'test' . int( rand(1000000) )
}

=item TestUserCreate()

creates a test user that can be used in tests. It will
be set to invalid automatically during the destructor. Returns
the login name of the new user, the password is the same.

    my $TestUserLogin = $Helper->TestUserCreate(
        Groups => ['admin', 'users'],           # optional, list of groups to add this user to (rw rights)
    );

=cut

sub TestUserCreate {
    my ( $Self, %Param ) = @_;

    # create test user
    my $TestUserLogin = $Self->GetRandomID();

    my $TestUserID = $Self->{UserObject}->UserAdd(
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
        my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $GroupName );
        die "Cannot find group $GroupName" if ( !$GroupID );

        $Self->{GroupObject}->GroupMemberAdd(
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

    return $TestUserLogin;
}

=item TestCustomerUserCreate()

creates a test customer user that can be used in tests. It will
be set to invalid automatically during the destructor. Returns
the login name of the new customer user, the password is the same.

    my $TestUserLogin = $Helper->TestCustomerUserCreate();

=cut

sub TestCustomerUserCreate {
    my ( $Self, %Param ) = @_;

    # create test user
    my $TestUserLogin = $Self->GetRandomID();

    my $TestUser = $Self->{CustomerUserObject}->CustomerUserAdd(
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

    return $TestUser;
}

sub SeleniumScenariosGet {
    my $Self = shift;

    my $Scenarios = [
        {
            ID          => 'Firefox on localhost',
            host        => 'localhost',
            port        => '4444',
            browser     => '*firefox',
            browser_url => 'http://127.0.0.1/',
        },
        {
            ID          => 'Safari on localhost',
            host        => 'localhost',
            port        => '4444',
            browser     => '*safari',
            browser_url => 'http://127.0.0.1/',
        },

        #        {
        #            ID          => 'IE7 VM',
        #            host        => '192.168.56.101',
        #            port        => '4444',
        #            browser     => '*iehta',
        #            browser_url => 'http://192.168.56.1/',
        #        },
        #        {
        #            ID          => 'IE8 VM',
        #            host        => '192.168.56.102',
        #            port        => '4444',
        #            browser     => '*iehta',
        #            browser_url => 'http://192.168.56.1/',
        #        },
    ];

    return $Scenarios;
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
            $Self->{MainObject}->Require($Object);
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

    # invalidate test users
    if ( ref $Self->{TestUsers} eq 'ARRAY' && @{ $Self->{TestUsers} } ) {
        for my $TestUser ( @{ $Self->{TestUsers} } ) {

            # make test user invalid
            my $Success = $Self->{UserObject}->UserUpdate(
                UserID        => $TestUser,
                UserFirstname => 'Firstname Test1',
                UserLastname  => 'Lastname Test1',
                UserLogin     => $TestUser,
                UserEmail     => $TestUser . '@localunittest.com.com',
                ValidID       => 2,
                ChangeUserID  => 1,
            ) || die "Could not invalidate test user";

            $Self->{UnitTestObject}->True( $Success, "Set test user $TestUser to invalid" );
        }
    }

    # invalidate test customer users
    if ( ref $Self->{TestCustomerUsers} eq 'ARRAY' && @{ $Self->{TestCustomerUsers} } ) {
        for my $TestCustomerUser ( @{ $Self->{TestCustomerUsers} } ) {

            my $Success = $Self->{CustomerUserObject}->CustomerUserUpdate(
                Source         => 'CustomerUser',
                ID             => $TestCustomerUser,
                UserCustomerID => $TestCustomerUser,
                UserLogin      => $TestCustomerUser,
                UserFirstname  => $TestCustomerUser,
                UserLastname   => $TestCustomerUser,
                UserPassword   => $TestCustomerUser,
                UserEmail      => $TestCustomerUser . '@localunittest.com.com',
                ValidID        => 2,
                UserID         => 1,
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
