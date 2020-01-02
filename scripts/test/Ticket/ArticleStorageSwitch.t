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

use Kernel::System::PostMaster;

# create tickets/article/attachments in backend for article storage switch tests
for my $SourceBackend (qw(ArticleStorageDB ArticleStorageFS)) {

    # Make sure that all objects get recreated for each loop.
    $Kernel::OM->ObjectsDiscard();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest::Helper' => {
            RestoreDatabase  => 1,
            UseTmpArticleDir => 1,
        },
    );
    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

    $ConfigObject->Set(
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
        Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::' . $SourceBackend,
    );

    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    $Self->Is(
        $ArticleBackendObject->{ArticleStorageModule},
        'Kernel::System::Ticket::Article::Backend::MIMEBase::' . $SourceBackend,
        'Article backend loaded the correct storage module'
    );

    my @TicketIDs;
    my %ArticleIDs;
    my $NamePrefix = "ArticleStorageSwitch ($SourceBackend)";
    for my $File (qw(1 2 3 4 5 6 7 8 9 10 11 20)) {

        my $NamePrefix = "$NamePrefix #$File ";

        # new ticket check
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );
        my @Content = @{$ContentRef};

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
            Email                  => \@Content,
        );

        my @Return = $PostMasterObject->Run();
        $Self->Is(
            $Return[0] || 0,
            1,
            $NamePrefix . ' Run() - NewTicket',
        );
        $Self->True(
            $Return[1] || 0,
            $NamePrefix . " Run() - NewTicket/TicketID:$Return[1]",
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );

        # remember created tickets
        push @TicketIDs, $Return[1];

        # Remember created article and attachments.
        my @Articles = $ArticleObject->ArticleList(
            TicketID => $Return[1],
            UserID   => 1,
        );
        for my $Article (@Articles) {
            my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article->{ArticleID},
            );
            $ArticleIDs{ $Article->{ArticleID} } = \%AttachmentIndex;
        }
    }

    my @Map = (
        [ 'ArticleStorageDB', 'ArticleStorageFS' ],
        [ 'ArticleStorageFS', 'ArticleStorageDB' ],
        [ 'ArticleStorageDB', 'ArticleStorageFS' ],
        [ 'ArticleStorageFS', 'ArticleStorageDB' ],
        [ 'ArticleStorageFS', 'ArticleStorageDB' ],
    );
    for my $Case (@Map) {
        my $SourceBackend      = $Case->[0];
        my $DestinationBackend = $Case->[1];
        my $NamePrefix         = "ArticleStorageSwitch ($SourceBackend->$DestinationBackend)";

        # verify
        for my $ArticleID ( sort keys %ArticleIDs ) {
            my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
            );

            # check file attributes
            for my $AttachmentID ( sort keys %{ $ArticleIDs{$ArticleID} } ) {

                ATTACHMENTINDEXID:
                for my $ID ( sort keys %Index ) {
                    if (
                        $ArticleIDs{$ArticleID}->{$AttachmentID}->{Filename} ne
                        $Index{$ID}->{Filename}
                        )
                    {
                        next ATTACHMENTINDEXID;
                    }
                    for my $Attribute ( sort keys %{ $ArticleIDs{$ArticleID}->{$AttachmentID} } ) {
                        $Self->Is(
                            $Index{$ID}->{$Attribute},
                            $ArticleIDs{$ArticleID}->{$AttachmentID}->{$Attribute},
                            "$NamePrefix - Verify before - $Attribute (ArticleID:$ArticleID)"
                        );
                    }
                }
            }
        }

        # switch to backend b
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketArticleStorageSwitch(
                TicketID    => $TicketID,
                Source      => $SourceBackend,
                Destination => $DestinationBackend,
                UserID      => 1,
            );
            $Self->True(
                $Success,
                "$NamePrefix - backend move TicketID: $TicketID"
            );
        }

        # verify
        for my $ArticleID ( sort keys %ArticleIDs ) {
            my %Index = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
            );

            # check file attributes
            for my $AttachmentID ( sort keys %{ $ArticleIDs{$ArticleID} } ) {

                ATTACHMENTINDEXID:
                for my $ID ( sort keys %Index ) {
                    if (
                        $ArticleIDs{$ArticleID}->{$AttachmentID}->{Filename} ne
                        $Index{$ID}->{Filename}
                        )
                    {
                        next ATTACHMENTINDEXID;
                    }
                    for my $Attribute ( sort keys %{ $ArticleIDs{$ArticleID}->{$AttachmentID} } ) {
                        $Self->Is(
                            $Index{$ID}->{$Attribute},
                            $ArticleIDs{$ArticleID}->{$AttachmentID}->{$Attribute},
                            "$NamePrefix - Verify after - $Attribute (ArticleID: $ArticleID)"
                        );
                    }
                }
            }
        }
    }
}

# cleanup is done by RestoreDatabase.

1;
