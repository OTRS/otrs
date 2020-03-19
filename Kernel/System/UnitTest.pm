# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::UnitTest;

use strict;
use warnings;

use File::stat;
use Storable();
use Term::ANSIColor();
use Time::HiRes();

use Kernel::System::VariableCheck qw(IsHashRefWithData IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::SupportDataCollector',
    'Kernel::System::WebUserAgent',
);

=head1 NAME

Kernel::System::UnitTest - functions to run all or some OTRS unit tests

=head1 PUBLIC INTERFACE

=head2 new()

create unit test object. Do not use it directly, instead use:

    my $UnitTestObject = $Kernel::OM->Get('Kernel::System::UnitTest');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;
    $Self->{ANSI}  = $Param{ANSI};

    return $Self;
}

=head2 Run()

run all or some tests located in C<scripts/test/**/*.t> and print the result.

    $UnitTestObject->Run(
        Name                   => ['JSON', 'User'],     # optional, execute certain test files only
        Directory              => 'Selenium',           # optional, execute tests in subdirectory
        Verbose                => 1,                    # optional (default 0), only show result details for all tests, not just failing
        SubmitURL              => $URL,                 # optional, send results to unit test result server
        SubmitAuth             => '0abc86125f0fd37baae' # optional authentication string for unit test result server
        SubmitResultAsExitCode => 1,                    # optional, specify if exit code should not indicate if tests were ok/not ok, but if submission was successful instead
        JobID                  => 12,                   # optional job ID for unit test submission to server
        Scenario               => 'OTRS 6 git',         # optional scenario identifier for unit test submission to server
        PostTestScripts        => ['...'],              # Script(s) to execute after a test has been run.
                                                        #  You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.
        PreSubmitScripts       => ['...'],              # Script(s) to execute after all tests have been executed
                                                        #  and the results are about to be sent to the server.
        NumberOfTestRuns       => 10,                   # optional (default 1), number of successive runs for every single unit test
    );

