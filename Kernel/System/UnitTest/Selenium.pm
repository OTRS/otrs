# --
# Selenium.pm - run frontend tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Selenium.pm,v 1.8 2010-12-22 09:22:59 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Selenium;

use strict;
use base qw(WWW::Selenium);

use Kernel::Config;
use Kernel::System::User;

=head1 NAME

Kernel::System::UnitTest::Selenium - run frontend tests

=over 4

=cut

sub new {
    my ( $Class, %Param ) = @_;

    # check needed objects
    if ( !$Param{UnitTestObject} ) {
        die "Got no UnitTestObject!";
    }

    $Param{host}        ||= 'localhost';
    $Param{port}        ||= '4444';
    $Param{browser}     ||= '*chrome';
    $Param{browser_url} ||= 'http://127.0.0.1/';

    my $default_names = defined $Param{default_names}
        ?
        delete $Param{default_names}
        : 1;

    my $Self = $Class->SUPER::new(%Param);
    $Self->{default_names} = $default_names;
    $Self->start;

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

    return $Self;
}

our $AUTOLOAD;

my %comparator = (
    is     => 'Is',
    isnt   => 'IsNot',
    like   => 'Like',
    unlike => 'Unlike',
);

# These commands don't require a locator
# grep item lib/WWW/Selenium.pm | grep sel | grep \(\) | grep get
my %no_locator = map { $_ => 1 }
    qw(alert confirmation prompt absolute_location location
    title body_text all_buttons all_links all_fields);

sub AUTOLOAD {
    my $Self = $_[0];

    my $Name = $AUTOLOAD;

    if ( $Self->{Verbose} ) {
        print STDERR "Called AUTOLOAD for $AUTOLOAD...\n";
    }

    $Name =~ s/.*:://;
    return if $Name eq 'DESTROY';

    my $sub;
    if ( $Name =~ /(\w+)_(is|isnt|like|unlike)$/i ) {
        my $getter     = "get_$1";
        my $comparator = $comparator{ lc $2 };

        # make a subroutine that will call Test::Builder's test methods
        # with selenium data from the getter
        if ( $no_locator{$1} ) {
            $sub = sub {
                my ( $Self, $str, $Name ) = @_;

                #
                # diag
                #
                print STDERR "Test::WWW::Selenium running $getter (@_[1..$#_])\n"
                    if $Self->{Verbose};
                $Name = "$getter, '$str'"
                    if $Self->{default_names} and !defined $Name;
                no strict 'refs';
                return $Self->{UnitTestObject}->$comparator( $Self->$getter, $str, $Name );
            };
        }
        else {
            $sub = sub {
                my ( $Self, $locator, $str, $Name ) = @_;

                #
                # diag
                #
                print STDERR "Test::WWW::Selenium running $getter (@_[1..$#_])\n"
                    if $Self->{Verbose};
                $Name = "$getter, $locator, '$str'"
                    if $Self->{default_names} and !defined $Name;
                no strict 'refs';
                return $Self->{UnitTestObject}
                    ->$comparator( $Self->$getter($locator), $str, $Name );
            };
        }
    }
    elsif ( $Name =~ /(\w+?)_?ok$/i ) {
        my $cmd = $1;

        # make a subroutine for ok() around the selenium command
        $sub = sub {
            my ( $Self, $arg1, $arg2, $Name ) = @_;
            if ( $Self->{default_names} and !defined $Name ) {
                $Name = $cmd;
                $Name .= ", $arg1" if defined $arg1;
                $Name .= ", $arg2" if defined $arg2;
            }

            #
            # diag
            #
            print STDERR "Test::WWW::Selenium running $cmd (@_[1..$#_])\n"
                if $Self->{Verbose};

            my $rc = '';
            eval { $rc = $Self->$cmd( $arg1, $arg2 ) };
            die $@ if $@ and $@ =~ /Can't locate object method/;

            #
            # diag
            #
            print STDERR ($@) if $@;

            return $Self->{UnitTestObject}->True( $rc, $Name );
        };
    }

    # jump directly to the new subroutine, avoiding an extra frame stack
    if ($sub) {
        no strict 'refs';
        *{$AUTOLOAD} = $sub;
        goto &$AUTOLOAD;
    }
    else {

        # try to pass through to WWW::Selenium
        my $sel = 'WWW::Selenium';
        my $sub = "${sel}::${Name}";
        goto &$sub if exists &$sub;
        my ( $package, $filename, $line ) = caller;
        die qq(Can't locate object method "$Name" via package ")
            . __PACKAGE__
            . qq(" (also tried "$sel") at $filename line $line\n);
    }
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    $Self->{UnitTestObject}->True( 1, 'Initiating login...' );

    my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

    if ( $Param{Type} eq 'Agent' ) {
        $ScriptAlias .= 'index.pl';
    }
    else {
        $ScriptAlias .= 'customer.pl';
    }
    $Self->open_ok("${ScriptAlias}?Action=Logout");

    $Self->is_editable_ok("User");
    $Self->type_ok( "User", $Param{User} );
    $Self->is_editable_ok("Password");
    $Self->type_ok( "Password", $Param{Password} );
    $Self->is_visible_ok("//button[\@id='LoginButton']");

    if ( !$Self->click_ok("//button[\@id='LoginButton']") ) {
        $Self->{UnitTestObject}->False( 1, "Could not submit login form" );
        return;
    }
    $Self->wait_for_page_to_load_ok("30000");

    if ( !$Self->is_element_present_ok("css=a#LogoutButton") ) {
        $Self->{UnitTestObject}->False( 1, "Login was not successful" );
        return;
    }

    $Self->{UnitTestObject}->True( 1, 'Login sequence ended...' );

    return 1;
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

    return $Self->SUPER::DESTROY();
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

$Revision: 1.8 $ $Date: 2010-12-22 09:22:59 $

=cut
