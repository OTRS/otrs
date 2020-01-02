# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::UnitTest::Helper;

use strict;
use warnings;

use File::Path qw(rmtree);

# Load DateTime so that we can override functions for the FixedTimeSet().
use DateTime;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::SysConfig;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::UnitTest::Driver',
    'Kernel::System::User',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::UnitTest::Helper - unit test helper functions


=head2 new()

construct a helper object.

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::UnitTest::Helper' => {
            RestoreDatabase            => 1,        # runs the test in a transaction,
                                                    # and roll it back in the destructor
                                                    #
                                                    # NOTE: Rollback does not work for
                                                    # changes in the database layout. If you
                                                    # want to do this in your tests, you cannot
                                                    # use this option and must handle the rollback
                                                    # yourself.
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

    $Self->{UnitTestDriverObject} = $Kernel::OM->Get('Kernel::System::UnitTest::Driver');

    # Override Perl's built-in time handling mechanism to set a fixed time if needed.
    $Self->_MockPerlTimeHandling();

    # Remove any leftover custom files from aborted previous runs.
    $Self->CustomFileCleanup();

    # set environment variable to skip SSL certificate verification if needed
    if ( $Param{SkipSSLVerify} ) {

        # remember original value
        $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME} = $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME};

        # set environment value to 0
        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;    ## no critic

        $Self->{RestoreSSLVerify} = 1;
        $Self->{UnitTestDriverObject}->True( 1, 'Skipping SSL certificates verification' );
    }

    # switch article dir to a temporary one to avoid collisions
    if ( $Param{UseTmpArticleDir} ) {
        $Self->UseTmpArticleDir();
    }

    if ( $Param{RestoreDatabase} ) {
        $Self->{RestoreDatabase} = 1;
        my $StartedTransaction = $Self->BeginWork();
        $Self->{UnitTestDriverObject}->True( $StartedTransaction, 'Started database transaction.' );

    }

    if ( $Param{DisableAsyncCalls} ) {
        $Self->DisableAsyncCalls();
    }

    return $Self;
}

=head2 GetRandomID()

creates a random ID that can be used in tests as a unique identifier.

It is guaranteed that within a test this function will never return a duplicate.

Please note that these numbers are not really random and should only be used
to create test data.

=cut

sub GetRandomID {
    my ( $Self, %Param ) = @_;

    return 'test' . $Self->GetRandomNumber();
}

=head2 GetRandomNumber()

creates a random Number that can be used in tests as a unique identifier.

It is guaranteed that within a test this function will never return a duplicate.

Please note that these numbers are not really random and should only be used
to create test data.

=cut

# Use package variables here (instead of attributes in $Self)
# to make it work across several unit tests that run during the same second.
my %GetRandomNumberPrevious;

sub GetRandomNumber {

    my $PIDReversed = reverse $$;
    my $PID         = reverse sprintf '%.6d', $PIDReversed;

    my $Prefix = $PID . substr time(), -5, 5;

    return $Prefix . sprintf( '%.05d', ( $GetRandomNumberPrevious{$Prefix}++ || 0 ) );
}

=head2 TestUserCreate()

creates a test user that can be used in tests. It will
be set to invalid automatically during L</DESTROY()>. Returns
the login name of the new user, the password is the same.

    my $TestUserLogin = $Helper->TestUserCreate(
        Groups => ['admin', 'users'],           # optional, list of groups to add this user to (rw rights)
        Language => 'de'                        # optional, defaults to 'en' if not set
    );

=cut

sub TestUserCreate {
    my ( $Self, %Param ) = @_;

    # Disable email checks to create new user.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # Create test user.
    my $TestUserID;
    my $TestUserLogin;
    COUNT:
    for ( 1 .. 10 ) {

        $TestUserLogin = $Self->GetRandomID();

        $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
            UserFirstname => $TestUserLogin,
            UserLastname  => $TestUserLogin,
            UserLogin     => $TestUserLogin,
            UserPw        => $TestUserLogin,
            UserEmail     => $TestUserLogin . '@localunittest.com',
            ValidID       => 1,
            ChangeUserID  => 1,
        );

        last COUNT if $TestUserID;
    }

    die 'Could not create test user login' if !$TestUserLogin;
    die 'Could not create test user'       if !$TestUserID;

    # Remember UserID of the test user to later set it to invalid
    #   in the destructor.
    $Self->{TestUsers} ||= [];
    push( @{ $Self->{TestUsers} }, $TestUserID );

    $Self->{UnitTestDriverObject}->True( 1, "Created test user $TestUserID" );

    # Add user to groups.
    GROUP_NAME:
    for my $GroupName ( @{ $Param{Groups} || [] } ) {

        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $GroupID = $GroupObject->GroupLookup( Group => $GroupName );
        die "Cannot find group $GroupName" if ( !$GroupID );

        $GroupObject->PermissionGroupUserAdd(
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

        $Self->{UnitTestDriverObject}->True( 1, "Added test user $TestUserLogin to group $GroupName" );
    }

    # Set user language.
    my $UserLanguage = $Param{Language} || 'en';
    $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
        UserID => $TestUserID,
        Key    => 'UserLanguage',
        Value  => $UserLanguage,
    );
    $Self->{UnitTestDriverObject}->True( 1, "Set user UserLanguage to $UserLanguage" );

    return wantarray ? ( $TestUserLogin, $TestUserID ) : $TestUserLogin;
}

