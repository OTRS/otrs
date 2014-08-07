# --
# ContentDisposition.t - PostMaster tests for content disposition
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use utf8;

use Kernel::System::PostMaster;
use Kernel::System::PostMaster::Filter;
use Kernel::System::Ticket;
use Kernel::Config;

use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;

# create local config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Name            => 'Disposition1',
        ExpectedResults => {
            'ceeibejd.png' => {
                Filename           => 'ceeibejd.png',
                ContentType        => 'image/png; name="ceeibejd.png"',
                ContentID          => '<part1.02040705.00020608@otrs.com>',
                ContentAlternative => '',
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
                ContentAlternative => '',
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
                ContentAlternative => '',
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
                ContentAlternative => '',
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

for my $Test (@Tests) {
    for my $Backend (qw(DB FS)) {
        $ConfigObject->Set(
            Key   => 'Ticket::StorageModule',
            Value => 'Kernel::System::Ticket::ArticleStorage' . $Backend,
        );

        my $Location = $ConfigObject->Get('Home')
            . '/scripts/test/sample/PostMaster/' . $Test->{Name} . '.box';
        my $ContentRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );

        # new/clear ticket object
        my $TicketObject = Kernel::System::Ticket->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        my $TicketID;
        {
            my $PostMasterObject = Kernel::System::PostMaster->new(
                %{$Self},
                ConfigObject => $ConfigObject,
                Email        => $ContentRef,
            );

            my @Return = $PostMasterObject->Run();

            $TicketID = $Return[1];
        }
        $Self->True(
            $TicketID,
            "$Test->{Name} | $Backend - Ticket created $TicketID",
        );

        # remember added tickets
        push @AddedTicketIDs, $TicketID;

        my @ArticleIDs = $TicketObject->ArticleIndex( TicketID => $TicketID );
        $Self->True(
            $ArticleIDs[0],
            "$Test->{Name} | $Backend - Article created",
        );

        my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleIDs[0],
            UserID    => 1,
        );

        my %AttachmentsLookup
            = map { $AttachmentIndex{$_}->{Filename} => $_ } sort keys %AttachmentIndex;

        for my $AttachmentFilename ( sort keys %{ $Test->{ExpectedResults} } ) {
            my $AttachmentID = $AttachmentsLookup{$AttachmentFilename};

            # delete zise attributes for easy compare
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

# cleanup the system
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

for my $TicketID (@AddedTicketIDs) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success,
        "TicketDelete() - removed ticket $TicketID",
    );
}

1;
