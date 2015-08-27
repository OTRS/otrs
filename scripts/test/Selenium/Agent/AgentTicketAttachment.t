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

# get selenium objects
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

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # set download type to inline
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test customer for testing
        my $TestCustomer = 'Customer' . $Helper->GetRandomID();
        my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        # create test phone ticket with attachment
        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        my $TicketSubject      = "Selenium Ticket";
        my $TicketBody         = "Selenium body test";
        my $AttachmentName     = "StdAttachment-Test1.txt";
        my $Location           = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        $Selenium->WaitFor( JavaScript => 'return $("p.Value").length' );

        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",    'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText",   'css' )->send_keys($TicketBody);
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return $("#AttachmentDeleteButton1").length' );
        $Selenium->find_element( "#Subject", 'css' )->submit();

        # wait until ticket is created
        $Selenium->WaitFor( JavaScript => "return \$('form').length" );

        # search for new created ticket on AgentTicketZoom screen
        my ( $TicketID, $TicketNumber ) = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomer,
            UserID         => $TestUserID,
        );

        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket with ticket id $TicketID is created"
        );

        # go to ticket zoom page of created test ticket
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom' )]")->click();

        # check if attachment exists
        $Self->True(
            $Selenium->find_element("//*[text()=\"$AttachmentName\"]"),
            "$AttachmentName is found on page",
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get article id
        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $TicketID,
        );

        # check ticket attachment
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketAttachment;ArticleID=$ArticleIDs[0];FileID=1");

        # check if attachment is genuine
        my $ExpectedAttachmentContent = "Some German Text with Umlaut: ÄÖÜß";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedAttachmentContent ) > -1,
            "$AttachmentName opened successfully",
        );

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # delete created test customer user
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # make sure the cache is correct.
        for my $Cache (qw( Ticket CustomerUser )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