=head2 TestCustomerUserCreate()

creates a test customer user that can be used in tests. It will
be set to invalid automatically during L</DESTROY()>. Returns
the login name of the new customer user, the password is the same.

    my $TestUserLogin = $Helper->TestCustomerUserCreate(
        Language => 'de',   # optional, defaults to 'en' if not set
    );

=cut

sub TestCustomerUserCreate {
    my ( $Self, %Param ) = @_;

    # Disable email checks to create new user.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # Create test user.
    my $TestUser;
    COUNT:
    for ( 1 .. 10 ) {

        my $TestUserLogin = $Self->GetRandomID();

        $TestUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestUserLogin,
            UserLastname   => $TestUserLogin,
            UserCustomerID => $TestUserLogin,
            UserLogin      => $TestUserLogin,
            UserPassword   => $TestUserLogin,
            UserEmail      => $TestUserLogin . '@localunittest.com',
            ValidID        => 1,
            UserID         => 1,
        );

        last COUNT if $TestUser;
    }

    die 'Could not create test user' if !$TestUser;

    # Remember UserID of the test user to later set it to invalid
    #   in the destructor.
    $Self->{TestCustomerUsers} ||= [];
    push( @{ $Self->{TestCustomerUsers} }, $TestUser );

    $Self->{UnitTestDriverObject}->True( 1, "Created test customer user $TestUser" );

    # Set customer user language.
    my $UserLanguage = $Param{Language} || 'en';
    $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
        UserID => $TestUser,
        Key    => 'UserLanguage',
        Value  => $UserLanguage,
    );
    $Self->{UnitTestDriverObject}->True( 1, "Set customer user UserLanguage to $UserLanguage" );

    return $TestUser;
}

=head2 BeginWork()

    $Helper->BeginWork()

Starts a database transaction (in order to isolate the test from the static database).

=cut

sub BeginWork {
    my ( $Self, %Param ) = @_;
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Connect();
    return $DBObject->{dbh}->begin_work();
}

=head2 Rollback()

    $Helper->Rollback()

Rolls back the current database transaction.

=cut

sub Rollback {
    my ( $Self, %Param ) = @_;
    my $DatabaseHandle = $Kernel::OM->Get('Kernel::System::DB')->{dbh};

    # if there is no database handle, there's nothing to rollback
    if ($DatabaseHandle) {
        return $DatabaseHandle->rollback();
    }
    return 1;
}

=head2 GetTestHTTPHostname()

returns a host name for HTTP based tests, possibly including the port.

=cut

sub GetTestHTTPHostname {
    my ( $Self, %Param ) = @_;

    my $Host = $Kernel::OM->Get('Kernel::Config')->Get('TestHTTPHostname');
    return $Host if $Host;

    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # try to resolve fqdn host
    if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
        $Host = $FQDN;
    }

    # try to resolve localhost instead
    if ( !$Host && gethostbyname('localhost') ) {
        $Host = 'localhost';
    }

    # use hardcoded localhost ip address
    if ( !$Host ) {
        $Host = '127.0.0.1';
    }

    return $Host;
}

my $FixedTime;

=head2 FixedTimeSet()

makes it possible to override the system time as long as this object lives.
You can pass an optional time parameter that should be used, if not,
the current system time will be used.

All calls to methods of Kernel::System::Time and Kernel::System::DateTime will
use the given time afterwards.

    $HelperObject->FixedTimeSet(366475757);         # with Timestamp
    $HelperObject->FixedTimeSet($DateTimeObject);   # with previously created DateTime object
    $HelperObject->FixedTimeSet();                  # set to current date and time

