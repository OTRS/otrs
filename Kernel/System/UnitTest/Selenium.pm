# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::UnitTest::Selenium;

use strict;
use warnings;

use MIME::Base64();
use File::Path();
use File::Temp();

use Kernel::Config;
use Kernel::System::User;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::UnitTest::Driver',
    'Kernel::System::UnitTest::Helper',
);

=head1 NAME

Kernel::System::UnitTest::Selenium - run frontend tests

This class inherits from Selenium::Remote::Driver. You can use
its full API (see
L<http://search.cpan.org/~aivaturi/Selenium-Remote-Driver-0.15/lib/Selenium/Remote/Driver.pm>).

Every successful Selenium command will be logged as a successful unit test.
In case of an error, an exception will be thrown that you can catch in your
unit test file and handle with C<HandleError()> in this class. It will output
a failing test result and generate a screenshot for analysis.

=over 4

=cut

=item new()

create a selenium object to run fontend tests.

To do this, you need a running selenium or phantomjs server.

Specify the connection details in Config.pm, like this:

    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'localhost',
        port                => '4444',
        browser_name        => 'phantomjs',
        platform            => 'ANY',
        window_height       => 1200,    # optional, default 1000
        window_width        => 1600,    # optional, default 1200
        extra_capabilities => {
            marionette     => \0,   # Required to run FF 47 or older on Selenium 3+.
        },
    };

Then you can use the full API of Selenium::Remote::Driver on this object.

=cut

sub new {
    my ( $Class, %Param ) = @_;

    $Param{UnitTestDriverObject} ||= $Kernel::OM->Get('Kernel::System::UnitTest::Driver');

    $Param{UnitTestDriverObject}->True( 1, "Starting up Selenium scenario..." );

    my %SeleniumTestsConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {} };

    if ( !%SeleniumTestsConfig ) {
        my $Self = bless {}, $Class;
        $Self->{UnitTestDriverObject} = $Param{UnitTestDriverObject};
        return $Self;
    }

    for my $Needed (qw(remote_server_addr port browser_name platform)) {
        if ( !$SeleniumTestsConfig{$Needed} ) {
            die "SeleniumTestsConfig must provide $Needed!";
        }
    }

    $Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass('Selenium::Remote::Driver')
        || die "Could not load Selenium::Remote::Driver";

    $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::UnitTest::Selenium::WebElement')
        || die "Could not load Kernel::System::UnitTest::Selenium::WebElement";

    my $Self = $Class->SUPER::new(
        webelement_class => 'Kernel::System::UnitTest::Selenium::WebElement',
        %SeleniumTestsConfig
    );
    $Self->{UnitTestDriverObject} = $Param{UnitTestDriverObject};
    $Self->{SeleniumTestsActive}  = 1;

    #$Self->debug_on();

    # set screen size from config or use defauls
    my $Height = $SeleniumTestsConfig{window_height} || 1000;
    my $Width  = $SeleniumTestsConfig{window_width}  || 1200;
    $Self->set_window_size( $Height, $Width );

    # get remote host with some precautions for certain unit test systems
    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # try to resolve fqdn host
    if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
        $Self->{BaseURL} = $FQDN;
    }

    # try to resolve localhost instead
    if ( !$Self->{BaseURL} && gethostbyname('localhost') ) {
        $Self->{BaseURL} = 'localhost';
    }

    # use hardcoded localhost ip address
    if ( !$Self->{BaseURL} ) {
        $Self->{BaseURL} = '127.0.0.1';
    }

    $Self->{BaseURL} = $Kernel::OM->Get('Kernel::Config')->Get('HttpType') . '://' . $Self->{BaseURL};

    # Remember the start system time for the selenium test run.
    $Self->{TestStartSystemTime} = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    return $Self;
}

=item RunTest()

runs a selenium test if Selenium testing is configured and performs proper
error handling (calls C<HandleError()> if needed).

    $SeleniumObject->RunTest( sub { ... } );

=cut

sub RunTest {
    my ( $Self, $Test ) = @_;

    if ( !$Self->{SeleniumTestsActive} ) {
        $Self->{UnitTestDriverObject}->True( 1, 'Selenium testing is not active, skipping tests.' );
        return 1;
    }

    eval {
        $Test->();
    };
    $Self->HandleError($@) if $@;

    return 1;
}

=item _execute_command()

Override internal command of base class.

We use it to output successful command runs to the UnitTest object.
Errors will cause an exeption and be caught elsewhere.

