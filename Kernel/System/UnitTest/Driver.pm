# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::UnitTest::Driver;

use strict;
use warnings;

use Storable();
use Term::ANSIColor();

# UnitTest helper must be loaded to override the builtin time functions!
use Kernel::System::UnitTest::Helper;

use Kernel::System::VariableCheck qw(DataIsDifferent);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::UnitTest::Driver - unit test file execution wrapper

=head1 PUBLIC INTERFACE

=head2 new()

create unit test driver object. Do not use it directly, instead use:

    my $Driver = $Kernel::OM->Create(
        'Kernel::System::UnitTest::Driver',
        ObjectParams => {
            Verbose => $Self->{Verbose},
            ANSI    => $Self->{ANSI},
        },
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ANSI}    = $Param{ANSI};
    $Self->{Verbose} = $Param{Verbose};

    # We use an output buffering mechanism if Verbose is not set. Only failed tests will be output in this case.

    # Make sure stuff is always flushed to keep it in the right order.
    *STDOUT->autoflush(1);
    *STDERR->autoflush(1);
    $Self->{OriginalSTDOUT} = *STDOUT;
    $Self->{OriginalSTDOUT}->autoflush(1);
    $Self->{OutputBuffer} = '';

    # Report results via file.
    $Self->{ResultDataFile} = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp/UnitTest.dump';
    unlink $Self->{ResultDataFile};    # purge if exists

    return $Self;
}

=head2 Run()

executes a single unit test file and provides it with an empty environment (fresh C<ObjectManager> instance).

This method assumes that it runs in a dedicated child process just for this one unit test.
This process forking is done in L<Kernel::System::UnitTest>, which creates one child process per test file.

All results will be collected and written to a C<var/tmp/UnitTest.dump> file that the main process will
load to collect all results.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $File = $Param{File};

    my $UnitTestFile = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );

    if ( !$UnitTestFile ) {
        $Self->True( 0, "ERROR: $!: $File" );
        print STDERR "ERROR: $!: $File\n";
        $Self->_SaveResults();
        return;
    }

    print "+-------------------------------------------------------------------+\n";
    print "$File:\n";
    print "+-------------------------------------------------------------------+\n";

    # Use non-overridden time() function.
    my $FileStartTime = CORE::time;    ## no critic

    # Create a new scope to be sure to destroy local object of the test files.
    {
        # Make sure every UT uses its own clean environment.
        ## nofilter(TidyAll::Plugin::OTRS::Perl::ObjectManagerCreation)
        local $Kernel::OM = Kernel::System::ObjectManager->new(
            'Kernel::System::Log' => {
                LogPrefix => 'OTRS-otrs.UnitTest',
            },
        );

        # Provide $Self as 'Kernel::System::UnitTest' for convenience.
        $Kernel::OM->ObjectInstanceRegister(
            Package      => 'Kernel::System::UnitTest::Driver',
            Object       => $Self,
            Dependencies => [],
        );

        $Self->{OutputBuffer} = '';
        local *STDOUT = *STDOUT;
        local *STDERR = *STDERR;
        if ( !$Self->{Verbose} ) {
            undef *STDOUT;
            undef *STDERR;
            open STDOUT, '>:utf8', \$Self->{OutputBuffer};    ## no critic
            open STDERR, '>:utf8', \$Self->{OutputBuffer};    ## no critic
        }

        # HERE the actual tests are run.
        my $TestSuccess = eval ${$UnitTestFile};              ## no critic

        if ( !$TestSuccess ) {
            if ($@) {
                $Self->True( 0, "ERROR: Error in $File: $@" );
            }
            else {
                $Self->True( 0, "ERROR: $File did not return a true value." );
            }
        }
    }

    # Use non-overridden time() function.
    $Self->{ResultData}->{Duration} = CORE::time - $FileStartTime;    ## no critic

    if ( $Self->{SeleniumCapabilities} ) {
        $Self->{ResultData}->{SeleniumBrowser} = $Self->{SeleniumCapabilities};
    }

    print { $Self->{OriginalSTDOUT} } "\n";

    return $Self->_SaveResults();
}

=head2 True()