Returns:
    Timestamp

=cut

sub FixedTimeSet {
    my ( $Self, $TimeToSave ) = @_;

    if ( $TimeToSave && ref $TimeToSave eq 'Kernel::System::DateTime' ) {
        $FixedTime = $TimeToSave->ToEpoch();
    }
    else {
        $FixedTime = $TimeToSave // CORE::time();
    }

    return $FixedTime;
}

=head2 FixedTimeUnset()

restores the regular system time behavior.

=cut

sub FixedTimeUnset {
    my ($Self) = @_;

    undef $FixedTime;
    return;
}

=head2 FixedTimeAddSeconds()

adds a number of seconds to the fixed system time which was previously
set by FixedTimeSet(). You can pass a negative value to go back in time.

=cut

sub FixedTimeAddSeconds {
    my ( $Self, $SecondsToAdd ) = @_;

    return if !defined $FixedTime;
    $FixedTime += $SecondsToAdd;
    return;
}

# See http://perldoc.perl.org/5.10.0/perlsub.html#Overriding-Built-in-Functions
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)
## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::TimeObject)
## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::DateTime)
sub _MockPerlTimeHandling {
    no warnings 'redefine';    ## no critic
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

    # Newer versions of DateTime provide a function _core_time() to override for time simulations.
    *DateTime::_core_time = sub {    ## no critic
        return defined $FixedTime ? $FixedTime : CORE::time();
    };

    # Make sure versions of DateTime also use _core_time() it by overriding now() as well.
    *DateTime::now = sub {
        my $Self = shift;
        return $Self->from_epoch(
            epoch => $Self->_core_time(),
            @_
        );
    };

    # This is needed to reload objects that directly use the native time functions
    #   to get a hold of the overrides.
    my @Objects = (
        'Kernel::System::Time',
        'Kernel::System::DB',
        'Kernel::System::Cache::FileStorable',
        'Kernel::System::PID',
    );

    for my $Object (@Objects) {
        my $FilePath = $Object;
        $FilePath =~ s{::}{/}xmsg;
        $FilePath .= '.pm';
        if ( $INC{$FilePath} ) {
            no warnings 'redefine';    ## no critic
            delete $INC{$FilePath};
            require $FilePath;         ## nofilter(TidyAll::Plugin::OTRS::Perl::Require)
        }
    }

    return 1;
}

=head2 DESTROY()

performs various clean-ups.

=cut

sub DESTROY {
    my $Self = shift;

    # reset time freeze
    FixedTimeUnset();

    # FixedDateTimeObjectUnset();

    if ( $Self->{DestroyLog} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Helper is destroyed!"
        );
    }

    # Cleanup temporary database if it was set up.
    $Self->TestDatabaseCleanup() if $Self->{ProvideTestDatabase};

    # Remove any custom files.
    $Self->CustomFileCleanup();

    # restore environment variable to skip SSL certificate verification if needed
    if ( $Self->{RestoreSSLVerify} ) {

        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME};    ## no critic

        $Self->{RestoreSSLVerify} = 0;

        $Self->{UnitTestDriverObject}->True( 1, 'Restored SSL certificates verification' );
    }

    # restore database, clean caches
    if ( $Self->{RestoreDatabase} ) {
        my $RollbackSuccess = $Self->Rollback();
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
        $Self->{UnitTestDriverObject}
            ->True( $RollbackSuccess, 'Rolled back all database changes and cleaned up the cache.' );
    }

    # disable email checks to create new user
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # cleanup temporary article directory
    if ( $Self->{TmpArticleDir} && -d $Self->{TmpArticleDir} ) {
        File::Path::rmtree( $Self->{TmpArticleDir} );
    }

    # invalidate test users
    if ( ref $Self->{TestUsers} eq 'ARRAY' && @{ $Self->{TestUsers} } ) {
        TESTUSERS:
        for my $TestUser ( @{ $Self->{TestUsers} } ) {

            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $TestUser,
            );

            if ( !$User{UserID} ) {

                # if no such user exists, there is no need to set it to invalid;
                # happens when the test user is created inside a transaction
                # that is later rolled back.
                next TESTUSERS;
            }

            # make test user invalid
            my $Success = $Kernel::OM->Get('Kernel::System::User')->UserUpdate(
                %User,
                ValidID      => 2,
                ChangeUserID => 1,
            );

            $Self->{UnitTestDriverObject}->True( $Success, "Set test user $TestUser to invalid" );
        }
    }

    # invalidate test customer users
    if ( ref $Self->{TestCustomerUsers} eq 'ARRAY' && @{ $Self->{TestCustomerUsers} } ) {
        TESTCUSTOMERUSERS:
        for my $TestCustomerUser ( @{ $Self->{TestCustomerUsers} } ) {

            my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $TestCustomerUser,
            );

            if ( !$CustomerUser{UserLogin} ) {

                # if no such customer user exists, there is no need to set it to invalid;
                # happens when the test customer user is created inside a transaction
                # that is later rolled back.
                next TESTCUSTOMERUSERS;
            }

            my $Success = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
                %CustomerUser,
                ID      => $CustomerUser{UserID},
                ValidID => 2,
                UserID  => 1,
            );

            $Self->{UnitTestDriverObject}->True(
                $Success, "Set test customer user $TestCustomerUser to invalid"
            );
        }
    }

    return;
}

