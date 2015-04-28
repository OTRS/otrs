# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Selenium;
## nofilter(TidyAll::Plugin::OTRS::Perl::Goto)

use strict;
use warnings;

use base qw(Selenium::Remote::Driver);
use MIME::Base64();
use File::Temp();

use Kernel::Config;
use Kernel::System::User;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::UnitTest',
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
    };

Then you can use the full API of Selenium::Remote::Driver on this object.

=cut

sub new {
    my ( $Class, %Param ) = @_;

    $Param{UnitTestObject} ||= $Kernel::OM->Get('Kernel::System::UnitTest');

    $Param{UnitTestObject}->True( 1, "Starting up Selenium scenario..." );

    my %SeleniumTestsConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('SeleniumTestsConfig') // {} };

    if ( !%SeleniumTestsConfig ) {
        my $Self = bless {}, $Class;
        $Self->{UnitTestObject} = $Param{UnitTestObject};
        return $Self;
    }

    for my $Needed (qw(remote_server_addr port browser_name platform)) {
        if ( !$SeleniumTestsConfig{$Needed} ) {
            die "SeleniumTestsConfig must provide $Needed!";
        }
    }

    my $Self = $Class->SUPER::new(%SeleniumTestsConfig);
    $Self->{UnitTestObject}      = $Param{UnitTestObject};
    $Self->{SeleniumTestsActive} = 1;

    #$Self->debug_on();
    $Self->set_window_size( 1024, 768 );

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
        $Self->{UnitTestObject}->True( 1, 'Selenium testing is not active, skipping tests.' );
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

    $Self->{UnitTestObject}->True(
        1,
        $TestName
    );

    return $Result;
}

=item get()

Override get method of base class to prepend the correct base URL.

=cut

sub get {    ## no critic
    my ( $Self, $URL ) = @_;

    if ( $URL !~ m{http[s]?://}smx ) {
        $URL = "$Self->{BaseURL}/$URL";
    }

    $Self->SUPER::get($URL);

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

    $Self->{UnitTestObject}->True( 1, 'Initiating login...' );

    eval {
        $Self->delete_all_cookies();

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        if ( $Param{Type} eq 'Agent' ) {
            $ScriptAlias .= 'index.pl';
        }
        else {
            $ScriptAlias .= 'customer.pl';
        }

        # First load the page so we can delete any pre-existing cookies
        $Self->get("${ScriptAlias}");
        $Self->delete_all_cookies();

        # Now load it again to login
        $Self->get("${ScriptAlias}");

        my $Element = $Self->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $Param{User} );

        $Element = $Self->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $Param{Password} );

        # login
        $Element->submit();

        # Wait until form has loaded, if neccessary
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Self->execute_script("return \$('a#LogoutButton').length") ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

        # login succressful?
        $Element = $Self->find_element( 'a#LogoutButton', 'css' );

        $Self->{UnitTestObject}->True( 1, 'Login sequence ended...' );
    };
    if ($@) {
        $Self->HandleError($@);
        die "Login failed!";
    }

    return 1;
}

=item HandleError()

use this method to handle any Selenium exceptions.

    $SeleniumObject->HandleError($@);

It will create a failing test result and store a screenshot of the page
for analysis.

=cut

sub HandleError {
    my ( $Self, $Error ) = @_;

    $Self->{UnitTestObject}->False( 1, "Exception in Selenium': $Error" );

    #eval {
    my $Data = $Self->screenshot();
    return if !$Data;
    $Data = MIME::Base64::decode_base64($Data);

    # This file should survive unit test scenario runs, so save it in a global directory.
    my ( $FH, $Filename ) = File::Temp::tempfile(
        DIR    => '/tmp/',
        SUFFIX => '.png',
        UNLINK => 0,
    );
    close $FH;
    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $Filename,
        Content  => \$Data,
    );

    $Self->{UnitTestObject}->False(
        1,
        "Saved screenshot in file://$Filename",
    );

    #}
}

=item DESTROY()

cleanup. Adds a unit test result to indicate the shutdown.

=cut

sub DESTROY {
    my $Self = shift;

    # Could be missing on early die.
    if ( $Self->{UnitTestObject} ) {
        $Self->{UnitTestObject}->True( 1, "Shutting down Selenium scenario." );
    }

    if ( $Self->{SeleniumTestsActive} ) {
        $Self->SUPER::DESTROY();
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
