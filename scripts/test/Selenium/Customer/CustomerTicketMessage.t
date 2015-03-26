# --
# CustomerTicketMessage.t - frontend tests for CustomerTicketMessage
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 1,
        );

        # do not check RichText
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check Service
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # do not check Type
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

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

        # check CustomerTicketMessage overview screen
        for my $ID (
            qw(Dest Subject RichText Attachment PriorityID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#Subject", 'css' )->clear();
        $Selenium->find_element( "#Subject", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # input fields and create ticket
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();
        $Selenium->find_element( "#Dest option[value='2||Raw']", 'css' )->click();
        $Selenium->find_element( "#Subject",                     'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",                    'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#submitRichText",              'css' )->click();

        # search for new created ticket on CustomerTicketOverview screen
        my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestUserLogin,
        );
        my $TicketNumber = (%TicketIDs)[1];
        my $TicketID = (%TicketIDs)[0];

        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket with ticket id $TicketID is created"
        );

        # clean up test data from the DB
        my $Success  = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
        }
);

1;
