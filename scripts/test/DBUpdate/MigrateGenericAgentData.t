# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase      => 1,
        RestoreConfiguration => 1,
    },
);
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name   => 'TransitionActionAdd Job simple',
        Config => {
            Name => "Job-$RandomID",
            Data => {
                NewQueue       => 'Misc',
                NewParamKey1   => 'Key1',
                NewParamValue1 => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name           => "Job-$RandomID",
            NewQueue       => 'Misc',
            NewParamKey1   => 'Key1',
            NewParamValue1 => 'Text1',
            Valid          => 1,
        },
    },

    {
        Name   => 'TransitionActionAdd Job ArticleType Is Not Visible',
        Config => {
            Name => "JobATN-$RandomID",
            Data => {
                NewArticleType => 'email',
                NewParamKey1   => 'Key1',
                NewParamValue1 => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                    => "JobATN-$RandomID",
            NewIsVisibleForCustomer => 0,
            NewParamKey1            => 'Key1',
            NewParamValue1          => 'Text1',
            Valid                   => 1,
        },
    },
    {
        Name   => 'TransitionActionAdd Job ArticleType IsVisible',
        Config => {
            Name => "JobAT-$RandomID",
            Data => {
                NewArticleType => 'phone',
                NewParamKey1   => 'Key1',
                NewParamValue1 => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                    => "JobAT-$RandomID",
            NewIsVisibleForCustomer => 1,
            NewParamKey1            => 'Key1',
            NewParamValue1          => 'Text1',
            Valid                   => 1,
        },
    },

    {
        Name   => 'TransitionActionAdd Job FollowUp ArticleType Is Not Visible',
        Config => {
            Name => "JobFATN-$RandomID",
            Data => {
                NewNoteArticleType => 'email',
                NewParamKey1       => 'Key1',
                NewParamValue1     => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                        => "JobFATN-$RandomID",
            NewNoteIsVisibleForCustomer => 0,
            NewParamKey1                => 'Key1',
            NewParamValue1              => 'Text1',
            Valid                       => 1,
        },
    },
    {
        Name   => 'TransitionActionAdd Job FollowUp ArticleType IsVisible',
        Config => {
            Name => "JobFAT-$RandomID",
            Data => {
                NewNoteArticleType => 'phone',
                NewParamKey1       => 'Key1',
                NewParamValue1     => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                        => "JobFAT-$RandomID",
            NewNoteIsVisibleForCustomer => 1,
            NewParamKey1                => 'Key1',
            NewParamValue1              => 'Text1',
            Valid                       => 1,
        },
    },

    {
        Name   => 'TransitionActionAdd Job Both ArticleType Is Not Visible',
        Config => {
            Name => "JobBATN-$RandomID",
            Data => {
                NewArticleType     => 'email',
                NewNoteArticleType => 'email',
                NewParamKey1       => 'Key1',
                NewParamValue1     => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                        => "JobBATN-$RandomID",
            NewIsVisibleForCustomer     => 0,
            NewNoteIsVisibleForCustomer => 0,
            NewParamKey1                => 'Key1',
            NewParamValue1              => 'Text1',
            Valid                       => 1,
        },
    },
    {
        Name   => 'TransitionActionAdd Job Both ArticleType IsVisible',
        Config => {
            Name => "JobBAT-$RandomID",
            Data => {
                NewArticleType     => 'phone',
                NewNoteArticleType => 'phone',
                NewParamKey1       => 'Key1',
                NewParamValue1     => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                        => "JobBAT-$RandomID",
            NewIsVisibleForCustomer     => 1,
            NewNoteIsVisibleForCustomer => 1,
            NewParamKey1                => 'Key1',
            NewParamValue1              => 'Text1',
            Valid                       => 1,
        },
    },
    {
        Name   => 'TransitionActionAdd Job Both ArticleType IsVisible',
        Config => {
            Name => "JobBBAT-$RandomID",
            Data => {
                NewArticleType     => 'email',
                NewNoteArticleType => 'phone',
                NewParamKey1       => 'Key1',
                NewParamValue1     => 'Text1',
            },
        },
        ExpectedConfigResult => {
            Name                        => "JobBBAT-$RandomID",
            NewIsVisibleForCustomer     => 0,
            NewNoteIsVisibleForCustomer => 1,
            NewParamKey1                => 'Key1',
            NewParamValue1              => 'Text1',
            Valid                       => 1,
        },
    },
);

for my $Test (@Tests) {

    my $JobAddResult = $GenericAgentObject->JobAdd( %{ $Test->{Config} }, UserID => 1 );

    $Self->True(
        $JobAddResult,
        "$Test->{Name} | Successful JobAdd ",
    );

    my %Job = $GenericAgentObject->JobGet( %{ $Test->{Config} } );

    $Self->Is(
        ref \%Job,
        'HASH',
        "Job structure is HASH",
    );

    my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateGenericAgentJobs');
    $Self->True(
        $DBUpdateObject,
        'Database update object successfully created!',
    );

    my $RunSuccess = $DBUpdateObject->_MigrateArticleTypeToIsVisibleForCustomer();

    $Self->Is(
        1,
        $RunSuccess,
        'DBUpdateObject ran without problems.',
    );

    # Delete cache due we are using API functions.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'GenericAgent',
    );

    %Job = $GenericAgentObject->JobGet( %{ $Test->{Config} } );

    $Self->Is(
        ref \%Job,
        'HASH',
        "Job structure is HASH",
    );

    $Self->IsDeeply(
        \%Job,
        $Test->{ExpectedConfigResult},
        "$Test->{Name} | Expected config result.",
    );
}

# Cleanup is done by TmpDatabaseCleanup().

1;
