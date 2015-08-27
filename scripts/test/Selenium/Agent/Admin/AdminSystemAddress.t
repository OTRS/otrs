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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test Queue
        my $QueueRandomID = "queue" . $Helper->GetRandomID();
        my $QueueID       = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueRandomID,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            UserID          => $UserID,
            Comment         => 'Selenium Test Queue',
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # navigate to AdminSystemAddress screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSystemAddress");

        # check overview AdminSystemAddress screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add system address'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminSystemAddress;Subaction=Add')]")->click();

        # check add new SystemAddress screen
        for my $ID (
            qw(Name Realname QueueID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create real test SystemAddress
        my $SysAddRandom  = 'sysadd' . $Helper->GetRandomID() . '@localhost.com';
        my $SysAddComment = "Selenium test SystemAddress";

        $Selenium->find_element( "#Name",     'css' )->send_keys($SysAddRandom);
        $Selenium->find_element( "#Realname", 'css' )->send_keys($SysAddRandom);
        $Selenium->execute_script("\$('#QueueID').val('$QueueID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys($SysAddComment);
        $Selenium->find_element( "#Name",    'css' )->submit();

        # wait for SystemAddress create
        $Selenium->WaitFor( JavaScript => "return \$('.MasterAction').length" );

        # check for created test SystemAddress
        $Self->True(
            index( $Selenium->get_page_source(), $SysAddRandom ) > -1,
            "$SysAddRandom found on page",
        );

        # go to the new test SystemAddress and check values
        $Selenium->find_element( $SysAddRandom, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $SysAddRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Realname', 'css' )->get_value(),
            $SysAddRandom,
            "#Realname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#QueueID', 'css' )->get_value(),
            $QueueID,
            "#QueueID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SysAddComment,
            "#Comment stored value",
        );

        # edit test SystemAddress and set it to invalid
        $Selenium->find_element( "#Realname", 'css' )->send_keys(" Edited");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Name",    'css' )->submit();

        # wait for SystemAddress create
        $Selenium->WaitFor( JavaScript => "return \$('.MasterAction').length" );

        # check class of invalid SystemAddress in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($SysAddRandom)').length"
            ),
            "There is a class 'Invalid' for test SystemAddress",
        );

        # check edited test SystemAddress values
        $Selenium->find_element( $SysAddRandom, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#Realname', 'css' )->get_value(),
            $SysAddRandom . " Edited",
            "#Realname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # since we no longer need them, delete test Queue and SystemAddress from the DB
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM system_address WHERE value0 = \'$SysAddRandom\'",
        );
        $Self->True(
            $Success,
            "Deleted - $SysAddRandom",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = \'$QueueID\'",
        );
        $Self->True(
            $Success,
            "Deleted - $QueueRandomID",
        );

        # make sure cache is correct
        for my $Cache (qw (Queue SystemAddress))
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }

);

1;