=cut

sub _execute_command {    ## no critic
    my ( $Self, $Res, $Params ) = @_;

    my $Result = $Self->SUPER::_execute_command( $Res, $Params );

    my $TestName = 'Selenium command success: ';
    $TestName .= $Kernel::OM->Get('Kernel::System::Main')->Dump(
        {
            %{ $Res    || {} },
            %{ $Params || {} },
        }
    );

    $Self->{UnitTestDriverObject}->True(
        1,
        $TestName
    );

    return $Result;
}

=item get()

Override get method of base class to prepend the correct base URL.

    $SeleniumObject->get(
        $URL,
    );

=cut

sub get {    ## no critic
    my ( $Self, $URL ) = @_;

    if ( $URL !~ m{http[s]?://}smx ) {
        $URL = "$Self->{BaseURL}/$URL";
    }

    $Self->SUPER::get($URL);

    return;
}

=item get_alert_text()

Override get_alert_text() method of base class to return alert text as string.

    my $AlertText = $SeleniumObject->get_alert_text();

returns

    my $AlertText = 'Some alert text!'

=cut

sub get_alert_text {    ## no critic
    my ($Self) = @_;

    my $AlertText = $Self->SUPER::get_alert_text();

    die "Alert dialog is not present" if ref $AlertText eq 'HASH';    # Chrome returns HASH when there is no alert text.

    return $AlertText;
}

=item VerifiedGet()

perform a get() call, but wait for the page to be fully loaded (works only within OTRS).
Will die() if the verification fails.

    $SeleniumObject->VerifiedGet(
        $URL,
    );

=cut

sub VerifiedGet {
    my ( $Self, $URL ) = @_;

    $Self->get($URL);

    $Self->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTRS API verification failed after page load.";

    return;
}

=item VerifiedRefresh()

perform a refresh() call, but wait for the page to be fully loaded (works only within OTRS).
Will die() if the verification fails.

    $SeleniumObject->VerifiedRefresh();

=cut

sub VerifiedRefresh {
    my ( $Self, $URL ) = @_;

    $Self->refresh();

    $Self->WaitFor(
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    ) || die "OTRS API verification failed after page load.";

    return;
}

=item Login()

login to agent or customer interface

    $SeleniumObject->Login(
        Type     => 'Agent', # Agent|Customer
        User     => 'someuser',
        Password => 'somepassword',
    );

=cut

sub Login {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type User Password)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    $Self->{UnitTestDriverObject}->True( 1, 'Initiating login...' );

    # we will try several times to log in
    my $MaxTries = 5;

    TRY:
    for my $Try ( 1 .. $MaxTries ) {

        eval {
            my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

            if ( $Param{Type} eq 'Agent' ) {
                $ScriptAlias .= 'index.pl';
            }
            else {
                $ScriptAlias .= 'customer.pl';
            }

            $Self->get("${ScriptAlias}");

            $Self->delete_all_cookies();
            $Self->VerifiedGet("${ScriptAlias}?Action=Login;User=$Param{User};Password=$Param{Password}");

            # login successful?
            $Self->find_element( 'a#LogoutButton', 'css' );    # dies if not found

            $Self->{UnitTestDriverObject}->True( 1, 'Login sequence ended...' );
        };

        # an error happend
        if ($@) {

            $Self->{UnitTestDriverObject}->True( 1, "Login attempt $Try of $MaxTries not successful." );

            # try again
            next TRY if $Try < $MaxTries;

            # log error
            $Self->HandleError($@);
            die "Login failed!";
        }

        # login was sucessful
        else {
            last TRY;
        }
    }

    return 1;
}

=item WaitFor()

wait with increasing sleep intervals until the given condition is true or the wait time is over.
Exactly one condition (JavaScript or WindowCount) must be specified.

    my $Success = $SeleniumObject->WaitFor(
        JavaScript  => 'return $(".someclass").length',   # Javascript code that checks condition
        WindowCount => 2,                                 # Wait until this many windows are open
        Time        => 20,                                # optional, wait time in seconds (default 20)
    );

=cut

