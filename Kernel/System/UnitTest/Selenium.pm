# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
use Time::HiRes();

use Kernel::Config;
use Kernel::System::User;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
    'Kernel::System::UnitTest::Driver',
    'Kernel::System::UnitTest::Helper',
);

# If a test throws an exception, we'll record it here in a package variable so that we can
#   take screenshots of *all* Selenium instances that are currently running on shutdown.
our $TestException;

=head1 NAME

Kernel::System::UnitTest::Selenium - run front end tests

This class inherits from Selenium::Remote::Driver. You can use
its full API (see
L<http://search.cpan.org/~aivaturi/Selenium-Remote-Driver-0.15/lib/Selenium/Remote/Driver.pm>).

Every successful Selenium command will be logged as a successful unit test.
In case of an error, an exception will be thrown that you can catch in your
unit test file and handle with C<HandleError()> in this class. It will output
a failing test result and generate a screen shot for analysis.

=head2 new()

create a selenium object to run front end tests.

To do this, you need a running C<selenium> or C<phantomjs> server.

Specify the connection details in C<Config.pm>, like this:

    # For testing with Firefox until v. 47 (testing with recent FF and marionette is currently not supported):
    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'localhost',
        port                => '4444',
        platform            => 'ANY',
        browser_name        => 'firefox',
        extra_capabilities => {
            marionette     => \0,   # Required to run FF 47 or older on Selenium 3+.
        },
    };

    # For testing with Chrome/Chromium (requires installed geckodriver):
    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'localhost',
        port                => '4444',
        platform            => 'ANY',
        browser_name        => 'chrome',
        extra_capabilities => {
            chromeOptions => {
                # disable-infobars makes sure window size calculations are ok
                args => [ "disable-infobars" ],
            },
        },
    };

Then you can use the full API of L<Selenium::Remote::Driver> on this object.

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

    my $Self;

    # TEMPORARY WORKAROUND FOR GECKODRIVER BUG https://github.com/mozilla/geckodriver/issues/1470:
    #   If marionette handshake fails, wait and try again. Can be removed after the bug is fixed
    #   in a new geckodriver version.
    eval {
        $Self = $Class->SUPER::new(
            webelement_class => 'Kernel::System::UnitTest::Selenium::WebElement',
            error_handler    => sub {
                my $Self = shift;
                return $Self->SeleniumErrorHandler(@_);
            },
            %SeleniumTestsConfig
        );
    };
    if ($@) {
        my $Exception = $@;

        # Only handle this specific geckodriver exception.
        die $Exception if $Exception !~ m{Socket timeout reading Marionette handshake data};

        # Sleep and try again, bail out if it fails a second time.
        #   A long sleep of 10 seconds is acceptable here, as it occurs only very rarely.
        sleep 10;

        $Self = $Class->SUPER::new(
            webelement_class => 'Kernel::System::UnitTest::Selenium::WebElement',
            error_handler    => sub {
                my $Self = shift;
                return $Self->SeleniumErrorHandler(@_);
            },
            %SeleniumTestsConfig
        );
    }

    $Self->{UnitTestDriverObject} = $Param{UnitTestDriverObject};
    $Self->{SeleniumTestsActive}  = 1;

    $Self->{UnitTestDriverObject}->{SeleniumData} = { %{ $Self->get_capabilities() }, %{ $Self->status() } };

    #$Self->debug_on();

    # set screen size from config or use defauls
    my $Height = $SeleniumTestsConfig{window_height} || 1200;
    my $Width  = $SeleniumTestsConfig{window_width}  || 1400;

    $Self->set_window_size( $Height, $Width );

    $Self->{BaseURL} = $Kernel::OM->Get('Kernel::Config')->Get('HttpType') . '://';
    $Self->{BaseURL} .= Kernel::System::UnitTest::Helper->GetTestHTTPHostname();

    # Remember the start system time for the selenium test run.
    $Self->{TestStartSystemTime} = time;    ## no critic

    # Force usage of legacy webdriver methods in Chrome until things are more stable.
    if ( lc $SeleniumTestsConfig{browser_name} eq 'chrome' ) {
        $Self->{is_wd3} = 0;
    }
    return $Self;
}