=head2 ConfigSettingChange()

temporarily change a configuration setting system wide to another value,
both in the current ConfigObject and also in the system configuration on disk.

This will be reset when the Helper object is destroyed.

Please note that this will not work correctly in clustered environments.

    $Helper->ConfigSettingChange(
        Valid => 1,            # (optional) enable or disable setting
        Key   => 'MySetting',  # setting name
        Value => { ... } ,     # setting value
    );

=cut

sub ConfigSettingChange {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} // 1;
    my $Key   = $Param{Key};
    my $Value = $Param{Value};

    die "Need 'Key'" if !defined $Key;

    my $RandomNumber = $Self->GetRandomNumber();

    my $KeyDump = $Key;
    $KeyDump =~ s|'|\\'|smxg;
    $KeyDump = "\$Self->{'$KeyDump'}";
    $KeyDump =~ s|\#{3}|'}->{'|smxg;

    # Also set at runtime in the ConfigObject. This will be destroyed at the end of the unit test.
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => $Key,
        Value => $Valid ? $Value : undef,
    );

    my $ValueDump;
    if ($Valid) {
        $ValueDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($Value);
        $ValueDump =~ s/\$VAR1/$KeyDump/;
    }
    else {
        $ValueDump = "delete $KeyDump;";
    }

    my $PackageName = "ZZZZUnitTest$RandomNumber";

    my $Content = <<"EOF";
# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::$PackageName;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
    $ValueDump
}
1;
EOF
    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FileName = "$Home/Kernel/Config/Files/$PackageName.pm";
    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $FileName,
        Mode     => 'utf8',
        Content  => \$Content,
    ) || die "Could not write $FileName";

    return 1;
}

=head2 CustomCodeActivate()

Temporarily include custom code in the system. For example, you may use this to redefine a
subroutine from another class. This change will persist for remainder of the test.

All code will be removed when the Helper object is destroyed.

Please note that this will not work correctly in clustered environments.

    $Helper->CustomCodeActivate(
        Code => q^
sub Kernel::Config::Files::ZZZZUnitTestIdentifier::Load {} # no-op, avoid warning logs
use Kernel::System::WebUserAgent;
package Kernel::System::WebUserAgent;
use strict;
use warnings;
{
    no warnings 'redefine';
    sub Request {
        my $JSONString = '{"Results":{},"ErrorMessage":"","Success":1}';
        return (
            Content => \$JSONString,
            Status  => '200 OK',
        );
    }
}
1;^,
        Identifier => 'News',   # (optional) Code identifier to include in file name
    );

=cut

sub CustomCodeActivate {
    my ( $Self, %Param ) = @_;

    my $Code       = $Param{Code};
    my $Identifier = $Param{Identifier} || $Self->GetRandomNumber();

    die "Need 'Code'" if !defined $Code;

    my $PackageName = "ZZZZUnitTest$Identifier";

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FileName = "$Home/Kernel/Config/Files/$PackageName.pm";
    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $FileName,
        Mode     => 'utf8',
        Content  => \$Code,
    ) || die "Could not write $FileName";

    return 1;
}

=head2 CustomFileCleanup()

Remove all custom files from C<ConfigSettingChange()> and C<CustomCodeActivate()>.

=cut

sub CustomFileCleanup {
    my ( $Self, %Param ) = @_;

    my $Home  = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => "$Home/Kernel/Config/Files",
        Filter    => "ZZZZUnitTest*.pm",
    );
    for my $File (@Files) {
        $Kernel::OM->Get('Kernel::System::Main')->FileDelete(
            Location => $File,
        ) || die "Could not delete $File";
    }
    return 1;
}

