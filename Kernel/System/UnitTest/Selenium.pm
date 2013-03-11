# --
# Selenium.pm - run frontend tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest::Selenium;

use strict;
use warnings;
use base qw(WWW::Selenium);

use Kernel::Config;
use Kernel::System::User;

=head1 NAME

Kernel::System::UnitTest::Selenium - run frontend tests

=over 4

=cut

# TODO: fix no critic
## no critic

sub new {
    my ( $Class, %Param ) = @_;

    # check needed objects
    for my $Needed (qw(UnitTestObject ID host port browser browser_url)) {
        if ( !$Param{$Needed} ) {
            die "Got no $Needed!";
        }
    }

    $Param{UnitTestObject}->True( 1, "Starting up Selenium scenario '$Param{ID}'..." );

    # selenium stuff
    my $DefaultNames = defined $Param{default_names}
        ?
        delete $Param{default_names}
        : 1;

    my $Self = $Class->SUPER::new(%Param);
    $Self->{default_names} = $DefaultNames;
    $Self->start;

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

    my $ScriptAlias = $Self->{UnitTestObject}->{ConfigObject}->Get('ScriptAlias');

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

sub DESTROY {
    my $Self = shift;

    $Self->{UnitTestObject}->True( 1, "Shutting down Selenium scenario" );

    $Self->SUPER::DESTROY();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
