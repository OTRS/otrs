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

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# define needed variable
my $RandomID = $Helper->GetRandomID();

for my $File (qw(1 2 3 5 6 11 21)) {

    # create random message ID
    my $MessageID = '<message' . $RandomID . $File . '@example.com>';

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

        @Return = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }

    $Self->Is(
        $Return[0] || 0,
        1,
        ' Run() - NewTicket',
    );

    my %Article = $ArticleBackendObject->ArticleGetByMessageID(
        MessageID => $MessageID,
    );

    $Self->Is(
        $Article{TicketID},
        $Return[1],
        "ArticleGetByMessageID - TicketID for message ID $MessageID"
    );
}

# cleanup is done by RestoreDatabase.

1;
