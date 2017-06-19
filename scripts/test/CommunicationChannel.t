# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper                     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

my @ChannelsDefault = $CommunicationChannelObject->ChannelList();

# remove keys
grep { delete $_->{CreateTime}, delete $_->{ChangeTime} } @ChannelsDefault;

my $RandomID1 = $Helper->GetRandomID();
my $RandomID2 = $Helper->GetRandomID();
my $RandomID3 = $Helper->GetRandomID();
my $RandomID4 = $Helper->GetRandomID();
my $RandomID5 = $Helper->GetRandomID();

my @TestChannelAdd = (
    {
        Title  => "Add channel without name.",
        Params => {
            Module      => 'scripts::test::CommunicationChannel::Test',
            ChannelName => 'Framework',
            UserID      => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Add channel without UserID.",
        Params => {
            ChannelName => 'TEßt channel namé',
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Add channel without Module.",
        Params => {
            ChannelName => 'TEßt channel namé',
            PackageName => 'Framework',
            UserID      => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Add channel without PackageName.",
        Params => {
            ChannelName => 'TEßt channel namé',
            Module      => 'scripts::test::CommunicationChannel::Test',
            UserID      => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Add UTF-8 channel name.",
        Params => {
            ChannelName => "TEßt channel namé$RandomID1",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            UserID      => 1,
        },
        ExpectedResult => 1,
    },
    {
        Title  => "Add normal channel name.",
        Params => {
            ChannelName => "Channel name $RandomID2",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            UserID      => 1,
        },
        ExpectedResult => 1,
    },
    {
        Title  => "ChannelData has array.",
        Params => {
            ChannelName => "Channel name $RandomID3",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => [
                '1',
                '2',
            ],
            UserID => 1,
        },
        ExpectedResult => 1,
    },
    {
        Title  => "ChannelData has hash.",
        Params => {
            ChannelName => "Channel name $RandomID4",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => {
                One => '1',
                Two => '2',
            },
            UserID => 1,
        },
        ExpectedResult => 1,
    },
    {
        Title  => "Channel with ValidID = 0.",
        Params => {
            ChannelName => "Channel name $RandomID5",
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ValidID     => 2,
            UserID      => 1,
        },
        ExpectedResult => 1,
    },
);

my @Channels;

for my $Test (@TestChannelAdd) {
    my $ChannelID = $CommunicationChannelObject->ChannelAdd( %{ $Test->{Params} } );

    if ($ChannelID) {
        push @Channels, {
            ChannelID   => $ChannelID,
            ChannelName => $Test->{Params}->{ChannelName},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => $Test->{Params}->{ChannelData} || '',
            ValidID     => $Test->{Params}->{ValidID} // 1,
            CreateBy    => 1,
            ChangeBy    => 1,
        };
    }

    $Self->Is(
        $ChannelID ? 1 : undef,
        $Test->{ExpectedResult},
        "ChannelAdd() - Check expected value for $Test->{Title}.",
    );
}

my @TestChannelGet = (
    {
        Title          => "Get channel without ChannelName or ChannelID",
        Params         => {},
        ExpectedResult => undef,
    },
    {
        Title  => "Get by ChannelName.",
        Params => {
            ChannelName => "TEßt channel namé$RandomID1",
        },
        ExpectedResult => {
            ChannelName => "TEßt channel namé$RandomID1",
            ChannelID   => $Channels[0]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => '',
            ValidID     => 1,
            CreateBy    => 1,
            ChangeBy    => 1,
        },
    },
    {
        Title  => "Get by ChannelID.",
        Params => {
            ChannelID => $Channels[0]->{ChannelID},
        },
        ExpectedResult => {
            ChannelName => "TEßt channel namé$RandomID1",
            ChannelID   => $Channels[0]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => '',
            ValidID     => 1,
            CreateBy    => 1,
            ChangeBy    => 1,
        },
    },
    {
        Title  => "Get by ChannelID.",
        Params => {
            ChannelID => $Channels[2]->{ChannelID},
        },
        ExpectedResult => {
            ChannelName => "Channel name $RandomID3",
            ChannelID   => $Channels[2]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => [
                '1',
                '2'
            ],
            ValidID  => 1,
            CreateBy => 1,
            ChangeBy => 1,
        },
    },
    {
        Title  => "Get by ChannelID.",
        Params => {
            ChannelID => $Channels[3]->{ChannelID},
        },
        ExpectedResult => {
            ChannelName => "Channel name $RandomID4",
            ChannelID   => $Channels[3]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => {
                'One' => '1',
                'Two' => '2'
            },
            ValidID  => 1,
            CreateBy => 1,
            ChangeBy => 1,
        },
    },
    {
        Title  => "Get by ChannelID.",
        Params => {
            ChannelID => $Channels[4]->{ChannelID},
        },
        ExpectedResult => {
            ChannelName => "Channel name $RandomID5",
            ChannelID   => $Channels[4]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => '',
            ValidID     => 2,
            CreateBy    => 1,
            ChangeBy    => 1,
        },
    },
);

for my $Test (@TestChannelGet) {
    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet( %{ $Test->{Params} } );

    if ( $Test->{ExpectedResult} ) {

        # remove keys
        delete $CommunicationChannel{CreateTime};
        delete $CommunicationChannel{ChangeTime};

        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{ExpectedResult},
            "ChannelGet() - Check expected value - $Test->{Title} (deeply).",
        );
    }
    else {
        $Self->False(
            %CommunicationChannel ? 1 : 0,
            "ChannelGet() - Check expected value - $Test->{Title}.",
        );
    }
}

# List channels.
my @ChannelList1 = $CommunicationChannelObject->ChannelList();

# remove keys
grep { delete $_->{CreateTime}, delete $_->{ChangeTime} } @ChannelList1;
my @ExpectedChannelList1 = (
    @ChannelsDefault,
    @Channels,
);

@ExpectedChannelList1 = sort { $a->{ChannelName} cmp $b->{ChannelName} } @ExpectedChannelList1;

$Self->IsDeeply(
    \@ChannelList1,
    \@ExpectedChannelList1,
    "ChannelList() - Check expected value.",
);

my @TestChannelUpdate = (
    {
        Title  => "Update channel without ChannelName",
        Params => {
            ID     => $Channels[0]->{ChannelID},
            UserID => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Update channel without ChannelID",
        Params => {
            ChannelName => 'Updated channel name',
            UserID      => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Update channel without UserID",
        Params => {
            ID          => $Channels[0]->{ChannelID},
            ChannelName => 'Updated channel name',
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Update ok",
        Params => {
            ChannelID   => $Channels[0]->{ChannelID},
            ChannelName => "Updated channel name $RandomID1",
            UserID      => 1,
        },
        ExpectedResult => 1,
    },
);

for my $Test (@TestChannelUpdate) {
    my $Success = $CommunicationChannelObject->ChannelUpdate( %{ $Test->{Params} } );

    $Self->Is(
        $Success ? 1 : undef,
        $Test->{ExpectedResult},
        "ChannelUpdate() - Check expected value for $Test->{Title}.",
    );
}

my @TestChannelGet2 = (
    {
        Title  => "Get by old name (after update).",
        Params => {
            ChannelName => "TEßt channel namé$RandomID1",
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Get by new name (after update).",
        Params => {
            ChannelName => "Updated channel name $RandomID1",
        },
        ExpectedResult => {
            ChannelName => "Updated channel name $RandomID1",
            ChannelID   => $Channels[0]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => '',
            ValidID     => 1,
            CreateBy    => 1,
            ChangeBy    => 1,
        },
    },
    {
        Title  => "Get by ID (after update).",
        Params => {
            ChannelID => $Channels[0]->{ChannelID},
        },
        ExpectedResult => {
            ChannelName => "Updated channel name $RandomID1",
            ChannelID   => $Channels[0]->{ChannelID},
            Module      => 'scripts::test::CommunicationChannel::Test',
            PackageName => 'Framework',
            ChannelData => '',
            ValidID     => 1,
            CreateBy    => 1,
            ChangeBy    => 1,
        },
    },
);

for my $Test (@TestChannelGet2) {
    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet( %{ $Test->{Params} } );

    # remove keys
    delete @CommunicationChannel{ 'CreateTime', 'ChangeTime' };

    if ( $Test->{ExpectedResult} ) {
        $Self->IsDeeply(
            \%CommunicationChannel,
            $Test->{ExpectedResult},
            "ChannelGet() - 2 Check expected value for $Test->{Title} (deeply).",
        );
    }
    else {
        $Self->False(
            %CommunicationChannel ? 1 : 0,
            "ChannelGet() - 2 Check expected value for $Test->{Title}.",
        );
    }
}

# List channels.
my @ChannelList2 = $CommunicationChannelObject->ChannelList();

# remove keys
grep { delete $_->{CreateTime}, delete $_->{ChangeTime} } @ChannelList2;

$Channels[0]->{ChannelName} = "Updated channel name $RandomID1";

my @ExpectedChannelList2 = (
    @ChannelsDefault,
    @Channels,
);

@ExpectedChannelList2 = sort { $a->{ChannelName} cmp $b->{ChannelName} } @ExpectedChannelList2;

$Self->IsDeeply(
    \@ChannelList2,
    \@ExpectedChannelList2,
    "ChannelList() - 2 Check expected value.",
);

my @TestChannelDelete = (
    {
        Title  => "Delete - missing ChannelID and ChannelName",
        Params => {
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Delete by ChannelName",
        Params => {
            ChannelName => "Updated channel name $RandomID1",
        },
        ExpectedResult => 1,
    },
    {
        Title  => "Delete already deleted channel",
        Params => {
            ChannelID => $Channels[0]->{ChannelID},
        },
        ExpectedResult => undef,
    },
    {
        Title  => "Delete by ChannelID",
        Params => {
            ChannelID => $Channels[1]->{ChannelID},
        },
        ExpectedResult => 1,
    },
);

for my $Test (@TestChannelDelete) {
    my $Success = $CommunicationChannelObject->ChannelDelete( %{ $Test->{Params} } );

    $Self->Is(
        $Success ? 1 : undef,
        $Test->{ExpectedResult},
        "ChannelDelete() - Check expected value - $Test->{Title}.",
    );
}

# List channels.
my @ChannelList3 = $CommunicationChannelObject->ChannelList();

# remove keys
grep { delete $_->{CreateTime}, delete $_->{ChangeTime} } @ChannelList3;

shift @Channels;
shift @Channels;

my @ExpectedChannelList3 = (
    @ChannelsDefault,
    @Channels,
);

@ExpectedChannelList3 = sort { $a->{ChannelName} cmp $b->{ChannelName} } @ExpectedChannelList3;

$Self->IsDeeply(
    \@ChannelList3,
    \@ExpectedChannelList3,
    "ChannelList() - 3 Check expected value.",
);

# List channels.
my @ChannelList4 = $CommunicationChannelObject->ChannelList( ValidID => 1 );

# remove keys
grep { delete $_->{CreateTime}, delete $_->{ChangeTime} } @ChannelList4;

pop @Channels;

my @ExpectedChannelList4 = (
    @ChannelsDefault,
    @Channels,
);

@ExpectedChannelList4 = sort { $a->{ChannelName} cmp $b->{ChannelName} } @ExpectedChannelList4;

$Self->IsDeeply(
    \@ChannelList4,
    \@ExpectedChannelList4,
    "ChannelList(ValidID => 1) - 4 Check expected value.",
);

my @AddedChannels1 = $CommunicationChannelObject->ChannelSync(
    UserID => 1,
);
$Self->IsDeeply(
    \@AddedChannels1,
    [],
    "ChannelSync() - already in sync.",
);

# Register a new communication channel.
$Helper->ConfigSettingChange(
    Valid => 1,                                # (optional) enable or disable setting
    Key   => 'CommunicationChannel',
    Value => {
        '100024-test' => {
            Name   => "TestChannelName$RandomID1",
            Module => 'scripts::test::CommunicationChannel::Test',
        },
    },
);

my @AddedChannels2 = $CommunicationChannelObject->ChannelSync(
    UserID => 1,
);
$Self->IsDeeply(
    \@AddedChannels2,
    ["TestChannelName$RandomID1"],
    "ChannelSync() - with sync.",
);

# Update registration - forward to another communication channel.
$Helper->ConfigSettingChange(
    Valid => 1,                                # (optional) enable or disable setting
    Key   => 'CommunicationChannel',
    Value => {
        '100024-test' => {
            Name   => "TestChannelName$RandomID1",
            Module => 'scripts::test::CommunicationChannel::TestTwo',
        },
    },
);

my @AddedChannels3 = $CommunicationChannelObject->ChannelSync(
    UserID => 1,
);
$Self->IsDeeply(
    \@AddedChannels3,
    ["TestChannelName$RandomID1"],
    "ChannelSync() - with sync.",
);

my %ChannelSynced = $CommunicationChannelObject->ChannelGet(
    ChannelName => "TestChannelName$RandomID1",
);

# remove keys
delete @ChannelSynced{ 'ChannelID', 'CreateTime', 'ChangeTime' };

$Self->IsDeeply(
    \%ChannelSynced,
    {
        ChangeBy    => '1',
        ChannelData => {
            ArticleDataArticleIDField => 'article_id',
            ArticleDataIsDroppable    => '0',
            ArticleDataTables         => [
                'article_data_mime',
                'article_data_mime_plain',
                'article_data_mime_attachment',
            ],
        },
        ChannelName => "TestChannelName$RandomID1",
        CreateBy    => '1',
        Module      => 'scripts::test::CommunicationChannel::TestTwo',
        PackageName => 'TestPackage',
        ValidID     => '1'
    },
    "ChannelGet() - Check synced value.",
);

my $DropSuccess1 = $CommunicationChannelObject->ChannelDrop(
    ChannelName => "TestChannelName$RandomID1",
);

$Self->False(
    $DropSuccess1,
    "ChannelDrop() - IsDroppable => 0",
);

# get object
my $Object1 = $CommunicationChannelObject->ChannelObjectGet(
    ChannelName => "TestChannelName$RandomID1",
);

$Self->True(
    $Object1,
    "Object created."
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CommunicationChannel',
    Value => {
        '100024-test' => {
            Name   => "TestChannelName$RandomID1",
            Module => 'scripts::test::CommunicationChannel::Test',
        },
    },
);

$CommunicationChannelObject->ChannelSync(
    UserID => 1,
);

my $DropSuccess2 = $CommunicationChannelObject->ChannelDrop(
    ChannelName => "TestChannelName$RandomID1",
);

$Self->True(
    $DropSuccess2,
    "ChannelDrop() - IsDroppable => 1",
);

# get object
my $Object2 = $CommunicationChannelObject->ChannelObjectGet(
    ChannelName => "TestChannelName$RandomID1",
);

$Self->False(
    $Object2,
    "Object created."
);

1;
