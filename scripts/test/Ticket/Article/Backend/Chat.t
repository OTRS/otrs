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
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject             = $Kernel::OM->Get('Kernel::System::DB');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Chat',
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Chat test Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()'
);

my %ArticleTemplate = (
    TicketID        => $TicketID,
    SenderType      => 'agent',
    ChatMessageList => [
        {
            MessageText     => 'My chat message',
            CreateTime      => '2017-04-04 10:11:12',
            SystemGenerated => 0,
            ChatterID       => 1,
            ChatterType     => 'User',
            ChatterName     => 'John Doe (root)',
        },
        {
            MessageText     => undef,                   # empty
            CreateTime      => '2017-04-05 10:11:12',
            SystemGenerated => 0,
            ChatterID       => 1,
            ChatterType     => 'Customer',
            ChatterName     => 'John Doe (customer)',
        },
    ],
    IsVisibleForCustomer => 1,
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
);

my @ArticleCreateTests = (
    {
        Name   => 'ArticleCreate() without TicketID',
        Params => {
            %ArticleTemplate,
            TicketID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without SenderType',
        Params => {
            %ArticleTemplate,
            SenderType => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without ChatMessageList',
        Params => {
            %ArticleTemplate,
            ChatMessageList => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() where ChatMessageList is not AoH',
        Params => {
            %ArticleTemplate,
            ChatMessageList => 3,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without IsVisibleForCustomer',
        Params => {
            %ArticleTemplate,
            IsVisibleForCustomer => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without HistoryType',
        Params => {
            %ArticleTemplate,
            HistoryType => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without HistoryComment',
        Params => {
            %ArticleTemplate,
            HistoryType => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() without UserID',
        Params => {
            %ArticleTemplate,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleCreate() success',
        Params => {
            %ArticleTemplate,
        },
        Success => 1,
    },
);

my $ArticleIDValid;

for my $Test (@ArticleCreateTests) {
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %{ $Test->{Params} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $ArticleID,
            "$Test->{Name} - Article created - $ArticleID",
        );

        $ArticleIDValid = $ArticleID;
    }
    else {
        $Self->False(
            $ArticleID,
            "$Test->{Name} - Article not created - $ArticleID",
        );
    }
}

my @ArticleGetTests = (
    {
        Name   => 'ArticleGet() without TicketID',
        Params => {
            ArticleID => $ArticleIDValid,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleGet() without ArticleID',
        Params => {
            TicketID => $TicketID,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleGet() with all required parameters',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 1,
                    ChatterName     => 'John Doe (root)',
                    ChatterType     => 'User',
                    CreateTime      => '2017-04-04 10:11:12',
                    MessageText     => 'My chat message',
                    SystemGenerated => 0,
                },
                {
                    ChatterID       => 1,
                    ChatterName     => 'John Doe (customer)',
                    ChatterType     => 'Customer',
                    CreateTime      => '2017-04-05 10:11:12',
                    MessageText     => undef,
                    SystemGenerated => 0,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 1,
            SenderType             => 'agent',
            SenderTypeID           => 1,
            TicketID               => $TicketID,
        },
    },
);

my @ChatMessageIDs;

for my $Test (@ArticleGetTests) {
    my %Article = $ArticleBackendObject->ArticleGet(
        %{ $Test->{Params} },
    );

    delete $Article{CreateTime};
    delete $Article{ChangeTime};
    if ( ref $Article{ChatMessageList} eq 'ARRAY' ) {
        for my $Message ( @{ $Article{ChatMessageList} } ) {
            my $ChatMessageID = delete $Message->{ID};
            push @ChatMessageIDs, $ChatMessageID;
        }
    }

    if ( $Test->{Success} ) {
        $Self->IsDeeply(
            \%Article,
            $Test->{ExpectedResult},
            "$Test->{Name} - Is deeply",
        );
    }
    else {
        $Self->False(
            scalar keys %Article,
            "$Test->{Name} - nothing returned",
        );
    }
}

my @ArticleUpdateTests = (
    {
        Name   => 'ArticleUpdate() without TicketID',
        Params => {
            ArticleID => $ArticleIDValid,
            Key       => 'SenderType',
            Value     => 'customer',
            UserID    => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleUpdate() without ArticleID',
        Params => {
            TicketID => $TicketID,
            Key      => 'SenderType',
            Value    => 'customer',
            UserID   => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ArticleUpdate() without UserID',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            Key       => 'SenderType',
            Value     => 'customer',
        },
        Success => 0,
    },
    {
        Name   => 'ArticleUpdate() success - change SenderType',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            Key       => 'SenderType',
            Value     => 'customer',
            UserID    => 1,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 1,
                    ChatterName     => 'John Doe (root)',
                    ChatterType     => 'User',
                    CreateTime      => '2017-04-04 10:11:12',
                    MessageText     => 'My chat message',
                    SystemGenerated => 0,
                },
                {
                    ChatterID       => '1',
                    ChatterName     => 'John Doe (customer)',
                    ChatterType     => 'Customer',
                    CreateTime      => '2017-04-05 10:11:12',
                    MessageText     => undef,
                    SystemGenerated => 0,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 1,
            SenderType             => 'customer',
            SenderTypeID           => 3,
            TicketID               => $TicketID,
        },
    },
    {
        Name   => 'ArticleUpdate() success - change IsVisibleForCustomer',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            Key       => 'IsVisibleForCustomer',
            Value     => '0',
            UserID    => 1,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 1,
                    ChatterName     => 'John Doe (root)',
                    ChatterType     => 'User',
                    CreateTime      => '2017-04-04 10:11:12',
                    MessageText     => 'My chat message',
                    SystemGenerated => 0,
                },
                {
                    ChatterID       => '1',
                    ChatterName     => 'John Doe (customer)',
                    ChatterType     => 'Customer',
                    CreateTime      => '2017-04-05 10:11:12',
                    MessageText     => undef,
                    SystemGenerated => 0,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 0,
            SenderType             => 'customer',
            SenderTypeID           => 3,
            TicketID               => $TicketID,
        },
    },
    {
        Name   => 'ArticleUpdate() success - change IsVisibleForCustomer',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            Key       => 'IsVisibleForCustomer',
            Value     => '0',
            UserID    => 1,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 1,
                    ChatterName     => 'John Doe (root)',
                    ChatterType     => 'User',
                    CreateTime      => '2017-04-04 10:11:12',
                    MessageText     => 'My chat message',
                    SystemGenerated => 0,
                },
                {
                    ChatterID       => '1',
                    ChatterName     => 'John Doe (customer)',
                    ChatterType     => 'Customer',
                    CreateTime      => '2017-04-05 10:11:12',
                    MessageText     => undef,
                    SystemGenerated => 0,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 0,
            SenderType             => 'customer',
            SenderTypeID           => 3,
            TicketID               => $TicketID,
        },
    },
    {
        Name   => 'ArticleUpdate() success - change ChatMessageList',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            Key       => 'ChatMessageList',
            Value     => [
                {
                    ChatterID       => 2,
                    ChatterName     => 'Jane Doe',
                    ChatterType     => 'System',
                    CreateTime      => '2017-03-04 10:11:15',
                    MessageText     => 'My chat message is updated',
                    SystemGenerated => 1,
                },
            ],
            UserID => 1,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 2,
                    ChatterName     => 'Jane Doe',
                    ChatterType     => 'System',
                    CreateTime      => '2017-03-04 10:11:15',
                    MessageText     => 'My chat message is updated',
                    SystemGenerated => 1,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 0,
            SenderType             => 'customer',
            SenderTypeID           => 3,
            TicketID               => $TicketID,
        },
    },
    {
        Name   => 'ArticleUpdate() success - without Key and Value',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            UserID    => 1,
        },
        Success        => 1,
        ExpectedResult => {
            ArticleID       => $ArticleIDValid,
            ArticleNumber   => 1,
            ChangeBy        => 1,
            ChatMessageList => [
                {
                    ChatterID       => 2,
                    ChatterName     => 'Jane Doe',
                    ChatterType     => 'System',
                    CreateTime      => '2017-03-04 10:11:15',
                    MessageText     => 'My chat message is updated',
                    SystemGenerated => 1,
                },
            ],
            CommunicationChannelID => 4,
            CreateBy               => 1,
            IsVisibleForCustomer   => 0,
            SenderType             => 'customer',
            SenderTypeID           => 3,
            TicketID               => $TicketID,
        },
    },
);

for my $Test (@ArticleUpdateTests) {
    my $Success = $ArticleBackendObject->ArticleUpdate(
        %{ $Test->{Params} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - update ok",
        );

        # Check article
        my %Article = $ArticleBackendObject->ArticleGet(
            %{ $Test->{Params} },
        );

        delete $Article{CreateTime};
        delete $Article{ChangeTime};
        if ( ref $Article{ChatMessageList} eq 'ARRAY' ) {
            for my $Message ( @{ $Article{ChatMessageList} } ) {
                delete $Message->{ID};
            }
        }

        $Self->IsDeeply(
            \%Article,
            $Test->{ExpectedResult},
            "$Test->{Name} - Check updated article",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - update failed",
        );
    }
}

my @ArticleDeleteTests = (
    {
        Name   => 'ArticleDelete() without TicketID',
        Params => {
            ArticleID => $ArticleIDValid,
            UserID    => 1,

        },
        Success => 0,
    },
    {
        Name   => 'ArticleDelete() without ArticleID',
        Params => {
            TicketID => $TicketID,
            UserID   => 1,

        },
        Success => 0,
    },
    {
        Name   => 'ArticleDelete() without UserID',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,

        },
        Success => 0,
    },
    {
        Name   => 'ArticleDelete() - OK',
        Params => {
            TicketID  => $TicketID,
            ArticleID => $ArticleIDValid,
            UserID    => 1,

        },
        Success => 1,
    },
);

for my $Test (@ArticleDeleteTests) {

    my $Success = $ArticleBackendObject->ArticleDelete(
        %{ $Test->{Params} },
    );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - delete ok",
        );

        # Make sure there is nothing left
        my $SQL = '
            SELECT COUNT(*)
            FROM article_data_otrs_chat
            WHERE article_id = ?
        ';

        # db query
        return if !$DBObject->Prepare(
            SQL  => $SQL,
            Bind => [
                \$ArticleIDValid,
            ],
        );

        my $Articles;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Articles = $Row[0];
        }

        $Self->False(
            $Articles,
            "$Test->{Name} - all data are deleted",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - delete failed",
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
