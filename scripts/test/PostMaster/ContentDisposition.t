# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name            => 'Disposition1',
        ExpectedResults => {
            'ceeibejd.png' => {
                Filename           => 'ceeibejd.png',
                ContentType        => 'image/png; name="ceeibejd.png"',
                ContentID          => '<part1.02040705.00020608@otrs.com>',
                ContentAlternative => '1',
                Disposition        => 'inline',
            },
            'ui-toolbar.png' => {
                Filename           => 'ui-toolbar.png',
                ContentType        => 'image/png; name="ui-toolbar.png"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
            'testing.pdf' => {
                Filename           => 'testing.pdf',
                ContentType        => 'application/pdf; name="testing.pdf"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
        },
    },
    {
        Name            => 'Disposition2',
        ExpectedResults => {
            'ceeibejd.png' => {
                Filename           => 'ceeibejd.png',
                ContentType        => 'image/png; name="ceeibejd.png"',
                ContentID          => '<part1.02040705.00020608@otrs.com>',
                ContentAlternative => '1',
                Disposition        => 'inline',
            },
            'ui-toolbar.png' => {
                Filename           => 'ui-toolbar.png',
                ContentType        => 'image/png; name="ui-toolbar.png"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'inline',
            },
            'testing.pdf' => {
                Filename           => 'testing.pdf',
                ContentType        => 'application/pdf; name="testing.pdf"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
        },
    },
    {
        Name            => 'Disposition3',
        ExpectedResults => {
            'ceeibejd.png' => {
                Filename           => 'ceeibejd.png',
                ContentType        => 'image/png; name="ceeibejd.png"',
                ContentID          => '<part1.02040705.00020608@otrs.com>',
                ContentAlternative => '1',
                Disposition        => 'inline',
            },
            'ui-toolbar.png' => {
                Filename           => 'ui-toolbar.png',
                ContentType        => 'image/png; name="ui-toolbar.png"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'inline',
            },
            'testing.pdf' => {
                Filename           => 'testing.pdf',
                ContentType        => 'application/pdf; name="testing.pdf"',
                ContentID          => '<part1.02040705.0001234@otrs.com>',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
        },
    },
    {
        Name            => 'Disposition4',
        ExpectedResults => {
            'ceeibejd.png' => {
                Filename           => 'ceeibejd.png',
                ContentType        => 'image/png; name="ceeibejd.png"',
                ContentID          => '<part1.02040705.00020608@otrs.com>',
                ContentAlternative => '1',
                Disposition        => 'attachment',
            },
            'ui-toolbar.png' => {
                Filename           => 'ui-toolbar.png',
                ContentType        => 'image/png; name="ui-toolbar.png"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
            'testing.pdf' => {
                Filename           => 'testing.pdf',
                ContentType        => 'application/pdf; name="testing.pdf"',
                ContentID          => '',
                ContentAlternative => '',
                Disposition        => 'attachment',
            },
        },
    },
);

my @AddedTicketIDs;

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

for my $Test (@Tests) {

    for my $Backend (qw(DB FS)) {

        $ConfigObject->Set(
            Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
        );

        my $Location = $ConfigObject->Get('Home')
            . '/scripts/test/sample/PostMaster/' . $Test->{Name} . '.box';

        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );

        my $TicketID;
        {
            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport => 'Email',
                    Direction => 'Incoming',
                },
            );
            $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

            my $PostMasterObject = Kernel::System::PostMaster->new(
                CommunicationLogObject => $CommunicationLogObject,
                Email                  => $ContentRef,
            );

            my @Return = $PostMasterObject->Run();

            $TicketID = $Return[1];

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Message',
                Status        => 'Successful',
            );
            $CommunicationLogObject->CommunicationStop(
                Status => 'Successful',
            );
        }

        $Self->True(
            $TicketID,
            "$Test->{Name} | $Backend - Ticket created $TicketID",
        );

        # remember added tickets
        push @AddedTicketIDs, $TicketID;

        my @ArticleIDs = map { $_->{ArticleID} } $ArticleObject->ArticleList( TicketID => $TicketID );
        $Self->True(
            $ArticleIDs[0],
            "$Test->{Name} | $Backend - Article created",
        );

        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $ArticleIDs[0],
        );

        my %AttachmentsLookup = map { $AttachmentIndex{$_}->{Filename} => $_ } sort keys %AttachmentIndex;

        for my $AttachmentFilename ( sort keys %{ $Test->{ExpectedResults} } ) {

            my $AttachmentID = $AttachmentsLookup{$AttachmentFilename};

            # delete size attributes for easy compare
            delete $AttachmentIndex{$AttachmentID}->{Filesize};
            delete $AttachmentIndex{$AttachmentID}->{FilesizeRaw};

            $Self->IsDeeply(
                $AttachmentIndex{$AttachmentID},
                $Test->{ExpectedResults}->{$AttachmentFilename},
                "$Test->{Name} | $Backend - Attachment",
            );
        }
    }
}

# cleanup is done by RestoreDatabase.

1;