Please note that the individual test files are not executed in the main process,
but instead in separate forked child processes which are controlled by L<Kernel::System::UnitTest::Driver>.
Their results will be transmitted to the main process via a local file.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Verbose} = $Param{Verbose};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Product = $ConfigObject->Get('Product') . " " . $ConfigObject->Get('Version');
    my $Home    = $ConfigObject->Get('Home');

    my $Directory = "$Home/scripts/test";
    if ( $Param{Directory} ) {
        $Directory .= "/$Param{Directory}";
        $Directory =~ s/\.//g;
    }

    my @TestsToExecute = @{ $Param{Tests} // [] };

    my $UnitTestBlacklist = $ConfigObject->Get('UnitTest::Blacklist');
    my @BlacklistedTests;
    my @SkippedTests;
    if ( IsHashRefWithData($UnitTestBlacklist) ) {

        CONFIGKEY:
        for my $ConfigKey ( sort keys %{$UnitTestBlacklist} ) {

            next CONFIGKEY if !$ConfigKey;
            next CONFIGKEY
                if !$UnitTestBlacklist->{$ConfigKey} || !IsArrayRefWithData( $UnitTestBlacklist->{$ConfigKey} );

            TEST:
            for my $Test ( @{ $UnitTestBlacklist->{$ConfigKey} } ) {

                next TEST if !$Test;

                push @BlacklistedTests, $Test;
            }
        }
    }

    my $StartTime      = CORE::time();                      # Use non-overridden time().
    my $StartTimeHiRes = [ Time::HiRes::gettimeofday() ];

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.t',
        Recursive => 1,
    );

    my $NumberOfTestRuns = $Param{NumberOfTestRuns};
    if ( !$NumberOfTestRuns ) {
        $NumberOfTestRuns = 1;
    }

    FILE:
    for my $File (@Files) {

        # check if only some tests are requested
        if ( @TestsToExecute && !grep { $File =~ /\/\Q$_\E\.t$/smx } @TestsToExecute ) {
            next FILE;
        }

        # Check blacklisted files.
        if ( @BlacklistedTests && grep { $File =~ m{\Q$Directory/$_\E$}smx } @BlacklistedTests ) {
            push @SkippedTests, $File;
            next FILE;
        }

        # Check if a file with the same path and name exists in the Custom folder.
        my $CustomFile = $File =~ s{ \A $Home }{$Home/Custom}xmsr;
        if ( -e $CustomFile ) {
            $File = $CustomFile;
        }

        for ( 1 .. $NumberOfTestRuns ) {
            $Self->_HandleFile(
                PostTestScripts => $Param{PostTestScripts},
                File            => $File,
                DataDiffType    => $Param{DataDiffType},
            );
        }
    }

    my $Duration = sprintf( '%.3f', Time::HiRes::tv_interval($StartTimeHiRes) );

    my $Host           = $ConfigObject->Get('FQDN');
    my $TestCountTotal = $Self->{TestCountOk} + $Self->{TestCountNotOk};

    print "=====================================================================\n";

    if (@SkippedTests) {
        print "Following blacklisted tests were skipped:\n";
        for my $SkippedTest (@SkippedTests) {
            print '  ' . $Self->_Color( 'yellow', $SkippedTest ) . "\n";
        }
    }

    printf(
        "%s ran %s test(s) in %s for %s.\n",
        $Self->_Color( 'yellow', $Host ),
        $Self->_Color( 'yellow', $TestCountTotal ),
        $Self->_Color( 'yellow', "${Duration}s" ),
        $Self->_Color( 'yellow', $Product )
    );

    if ( $Self->{TestCountNotOk} ) {
        print $Self->_Color( 'red', "$Self->{TestCountNotOk} tests failed.\n" );
        print " FailedTests:\n";
        FAILEDFILE:
        for my $FailedFile ( @{ $Self->{NotOkInfo} || [] } ) {
            my ( $File, @Tests ) = @{ $FailedFile || [] };
            next FAILEDFILE if !@Tests;
            print sprintf "  %s %s\n", $File, join ", ", @Tests;
        }
    }
    elsif ( $Self->{TestCountOk} ) {
        print $Self->_Color( 'green', "All $Self->{TestCountOk} tests passed.\n" );
    }
    else {
        print $Self->_Color( 'yellow', "No tests executed.\n" );
    }

    if ( $Param{SubmitURL} ) {

        for my $PreSubmitScript ( @{ $Param{PreSubmitScripts} // [] } ) {
            system "$PreSubmitScript";
        }

        my $SubmitResultSuccess = $Self->_SubmitResults(
            %Param,
            StartTime => $StartTime,
            Duration  => $Duration,
        );
        if ( $Param{SubmitResultAsExitCode} ) {
            return $SubmitResultSuccess ? 1 : 0;
        }
    }

    return $Self->{TestCountNotOk} ? 0 : 1;
}

=begin Internal:

=cut

