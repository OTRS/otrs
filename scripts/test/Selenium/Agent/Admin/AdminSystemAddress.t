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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSystemAddress");

        # check overview AdminSystemAddress screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add system address'
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Add')]")->click();

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

        $Selenium->find_element( "#Name",                             'css' )->send_keys($SysAddRandom);
        $Selenium->find_element( "#Realname",                         'css' )->send_keys($SysAddRandom);
        $Selenium->find_element( "#QueueID option[value='$QueueID']", 'css' )->click();
        $Selenium->find_element( "#Comment",                          'css' )->send_keys($SysAddComment);
        $Selenium->find_element( "#Name",                             'css' )->submit();

        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Selenium->execute_script("return \$('.MasterAction').length") ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

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
        $Selenium->find_element( "#Realname",                  'css' )->send_keys(" Edited");
        $Selenium->find_element( "#ValidID option[value='2']", 'css' )->click();
        $Selenium->find_element( "#Comment",                   'css' )->clear();
        $Selenium->find_element( "#Name",                      'css' )->submit();

        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Selenium->execute_script("return \$('.MasterAction').length") ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

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
