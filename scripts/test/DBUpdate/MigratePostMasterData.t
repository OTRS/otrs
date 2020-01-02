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
my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');
my $PostMasterFilter = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

$ConfigObject->Set(
    Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
    Value => "Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB",
);

my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name   => 'TransitionActionAdd Filter simple',
        Config => {
            Name           => "Filter-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "Filter-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-Queue',
                    Value => 'Misc',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },

    {
        Name   => 'TransitionActionAdd Filter ArticleType Is Not Visible',
        Config => {
            Name           => "FilterATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-ArticleType',
                    Value => 'email',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-IsVisibleForCustomer',
                    Value => 0,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },
    {
        Name   => 'TransitionActionAdd Filter ArticleType IsVisible',
        Config => {
            Name           => "FilterAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-ArticleType',
                    Value => 'phone',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-IsVisibleForCustomer',
                    Value => 1,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },

    {
        Name   => 'TransitionActionAdd Filter FollowUp ArticleType Is Not Visible',
        Config => {
            Name           => "FilterFATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-ArticleType',
                    Value => 'email',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterFATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-IsVisibleForCustomer',
                    Value => 0,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },
    {
        Name   => 'TransitionActionAdd Filter FollowUp ArticleType IsVisible',
        Config => {
            Name           => "FilterFAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-ArticleType',
                    Value => 'phone',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterFAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-IsVisibleForCustomer',
                    Value => 1,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },

    {
        Name   => 'TransitionActionAdd Filter Both ArticleType Is Not Visible',
        Config => {
            Name           => "FilterBATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-ArticleType',
                    Value => 'email',
                },
                {
                    Key   => 'X-OTRS-FollowUp-ArticleType',
                    Value => 'email',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterBATN-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-IsVisibleForCustomer',
                    Value => 0,
                },
                {
                    Key   => 'X-OTRS-IsVisibleForCustomer',
                    Value => 0,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },
    {
        Name   => 'TransitionActionAdd Filter Both ArticleType IsVisible',
        Config => {
            Name           => "FilterBAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-ArticleType',
                    Value => 'phone',
                },
                {
                    Key   => 'X-OTRS-FollowUp-ArticleType',
                    Value => 'phone',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterBAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-IsVisibleForCustomer',
                    Value => 1,
                },
                {
                    Key   => 'X-OTRS-IsVisibleForCustomer',
                    Value => 1,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },
    {
        Name   => 'TransitionActionAdd Filter Both ArticleType IsVisible',
        Config => {
            Name           => "FilterBBAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-ArticleType',
                    Value => 'email',
                },
                {
                    Key   => 'X-OTRS-FollowUp-ArticleType',
                    Value => 'phone',
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
        },
        ExpectedConfigResult => {
            Name           => "FilterBBAT-$RandomID",
            StopAfterMatch => 0,
            Match          => [
                {
                    Key   => 'Subject',
                    Value => 'test',
                },
                {
                    Key   => 'To',
                    Value => 'EMAILADDRESS:darthvader@otrs.org',
                },
            ],
            Set => [
                {
                    Key   => 'X-OTRS-FollowUp-IsVisibleForCustomer',
                    Value => 1,
                },
                {
                    Key   => 'X-OTRS-IsVisibleForCustomer',
                    Value => 0,
                },
                {
                    Key   => 'X-OTRS-TicketKey1',
                    Value => 'Key1',
                },
                {
                    Key   => 'X-OTRS-TicketValue1',
                    Value => 'Text1',
                },
            ],
            Not => [
                {
                    Key   => 'Subject',
                    Value => undef,
                },
                {
                    Key   => 'To',
                    Value => undef,
                },
            ],
        },
    },
);

for my $Test (@Tests) {

    my $FilterAddResult = $PostMasterFilter->FilterAdd( %{ $Test->{Config} } );

    $Self->True(
        $FilterAddResult,
        "$Test->{Name} | Successful FilterAdd ",
    );

    my %Filter = $PostMasterFilter->FilterGet( %{ $Test->{Config} } );

    $Self->Is(
        ref \%Filter,
        'HASH',
        "Filter structure is HASH",
    );

    my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigratePostMasterData');
    $Self->True(
        $DBUpdateObject,
        'Database update object successfully created!',
    );

    my $RunSuccess = $DBUpdateObject->Run();

    $Self->Is(
        1,
        $RunSuccess,
        'DBUpdateObject ran without problems.',
    );

    %Filter = $PostMasterFilter->FilterGet( %{ $Test->{Config} } );

    $Self->Is(
        ref \%Filter,
        'HASH',
        "Filter structure is HASH",
    );

    $Self->IsDeeply(
        \%Filter,
        $Test->{ExpectedConfigResult},
        "$Test->{Name} | Expected config result.",
    );

}

# Cleanup is done by TmpDatabaseCleanup().

1;
