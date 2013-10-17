# --
# ArticleStorageSwitch.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::PostMaster;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create tickets/article/attachments in backend for article storage switch tests
for my $SourceBackend (qw(ArticleStorageDB ArticleStorageFS)) {

    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::' . $SourceBackend,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    my @TicketIDs;
    my %ArticleIDs;
    my $NamePrefix = "ArticleStorageSwitch ($SourceBackend)";
    for my $File (qw(1 2 3 4 5 6 7 8 9 10 11 20)) {

        my $NamePrefix = "$NamePrefix #$File ";

        # new ticket check
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
        my $ContentRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );
        my @Content = @{$ContentRef};

        my $PostMasterObject = Kernel::System::PostMaster->new(
            %{$Self},
            TicketObject => $TicketObject,
            QueueObject  => $QueueObject,
            ConfigObject => $ConfigObject,
            Email        => \@Content,
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

        # remember created tickets
        push @TicketIDs, $Return[1];

        # remember created article and attachments
        my @ArticleBox = $TicketObject->ArticleContentIndex(
            TicketID => $Return[1],
            UserID   => 1,
        );
        for my $Article (@ArticleBox) {
            $ArticleIDs{ $Article->{ArticleID} } = { %{ $Article->{Atms} } };
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
            my %Index = $TicketObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
                UserID    => 1,
            );

            # check file attributes
            for my $AttachmentID ( sort keys %{ $ArticleIDs{$ArticleID} } ) {
                for my $ID ( sort keys %Index ) {
                    next
                        if $ArticleIDs{$ArticleID}->{$AttachmentID}->{Filename} ne
                            $Index{$ID}->{Filename};
                    for my $Attribute ( sort keys %{ $ArticleIDs{$ArticleID}->{$AttachmentID} } ) {
                        $Self->Is(
                            $Index{$ID}->{$Attribute},
                            $ArticleIDs{$ArticleID}->{$AttachmentID}->{$Attribute},
                            "$NamePrefix - Verify before - $Attribute (ArticleID:$ArticleID)",
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
                "$NamePrefix - backend move TicketID:$TicketID",
            );
        }

        # verify
        for my $ArticleID ( sort keys %ArticleIDs ) {
            my %Index = $TicketObject->ArticleAttachmentIndex(
                ArticleID => $ArticleID,
                UserID    => 1,
            );

            # check file attributes
            for my $AttachmentID ( sort keys %{ $ArticleIDs{$ArticleID} } ) {
                for my $ID ( sort keys %Index ) {
                    next
                        if $ArticleIDs{$ArticleID}->{$AttachmentID}->{Filename} ne
                            $Index{$ID}->{Filename};
                    for my $Attribute ( sort keys %{ $ArticleIDs{$ArticleID}->{$AttachmentID} } ) {
                        $Self->Is(
                            $Index{$ID}->{$Attribute},
                            $ArticleIDs{$ArticleID}->{$AttachmentID}->{$Attribute},
                            "$NamePrefix - Verify after - $Attribute (ArticleID:$ArticleID)",
                        );
                    }
                }
            }
        }
    }

    # cleanup
    for my $TicketID (@TicketIDs) {
        my $Delete = $TicketObject->TicketDelete(
            UserID   => 1,
            TicketID => $TicketID,
        );
        $Self->True(
            $Delete,
            "$NamePrefix - TicketDelete()",
        );
    }
}

1;
