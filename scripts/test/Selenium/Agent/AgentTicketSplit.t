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

        # get needed objects
        my $Helper              = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject        = $Kernel::OM->Get('Kernel::System::Ticket');
        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

        my @TicketIDs;

        # create test system address
        my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
            Name     => 'systemaddress@localhost.com',
            Realname => 'SeleniumSystemAddress',
            ValidID  => 1,
            QueueID  => 1,
            Comment  => 'Selenium test address',
            UserID   => 1,
        );

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'First test ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@localhost.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID - created",
        );

        # get create article data
        my $Customer     = 'customer' . $Helper->GetRandomID();
        my $ToCustomer   = "to$Customer\@localhost.com";
        my $FromCustomer = "from$Customer\@localhost.com";
        my @TestArticles = (
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => 'Raw',
            },
            {
                SenderType => 'system',
                From       => 'SeleniumSystemAddress <systemaddress@localhost.com>',
                To         => "To Customer <$ToCustomer>",
            },
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => "To Customer <$ToCustomer>",
            },
        );

        # create test articles for test ticket
        my @ArticleIDs;
        for my $TestArticle (@TestArticles) {
            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'email-external',
                SenderType     => $TestArticle->{SenderType},
                From           => $TestArticle->{From},
                To             => $TestArticle->{To},
                Subject        => 'Selenium test',
                Body           => 'Just a test body for selenium testing',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'PhoneCallCustomer',
                HistoryComment => 'Selenium testing',
                UserID         => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID - created",
            );
            push @ArticleIDs, $ArticleID;
        }

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # get test data
        my @Tests = (
            {
                ArticleID      => $ArticleIDs[0],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Queue',
            },
            {
                ArticleID      => $ArticleIDs[1],
                ToValueOnSplit => "To Customer <$ToCustomer>",
                ResultMessage  => 'From is SystemAddress, To is Customer'
            },
            {
                ArticleID      => $ArticleIDs[2],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Customer'
            },
        );

        # run test scenarios
        for my $Test (@Tests) {

            # navigate to split ticket of test ticket first article
            $Selenium->get(
                "${ScriptAlias}index.pl?Action=AgentTicketPhone;TicketID=$TicketID;ArticleID=$Test->{ArticleID};LinkTicketID=$TicketID"
            );

            $Self->Is(
                $Selenium->find_element("//input[\@type='text'][\@name='CustomerTicketText_1']")->get_value(),
                "$Test->{ToValueOnSplit}",
                "$Test->{ResultMessage} - on article split value From",
            );
        }

        # delete test system address
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL => "DELETE FROM system_address WHERE id= $SystemAddressID",
        );
        $Self->True(
            $Success,
            "SystemAddressID $SystemAddressID - deleted",
        );

        # delete test created ticket
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID - deleted",
        );
    }
);

1;