=head2 UseTmpArticleDir()

switch the article storage directory to a temporary one to prevent collisions;

=cut

sub UseTmpArticleDir {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $TmpArticleDir;
    TRY:
    for my $Try ( 1 .. 100 ) {

        $TmpArticleDir = $Home . '/var/tmp/unittest-article-' . $Self->GetRandomNumber();

        next TRY if -e $TmpArticleDir;
        last TRY;
    }

    $Self->ConfigSettingChange(
        Valid => 1,
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleDataDir',
        Value => $TmpArticleDir,
    );

    $Self->{TmpArticleDir} = $TmpArticleDir;

    return 1;
}

=head2 DisableAsyncCalls()

Disable scheduling of asynchronous tasks using C<AsynchronousExecutor> component of OTRS daemon.

=cut

sub DisableAsyncCalls {
    my ( $Self, %Param ) = @_;

    $Self->ConfigSettingChange(
        Valid => 1,
        Key   => 'DisableAsyncCalls',
        Value => 1,
    );

    return 1;
}

=head2 ProvideTestDatabase()

Provide temporary database for the test. Please first define test database settings in C<Config.pm>, i.e:

    $Self->{TestDatabase} = {
        DatabaseDSN  => 'DBI:mysql:database=otrs_test;host=127.0.0.1;',
        DatabaseUser => 'otrs_test',
        DatabasePw   => 'otrs_test',
    };

The method call will override global database configuration for duration of the test, i.e. temporary database will
receive all calls sent over system C<DBObject>.

All database contents will be automatically dropped when the Helper object is destroyed.

    $Helper->ProvideTestDatabase(
        DatabaseXMLString => $XML,      # (optional) OTRS database XML schema to execute
                                        # or
        DatabaseXMLFiles => [           # (optional) List of XML files to load and execute
            '/opt/otrs/scripts/database/otrs-schema.xml',
            '/opt/otrs/scripts/database/otrs-initial_insert.xml',
        ],
    );

This method returns 'undef' in case the test database is not configured. If it is configured, but the supplied XML cannot be read or executed, this method will C<die()> to interrupt the test with an error.

=cut

sub ProvideTestDatabase {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TestDatabase = $ConfigObject->Get('TestDatabase');
    return if !$TestDatabase;

    for (qw(DatabaseDSN DatabaseUser DatabasePw)) {
        if ( !$TestDatabase->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in TestDatabase!",
            );
            return;
        }
    }

    my %EscapedSettings;
    for my $Key (qw(DatabaseDSN DatabaseUser DatabasePw)) {

        # Override database connection settings in memory.
        $ConfigObject->Set(
            Key   => "Test$Key",
            Value => $TestDatabase->{$Key},
        );

        # Escape quotes in database settings.
        $EscapedSettings{$Key} = $TestDatabase->{$Key};
        $EscapedSettings{$Key} =~ s/'/\\'/g;
    }

    # Override database connection settings system wide.
    my $Identifier  = 'TestDatabase';
    my $PackageName = "ZZZZUnitTest$Identifier";
    $Self->CustomCodeActivate(
        Code => qq^
# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::$PackageName;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
    \$Self->{TestDatabaseDSN}  = '$EscapedSettings{DatabaseDSN}';
    \$Self->{TestDatabaseUser} = '$EscapedSettings{DatabaseUser}';
    \$Self->{TestDatabasePw}   = '$EscapedSettings{DatabasePw}';
}
1;^,
        Identifier => $Identifier,
    );

    # Discard already instanced database object.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::DB'] );

    # Delete cache.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    $Self->{ProvideTestDatabase} = 1;

    # Clear test database.
    my $Success = $Self->TestDatabaseCleanup();
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Error clearing temporary database!',
        );
        die 'Error clearing temporary database!';
    }

    # Load supplied XML files.
    if ( IsArrayRefWithData( $Param{DatabaseXMLFiles} ) ) {
        $Param{DatabaseXMLString} //= '';

        my $Index = 0;
        my $Count = scalar @{ $Param{DatabaseXMLFiles} };

        XMLFILE:
        for my $XMLFile ( @{ $Param{DatabaseXMLFiles} } ) {
            next XMLFILE if !$XMLFile;

            # Load XML contents.
            my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $XMLFile,
            );
            if ( !$XML ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not load '$XMLFile'!",
                );
                die "Could not load '$XMLFile'!";
            }

            # Concatenate the file contents, but make sure to remove duplicated XML tags first.
            #   - First file should get only end tag removed.
            #   - Last file should get only start tags removed.
            #   - Any other file should get both start and end tags removed.
            $XML = ${$XML};
            if ( $Index != 0 ) {
                $XML =~ s/<\?xml .*? \?>//xm;
                $XML =~ s/<database .*? >//xm;
            }
            if ( $Index != $Count - 1 ) {
                $XML =~ s/<\/database .*? >//xm;
            }
            $Param{DatabaseXMLString} .= $XML;

            $Index++;
        }
    }

    # Execute supplied XML.
    if ( $Param{DatabaseXMLString} ) {
        my $Success = $Self->DatabaseXMLExecute( XML => $Param{DatabaseXMLString} );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error executing supplied XML!',
            );
            die 'Error executing supplied XML!';
        }
    }

    return 1;
}

