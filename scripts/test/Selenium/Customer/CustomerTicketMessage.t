# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check Service
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # do not check Type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to CustomerTicketMessage screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # check CustomerTicketMessage overview screen
        for my $ID (
            qw(Dest Subject RichText PriorityID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # check client side validation
        $Selenium->find_element( "#Subject", 'css' )->clear();
        $Selenium->find_element( "#Subject", 'css' )->VerifiedSubmit();
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
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",        'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",       'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get test created ticket ID and number
        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomerUserLogin,
        );
        my $TicketID     = (%TicketIDs)[0];
        my $TicketNumber = (%TicketIDs)[1];

        $Self->True(
            $TicketID,
            "Ticket was created and found",
        ) || die;

        # search for new created ticket on CustomerTicketOverview screen
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket with ticket ID $TicketID - found on CustomerTicketOverview screen"
        ) || die;

        # Check URL preselection of queue
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage;Dest=3||Junk");

        $Self->Is(
            $Selenium->execute_script("return \$('#Dest').val();"),
            '3||Junk',
            "Queue preselected in URL"
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerPanelOwnSelection',
            Value => {
                Junk => 'First Queue',
            },
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage;Dest=3||Junk");

        $Self->Is(
            $Selenium->execute_script("return \$('#Dest').val();"),
            '3||First Queue',
            "Queue preselected in URL"
        );

        # test prefilling of some parameters with StoreNew
        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerTicketMessage;Subject=TestSubject;Body=TestBody;Subaction=StoreNew;Expand=1"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('#Subject').val();"),
            'TestSubject',
            "Subject preselected in URL"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('#RichText').val();"),
            'TestBody',
            "Subject preselected in URL"
        );

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
