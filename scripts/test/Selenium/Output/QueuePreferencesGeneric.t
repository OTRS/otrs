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

        my %QueuePreferences = (
            Module  => "Kernel::Output::HTML::QueuePreferences::Generic",
            Label   => "Comment2",
            Desc    => "Define the queue comment 2.",
            Block   => "TextArea",
            Cols    => 50,
            Rows    => 5,
            PrefKey => "Comment2",
        );

        # enable QueuePreferences
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'QueuePreferences###Comment2',
            Value => \%QueuePreferences,
        );

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'QueuePreferences###Comment2',
            Value => \%QueuePreferences,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to queue admin
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminQueue");

        # add new queue
        $Selenium->find_element( "a.Create", 'css' )->click();

        # check add page, and especially included queue attribute Comment2
        for my $ID (
            qw(Name GroupID FollowUpID FollowUpLock SalutationID SystemAddressID SignatureID ValidID Comment2)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # create a real test queue
        my $RandomQueueName = "Queue" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name",                              'css' )->send_keys($RandomQueueName);
        $Selenium->execute_script("\$('#GroupID').val('1').trigger('redraw.InputField');");
        $Selenium->execute_script("\$('#FollowUpID').val('1').trigger('redraw.InputField');");
        $Selenium->execute_script("\$('#SalutationID').val('1').trigger('redraw.InputField');");
        $Selenium->execute_script("\$('#SystemAddressID').val('1').trigger('redraw.InputField');");
        $Selenium->execute_script("\$('#SignatureID').val('1').trigger('redraw.InputField');");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField');");

        # set included queue attribute Comment2
        $Selenium->find_element( "#Comment2", 'css' )->send_keys('QueuePreferences Comment2');
        $Selenium->find_element( "#Name",     'css' )->submit();

        # check if test queue is created
        $Self->True(
            index( $Selenium->get_page_source(), $RandomQueueName ) > -1,
            'New queue found on table'
        );

        # go to new queue again
        $Selenium->find_element( $RandomQueueName, 'link_text' )->click();

        # check queue value for Comment2
        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            'QueuePreferences Comment2',
            "#Comment2 stored value",
        );

        # update queue
        my $UpdatedComment = "Updated comment for QueuePreferences Comment2";
        my $UpdatedName    = $RandomQueueName . "-updated";
        $Selenium->find_element( "#Name",     'css' )->clear();
        $Selenium->find_element( "#Name",     'css' )->send_keys($UpdatedName);
        $Selenium->find_element( "#Comment2", 'css' )->clear();
        $Selenium->find_element( "#Comment2", 'css' )->send_keys($UpdatedComment);
        $Selenium->find_element( "#Comment2", 'css' )->submit();

        # check updated values
        $Selenium->find_element( $UpdatedName, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $UpdatedName,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment2', 'css' )->get_value(),
            $UpdatedComment,
            "#Comment2 updated value",
        );

        # delete test queue
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
            Queue => $UpdatedName,
        );
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue_preferences WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueuePreferences are deleted - $UpdatedName",
        );
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - $UpdatedName",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (Queue SysConfig)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
