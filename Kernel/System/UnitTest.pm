# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::UnitTest;

use strict;
use warnings;

use File::stat;
use Storable();
use Term::ANSIColor();

use Kernel::System::UnitTest::Driver;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Main',
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
    $Self->{ANSI} = $Param{ANSI};

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

    # Use non-overridden time() function.
    my $StartTime = CORE::time;    ## no critic;

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

        $Self->_HandleFile(
            PostTestScripts => $Param{PostTestScripts},
            File            => $File,
        );
    }

    # Use non-overridden time() function.
    my $Duration = CORE::time - $StartTime;    ## no critic

    my $Host = $ConfigObject->Get('FQDN');

    print "=====================================================================\n";
    print $Self->_Color( 'yellow', $Host ) . " ran tests in " . $Self->_Color( 'yellow', "${Duration}s" );
    print " for " . $Self->_Color( 'yellow', $Product ) . "\n";

    if ( $Self->{TestCountNotOk} ) {
        print $Self->_Color( 'red', "$Self->{TestCountNotOk} tests failed.\n" );
        print " FailedTests:\n";
        FAILEDFILE:
        for my $FailedFile ( @{ $Self->{NotOkInfo} || [] } ) {
            my ( $File, @Tests ) = @{ $FailedFile || [] };
            next FAILEDFILE if !@Tests;
            print sprintf "  %s #%s\n", $File, join ", ", @Tests;
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

        my $Driver = Kernel::System::UnitTest::Driver->new(
            Verbose => $Self->{Verbose},
            ANSI    => $Self->{ANSI},
        );

        $Driver->Run( File => $Param{File} );

        exit 0;
    }

    # Wait for child process to finish.
    waitpid( $PID, 0 );

    my $ResultData = Storable::retrieve($ResultDataFile);

    if ( !$ResultData ) {
        $ResultData->{TestNotOk}++;
    }

    $Self->{ResultData}->{ $Param{File} } = $ResultData;
    $Self->{TestCountOk}    += $ResultData->{TestOk}    // 0;
    $Self->{TestCountNotOk} += $ResultData->{TestNotOk} // 0;

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

    my %SubmitData = (
        Auth     => $Param{SubmitAuth} // '',
        JobID    => $Param{JobID}      // '',
        Scenario => $Param{Scenario}   // '',
        Meta     => {
            StartTime => $Param{StartTime},
            Duration  => $Param{Duration},
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

    # Limit attachment sizes to 2MB in total.
    my $AttachmentCount = scalar @{ $Param{AttachmentPath} // [] };
    my $AttachmentsSize = 1024 * 1024 * 2;

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
        SkipSSLVerification => 1,
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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
