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

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # enable change owner to everyone feature
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::ChangeOwnerToEveryone',
            Value => 1
        );

        # enable ticket responsible feature
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1
        );

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AgentTicketResponsible');
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketResponsible',
            Value => {
                %$Config,
                Note          => 1,
                NoteMandatory => 1,
            },
        );

        # create test users and login first
        my @TestUser;
        for my $User ( 1 .. 2 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUser, $TestUserLogin;
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[0],
            Password => $TestUser[0],
        );

        # get test users ID
        my @UserID;
        for my $UserID (@TestUser) {
            my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $UserID,
            );

            push @UserID, $TestUserID;
        }

        # get needed objects
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticcket
        my $TicketID = $TicketObject->TicketCreate(
            TN            => $TicketObject->TicketCreateNumber(),
            Title         => "Selenium Test Ticket",
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'new',
            CustomerID    => 'SeleniumCustomer',
            CustomerUser  => "SeleniumCustomer\@localhost.com",
            ResponsibleID => $UserID[0],
            OwnerID       => $UserID[0],
            UserID        => $UserID[0],
        );

        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # naviage to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor( JavaScript => 'return $("#nav-People ul").css({ "height": "auto", "opacity": "100" });' );

        # click on 'Responsible' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketResponsible;TicketID=$TicketID' )]")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check page
        for my $ID (
            qw(Title NewResponsibleID Subject RichText FileUpload ArticleTypeID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#RichText", 'css' );
        $Element->send_keys("");
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#RichText').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # change ticket user responsible
        $Selenium->execute_script("\$('#NewResponsibleID').val('$UserID[1]').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",                      'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",                                    'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText",                              'css' )->click();

        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # confirm responsible action
        my $ResponsibleMsg = "New responsible is \"$TestUser[1]\" (ID=$UserID[1]).";
        $Self->True(
            index( $Selenium->get_page_source(), $ResponsibleMsg ) > -1,
            "Ticket responsible action completed",
        );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );
        $Self->True(
            $Success,
            "Delete ticket - $TicketID"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

    }
);

1;