=head2 TestDatabaseCleanup()

Clears temporary database used in the test. Always call C<ProvideTestDatabase()> called first, in
order to set it up.

Please note that all database contents will be dropped, USE WITH CARE!

    $Helper->TestDatabaseCleanup();

=cut

sub TestDatabaseCleanup {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{ProvideTestDatabase} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Please call ProvideTestDatabase() first!',
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get a list of all tables in database.
    my @Tables = $DBObject->ListTables();

    if ( scalar @Tables ) {
        my $TableList = join ', ', sort @Tables;
        my $DBType    = $DBObject->{'DB::Type'};

        if ( $DBType eq 'mysql' ) {

            # Turn off checking foreign key constraints temporarily.
            $DBObject->Do( SQL => 'SET foreign_key_checks = 0' );

            # Drop all found tables in the database in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );

            # Turn back on checking foreign key constraints.
            $DBObject->Do( SQL => 'SET foreign_key_checks = 1' );
        }
        elsif ( $DBType eq 'postgresql' ) {

            # Drop all found tables in the database in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );
        }
        elsif ( $DBType eq 'oracle' ) {

            # Drop each found table in the database in a separate statement.
            for my $Table (@Tables) {
                $DBObject->Do( SQL => "DROP TABLE $Table CASCADE CONSTRAINTS" );
            }

            # Get complete list of user sequences.
            my @Sequences;
            return if !$DBObject->Prepare(
                SQL => 'SELECT sequence_name FROM user_sequences ORDER BY sequence_name',
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @Sequences, $Row[0];
            }

            # Drop all found sequences as well.
            for my $Sequence (@Sequences) {
                $DBObject->Do( SQL => "DROP SEQUENCE $Sequence" );
            }

            # Check if all sequences have been dropped.
            @Sequences = ();
            return if !$DBObject->Prepare(
                SQL => 'SELECT sequence_name FROM user_sequences ORDER BY sequence_name',
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @Sequences, $Row[0];
            }
            return if scalar @Sequences;
        }

        # Check if all tables have been dropped.
        @Tables = $DBObject->ListTables();
        return if scalar @Tables;
    }

    return 1;
}

=head2 DatabaseXMLExecute()

Execute supplied XML against current database. Content of supplied XML or XMLFilename parameter must be valid OTRS
database XML schema.

    $Helper->DatabaseXMLExecute(
        XML => $XML,     # OTRS database XML schema to execute
    );

Alternatively, it can also load an XML file to execute:

    $Helper->DatabaseXMLExecute(
        XMLFile => '/path/to/file',  # OTRS database XML file to execute
    );

=cut

sub DatabaseXMLExecute {
    my ( $Self, %Param ) = @_;

    if ( !$Param{XML} && !$Param{XMLFile} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need XML or XMLFile!',
        );
        return;
    }

    my $XML = $Param{XML};

    if ( !$XML ) {

        $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Param{XMLFile},
        );
        if ( !$XML ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not load '$Param{XMLFile}'!",
            );
            die "Could not load '$Param{XMLFile}'!";
        }
        $XML = ${$XML};
    }

    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
    if ( !@XMLArray ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not parse XML!',
        );
        die 'Could not parse XML!';
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @SQLPre = $DBObject->SQLProcessor(
        Database => \@XMLArray,
    );
    if ( !@SQLPre ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not generate SQL!',
        );
        die 'Could not generate SQL!';
    }

    my @SQLPost = $DBObject->SQLProcessorPost();

    for my $SQL ( @SQLPre, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Database action failed: ' . $DBObject->Error(),
            );
            die 'Database action failed: ' . $DBObject->Error();
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
