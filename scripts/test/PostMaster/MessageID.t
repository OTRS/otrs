# --
# MessageID.t - PostMaster tests for Message ID
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my @Tickets;
for my $File (qw(1 2 3 5 6 11 21)) {

    # create random message ID
    my $MessageID = '<message' . time() . ( int rand 1000000 ) . '@example.com>';

    # new ticket check
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";

    my $ContentRef = $MainObject->FileRead(
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
            Email => \@Content,
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