sub _HandleFile {
    my ( $Self, %Param ) = @_;

    my $ResultDataFile = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp/UnitTest.dump';
    unlink $ResultDataFile;

    # Create a child process.
    my $PID = fork;

    # Could not create child.
    if ( $PID < 0 ) {

        $Self->{ResultData}->{ $Param{File} } = { TestNotOk => 1 };
        $Self->{TestCountNotOk} += 1;

        print $Self->_Color( 'red', "Could not create child process for $Param{File}.\n" );
        return;
    }

    # We're in the child process.
    if ( !$PID ) {

        my $Driver = $Kernel::OM->Create(
            'Kernel::System::UnitTest::Driver',
            ObjectParams => {
                Verbose      => $Self->{Verbose},
                ANSI         => $Self->{ANSI},
                DataDiffType => $Param{DataDiffType},
            },
        );

        $Driver->Run( File => $Param{File} );

        exit 0;
    }

    # Wait for child process to finish.
    waitpid( $PID, 0 );

    my $ResultData = eval { Storable::retrieve($ResultDataFile) };

    if ( !$ResultData ) {
        print $Self->_Color( 'red', "Could not read result data for $Param{File}.\n" );
        $ResultData->{TestNotOk}++;
    }

    $Self->{ResultData}->{ $Param{File} } = $ResultData;
    $Self->{TestCountOk}    += $ResultData->{TestOk}    // 0;
    $Self->{TestCountNotOk} += $ResultData->{TestNotOk} // 0;

    $Self->{SeleniumData} //= $ResultData->{SeleniumData};

    $Self->{NotOkInfo} //= [];
    if ( $ResultData->{NotOkInfo} ) {

        # Cut out from result data hash, as we don't need to send this to the server.
        push @{ $Self->{NotOkInfo} }, [ $Param{File}, @{ delete $ResultData->{NotOkInfo} } ];
    }

    for my $PostTestScript ( @{ $Param{PostTestScripts} // [] } ) {
        my $Commandline = $PostTestScript;
        $Commandline =~ s{%File%}{$Param{File}}ismxg;
        $Commandline =~ s{%TestOk%}{$ResultData->{TestOk} // 0}iesmxg;
        $Commandline =~ s{%TestNotOk%}{$ResultData->{TestNotOk} // 0}iesmxg;
        system $Commandline;
    }

    return 1;
}

sub _SubmitResults {
    my ( $Self, %Param ) = @_;

    my %SupportData = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
    die "Could not collect SupportData.\n" if !$SupportData{Success};

    # Limit number of screenshots in the result data, since it can grow very large.
    #   Allow only up to 25 screenshots per submission (average size of 80kb per screenshot for a total of 2MB).
    my $ScreenshotCountLimit = 25;
    my $ScreenshotCount      = 0;

    RESULT:
    for my $Result ( sort keys %{ $Self->{ResultData} } ) {
        next RESULT if !IsHashRefWithData( $Self->{ResultData}->{$Result}->{Results} );

        TEST:
        for my $Test ( sort keys %{ $Self->{ResultData}->{$Result}->{Results} } ) {
            next TEST if !IsArrayRefWithData( $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Screenshots} );

            # Get number of screenshots in this test. Note that this key is an array, and we support multiple
            #   screenshots per one test.
            my $TestScreenshotCount = scalar @{ $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Screenshots} };

            # Check if number of screenshots for this result breaks the limit.
            if ( $ScreenshotCount + $TestScreenshotCount > $ScreenshotCountLimit ) {
                my $ScreenshotCountRemaining = $ScreenshotCountLimit - $ScreenshotCount;

                # Allow only remaining number of screenshots.
                if ( $ScreenshotCountRemaining > 0 ) {
                    @{ $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Screenshots} }
                        = @{ $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Screenshots} }[
                        0,
                        $ScreenshotCountRemaining
                        ];
                    $ScreenshotCount = $ScreenshotCountLimit;
                }

                # Remove all screenshots.
                else {
                    delete $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Screenshots};
                }

                # Include message about removal of screenshots.
                $Self->{ResultData}->{$Result}->{Results}->{$Test}->{Message}
                    .= ' (Additional screenshots have been omitted from the report because of size constraint.)';

                next TEST;
            }

            $ScreenshotCount += $TestScreenshotCount;
        }
    }

    # Include Selenium information as part of the support data.
    if ( IsHashRefWithData( $Self->{SeleniumData} ) ) {
        push @{ $SupportData{Result} },
            {
            Value       => $Self->{SeleniumData}->{build}->{version} // 'N/A',
            Label       => 'Selenium Server',
            DisplayPath => 'Unit Test/Selenium Information',
            Status      => 1,
            },
            {
            Value       => $Self->{SeleniumData}->{java}->{version} // 'N/A',
            Label       => 'Java',
            DisplayPath => 'Unit Test/Selenium Information',
            Status      => 1,
            },
            {
            Value       => $Self->{SeleniumData}->{browserName} // 'N/A',
            Label       => 'Browser Name',
            DisplayPath => 'Unit Test/Selenium Information',
            Status      => 1,
            };
        if ( $Self->{SeleniumData}->{browserName} && $Self->{SeleniumData}->{browserName} eq 'chrome' ) {
            push @{ $SupportData{Result} },
                {
                Value       => $Self->{SeleniumData}->{version} // 'N/A',
                Label       => 'Browser Version',
                DisplayPath => 'Unit Test/Selenium Information',
                Status      => 1,
                },
                {
                Value       => $Self->{SeleniumData}->{chrome}->{chromedriverVersion} // 'N/A',
                Label       => 'Chrome Driver',
                DisplayPath => 'Unit Test/Selenium Information',
                Status      => 1,
                };
        }
        elsif ( $Self->{SeleniumData}->{browserName} && $Self->{SeleniumData}->{browserName} eq 'firefox' ) {
            push @{ $SupportData{Result} },
                {
                Value       => $Self->{SeleniumData}->{browserVersion} // 'N/A',
                Label       => 'Browser Version',
                DisplayPath => 'Unit Test/Selenium Information',
                Status      => 1,
                },
                {
                Value       => $Self->{SeleniumData}->{'moz:geckodriverVersion'} // 'N/A',
                Label       => 'Gecko Driver',
                DisplayPath => 'Unit Test/Selenium Information',
                Status      => 1,
                };
        }
    }

    # Include versioning information as part of the support data.
    #   Get framework commit ID from the RELEASE file.
    my $ReleaseFile = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/RELEASE',
    );

    if ( ${$ReleaseFile} =~ /COMMIT\_ID\s=\s(.*)$/ ) {
        my $FrameworkCommitID = $1;
        push @{ $SupportData{Result} },
            {
            Value       => $FrameworkCommitID,
            Label       => 'Framework',
            DisplayPath => 'Unit Test/Versioning Information',
            Identifier  => 'VersionHash',
            Status      => 1,
            };
    }

    # Get build commit IDs of all installed packages.
    my @PackageList = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList(
        Result => 'short',
    );

    if ( IsArrayRefWithData( \@PackageList ) ) {
        for my $Package (@PackageList) {
            if ( $Package->{BuildCommitID} ) {
                push @{ $SupportData{Result} },
                    {
                    Value       => $Package->{BuildCommitID},
                    Label       => $Package->{Name},
                    DisplayPath => 'Unit Test/Versioning Information',
                    Identifier  => 'VersionHash',
                    Status      => 1,
                    };
            }
        }
    }

    my %SubmitData = (
        Auth     => $Param{SubmitAuth} // '',
        JobID    => $Param{JobID}      // '',
        Scenario => $Param{Scenario}   // '',
        Meta     => {
            StartTime => $Param{StartTime},
            Duration  => int $Param{Duration},      # CI master expects an integer here.
            TestOk    => $Self->{TestCountOk},
            TestNotOk => $Self->{TestCountNotOk},
        },
        SupportData => $SupportData{Result},
        Results     => $Self->{ResultData},
    );

    print "=====================================================================\n";
    print "Sending results to " . $Self->_Color( 'yellow', $Param{SubmitURL} ) . " ...\n";

    # Flush possible output log files to be able to submit them.
    *STDOUT->flush();
    *STDERR->flush();

    # Limit attachment sizes to 20MB in total.
    my $AttachmentCount = scalar grep { -r $_ } @{ $Param{AttachmentPath} // [] };
    my $AttachmentsSize = 1024 * 1024 * 20;

    ATTACHMENT_PATH:
    for my $AttachmentPath ( @{ $Param{AttachmentPath} // [] } ) {
        my $FileHandle;
        my $Content;

        if ( !open $FileHandle, '<:encoding(UTF-8)', $AttachmentPath ) {    ## no-critic
            print $Self->_Color( 'red', "Could not open file $AttachmentPath, skipping.\n" );
            next ATTACHMENT_PATH;
        }

        # Read only allocated size of file to try to avoid out of memory error.
        if ( !read $FileHandle, $Content, $AttachmentsSize / $AttachmentCount ) {    ## no-critic
            print $Self->_Color( 'red', "Could not read file $AttachmentPath, skipping.\n" );
            close $FileHandle;
            next ATTACHMENT_PATH;
        }

        my $Stat = stat($AttachmentPath);

        if ( !$Stat ) {
            print $Self->_Color( 'red', "Cannot stat file $AttachmentPath, skipping.\n" );
            close $FileHandle;
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
        print $Self->_Color( 'red', "Submission to server failed (status code '$Response{Status}').\n" );
        return;
    }

    if ( !$Response{Content} ) {
        print $Self->_Color( 'red', "Submission to server failed (no response).\n" );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput(
        $Response{Content},
    );

    my $ResponseData = $JSONObject->Decode(
        Data => ${ $Response{Content} },
    );

    if ( !$ResponseData ) {
        print $Self->_Color( 'red', "Submission to server failed (invalid response).\n" );
        return;
    }

    if ( !$ResponseData->{Success} && $ResponseData->{ErrorMessage} ) {
        print $Self->_Color(
            'red',
            "Submission to server failed (error message '$ResponseData->{ErrorMessage}').\n"
        );
        return;
    }

    print $Self->_Color( 'green', "Submission was successful.\n" );
    return 1;
}

=head2 _Color()

this will color the given text (see L<Term::ANSIColor::color()>) if
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
