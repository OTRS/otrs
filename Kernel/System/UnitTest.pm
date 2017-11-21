# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest;

use strict;
use warnings;

use if $^O eq 'MSWin32', "Win32::Console::ANSI";
use File::stat;
use Term::ANSIColor;

use Kernel::System::ObjectManager;

# UnitTest helper must be loaded to override the builtin time functions!
use Kernel::System::UnitTest::Helper;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SupportDataCollector',
    'Kernel::System::Time',
    'Kernel::System::WebUserAgent',
);

=head1 NAME

Kernel::System::UnitTest - global unit test interface

=head1 SYNOPSIS

Functions to run existing unit tests, as well as functions to define test cases.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create unit test object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $UnitTestObject = $Kernel::OM->Get('Kernel::System::UnitTest');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{ResultData} = undef;
    $Self->{TestFile}   = '';

    # Make sure stuff is always flushed to keep it in the right order.
    *STDOUT->autoflush(1);
    *STDERR->autoflush(1);
    $Self->{OriginalSTDOUT} = *STDOUT;
    $Self->{OriginalSTDOUT}->autoflush(1);

    return $Self;
}

=item Run()

Run all tests located in scripts/test/*.t and print result to stdout.

    $UnitTestObject->Run(
        Tests                  => 'JSON:User:Auth',     # optional, execute certain test files only
        Directory              => 'Selenium',           # optional, execute tests in subdirectory
        Verbose                => 1,                    # optional (default 0), show result details for all tests, not just failing
        SubmitURL              => $URL,                 # optional, send results to unit test result server
        SubmitAuth             => '0abc86125f0fd37baae' # optional authentication string for unit test result server
        SubmitResultAsExitCode => 1,                    # optional, specify if exit code should not indicate if tests were ok/not ok, but if submission was successful instead
        JobID                  => 12,                   # optional job ID for unit test submission to server
        Scenario               => 'OTRS 4 git',         # optional scenario identifier for unit test submission to server
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Verbose} = $Param{Verbose};

    my $Product
        = $Kernel::OM->Get('Kernel::Config')->Get('Product') . " " . $Kernel::OM->Get('Kernel::Config')->Get('Version');

    my $Home      = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $Directory = "$Home/scripts/test";
    if ( $Param{Directory} ) {
        $Directory .= "/$Param{Directory}";
        $Directory =~ s/\.//g;
    }

    my @TestsToExecute = split( /:/, $Param{Tests} || '' );

    $Self->{TestCountOk}    = 0;
    $Self->{TestCountNotOk} = 0;

    my $StartTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.t',
        Recursive => 1,
    );

    FILE:
    for my $File (@Files) {

        # check if only some tests are requested
        if ( @TestsToExecute && !grep { $File =~ /\/\Q$_\E\.t$/smx } @TestsToExecute ) {
            next FILE;
        }

        $Self->{TestCount} = 0;

        my $UnitTestFile = $Kernel::OM->Get('Kernel::System::Main')->FileRead( Location => $File );
        if ( !$UnitTestFile ) {
            $Self->True( 0, "ERROR: $!: $File" );
            print STDERR "ERROR: $!: $File\n";
            next FILE;
        }

        print "+-------------------------------------------------------------------+\n";
        print "$File:\n";
        print "+-------------------------------------------------------------------+\n";

        $Self->{TestFile} = $File;

        my $FileStartTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

        # create a new scope to be sure to destroy local object of the test files
        {
            # Make sure every UT uses its own clean environment.
            local $Kernel::OM = Kernel::System::ObjectManager->new(
                'Kernel::System::Log' => {
                    LogPrefix => 'OTRS-otrs.UnitTest',
                },
            );

            # Provide $Self as 'Kernel::System::UnitTest' for convenience.
            $Kernel::OM->ObjectInstanceRegister(
                Package      => 'Kernel::System::UnitTest',
                Object       => $Self,
                Dependencies => [],
            );

            push @{ $Self->{NotOkInfo} }, [$File];

            $Self->{OutputBuffer} = '';
            local *STDOUT = *STDOUT;
            local *STDERR = *STDERR;
            if ( !$Param{Verbose} ) {
                undef *STDOUT;
                undef *STDERR;
                open STDOUT, '>:utf8', \$Self->{OutputBuffer};    ## no critic
                open STDERR, '>:utf8', \$Self->{OutputBuffer};    ## no critic
            }

            # HERE the actual tests are run!!!
            if ( !eval ${$UnitTestFile} ) {                       ## no critic
                if ($@) {
                    $Self->True( 0, "ERROR: Error in $File: $@" );
                }
                else {
                    $Self->True( 0, "ERROR: $File did not return a true value." );
                }
            }
        }

        my $FileDuration = $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - $FileStartTime;
        $Self->{ResultData}->{$File}->{Duration} = $FileDuration;

        print "\n";
    }

    my $EndTime  = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    my $Duration = $EndTime - $StartTime;

    my $Host = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    print "=====================================================================\n";
    print "$Host ran tests in ${Duration}s";
    print " for $Product\n";

    if ( $Self->{TestCountNotOk} ) {
        print "$Self->{TestCountNotOk} tests failed.\n";
    }
    else {
        if ( $Self->{TestCountOk} ) {
            print "All $Self->{TestCountOk} tests passed.\n";
        }
        else {
            print "No tests executed.\n";
        }
    }

    if ( $Self->{TestCountNotOk} ) {
        print " FailedTests:\n";
        FAILEDFILE:
        for my $FailedFile ( @{ $Self->{NotOkInfo} || [] } ) {
            my ( $File, @Tests ) = @{ $FailedFile || [] };
            next FAILEDFILE if !@Tests;
            print sprintf "  %s #%s\n", $File, join ", ", @Tests;
        }
    }

    if ( $Param{SubmitURL} ) {

        my %SupportData = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
        die "Could not collect SupportData.\n" if !$SupportData{Success};

        my %SubmitData = (
            Auth     => $Param{SubmitAuth} // '',
            JobID    => $Param{JobID}      // '',
            Scenario => $Param{Scenario}   // '',
            Meta     => {
                StartTime => $StartTime,
                Duration  => $Duration,
                TestOk    => $Self->{TestCountOk},
                TestNotOk => $Self->{TestCountNotOk},
            },
            SupportData => $SupportData{Result},
            Results     => $Self->{ResultData},
        );

        print "=====================================================================\n";
        print "Sending results to $Param{SubmitURL} ...\n";

        # Flush possible output log files to be able to submit them.
        *STDOUT->flush();
        *STDERR->flush();

        # Limit attachment sizes to 2MB in total.
        my @AttachmentPath  = split( /:/, $Param{AttachmentPath} || '' );
        my $AttachmentCount = scalar @AttachmentPath;
        my $AttachmentsSize = 1024 * 1024 * 2;

        ATTACHMENT_PATH:
        for my $AttachmentPath (@AttachmentPath) {
            my $FileHandle;
            my $Content;

            if ( !open $FileHandle, '<:encoding(UTF-8)', $AttachmentPath ) {    ## no-critic
                print "Could not open file $AttachmentPath, skipping.\n";
                next ATTACHMENT_PATH;
            }

            # Read only allocated size of file to try to avoid out of memory error.
            if ( !read $FileHandle, $Content, $AttachmentsSize / $AttachmentCount ) {    ## no-critic
                print "Could not read file $AttachmentPath, skipping.\n";
                close $FileHandle;
                next ATTACHMENT_PATH;
            }

            my $Stat = stat($AttachmentPath);

            if ( !$Stat ) {
                print "Cannot stat file $AttachmentPath, skipping.\n";
                next ATTACHMENT_PATH;
            }

            # If file size exceeds the limit, include message about shortening at the end.
            if ( $Stat->size() > $AttachmentsSize / $AttachmentCount ) {
                $Content .= "\nThis file has been shortened because of size constraint.";
            }

            close $FileHandle;

            $SubmitData{Attachments}->{$AttachmentPath} = $Content;
        }

        my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

        # Perform web service request and get response.
        my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
            Type => 'POST',
            URL  => $Param{SubmitURL},
            Data => {
                Action      => 'PublicCIMaster',
                Subaction   => 'TestResults',
                RequestData => $JSONObject->Encode(
                    Data => \%SubmitData,
                ),
            },
        );

        if ( $Response{Status} ne '200 OK' ) {
            print "Submission to server failed (status code '$Response{Status}').\n";
            return;
        }

        if ( !$Response{Content} ) {
            print "Submission to server failed (no response).\n";
            return;
        }

        # Convert internal used charset.
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput(
            $Response{Content},
        );

        my $ResponseData = $JSONObject->Decode(
            Data => ${ $Response{Content} },
        );

        if ( !$ResponseData ) {
            print "Submission to server failed (invalid response).\n";
            return;
        }

        if ( !$ResponseData->{Success} && $ResponseData->{ErrorMessage} ) {
            print "Submission to server failed (error message '$ResponseData->{ErrorMessage}').\n";
            return;
        }

        print "Submission was successful.\n";

        if ( $Param{SubmitResultAsExitCode} ) {
            return 1;
        }
    }

    return $Self->{TestCountNotOk} ? 0 : 1;
}

=item True()

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

=item False()

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

=item Is()

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

=item IsNot()

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

=item IsDeeply()

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

    my $Diff = $Self->_DataDiff(
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

=item IsNotDeeply()

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

    my $Diff = $Self->_DataDiff(
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

=begin Internal:

=cut

=item _DataDiff()

compares two data structures with each other. Returns 1 if
they are different, undef otherwise.

Data parameters need to be passed by reference and can be SCALAR,
ARRAY or HASH.

    my $DataIsDifferent = $UnitTestObject->_DataDiff(
        Data1 => \$Data1,
        Data2 => \$Data2,
    );

=cut

sub _DataDiff {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data1 Data2)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # ''
    if ( ref $Param{Data1} eq '' && ref $Param{Data2} eq '' ) {

        # do nothing, it's ok
        return if !defined $Param{Data1} && !defined $Param{Data2};

        # return diff, because its different
        return 1 if !defined $Param{Data1} || !defined $Param{Data2};

        # return diff, because its different
        return 1 if $Param{Data1} ne $Param{Data2};

        # return, because its not different
        return;
    }

    # SCALAR
    if ( ref $Param{Data1} eq 'SCALAR' && ref $Param{Data2} eq 'SCALAR' ) {

        # do nothing, it's ok
        return if !defined ${ $Param{Data1} } && !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if !defined ${ $Param{Data1} } || !defined ${ $Param{Data2} };

        # return diff, because its different
        return 1 if ${ $Param{Data1} } ne ${ $Param{Data2} };

        # return, because its not different
        return;
    }

    # ARRAY
    if ( ref $Param{Data1} eq 'ARRAY' && ref $Param{Data2} eq 'ARRAY' ) {
        my @A = @{ $Param{Data1} };
        my @B = @{ $Param{Data2} };

        # check if the count is different
        return 1 if $#A ne $#B;

        # compare array
        COUNT:
        for my $Count ( 0 .. $#A ) {

            # do nothing, it's ok
            next COUNT if !defined $A[$Count] && !defined $B[$Count];

            # return diff, because its different
            return 1 if !defined $A[$Count] || !defined $B[$Count];

            if ( $A[$Count] ne $B[$Count] ) {
                if ( ref $A[$Count] eq 'ARRAY' || ref $A[$Count] eq 'HASH' ) {
                    return 1 if $Self->_DataDiff(
                        Data1 => $A[$Count],
                        Data2 => $B[$Count]
                    );
                    next COUNT;
                }
                return 1;
            }
        }
        return;
    }

    # HASH
    if ( ref $Param{Data1} eq 'HASH' && ref $Param{Data2} eq 'HASH' ) {
        my %A = %{ $Param{Data1} };
        my %B = %{ $Param{Data2} };

        # compare %A with %B and remove it if checked
        KEY:
        for my $Key ( sort keys %A ) {

            # Check if both are undefined
            if ( !defined $A{$Key} && !defined $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next KEY;
            }

            # return diff, because its different
            return 1 if !defined $A{$Key} || !defined $B{$Key};

            if ( $A{$Key} eq $B{$Key} ) {
                delete $A{$Key};
                delete $B{$Key};
                next KEY;
            }

            # return if values are different
            if ( ref $A{$Key} eq 'ARRAY' || ref $A{$Key} eq 'HASH' ) {
                return 1 if $Self->_DataDiff(
                    Data1 => $A{$Key},
                    Data2 => $B{$Key}
                );
                delete $A{$Key};
                delete $B{$Key};
                next KEY;
            }
            return 1;
        }

        # check rest
        return 1 if %B;
        return;
    }

    if ( ref $Param{Data1} eq 'REF' && ref $Param{Data2} eq 'REF' ) {
        return 1 if $Self->_DataDiff(
            Data1 => ${ $Param{Data1} },
            Data2 => ${ $Param{Data2} }
        );
        return;
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
        $Self->{TestCountOk}++;
        if ( $Self->{Verbose} ) {
            print { $Self->{OriginalSTDOUT} } " ok $Self->{TestCount} - $ShortMessage\n";
        }
        else {
            print { $Self->{OriginalSTDOUT} } '.';
        }
        $Self->{ResultData}->{ $Self->{TestFile} }->{TestOk}++;
        return 1;
    }
    else {
        $Self->{TestCountNotOk}++;
        if ( !$Self->{Verbose} ) {
            print { $Self->{OriginalSTDOUT} } "\n";
        }
        print { $Self->{OriginalSTDOUT} } " not ok $Self->{TestCount} - $ShortMessage\n";
        $Self->{ResultData}->{ $Self->{TestFile} }->{TestNotOk}++;
        $Self->{ResultData}->{ $Self->{TestFile} }->{Results}->{ $Self->{TestCount} }->{Status}  = 'not ok';
        $Self->{ResultData}->{ $Self->{TestFile} }->{Results}->{ $Self->{TestCount} }->{Message} = $Message;

        my $TestFailureDetails = $Message;
        $TestFailureDetails =~ s{\(.+\)$}{};
        if ( length $TestFailureDetails > 200 ) {
            $TestFailureDetails = substr( $TestFailureDetails, 0, 200 ) . "...";
        }

        # Store information about failed tests, but only if we are running in a toplevel unit test object
        #   that is actually processing files, and not in an embedded object that just runs individual tests.
        if ( ref $Self->{NotOkInfo} eq 'ARRAY' ) {
            push @{ $Self->{NotOkInfo}->[-1] }, sprintf "%s - %s", $Self->{TestCount},
                $TestFailureDetails;
        }

        return;
    }
}

sub AttachSeleniumScreenshot {
    my ( $Self, %Param ) = @_;

    push @{ $Self->{ResultData}->{ $Self->{TestFile} }->{Results}->{ $Self->{TestCount} }->{Screenshots} },
        {
        Filename => $Param{Filename},
        Content  => $Param{Content},
        };

    return;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