test for a scalar value that evaluates to true.

Send a scalar value to this function along with the test's name:

    $UnitTestObject->True(1, 'Test Name');

    $UnitTestObject->True($ParamA, 'Test Name');

Internally, the function receives this value and evaluates it to see
if it's true, returning 1 in this case or undef, otherwise.

    my $TrueResult = $UnitTestObject->True(
        $TestValue,
        'Test Name',
    );

=cut

sub True {
    my ( $Self, $True, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. True(\$A, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. True(\$A, \'Test Name\')' );
        return;
    }

    if ($True) {
        $Self->_Print( 1, $Name );
        return 1;
    }
    else {
        $Self->_Print( 0, $Name );
        return;
    }
}

=head2 False()

test for a scalar value that evaluates to false.

It has the same interface as L</True()>, but tests
for a false value instead.

=cut

sub False {
    my ( $Self, $False, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. False(\$A, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. False(\$A, \'Test Name\')' );
        return;
    }

    if ( !$False ) {
        $Self->_Print( 1, $Name );
        return 1;
    }
    else {
        $Self->_Print( 0, $Name );
        return;
    }
}

=head2 Is()

compares two scalar values for equality.

To this function you must send a pair of scalar values to compare them,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject->Is($A, $B, 'Test Name');

Returns 1 if the values were equal, or undef otherwise.

    my $IsResult = $UnitTestObject->Is(
        $ValueFromFunction,      # test data
        1,                       # expected value
        'Test Name',
    );

=cut

sub Is {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. Is(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. Is(\$A, \$B, \'Test Name\')' );
        return;
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef' should be '$ShouldBe')" );
        return;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is '$Test' should be 'undef')" );
        return;
    }
    elsif ( $Test eq $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$ShouldBe')" );
        return 1;
    }
    else {
        $Self->_Print( 0, "$Name (is '$Test' should be '$ShouldBe')" );
        return;
    }
}

=head2 IsNot()

compares two scalar values for inequality.

It has the same interface as L</Is()>, but tests
for inequality instead.

=cut

sub IsNot {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')' );
        return;
    }

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef')" );
        return;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$Test')" );
        return 1;
    }
    if ( $Test ne $ShouldBe ) {
        $Self->_Print( 1, "$Name (is '$Test')" );
        return 1;
    }
    else {
        $Self->_Print( 0, "$Name (is '$Test' should not be '$ShouldBe')" );
        return;
    }
}

=head2 IsDeeply()

compares complex data structures for equality.

To this function you must send the references to two data structures to be compared,
and the name that the test will take, this is done as shown in the examples
below.

    $UnitTestObject-> IsDeeply($ParamA, $ParamB, 'Test Name');

Where $ParamA and $ParamB must be references to a structure (scalar, list or hash).

Returns 1 if the data structures are the same, or undef otherwise.

    my $IsDeeplyResult = $UnitTestObject->IsDeeply(
        \%ResultHash,           # test data
        \%ExpectedHash,         # expected value
        'Dummy Test Name',
    );

=cut

sub IsDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. Is(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. Is(\$A, \$B, \'Test Name\')' );
        return;
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef' should be defined)" );
        return;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is defined should be 'undef')" );
        return;
    }
    elsif ( !$Diff ) {
        $Self->_Print( 1, "$Name matches expected value" );
        return 1;
    }
    else {
        my $ShouldBeDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($ShouldBe);
        my $TestDump     = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        $Self->_Print( 0, "$Name (is '$TestDump' should be '$ShouldBeDump')" );
        return;
    }
}

=head2 IsNotDeeply()

compares two data structures for inequality.

It has the same interface as L</IsDeeply()>, but tests
for inequality instead.

=cut