sub SeleniumErrorHandler {
    my ( $Self, $Error ) = @_;

    my $Caller     = 0;
    my $StackTrace = "Selenium stack trace: ($$): \n";

    COUNT:
    for ( my $Count = 0; $Count < 30; $Count++ ) {

        my ( $Package1, $Filename1, $Line1, $Subroutine1 ) = caller( $Caller + $Count );

        last COUNT if !$Line1;

        my ( $Package2, $Filename2, $Line2, $Subroutine2 ) = caller( $Caller + 1 + $Count );

        # if there is no caller module use the file name
        $Subroutine2 ||= $0;

        # Cut limit stack trace to test evaluation itself.
        last COUNT if $Subroutine2 eq 'Kernel::System::UnitTest::Driver::Run';

        # print line if upper caller module exists
        my $VersionString = '';

        eval { $VersionString = $Package1->VERSION || ''; };    ## no critic

        # version is present
        if ($VersionString) {
            $VersionString = ' (v' . $VersionString . ')';
        }

        $StackTrace .= "   Module: $Subroutine2$VersionString Line: $Line1\n";

        last COUNT if !$Line2;
    }

    $Self->{_SeleniumStackTrace} = $StackTrace;
    $Self->{_SeleniumException}  = $Error;

    die $Error;
}

=head2 RunTest()

runs a selenium test if Selenium testing is configured.

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

    $TestException = $@ if $@;

    return 1;
}

=begin Internal:

=head2 _execute_command()

Override internal command of base class.

We use it to output successful command runs to the UnitTest object.
Errors will cause an exeption and be caught elsewhere.

=end Internal:

=cut

sub _execute_command {    ## no critic
    my ( $Self, $Res, $Params ) = @_;

    my $Result = $Self->SUPER::_execute_command( $Res, $Params );

    my $TestName = 'Selenium command success: ';
    $TestName .= $Kernel::OM->Get('Kernel::System::Main')->Dump(
        {
            %{ $Res    || {} },    ## no critic
            %{ $Params || {} },    ## no critic
        }
    );

    if ( $Self->{SuppressCommandRecording} ) {
        print $TestName;
    }
    else {
        $Self->{UnitTestDriverObject}->True( 1, $TestName );
    }

    return $Result;
}

=head2 get()

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

=head2 get_alert_text()

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

=head2 VerifiedGet()

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

=head2 VerifiedRefresh()

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

=head2 Login()

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

            die "Login failed!";
        }

        # login was sucessful
        else {
            last TRY;
        }
    }

    return 1;
}

=head2 WaitFor()

wait with increasing sleep intervals until the given condition is true or the wait time is over.
Exactly one condition (JavaScript or WindowCount) must be specified.

    my $Success = $SeleniumObject->WaitFor(
        AlertPresent   => 1,                                 # Wait until an alert, confirm or prompt dialog is present
        Callback       => sub { ... }                        # Wait until function returns true
        ElementExists  => 'xpath-selector'                   # Wait until an element is present
        ElementExists  => ['css-selector', 'css'],
        ElementMissing => 'xpath-selector',                  # Wait until an element is not present
        ElementMissing => ['css-selector', 'css'],
        JavaScript     => 'return $(".someclass").length',   # Javascript code that checks condition
        WindowCount    => 2,                                 # Wait until this many windows are open
        Time           => 20,                                # optional, wait time in seconds (default 20)
    );

=cut

sub WaitFor {
    my ( $Self, %Param ) = @_;

    if (
        !$Param{JavaScript}
        && !$Param{WindowCount}
        && !$Param{AlertPresent}
        && !$Param{Callback}
        && !$Param{ElementExists}
        && !$Param{ElementMissing}
        )
    {
        die "Need JavaScript, WindowCount, ElementExists, ElementMissing, Callback or AlertPresent.";
    }

    local $Self->{SuppressCommandRecording} = 1;

    $Param{Time} //= 20;
    my $WaitedSeconds = 0;
    my $Interval      = 0.1;
    my $WaitSeconds   = 0.5;

    while ( $WaitedSeconds <= $Param{Time} ) {
        if ( $Param{JavaScript} ) {
            return 1 if $Self->execute_script( $Param{JavaScript} );
        }
        elsif ( $Param{WindowCount} ) {
            return 1 if scalar( @{ $Self->get_window_handles() } ) == $Param{WindowCount};
        }
        elsif ( $Param{AlertPresent} ) {

            # Eval is needed because the method would throw if no alert is present (yet).
            return 1 if eval { $Self->get_alert_text() };
        }
        elsif ( $Param{Callback} ) {
            return 1 if $Param{Callback}->();
        }
        elsif ( $Param{ElementExists} ) {
            my @Arguments
                = ref( $Param{ElementExists} ) eq 'ARRAY' ? @{ $Param{ElementExists} } : $Param{ElementExists};

            if ( eval { $Self->find_element(@Arguments) } ) {
                Time::HiRes::sleep($WaitSeconds);
                return 1;
            }
        }
        elsif ( $Param{ElementMissing} ) {
            my @Arguments
                = ref( $Param{ElementMissing} ) eq 'ARRAY' ? @{ $Param{ElementMissing} } : $Param{ElementMissing};

            if ( !eval { $Self->find_element(@Arguments) } ) {
                Time::HiRes::sleep($WaitSeconds);
                return 1;
            }
        }
        Time::HiRes::sleep($Interval);
        $WaitedSeconds += $Interval;
        $Interval      += 0.1;
    }

    my $Argument = '';
    for my $Key (qw(JavaScript WindowCount AlertPresent)) {
        $Argument = "$Key => $Param{$Key}" if $Param{$Key};
    }
    $Argument = "Callback" if $Param{Callback};

    # Use the selenium error handler to generate a stack trace.
    die $Self->SeleniumErrorHandler("WaitFor($Argument) failed.\n");
}

