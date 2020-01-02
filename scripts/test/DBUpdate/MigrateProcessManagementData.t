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

my $TransitionActionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
my $ActivityDialogObject   = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $RandomID = $Helper->GetRandomID();
my $UserID   = 1;

my @Tests = (
    {
        Name   => 'TransitionActionAdd Test simple',
        Config => {
            Name   => "TransitionAction-$RandomID",
            Config => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Module => 'Kernel::System::Process::Transition::Action::QueueMove',
            Config => {
                Key1 => 'String',
                Key2 => 2,
            },
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionAdd test NOT visible for customer',
        Config => {
            Name   => "TransitionActionTwo-$RandomID",
            Config => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1        => 'String',
                    Key2        => 2,
                    ArticleType => 'email-internal',
                },
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Module => 'Kernel::System::Process::Transition::Action::QueueMove',
            Config => {
                Key1                 => 'String',
                Key2                 => 2,
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Email',
            },
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionAdd IS visible for customer',
        Config => {
            Name   => "TransitionActionThree-$RandomID",
            Config => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1        => 'String',
                    Key2        => 2,
                    ArticleType => 'phone',
                },
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Module => 'Kernel::System::Process::Transition::Action::QueueMove',
            Config => {
                Key1                 => 'String',
                Key2                 => 2,
                IsVisibleForCustomer => 1,
                CommunicationChannel => 'Phone',
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    my $EntityID = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity')->EntityIDGenerate(
        EntityType => 'TransitionAction',
        UserID     => $UserID,
    );

    $Self->True(
        $EntityID,
        "$Test->{Name} | EntityID $EntityID",
    );

    $Test->{Config}->{EntityID} = $EntityID;

    my $TransitionActionID = $TransitionActionObject->TransitionActionAdd( %{ $Test->{Config} } );

    $Self->True(
        $TransitionActionID,
        "$Test->{Name} | TransitionActionID $TransitionActionID",
    );

    my $TransitionAction = $TransitionActionObject->TransitionActionGet( %{ $Test->{Config} } );

    $Self->Is(
        ref $TransitionAction,
        'HASH',
        "TransitionAction structure is HASH",
    );

    my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateProcessManagementData');
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

    # Delete cache due we are using API functions.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_TransitionAction',
    );

    $TransitionAction = $TransitionActionObject->TransitionActionGet( %{ $Test->{Config} } );

    $Self->Is(
        ref $TransitionAction,
        'HASH',
        "TransitionAction structure is HASH",
    );

    $Self->IsDeeply(
        $TransitionAction->{Config},
        $Test->{ExpectedConfigResult},
        "$Test->{Name} | Expected config result.",
    );

}

# Delete cache due we are using API functions.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'ProcessManagement_TransitionAction',
);

@Tests = (

    {
        Name   => 'ActivityDialogAdd - No changes',
        Config => {
            Name   => "ActivityDialogAdd-$RandomID",
            Config => {
                DescriptionShort =>
                    'Description',
                Fields => {
                    Article => {
                        DescriptionLong  => 'A long description',
                        DefaultValue     => '',
                        DescriptionShort => '.',
                        Config           => {
                            TimeUnits => '1',
                        },
                        Display => '1',
                    },
                    QueueID => {
                        DescriptionShort => 'Short description',
                        DescriptionLong  => 'Longer description',
                        Display          => 0,
                        DefaultValue     => 1,
                    },
                },
                FieldOrder => [ 'Article', 'QueueID' ],
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Article => {
                DescriptionLong  => 'A long description',
                DefaultValue     => '',
                DescriptionShort => '.',
                Config           => {
                    TimeUnits => '1',
                },
                Display => '1',
            },
            QueueID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
        },
        Success => 1,
    },
    {
        Name   => 'ActivityDialogAdd - Visible for customer',
        Config => {
            Name   => "ActivityDialogAddTwo-$RandomID",
            Config => {
                DescriptionShort =>
                    'Description',
                Fields => {
                    Article => {
                        DescriptionLong  => 'A long description',
                        DefaultValue     => '',
                        DescriptionShort => '.',
                        Config           => {
                            ArticleType => 'note-external',
                            TimeUnits   => '1',
                        },
                        Display => '1',
                    },
                    QueueID => {
                        DescriptionShort => 'Short description',
                        DescriptionLong  => 'Longer description',
                        Display          => 0,
                        DefaultValue     => 1,
                    },
                },
                FieldOrder => [ 'Article', 'QueueID' ],
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Article => {
                DescriptionLong  => 'A long description',
                DefaultValue     => '',
                DescriptionShort => '.',
                Config           => {
                    IsVisibleForCustomer => 1,
                    CommunicationChannel => 'Internal',
                    TimeUnits            => '1',
                },
                Display => '1',
            },
            QueueID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
        },
        Success => 1,
    },

    {
        Name   => 'ActivityDialogAdd - Not visible for customer',
        Config => {
            Name   => "ActivityDialogAddThree-$RandomID",
            Config => {
                DescriptionShort =>
                    'Description',
                Fields => {
                    Article => {
                        DescriptionLong  => 'A long description',
                        DefaultValue     => '',
                        DescriptionShort => '.',
                        Config           => {
                            ArticleType => 'email-internal',
                            TimeUnits   => '1',
                        },
                        Display => '1',
                    },
                    QueueID => {
                        DescriptionShort => 'Short description',
                        DescriptionLong  => 'Longer description',
                        Display          => 0,
                        DefaultValue     => 1,
                    },
                },
                FieldOrder => [ 'Article', 'QueueID' ],
            },
            UserID => $UserID,
        },
        ExpectedConfigResult => {
            Article => {
                DescriptionLong  => 'A long description',
                DefaultValue     => '',
                DescriptionShort => '.',
                Config           => {
                    CommunicationChannel => 'Email',
                    IsVisibleForCustomer => 0,
                    TimeUnits            => '1',
                },
                Display => '1',
            },
            QueueID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    my $EntityID = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity')->EntityIDGenerate(
        EntityType => 'TransitionAction',
        UserID     => $UserID,
    );

    $Self->True(
        $EntityID,
        "$Test->{Name} | EntityID $EntityID",
    );

    $Test->{Config}->{EntityID} = $EntityID;

    my $ActivityDialogID = $ActivityDialogObject->ActivityDialogAdd( %{ $Test->{Config} } );

    $Self->True(
        $ActivityDialogID,
        "$Test->{Name} | ActivityDialogID $ActivityDialogID",
    );

    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet( %{ $Test->{Config} } );
    $Self->Is(
        ref $ActivityDialog,
        'HASH',
        "ActivityDialog structure is HASH",
    );

    my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateProcessManagementData');
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

    # Delete cache due we are using API functions.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'ProcessManagement_ActivityDialog',
    );

    $ActivityDialog = $ActivityDialogObject->ActivityDialogGet( %{ $Test->{Config} } );

    $Self->Is(
        ref $ActivityDialog,
        'HASH',
        "ActivityDialog structure is HASH",
    );

    $Self->IsDeeply(
        $ActivityDialog->{Config}->{Fields},
        $Test->{ExpectedConfigResult},
        "$Test->{Name} | Expected config result.",
    );

}

# Delete cache due we are using API functions.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'ProcessManagement_ActivityDialog',
);

# Cleanup is done by TmpDatabaseCleanup().

1;
