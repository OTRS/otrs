# --
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check Type
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # do not check Service
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # create test customer user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # click on 'Create your first ticket'
        $Selenium->find_element( ".Button", 'css' )->click();

        # input fields and create ticket
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",  'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#Subject",  'css' )->submit();

        # Wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => "return \$('table.Overview').length" );

        # get needed data
        my @User = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestUserLogin,
        );
        my $UserID    = $User[0];
        my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $UserID,
        );
        my $TicketNumber = (%TicketIDs)[1];

        # search for new created ticket on CustomerTicketOverview screen (default filter is Open)
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen with Open filter"
        );

        # check All filter on CustomerTicketOverview screen
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=All' )]"
        )->click();

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen with All filter"
        );

        # check Close filter on CustomerTicketOverview screen
        # there is only one created ticket, and it should not be on screen with Close filter
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=Close' )]"
        )->click();

        my $Success;
        eval {
            $Success = $Selenium->find_element(
                "//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"
                )
        };
        $Self->False(
            $Success,
            "Ticket with ticket number $TicketNumber is not found on screen with Close filter"
        );

        # clean up test data from the DB
        my $TicketID = (%TicketIDs)[0];
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID,
        );
        $Self->True(
            $Success,
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