=head2 SwitchToFrame()

Change focus to another frame on the page. If C<WaitForLoad> is passed, it will wait until the frame has loaded the
page completely.

    my $Success = $SeleniumObject->SwitchToFrame(
        FrameSelector => '.Iframe',     # (required) CSS selector of the frame element
        WaitForLoad   => 1,             # (optional) Wait until the frame has loaded, if necessary
        Time          => 20,            # (optional) Wait time in seconds (default 20)
    );

=cut

sub SwitchToFrame {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FrameSelector} ) {
        die 'Need FrameSelector.';
    }

    if ( $Param{WaitForLoad} ) {
        $Self->WaitFor(
            JavaScript => "return typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core) == 'object'
                && typeof(\$('$Param{FrameSelector}').get(0).contentWindow.Core.App) == 'object'
                && \$('$Param{FrameSelector}').get(0).contentWindow.Core.App.PageLoadComplete;",
            Time => $Param{Time},
        );
    }

    $Self->switch_to_frame( $Self->find_element( $Param{FrameSelector}, 'css' ) );

    return 1;
}

=head2 DragAndDrop()

Drag and drop an element.

    $SeleniumObject->DragAndDrop(
        Element         => '.Element', # (required) css selector of element which should be dragged
        Target          => '.Target',  # (required) css selector of element on which the dragged element should be dropped
        TargetOffset    => {           # (optional) Offset for target. If not specified, the mouse will move to the middle of the element.
            X   => 150,
            Y   => 100,
        }
    );

=cut

sub DragAndDrop {

    my ( $Self, %Param ) = @_;

    # Value is optional parameter
    for my $Needed (qw(Element Target)) {
        if ( !$Param{$Needed} ) {
            die "Need $Needed";
        }
    }

    my %TargetOffset;
    if ( $Param{TargetOffset} ) {
        %TargetOffset = (
            xoffset => $Param{TargetOffset}->{X} || 0,
            yoffset => $Param{TargetOffset}->{Y} || 0,
        );
    }

    # Make sure Element is visible
    $Self->WaitFor(
        JavaScript => 'return typeof($) === "function" && $(\'' . $Param{Element} . ':visible\').length;',
    );
    my $Element = $Self->find_element( $Param{Element}, 'css' );

    # Move mouse to from element, drag and drop
    $Self->mouse_move_to_location( element => $Element );

    # Holds the mouse button on the element
    $Self->button_down();

    # Make sure Target is visible
    $Self->WaitFor(
        JavaScript => 'return typeof($) === "function" && $(\'' . $Param{Target} . ':visible\').length;',
    );
    my $Target = $Self->find_element( $Param{Target}, 'css' );

    # Move mouse to the destination
    $Self->mouse_move_to_location(
        element => $Target,
        %TargetOffset,
    );

    # Release
    $Self->button_up();

    return;
}

=head2 HandleError()

use this method to handle any Selenium exceptions.

    $SeleniumObject->HandleError($@);

It will create a failing test result and store a screen shot of the page
for analysis (in folder /var/otrs-unittest if it exists, in $Home/var/httpd/htdocs otherwise).

=cut