sub IsNotDeeply {
    my ( $Self, $Test, $ShouldBe, $Name ) = @_;

    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')!'
        );
        $Self->_Print( 0, 'ERROR: Need Name! E. g. IsNot(\$A, \$B, \'Test Name\')' );
        return;
    }

    my $Diff = DataIsDifferent(
        Data1 => $Test,
        Data2 => $ShouldBe,
    );

    if ( !defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 0, "$Name (is 'undef')" );
        return;
    }
    elsif ( !defined $Test && defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (is 'undef')" );
        return 1;
    }
    elsif ( defined $Test && !defined $ShouldBe ) {
        $Self->_Print( 1, "$Name (differs from expected value)" );
        return 1;
    }

    if ($Diff) {
        $Self->_Print( 1, "$Name (The structures are not equal.)" );
        return 1;
    }
    else {

        #        $Self->_Print( 0, "$Name (matches the expected value)" );
        my $TestDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($Test);
        $Self->_Print( 0, "$Name (The structures are equal: '$TestDump')" );

        return;
    }
}

=head2 AttachSeleniumScreenshot()

attach a screenshot taken during Selenium error handling. These will be sent to the server
together with the test results.

    $Driver->AttachSeleniumScreenshot(
        Filename => $Filename,
        Content  => $Data               # raw image data
    );

=cut

sub AttachSeleniumScreenshot {
    my ( $Self, %Param ) = @_;

    push @{ $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Screenshots} },
        {
        Filename => $Param{Filename},
        Content  => $Param{Content},
        };

    return;
}

=begin Internal:

=cut

sub _SaveResults {
    my ($Self) = @_;

    if ( !$Self->{ResultData} ) {
        $Self->True( 0, 'No result data found.' );
    }

    my $Success = Storable::nstore( $Self->{ResultData}, $Self->{ResultDataFile} );
    if ( !$Success ) {
        print STDERR $Self->_Color( 'red', "Could not store result data in $Self->{ResultDataFile}\n" );
        return 0;
    }

    return 1;
}

sub _Print {
    my ( $Self, $ResultOk, $Message ) = @_;

    $Message ||= '->>No Name!<<-';

    my $ShortMessage = $Message;
    if ( length $ShortMessage > 1000 && !$Self->{Verbose} ) {
        $ShortMessage = substr( $ShortMessage, 0, 1000 ) . "...";
    }

    if ( $Self->{Verbose} || !$ResultOk ) {
        print { $Self->{OriginalSTDOUT} } $Self->{OutputBuffer};
    }
    $Self->{OutputBuffer} = '';

    $Self->{TestCount}++;
    if ($ResultOk) {
        if ( $Self->{Verbose} ) {
            print { $Self->{OriginalSTDOUT} } " "
                . $Self->_Color( 'green', "ok" )
                . " $Self->{TestCount} - $ShortMessage\n";
        }
        else {
            print { $Self->{OriginalSTDOUT} } $Self->_Color( 'green', "." );
        }

        $Self->{ResultData}->{TestOk}++;
        return 1;
    }
    else {
        if ( !$Self->{Verbose} ) {
            print { $Self->{OriginalSTDOUT} } "\n";
        }
        print { $Self->{OriginalSTDOUT} } " "
            . $Self->_Color( 'red', "not ok" )
            . " $Self->{TestCount} - $ShortMessage\n";
        $Self->{ResultData}->{TestNotOk}++;
        $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Status}  = 'not ok';
        $Self->{ResultData}->{Results}->{ $Self->{TestCount} }->{Message} = $Message;

        my $TestFailureDetails = $Message;
        $TestFailureDetails =~ s{\(.+\)$}{};
        if ( length $TestFailureDetails > 200 ) {
            $TestFailureDetails = substr( $TestFailureDetails, 0, 200 ) . "...";
        }

        # Store information about failed tests, but only if we are running in a toplevel unit test object
        #   that is actually processing files, and not in an embedded object that just runs individual tests.
        push @{ $Self->{ResultData}->{NotOkInfo} }, sprintf "%s - %s", $Self->{TestCount},
            $TestFailureDetails;

        return;
    }
}

=head2 _Color()

this will color the given text (see Term::ANSIColor::color()) if
ANSI output is available and active, otherwise the text stays unchanged.

    my $PossiblyColoredText = $CommandObject->_Color('green', $Text);

=cut

sub _Color {
    my ( $Self, $Color, $Text ) = @_;

    return $Text if !$Self->{ANSI};
    return Term::ANSIColor::color($Color) . $Text . Term::ANSIColor::color('reset');
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
