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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $SystemAddressObject  = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        my $RandomID = $Helper->GetRandomID();

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => '0',
        );

        my %AgentTicketEmailConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'Frontend::Module###AgentTicketEmail',
        );

        # Create test system address.
        my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
            Name     => "sys$RandomID\@localhost.com",
            Realname => 'SeleniumSystemAddress',
            ValidID  => 1,
            QueueID  => 1,
            Comment  => 'Selenium test address',
            UserID   => 1,
        );
        $Self->True(
            $SystemAddressID,
            'System address added.'
        );

        my $CustomerID   = 'customer' . $RandomID;
        my $CustomerUser = "$CustomerID\@localhost.com";
        my $Queue        = 'Raw';
        my $Priority     = '3 normal';
        my $Subject      = 'Selenium test';
        my $Body         = 'Just a test body for selenium testing';

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'First test ticket',
            Queue        => $Queue,
            Lock         => 'unlock',
            Priority     => $Priority,
            State        => 'new',
            CustomerID   => $CustomerID,
            CustomerUser => $CustomerUser,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID - created",
        );

        # Get create article data.
        my $ToCustomer   = "to$CustomerID\@localhost.com";
        my $FromCustomer = "from$CustomerID\@localhost.com";
        my @TestArticles = (
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => 'Raw',
            },
            {
                SenderType => 'system',
                From       => "SeleniumSystemAddress <sys$RandomID\@localhost.com>",
                To         => "To Customer <$ToCustomer>",
            },
            {
                SenderType => 'customer',
                From       => "From Customer <$FromCustomer>",
                To         => "To Customer <$ToCustomer>",
            },
        );

        # Create test articles for test ticket.
        my $AccountedTime = 123;
        my @ArticleIDs;
        for my $TestArticle (@TestArticles) {
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => $TestArticle->{SenderType},
                From                 => $TestArticle->{From},
                To                   => $TestArticle->{To},
                Subject              => $Subject,
                Body                 => $Body,
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'PhoneCallCustomer',
                HistoryComment       => 'Selenium testing',
                UserID               => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID - created",
            );
            push @ArticleIDs, $ArticleID;

            # Add accounted time to the ticket.
            my $Success = $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $AccountedTime,
                UserID    => 1,
            );
            $Self->True(
                $Success,
                "Accounted Time $AccountedTime added to ticket"
            );
        }

        # Create and login test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @Tests = (
            {
                ArticleID      => $ArticleIDs[0],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Queue',
            },
            {
                ArticleID      => $ArticleIDs[1],
                ToValueOnSplit => "To Customer <$ToCustomer>",
                ResultMessage  => 'From is SystemAddress, To is Customer',
            },
            {
                ArticleID      => $ArticleIDs[2],
                ToValueOnSplit => "From Customer <$FromCustomer>",
                ResultMessage  => 'From is Customer, To is Customer',
            },
        );

        my @AllTicketIDs = ($TicketID);

        for my $Test (@Tests) {
            for my $Screen (qw(Phone Email)) {

                # Navigate to the ticket zoom screen.
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$Test->{ArticleID}",
                );

                # Wait until screen is loaded completely.
                $Selenium->WaitFor(
                    ElementMissing => [ '.WidgetIsLoading', 'css' ],
                );

                $Selenium->WaitForjQueryEventBound(
                    CSSSelector => ".SplitSelection",
                );

                # Click on the split action.
                $Selenium->find_element( '.SplitSelection', 'css' )->click();

                $Selenium->WaitFor(
                    JavaScript => 'return $("#SplitSubmit").length;'
                );

                if ( $Screen eq 'Email' ) {

                    # Change it to Email.
                    $Selenium->InputFieldValueSet(
                        Element => '#SplitSelection',
                        Value   => 'EmailTicket',
                    );
                }

                $Selenium->WaitForjQueryEventBound(
                    CSSSelector => "#SplitSubmit",
                );

                $Selenium->find_element( '#SplitSubmit', 'css' )->VerifiedClick();

                my @PageFields = (
                    {
                        Name  => 'From',
                        ID    => 'CustomerTicketText_1',
                        Value => $Test->{ToValueOnSplit},
                    },
                    {
                        Name  => 'CustomerID',
                        ID    => 'CustomerID',
                        Value => $CustomerID,
                    },
                    {
                        Name     => 'Queue',
                        ID       => 'Dest',
                        Value    => $Queue,
                        Dropdown => 1,
                    },
                    {
                        Name     => 'Priority',
                        ID       => 'PriorityID',
                        Value    => $Priority,
                        Dropdown => 1,
                    },
                    {
                        Name  => 'Subject',
                        ID    => 'Subject',
                        Value => $Subject,
                    },
                    {
                        Name  => 'Body',
                        ID    => 'RichText',
                        Value => $Body,
                    },
                    {
                        Name  => 'AccountedTime',
                        ID    => 'TimeUnits',
                        Value => $AccountedTime,
                    },
                );

                for my $PageField (@PageFields) {
                    my $ID    = $PageField->{ID};
                    my $Value = $PageField->{Value};

                    if ( $PageField->{Dropdown} ) {
                        $Selenium->WaitFor(
                            JavaScript =>
                                "return typeof(\$) === 'function' && \$('#$ID option:selected').text() == '$Value';"
                        );
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('#$ID option:selected').text();"
                            ),
                            $Value,
                            "Check '$PageField->{Name}' field for ArticleID = $ArticleIDs[0] in '$Screen' split screen",
                        );
                    }
                    else {
                        $Selenium->WaitFor(
                            JavaScript => "return typeof(\$) === 'function' && \$('#$ID').val() == '$Value';"
                        );
                        $Self->Is(
                            $Selenium->execute_script("return \$('#$ID').val();"),
                            $Value,
                            "Check '$PageField->{Name}' field for ArticleID = $ArticleIDs[0] in '$Screen' split screen",
                        );
                    }
                }

                $Selenium->execute_script(
                    "\$('#submitRichText')[0].scrollIntoView(true);",
                );

                $Selenium->WaitForjQueryEventBound(
                    CSSSelector => "#submitRichText",
                );

                $Self->True(
                    $Selenium->execute_script(
                        "return \$('#submitRichText').length;"
                    ),
                    "Element '#submitRichText' is found in screen"
                );

                # Submit form.
                $Selenium->find_element( '#submitRichText', 'css' )->VerifiedClick();

                # Get all tickets that we created.
                my @TicketIDs = $TicketObject->TicketSearch(
                    Result            => 'ARRAY',
                    CustomerUserLogin => $CustomerUser,
                    Limit             => 1,
                    OrderBy           => 'Down',
                    SortBy            => 'Age',
                    UserID            => 1,
                );

                my $CurrentTicketID = $TicketIDs[0];

                my $OldTicket = grep { $_ == $CurrentTicketID } @AllTicketIDs;
                $Self->False(
                    $OldTicket,
                    'Make sure that ticket is really created.',
                ) || die;

                push @AllTicketIDs, $CurrentTicketID;

                # Get ticket data.
                my %SplitTicketData = $TicketObject->TicketGet(
                    TicketID => $CurrentTicketID,
                    UserID   => 1,
                );

                # Check if customer is present.
                $Self->Is(
                    $SplitTicketData{CustomerID},
                    $CustomerID,
                    'Check if CustomerID is present.'
                );

                # Check if customer user is present.
                $Self->Is(
                    $SplitTicketData{CustomerUserID},
                    $CustomerUser,
                    'Check if CustomerUserID is present.'
                );

                $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;' )]")->VerifiedClick();
                $Selenium->WaitFor(
                    JavaScript => "return \$('.TableLike label:contains(\"Accounted time:\")').next().length;"
                );

                # Check accounted time on zoom screen.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('.TableLike label:contains(\"Accounted time:\")').next().text().trim();"
                    ),
                    $AccountedTime,
                    "Check AccountedTime field for ArticleID = $ArticleIDs[0] in $Screen split screen",
                );
            }
        }

        # Disable 'Frontend::Module###AgentTicketEmail' does not remove split target 'Email ticket'.
        # See bug#13690 (https://bugs.otrs.org/show_bug.cgi?id=13690) for more information.
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => "Frontend::Module###AgentTicketEmail",
        );

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => ".SplitSelection",
        );

        # Click on the split action.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length;'
        );

        # Verify there is no 'Email ticket' split option.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"#SplitSelection option[value='EmailTicket']\").length === 0;"
            ),
            "Split option for 'Email Ticket' is disabled.",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => ".Dialog.Modal a.Close",
        );

        $Selenium->find_element( '.Dialog.Modal a.Close', 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => 'return !$(".Dialog.Modal").length;'
        );

        # Check customer information widget (https://bugs.otrs.org/show_bug.cgi?id=14414).
        # Enable AgentTicketEmail frontend module.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Frontend::Module###AgentTicketEmail",
            Value => $AgentTicketEmailConfig{EffectiveValue},
        );

        # Create test customer users.
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my @TestCustomerUsers;
        for ( 1 .. 3 ) {
            my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
                Groups => ['admin'],
            ) || die 'Did not get test customer user';

            my %TestCustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                User => $TestCustomerUserLogin,
            );

            push @TestCustomerUsers, \%TestCustomerUserData;
        }

        my $TestRandomID = $Helper->GetRandomID();

        # Create test ticket with second customer user.
        my $TestTicketID = $TicketObject->TicketCreate(
            Title        => 'Title' . $TestRandomID,
            Queue        => $Queue,
            Lock         => 'unlock',
            Priority     => $Priority,
            State        => 'new',
            CustomerID   => $TestCustomerUsers[1]->{CustomerID},
            CustomerUser => $TestCustomerUsers[1]->{UserLogin},
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );
        push @AllTicketIDs, $TestTicketID;

        my @TestArticleIDs;

        my $From = $TestCustomerUsers[0]->{UserMailString} . ', ' .
            $TestCustomerUsers[1]->{UserMailString} . ', ' .
            $TestCustomerUsers[2]->{UserMailString};

        # Create test articles.
        for my $Count ( 1 .. 2 ) {
            my $TestArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TestTicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                From                 => $Count == 1 ? $From : $TestCustomerUsers[2]->{UserMailString},
                To                   => $Queue,
                Subject              => 'Subject' . $TestRandomID,
                Body                 => 'Body' . $TestRandomID,
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'PhoneCallCustomer',
                HistoryComment       => 'Selenium testing',
                UserID               => 1,
            );
            $Self->True(
                $TestArticleID,
                "TestArticleID $TestArticleID is created",
            );
            push @TestArticleIDs, $TestArticleID;
        }

        @Tests = (
            {
                TestArticleID      => $TestArticleIDs[0],
                CustomerUserOnLoad => $TestCustomerUsers[0],
                ClickRadioButtons  => 1,
            },
            {
                TestArticleID      => $TestArticleIDs[1],
                CustomerUserOnLoad => $TestCustomerUsers[2],
                ClickRadioButtons  => 0,
            },
        );

        for my $Test (@Tests) {

            my $TestArticleID      = $Test->{TestArticleID};
            my $CustomerUserOnLoad = $Test->{CustomerUserOnLoad};

            for my $Target (qw(Phone Email)) {

                # Go to an appropriate split screen.
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicket$Target;ArticleID=$TestArticleID;LinkTicketID=$TestTicketID;TicketID=$TestTicketID",
                );

                # Check if the first radio button is selected.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.CustomerKey[value=$CustomerUserOnLoad->{UserLogin}]').siblings('.CustomerTicketRadio').prop('checked') == true;"
                    ),
                    "On page load - Customer user '$CustomerUserOnLoad->{UserLogin}' is checked correctly",
                );

                # Check appropriate customer user data in widget.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('label:contains(Firstname)').next().attr('title');"
                    ),
                    $CustomerUserOnLoad->{UserFirstname},
                    "On page load - Firstname '$CustomerUserOnLoad->{UserFirstname}' is found",
                );
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('label:contains(Lastname)').next().attr('title');"
                    ),
                    $CustomerUserOnLoad->{UserLastname},
                    "On page load - Lastname '$CustomerUserOnLoad->{UserLastname}' is found",
                );
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('label:contains(Username)').next().attr('title');"
                    ),
                    $CustomerUserOnLoad->{UserLogin},
                    "On page load - Username '$CustomerUserOnLoad->{UserLogin}' is found",
                );
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('label:contains(Email)').next().attr('title');"
                    ),
                    $CustomerUserOnLoad->{UserEmail},
                    "On page load - Email '$CustomerUserOnLoad->{UserEmail}' is found",
                );

                # Click on radio buttons and check customer info widget data.
                if ( $Test->{ClickRadioButtons} ) {
                    for my $Number ( 0 .. $#TestCustomerUsers ) {
                        $Selenium->execute_script(
                            "\$('.CustomerKey[value=$TestCustomerUsers[$Number]->{UserLogin}]').siblings('.CustomerTicketRadio').trigger('click');"
                        );
                        $Selenium->WaitFor(
                            JavaScript =>
                                "return \$('label:contains(Email)').next().attr('title') === '$TestCustomerUsers[$Number]->{UserEmail}';"
                        );
                        $Selenium->WaitFor(
                            JavaScript => 'return !$(".AJAXLoader:visible").length;'
                        );
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('label:contains(Firstname)').next().attr('title');"
                            ),
                            $TestCustomerUsers[$Number]->{UserFirstname},
                            "After radio button click - Firstname '$TestCustomerUsers[$Number]->{UserFirstname}' is found",
                        );
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('label:contains(Lastname)').next().attr('title');"
                            ),
                            $TestCustomerUsers[$Number]->{UserLastname},
                            "After radio button click - Lastname '$TestCustomerUsers[$Number]->{UserLastname}' is found",
                        );
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('label:contains(Username)').next().attr('title');"
                            ),
                            $TestCustomerUsers[$Number]->{UserLogin},
                            "After radio button click - Username '$TestCustomerUsers[$Number]->{UserLogin}' is found",
                        );
                        $Self->Is(
                            $Selenium->execute_script(
                                "return \$('label:contains(Email)').next().attr('title');"
                            ),
                            $TestCustomerUsers[$Number]->{UserEmail},
                            "After radio button click - Email '$TestCustomerUsers[$Number]->{UserEmail}' is found",
                        );
                    }
                }
            }
        }

        # Delete test system address.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL  => "DELETE FROM system_address WHERE id = ?",
            Bind => [ \$SystemAddressID ],
        );
        $Self->True(
            $Success,
            "SystemAddressID $SystemAddressID - deleted",
        );

        for my $DeleteTicketID (@AllTicketIDs) {

            # delete test created ticket
            $Success = $TicketObject->TicketDelete(
                TicketID => $DeleteTicketID,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $DeleteTicketID,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "TicketID $DeleteTicketID - deleted",
            );
        }
    }
);

1;
