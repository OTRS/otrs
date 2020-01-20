# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::UnitTest::Run;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::UnitTest',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Execute unit tests.');
    $Self->AddOption(
        Name => 'test',
        Description =>
            "Run individual test files, e.g. 'Ticket' or 'Ticket/ArchiveFlags' (can be specified several times).",
        Required   => 0,
        HasValue   => 1,
        Multiple   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'directory',
        Description => "Run all test files in the specified directory.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'verbose',
        Description => "Show details for all tests, not just failing.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'data-diff-type',
        Description => "Choose which diff type to use for the data diff (table or unified).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^(table|unified)$/ismx,
    );
    $Self->AddOption(
        Name        => 'submit-url',
        Description => "Send unit test results to a server (URL).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'submit-auth',
        Description => "Authentication string for unit test result server.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'submit-result-as-exit-code',
        Description =>
            "Specify if command return code should not indicate if tests were ok/not ok, but if submission was successful instead.",
        Required => 0,
        HasValue => 0,
    );
    $Self->AddOption(
        Name        => 'job-id',
        Description => "Job ID for unit test submission to server.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'scenario',
        Description => "Scenario identifier for unit test submission to server.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'attachment-path',
        Description =>
            "Send an additional file to the server, for example to submit the complete command output that has been redirected to a file.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
        Multiple   => 1
    );
    $Self->AddOption(
        Name => 'post-test-script',
        Description =>
            'Script(s) to execute after a test has been run. You can specify %File%, %TestOk% and %TestNotOk% as dynamic arguments.',
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
        Multiple   => 1
    );
    $Self->AddOption(
        Name => 'pre-submit-script',
        Description =>
            'Script(s) to execute after all tests have been executed and the results are about to be sent to the server.',
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
        Multiple   => 1
    );
    $Self->AddOption(
        Name        => 'test-runs',
        Description => 'Number of successive runs for every single unit test, default 1.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );
    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( $Self->GetOption('submit-result-as-exit-code') && !$Self->GetOption('submit-url') ) {
        die "Please specify a valid 'submit-url'.";
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest' => {
            ANSI => $Self->{ANSI},
        },
    );

    # Allow specification of a default directory to limit test execution.
    my $DefaultDirectory = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::DefaultDirectory');

    my $FunctionResult = $Kernel::OM->Get('Kernel::System::UnitTest')->Run(
        Tests                  => $Self->GetOption('test'),
        Directory              => $Self->GetOption('directory') || $DefaultDirectory,
        JobID                  => $Self->GetOption('job-id'),
        Scenario               => $Self->GetOption('scenario'),
        SubmitURL              => $Self->GetOption('submit-url'),
        SubmitAuth             => $Self->GetOption('submit-auth'),
        SubmitResultAsExitCode => $Self->GetOption('submit-result-as-exit-code') || '',
        Verbose                => $Self->GetOption('verbose'),
        DataDiffType           => $Self->GetOption('data-diff-type'),
        AttachmentPath         => $Self->GetOption('attachment-path'),
        PostTestScripts        => $Self->GetOption('post-test-script'),
        PreSubmitScripts       => $Self->GetOption('pre-submit-script'),
        NumberOfTestRuns       => $Self->GetOption('test-runs'),
    );

    if ($FunctionResult) {
        return $Self->ExitCodeOk();
    }
    return $Self->ExitCodeError();
}

1;