sub HandleError {
    my ( $Self, $Error ) = @_;

    # If we really have a selenium error, get the stack trace for it.
    if ( $Self->{_SeleniumStackTrace} && $Error eq $Self->{_SeleniumException} ) {
        $Error .= "\n" . $Self->{_SeleniumStackTrace};
    }

    $Self->{UnitTestDriverObject}->False( 1, $Error );

    # Don't create a test entry for the screenshot command,
    #   to make sure it gets attached to the previous error entry.
    local $Self->{SuppressCommandRecording} = 1;

    my $Data = $Self->screenshot();
    return if !$Data;
    $Data = MIME::Base64::decode_base64($Data);

    # Attach the screenshot to the actual error entry.
    my $Filename = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomNumber() . '.png';
    $Self->{UnitTestDriverObject}->AttachSeleniumScreenshot(
        Filename => $Filename,
        Content  => $Data
    );

    #
    # Store screenshots in a local folder from where they can be opened directly in the browser.
    #
    my $LocalScreenshotDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/httpd/htdocs/SeleniumScreenshots';
    mkdir $LocalScreenshotDir || return $Self->False( 1, "Could not create $LocalScreenshotDir." );

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
    if ( -d '/var/otrs-unittest/' && -w '/var/otrs-unittest/' ) {

        my $SharedScreenshotDir = '/var/otrs-unittest/SeleniumScreenshots';
        mkdir $SharedScreenshotDir || return $Self->False( 1, "Could not create $SharedScreenshotDir." );

        $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Directory => $SharedScreenshotDir,
            Filename  => $Filename,
            Content   => \$Data,
            )
            || return $Self->{UnitTestDriverObject}->False( 1, "Could not write file $SharedScreenshotDir/$Filename" );
    }

    {
        # Make sure the screenshot URL is output even in non-verbose mode to make it visible
        #   for debugging, but don't register it as a test failure to keep the error count more correct.
        local $Self->{UnitTestDriverObject}->{Verbose} = 1;
        $Self->{UnitTestDriverObject}->True( 1, "Saved screenshot in $URL" );
    }

    return;
}

=head2 DEMOLISH()

override DEMOLISH from L<Selenium::Remote::Driver> (required because this class is managed by L<Moo>).
Performs proper error handling (calls C<HandleError()> if needed). Adds a unit test result to indicate the shutdown,
and performs some clean-ups.

=cut

sub DEMOLISH {
    my $Self = shift;

    if ($TestException) {
        $Self->HandleError($TestException);
    }

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

        # Cleanup all sessions which were created after the selenium test start time.
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

    return;
}

=head1 DEPRECATED FUNCTIONS

=head2 WaitForjQueryEventBound()

waits until event handler is bound to the selected C<jQuery> element. Deprecated - it will be removed in the future releases.

    $SeleniumObject->WaitForjQueryEventBound(
        CSSSelector => 'li > a#Test',       # (required) css selector
        Event       => 'click',             # (optional) Specify event name. Default 'click'.
    );

=cut

sub WaitForjQueryEventBound {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{CSSSelector} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CSSSelector!",
        );
        return;
    }

    my $Event = $Param{Event} || 'click';

    # Wait for element availability.
    $Self->WaitFor(
        JavaScript => 'return typeof($) === "function" && $("' . $Param{CSSSelector} . '").length;'
    );

    # Wait for jQuery initialization.
    $Self->WaitFor(
        JavaScript =>
            'return Object.keys($("' . $Param{CSSSelector} . '")[0]).length > 0'
    );

    # Get jQuery object keys.
    my $Keys = $Self->execute_script(
        'return Object.keys($("' . $Param{CSSSelector} . '")[0]);'
    );

    if ( !IsArrayRefWithData($Keys) ) {
        die "Couldn't determine jQuery object id";
    }

    my $JQueryObjectID;

    KEY:
    for my $Key ( @{$Keys} ) {
        if ( $Key =~ m{^jQuery\d+$} ) {
            $JQueryObjectID = $Key;
            last KEY;
        }
    }

    if ( !$JQueryObjectID ) {
        die "Couldn't determine jQuery object id.";
    }

    # Wait until click event is bound to the element.
    $Self->WaitFor(
        JavaScript =>
            'return $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events
                && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '
                && $("' . $Param{CSSSelector} . '")[0].' . $JQueryObjectID . '.events.' . $Event . '.length > 0;',
    );

    return 1;
}

=head2 InputFieldValueSet()

sets modernized input field value.

    $SeleniumObject->InputFieldValueSet(
        Element => 'css-selector',              # (required) css selector
        Value   => 3,                           # (optional) Value
    );

=cut

sub InputFieldValueSet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Element} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Element!",
        );
        die 'Missing Element.';
    }
    my $Value = $Param{Value} // '';

    if ( $Value !~ m{^\[} && $Value !~ m{^".*"$} ) {

        # Quote text of Value is not array and if not already quoted.
        $Value = "\"$Value\"";
    }

    # Set selected value.
    $Self->execute_script(
        "\$('$Param{Element}').val($Value).trigger('redraw.InputField').trigger('change');"
    );

    # Wait until selection tree is closed.
    $Self->WaitFor(
        ElementMissing => [ '.InputField_ListContainer', 'css' ],
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
