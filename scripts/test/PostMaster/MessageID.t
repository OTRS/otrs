# --
# MessageID.t - PostMaster tests for Message ID
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

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
my $ConfigObject = Kernel::Config->new();

# new/clear ticket object
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my @Tickets;

for my $File (qw(1 2 3 5 6 11 21)) {

    # create random message ID
    my $MessageID = '<message' . time() . ( int rand 1000000 ) . '@example.com>';

    # new ticket check
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";
    my $ContentRef = $Self->{MainObject}->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );
    my @Content;
    for my $Line ( @{$ContentRef} ) {

        # override Message-ID
        if ( $Line =~ /^Message-ID:/ ) {
            $Line = "Message-ID: $MessageID\n";
        }
        push @Content, $Line;
    }
    my @Return;

    $ConfigObject->Set(
        Key   => 'PostmasterDefaultState',
        Value => 'new'
    );
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \@Content,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        1,
        ' Run() - NewTicket',
    );
    my $TicketID = $TicketObject->ArticleGetTicketIDOfMessageID(
        MessageID => $MessageID,
    );

    $Self->Is(
        $TicketID,
        $Return[1],
        "ArticleGetTicketIDOfMessageID - TicketID for message ID $MessageID"
    );
    push @Tickets, $Return[1];
}

for my $TicketID (@Tickets) {

    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "TicketDelete - removed ticket $TicketID",
    );

}

1;