sub WaitFor {
    my ( $Self, %Param ) = @_;

    if ( !$Param{JavaScript} && !$Param{WindowCount} ) {
        die "Need JavaScript.";
    }

    $Param{Time} //= 20;
    my $WaitedSeconds = 0;
    my $Interval      = 0.1;

    while ( $WaitedSeconds <= $Param{Time} ) {
        if ( $Param{JavaScript} ) {
            return 1 if $Self->execute_script( $Param{JavaScript} );
        }
        elsif ( $Param{WindowCount} ) {
            return 1 if scalar( @{ $Self->get_window_handles() } ) == $Param{WindowCount};
        }
        sleep $Interval;
        $WaitedSeconds += $Interval;
        $Interval += 0.1;
    }
    return;
}

=item HandleError()

use this method to handle any Selenium exceptions.

    $SeleniumObject->HandleError($@);

It will create a failing test result and store a screenshot of the page
for analysis (in folder /var/otrs-unittest if it exists, in $Home/var/httpd/htdocs otherwise).

=cut

sub HandleError {
    my ( $Self, $Error ) = @_;

    $Self->{UnitTestDriverObject}->False( 1, "Exception in Selenium': $Error" );

    #eval {
    my $Data = $Self->screenshot();
    return if !$Data;
    $Data = MIME::Base64::decode_base64($Data);

    #
    # Store screenshots in a local folder from where they can be opened directly in the browser.
    #
    my $LocalScreenshotDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/SeleniumScreenshots';
    mkdir $LocalScreenshotDir || return $Self->False( 1, "Could not create $LocalScreenshotDir." );

    my $Filename = $Kernel::OM->Get('Kernel::System::Time')->CurrentTimestamp();
    $Filename .= '-' . ( int rand 100_000_000 ) . '.png';
    $Filename =~ s{[ :]}{-}smxg;

    my $HttpType = $Kernel::OM->Get('Kernel::Config')->Get('HttpType');
    my $Hostname = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetTestHTTPHostname();
    my $URL      = "$HttpType://$Hostname/"
        . $Kernel::OM->Get('Kernel::Config')->Get('Frontend::WebPath')
        . "SeleniumScreenshots/$Filename";

    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory => $LocalScreenshotDir,
        Filename  => $Filename,
        Content   => \$Data,
    ) || return $Self->False( 1, "Could not write file $LocalScreenshotDir/$Filename" );

    #
    # If a shared screenshot folder is present, then we also store the screenshot there for external use.
    #
    if ( -d '/var/otrs-unittest/' ) {

        my $SharedScreenshotDir = '/var/otrs-unittest/SeleniumScreenshots';
        mkdir $SharedScreenshotDir || return $Self->False( 1, "Could not create $SharedScreenshotDir." );

        $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Directory => $SharedScreenshotDir,
            Filename  => $Filename,
            Content   => \$Data,
            )
            || return $Self->{UnitTestDriverObject}->False( 1, "Could not write file $SharedScreenshotDir/$Filename" );
    }

    $Self->{UnitTestDriverObject}->False( 1, "Saved screenshot in $URL" );
    $Self->{UnitTestDriverObject}->AttachSeleniumScreenshot(
        Filename => $Filename,
        Content  => $Data
    );
}

=head2 DEMOLISH()

override DEMOLISH from L<Selenium::Remote::Driver> (required because this class is managed by L<Moo>).
Adds a unit test result to indicate the shutdown, and performs some cleanups.

=cut

sub DEMOLISH {
    my $Self = shift;

    # Could be missing on early die.
    if ( $Self->{UnitTestDriverObject} ) {
        $Self->{UnitTestDriverObject}->True( 1, "Shutting down Selenium scenario." );
    }

    if ( $Self->{SeleniumTestsActive} ) {
        $Self->SUPER::DEMOLISH(@_);

        # Cleanup possibly leftover zombie firefox profiles.
        my @LeftoverFirefoxProfiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => '/tmp/',
            Filter    => 'anonymous*webdriver-profile',
        );

        for my $LeftoverFirefoxProfile (@LeftoverFirefoxProfiles) {
            if ( -d $LeftoverFirefoxProfile ) {
                File::Path::remove_tree($LeftoverFirefoxProfile);
            }
        }

        # Cleanup all sessions, which was created after the selenium test start time.
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        my @Sessions = $AuthSessionObject->GetAllSessionIDs();

        SESSION:
        for my $SessionID (@Sessions) {

            my %SessionData = $AuthSessionObject->GetSessionIDData( SessionID => $SessionID );

            next SESSION if !%SessionData;
            next SESSION
                if $SessionData{UserSessionStart} && $SessionData{UserSessionStart} < $Self->{TestStartSystemTime};

            $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
        }
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
