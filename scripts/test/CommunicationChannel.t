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
        RestoreDatabase => 1,
    },
);
my $Helper                     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

my @ChannelIDs;
my $UserID    = 1;
my @RandomIDs = (
    $Helper->GetRandomID(),
    $Helper->GetRandomID(),
    $Helper->GetRandomID(),
    $Helper->GetRandomID(),
);

#
# Tests for ChannelAdd().
#
my @Tests = (
    {
        Name   => 'ChannelAdd - Without ChannelName',
        Config => {
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            UserID      => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelAdd - Without Module',
        Config => {
            ChannelName => "Channel $RandomIDs[0]",
            PackageName => 'Framework',
            UserID      => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelAdd - Without PackageName',
        Config => {
            ChannelName => "Channel $RandomIDs[0]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            UserID      => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelAdd - Without UserID',
        Config => {
            ChannelName => "Channel $RandomIDs[0]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
        },
        Success => 0,
    },
    {
        Name   => 'ChannelAdd - With all required params',
        Config => {
            ChannelName => "Channel $RandomIDs[0]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            UserID      => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ChannelAdd - With optional ChannelData',
        Config => {
            ChannelName => "Channel $RandomIDs[1]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => {
                ArticleDataTables => [
                    'i_do_not_exist',
                ],
                ArticleDataArticleIDField => 'article_id',
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ChannelAdd - With optional ValidID',
        Config => {
            ChannelName => "Channel $RandomIDs[2]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ValidID     => 2,
            UserID      => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ChannelAdd - With all required and optional params',
        Config => {
            ChannelName => "Channel $RandomIDs[3]",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => {
                ArticleDataTables => [
                    'i_do_not_exist',
                ],
                ArticleDataArticleIDField => 'article_id',
            },
            ValidID => 1,
            UserID  => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $ChannelID = $CommunicationChannelObject->ChannelAdd(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $ChannelID,
            "$Test->{Name} - Success"
        );

        push @ChannelIDs, $ChannelID;
    }
    else {
        $Self->False(
            $ChannelID // 0,
            "$Test->{Name} - No Success"
        );
    }
}

#
# Expected test channel data.
#
my @TestChannels = (
    {
        ChannelName => "Channel $RandomIDs[0]",
        ChangeBy    => $UserID,
        ChannelData => '',
        ChannelID   => $ChannelIDs[0],
        CreateBy    => $UserID,
        DisplayIcon => 'fa-exchange',
        DisplayName => "Channel $RandomIDs[0]",
        Module      => 'scripts::test::CommunicationChannel::Test',
        PackageName => 'Framework',
        ValidID     => 1,
    },
    {
        ChannelName => "Channel $RandomIDs[1]",
        ChangeBy    => $UserID,
        ChannelData => {
            ArticleDataTables => [
                'i_do_not_exist',
            ],
            ArticleDataArticleIDField => 'article_id',
        },
        ChannelID   => $ChannelIDs[1],
        CreateBy    => $UserID,
        DisplayIcon => 'fa-exchange',
        DisplayName => "Channel $RandomIDs[1]",
        Module      => 'scripts::test::CommunicationChannel::Test',
        PackageName => 'Framework',
        ValidID     => 1,
    },
    {
        ChannelName => "Channel $RandomIDs[2]",
        ChangeBy    => $UserID,
        ChannelData => '',
        ChannelID   => $ChannelIDs[2],
        CreateBy    => $UserID,
        DisplayIcon => 'fa-exchange',
        DisplayName => "Channel $RandomIDs[2]",
        Module      => 'scripts::test::CommunicationChannel::Test',
        PackageName => 'Framework',
        ValidID     => 2,
    },
    {
        ChannelName => "Channel $RandomIDs[3]",
        ChangeBy    => $UserID,
        ChannelData => {
            ArticleDataTables => [
                'i_do_not_exist',
            ],
            ArticleDataArticleIDField => 'article_id',
        },
        ChannelID   => $ChannelIDs[3],
        CreateBy    => $UserID,
        DisplayIcon => 'fa-exchange',
        DisplayName => "Channel $RandomIDs[3]",
        Module      => 'scripts::test::CommunicationChannel::Test',
        PackageName => 'Framework',
        ValidID     => 1,
    },
);

#
# Tests for ChannelGet().
#
@Tests = (
    {
        Name    => 'ChannelGet - Without parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ChannelGet - With ChannelID',
        Config => {
            ChannelID => $ChannelIDs[0],
        },
        Result  => $TestChannels[0],
        Success => 1,
    },
    {
        Name   => 'ChannelGet - With ChannelName',
        Config => {
            ChannelName => "Channel $RandomIDs[1]",
        },
        Result  => $TestChannels[1],
        Success => 1,
    },
    {
        Name   => 'ChannelGet - With another ChannelID',
        Config => {
            ChannelID => $ChannelIDs[2],
        },
        Result  => $TestChannels[2],
        Success => 1,
    },
    {
        Name   => 'ChannelGet - With both ChannelID and ChannelName',
        Config => {
            ChannelID   => $ChannelIDs[2],
            ChannelName => "Channel $RandomIDs[3]",    # this should win
        },
        Result  => $TestChannels[3],
        Success => 1,
    },
    {
        Name   => 'ChannelGet - Invalid ChannelID',
        Config => {
            ChannelID => 999_999_999,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelGet - Invalid ChannelName',
        Config => {
            ChannelName => $Helper->GetRandomID(),
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            scalar %CommunicationChannel,
            "$Test->{Name} - Success"
        );

        # Remove variable data before comparison.
        for my $Field (qw(CreateTime ChangeTime)) {
            delete $CommunicationChannel{$Field};
        }

        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{Result},
            "$Test->{Name} - Result"
        );
    }
    else {
        $Self->False(
            scalar %CommunicationChannel // 0,
            "$Test->{Name} - No Success"
        );
    }
}

#
# Tests for ChannelList().
#
@Tests = (
    {
        Name    => 'ChannelList - Without parameters',
        Config  => {},
        Result  => [ @TestChannels[ 0 .. 3 ] ],
        Success => 1,
    },
    {
        Name   => 'ChannelList - Valid only',
        Config => {
            ValidID => 1,
        },
        Result  => [ @TestChannels[ 0, 1, 3 ] ],
        Success => 1,
    },
    {
        Name   => 'ChannelList - Invalid only',
        Config => {
            ValidID => 2,
        },
        Result  => [ $TestChannels[2] ],
        Success => 1,
    },
);

for my $Test (@Tests) {
    my @CommunicationChannels = $CommunicationChannelObject->ChannelList(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            scalar @CommunicationChannels,
            "$Test->{Name} - Success"
        );

        my $Count = 0;
        for my $Result ( @{ $Test->{Result} } ) {
            for my $CommunicationChannel (@CommunicationChannels) {
                if ( $CommunicationChannel->{ChannelName} eq $Result->{ChannelName} ) {

                    # Remove variable data before comparison.
                    for my $Field (qw(CreateTime ChangeTime)) {
                        delete $CommunicationChannel->{$Field};
                    }

                    $Self->IsDeeply(
                        $CommunicationChannel,
                        $Result,
                        "$Test->{Name} - $Result->{ChannelName}"
                    );

                    $Count++;
                }
            }
        }

        $Self->Is(
            $Count,
            scalar @{ $Test->{Result} },
            "$Test->{Name} - Count"
        );
    }
    else {
        $Self->False(
            scalar @CommunicationChannels // 0,
            "$Test->{Name} - No Success"
        );
    }
}

#
# Tests for ChannelUpdate().
#
@Tests = (
    {
        Name   => 'ChannelUpdate - Without ChannelID',
        Config => {
            ChannelName => "New channel $RandomIDs[0]",
            UserID      => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelUpdate - Without ChannelName',
        Config => {
            ChannelID => $ChannelIDs[0],
            UserID    => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ChannelUpdate - Without UserID',
        Config => {
            ChannelID   => $ChannelIDs[0],
            ChannelName => "New channel $RandomIDs[0]",
        },
        Success => 0,
    },
    {
        Name   => 'ChannelUpdate - With all required parameters',
        Config => {
            ChannelID   => $ChannelIDs[0],
            ChannelName => "New channel $RandomIDs[0]",
            UserID      => 1,
        },
        Result => {
            %{ $TestChannels[0] },
            ChannelName => "New channel $RandomIDs[0]",
            DisplayName => "New channel $RandomIDs[0]",
        },
        Success => 1,
    },
    {
        Name   => 'ChannelUpdate - With optional parameters',
        Config => {
            ChannelID   => $ChannelIDs[0],
            ChannelName => "Even newer channel $RandomIDs[0]",
            Module      => 'Kernel::System::CommunicationChannel::Internal',
            PackageName => 'TestPackage',
            ChannelData => {
                ArticleDataTables => [
                    'i_do_not_exist',
                ],
                ArticleDataArticleIDField => 'article_id',
            },
            ValidID => 2,
            UserID  => $UserID,
        },
        Result => {
            %{ $TestChannels[0] },
            ChannelName => "Even newer channel $RandomIDs[0]",
            DisplayName => "Even newer channel $RandomIDs[0]",
            Module      => 'Kernel::System::CommunicationChannel::Internal',
            PackageName => 'TestPackage',
            ChannelData => {
                ArticleDataTables => [
                    'i_do_not_exist',
                ],
                ArticleDataArticleIDField => 'article_id',
            },
            ValidID => 2,
        },
        Success => 1,
    },
    {
        Name   => 'ChannelUpdate - Reset',
        Config => {
            %{ $TestChannels[0] },
            UserID => $UserID,
        },
        Result => {
            %{ $TestChannels[0] },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $CommunicationChannelObject->ChannelUpdate(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Success"
        );

        my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
            %{ $Test->{Config} },
        );

        # Remove variable data before comparison.
        for my $Field (qw(CreateTime ChangeTime)) {
            delete $CommunicationChannel{$Field};
        }

        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{Result},
            "$Test->{Name} - Result"
        );
    }
    else {
        $Self->False(
            $Success // 0,
            "$Test->{Name} - No Success"
        );
    }
}

#
# Tests for ChannelDelete().
#
@Tests = (
    {
        Name    => 'ChannelDelete - Without parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ChannelDelete - With ChannelID',
        Config => {
            ChannelID => $ChannelIDs[0],
        },
        Success => 1,
    },
    {
        Name   => 'ChannelDelete - With ChannelName',
        Config => {
            ChannelName => "Channel $RandomIDs[1]",
        },
        Success => 1,
    },
    {
        Name   => 'ChannelDelete - With both ChannelID and ChannelName',
        Config => {
            ChannelID   => $ChannelIDs[2],            # this will win
            ChannelName => "Channel $RandomIDs[2]",
        },
        Success => 1,
    },
    {
        Name   => 'ChannelDelete - With another ChannelName',
        Config => {
            ChannelName => "Channel $RandomIDs[3]",
        },
        Success => 1,
    },
    {
        Name   => 'ChannelDelete - With invalid ChannelID',
        Config => {
            ChannelID   => 999_999_999,
            ChannelName => "Channel $RandomIDs[3]",
        },
        Success => 0,
    },
    {
        Name   => 'ChannelDelete - With invalid ChannelName',
        Config => {
            ChannelName => $Helper->GetRandomID(),
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $CommunicationChannelObject->ChannelDelete(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Success"
        );

        my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
            %{ $Test->{Config} },
        );

        $Self->False(
            %CommunicationChannel // 0,
            "$Test->{Name} - Channel deleted"
        );
    }
    else {
        $Self->False(
            $Success // 0,
            "$Test->{Name} - No Success"
        );
    }
}

# Forget channel IDs.
@ChannelIDs = ();

#
# Tests for ChannelSync().
#
@Tests = (
    {
        Name   => 'ChannelSync - Already in sync',
        Config => {
            UserID => $UserID,
        },
        Result => {},
    },
    {
        Name   => 'ChannelSync - Add first test channel',
        Config => {
            UserID => $UserID,
        },
        ChannelName     => $TestChannels[0]->{ChannelName},
        RegistrationAdd => {
            Name        => $TestChannels[0]->{DisplayName},
            Icon        => 'fa-font-awesome',
            Description => 'First test communication channel',
            Module      => 'scripts::test::CommunicationChannel::Test',
        },
        Result => {
            ChannelsAdded => [ $TestChannels[0]->{ChannelName} ],
        },
        ChannelGet => {
            %{ $TestChannels[0] },
            ChannelID   => undef,
            DisplayIcon => 'fa-font-awesome',
            PackageName => 'TestPackage',
            ChannelData => {
                ArticleDataArticleIDField => 'article_id',
                ArticleDataTables         => [
                    'i_do_not_exist',
                ],
            },
        },
    },
    {
        Name   => 'ChannelSync - Add second test channel',
        Config => {
            UserID => $UserID,
        },
        ChannelName     => $TestChannels[1]->{ChannelName},
        RegistrationAdd => {
            Name        => $TestChannels[1]->{DisplayName},
            Icon        => 'fa-exchange',
            Description => 'Second test communication channel',
            Module      => 'scripts::test::CommunicationChannel::TestTwo',
        },
        Result => {
            ChannelsAdded => [ $TestChannels[1]->{ChannelName} ],
        },
        ChannelGet => {
            %{ $TestChannels[1] },
            ChannelID   => undef,
            Module      => 'scripts::test::CommunicationChannel::TestTwo',
            PackageName => 'TestPackage',
        },
    },
    {
        Name   => 'ChannelSync - Remove first test channel',
        Config => {
            UserID => $UserID,
        },
        ChannelName        => $TestChannels[0]->{ChannelName},
        RegistrationRemove => 1,
        Result             => {
            ChannelsInvalid => [ $TestChannels[0]->{ChannelName} ],
        },
        ChannelGet => {},
    },
    {
        Name   => 'ChannelSync - Remove Email channel registration',
        Config => {
            UserID => $UserID,
        },
        ChannelName        => 'Email',
        RegistrationRemove => 1,
        Result             => {
            ChannelsInvalid => ['Email'],
        },
        ChannelGet => {
            ChangeBy    => 1,
            ChannelData => {
                ArticleDataArticleIDField => 'article_id',
                ArticleDataTables         => [
                    'article_data_mime',
                    'article_data_mime_plain',
                    'article_data_mime_attachment',
                    'article_data_mime_send_error',
                ],
            },
            ChannelID   => undef,
            ChannelName => 'Email',
            CreateBy    => 1,
            DisplayIcon => 'fa-exchange',
            DisplayName => 'Email',
            Module      => 'Kernel::System::CommunicationChannel::Email',
            PackageName => 'Framework',
            ValidID     => 1,
        },
    },
);

for my $Test (@Tests) {
    if ( $Test->{ChannelName} && $Test->{RegistrationAdd} ) {
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "CommunicationChannel###$Test->{ChannelName}",
            Value => $Test->{RegistrationAdd},
        );
    }
    if ( $Test->{ChannelName} && $Test->{RegistrationRemove} ) {
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => "CommunicationChannel###$Test->{ChannelName}",
        );
    }

    my %Result = $CommunicationChannelObject->ChannelSync(
        %{ $Test->{Config} },
    );

    $Self->IsDeeply(
        \%Result,
        $Test->{Result},
        "$Test->{Name} - Result"
    );

    if ( $Test->{ChannelGet} ) {
        my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
            ChannelName => $Test->{ChannelName},
        );

        # Remember channel ID for later.
        push @ChannelIDs, $CommunicationChannel{ChannelID};

        # Remove variable data before comparison.
        for my $Field (qw(ChannelID CreateTime ChangeTime)) {
            if ( $Field eq 'ChannelID' ) {
                $CommunicationChannel{ChannelID} = undef;
            }
            else {
                delete $CommunicationChannel{$Field};
            }
        }

        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{ChannelGet},
            "$Test->{Name} - ChannelGet"
        );
    }
    if ( $Test->{ChannelCheckPresent} ) {
        my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
            ChannelName => $Test->{ChannelCheckPresent},
        );

        $Self->True(
            %CommunicationChannel,
            'Channel is present',
        );
    }
}

#
# Tests for ChannelDrop().
#
@Tests = (
    {
        Name    => 'ChannelDrop - Without parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ChannelDrop - With ChannelID, with data deletion',
        Config => {
            ChannelID       => $ChannelIDs[1],
            ChannelName     => $TestChannels[1]->{ChannelName},    # will be ignored, needed for invalidating channel
            DropArticleData => 1,
        },
        Success => 1,
        Check   => 1,
        Result  => {},
    },
    {
        Name   => 'ChannelDrop - With ChannelName, framework channel',
        Config => {
            ChannelName => 'Email',
        },
        Success => 0,
        Check   => 1,
        Result  => {
            ChangeBy    => 1,
            ChannelData => {
                ArticleDataArticleIDField => 'article_id',
                ArticleDataTables         => [
                    'article_data_mime',
                    'article_data_mime_plain',
                    'article_data_mime_attachment',
                    'article_data_mime_send_error',
                ],
            },
            ChannelID   => '1',
            ChannelName => 'Email',
            CreateBy    => 1,
            DisplayIcon => 'fa-exchange',
            DisplayName => 'Email',
            Module      => 'Kernel::System::CommunicationChannel::Email',
            PackageName => 'Framework',
            ValidID     => 1,
        },
    },
);

for my $Test (@Tests) {
    if ( $Test->{Config}->{ChannelName} ) {
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => "CommunicationChannel###$Test->{Config}->{ChannelName}",
        );
    }

    my $Success = $CommunicationChannelObject->ChannelDrop(
        %{ $Test->{Config} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Success"
        );
    }
    else {
        $Self->False(
            $Success // 0,
            "$Test->{Name} - No success",
        );
    }

    if ( $Test->{Check} ) {
        my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
            %{ $Test->{Config} },
        );

        # Remove variable data before comparison.
        for my $Field (qw(CreateTime ChangeTime)) {
            delete $CommunicationChannel{$Field};
        }

        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{Result},
            "$Test->{Name} - Result"
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
