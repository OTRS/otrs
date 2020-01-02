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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my $CheckBredcrumb = sub {

    my %Param = @_;

    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( 'System Maintenance Management', $BreadcrumbText ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }
};

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Make sure system is based on UTC.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'OTRSTimeZone',
            Value => 'UTC',
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # get SystemMaintenance object
        my $SystemMaintenanceObject = $Kernel::OM->Get('Kernel::System::SystemMaintenance');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Get UserID for later manipulation of preferences.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $UserID     = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Set user's time zone.
        my $UserTimeZone = 'UTC';
        $UserObject->SetPreferences(
            Key    => 'UserTimeZone',
            Value  => $UserTimeZone,
            UserID => $UserID,
        );

        # Login test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSystemMaintenance screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemMaintenance");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click "Schedule New System Maintenance"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=SystemMaintenanceNew' )]")->VerifiedClick();

        # check Schedule New System Maintenance screen
        for my $ID (
            qw(StartDateDay StartDateMonth StartDateYear StartDateDayDatepickerIcon StartDateHour StartDateMinute
            StopDateDay StopDateMonth StopDateYear StopDateDayDatepickerIcon StopDateHour StopDateMinute
            Comment LoginMessage ShowLoginMessage NotifyMessage ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Add screen
        $CheckBredcrumb->( BreadcrumbText => 'Schedule New System Maintenance' );

        # check client side validation
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->execute_script("\$('#Submit').trigger('click')");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Comment.Error').length"
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Comment').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        my $DTObj = $Kernel::OM->Create('Kernel::System::DateTime');

        # create error test SystemMaintenance scenario
        # get test end time - 1 hour of current time
        my $DTWrongObj = $DTObj->Clone();
        $DTWrongObj->Subtract( Hours => 1 );
        my $DTWrong = $DTWrongObj->Get();

        my $SysMainComment = "sysmaintenance" . $Helper->GetRandomID();
        my $SysMainLogin   = "Selenium test SystemMaintance is progress, please log in later on";
        my $SysMainNotify  = "Currently Selenium SystemMaintenance test is active";

        $Selenium->find_element( "#Comment", 'css' )->send_keys($SysMainComment);

        $Selenium->execute_script("\$('#StopDateDay').val('$DTWrong->{Day}')");
        $Selenium->execute_script("\$('#StopDateMonth').val('$DTWrong->{Month}')");
        $Selenium->execute_script("\$('#StopDateYear').val('$DTWrong->{Year}')");
        $Selenium->execute_script("\$('#StopDateHour').val('$DTWrong->{Hour}')");
        $Selenium->execute_script("\$('#StopDateMinute').val('$DTWrong->{Minute}')");

        $Selenium->execute_script("\$('#Submit').trigger('click')");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.MessageBox > p:contains(\"Start date shouldn\\'t be defined after Stop date!\")').length"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('.MessageBox > p:contains(\"Start date shouldn\\'t be defined after Stop date!\")').length"
            ),
            "Error message correctly displayed"
        ) || die "Did not get notification message";

        # get test start time + 1 hour of system time
        my $DTStartObj = $DTObj->Clone();
        $DTStartObj->Add( Hours => 1 );
        my $DTStart = $DTStartObj->Get();

        # get test end time + 2 hour of system time
        my $DTEndObj = $DTObj->Clone();
        $DTEndObj->Add( Hours => 2 );
        my $DTEnd = $DTEndObj->Get();

        # create real test SystemMaintenance
        $Selenium->execute_script("\$('#StartDateDay').val('$DTStart->{Day}')");
        $Selenium->execute_script("\$('#StartDateMonth').val('$DTStart->{Month}')");
        $Selenium->execute_script("\$('#StartDateYear').val('$DTStart->{Year}')");
        $Selenium->execute_script("\$('#StartDateHour').val('$DTStart->{Hour}')");
        $Selenium->execute_script("\$('#StartDateMinute').val('$DTStart->{Minute}')");
        $Selenium->execute_script("\$('#StopDateDay').val('$DTEnd->{Day}')");
        $Selenium->execute_script("\$('#StopDateMonth').val('$DTEnd->{Month}')");
        $Selenium->execute_script("\$('#StopDateYear').val('$DTEnd->{Year}')");
        $Selenium->execute_script("\$('#StopDateHour').val('$DTEnd->{Hour}')");
        $Selenium->execute_script("\$('#StopDateMinute').val('$DTEnd->{Minute}')");

        # Try to create System Maintenance with Login and Notify message longer then 250 characters.
        #   See bug#13366 (https://bugs.otrs.org/show_bug.cgi?id=13366).
        #   Verify there is no Error class initially.
        $Self->False(
            $Selenium->execute_script("return \$('#LoginMessage').hasClass('Error')"),
            "There is no error class in Login Message text area"
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NotifyMessage').hasClass('Error')"),
            "There is no error class in Notify Message text area"
        );

        # Add 251 characters in the fields and verify Error class.
        my $LongLoginMessage  = "a" x 251;
        my $LongNotifyMessage = "b" x 251;

        $Selenium->find_element( "#LoginMessage",  'css' )->send_keys($LongLoginMessage);
        $Selenium->find_element( "#NotifyMessage", 'css' )->send_keys($LongNotifyMessage);

        $Selenium->execute_script("\$('#Submit').trigger('click')");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#LoginMessage.Error').length && \$('#NotifyMessage.Error').length"
        );

        $Self->True(
            $Selenium->execute_script("return \$('#LoginMessage').hasClass('Error')"),
            "There is error class in Login Message text area"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NotifyMessage').hasClass('Error')"),
            "There is error class in Notify Message text area"
        );

        # Create SystemMaintenance.
        $Selenium->find_element( "#LoginMessage",  'css' )->clear();
        $Selenium->find_element( "#NotifyMessage", 'css' )->clear();
        $Selenium->find_element( "#LoginMessage",  'css' )->send_keys($SysMainLogin);
        $Selenium->find_element( "#NotifyMessage", 'css' )->send_keys($SysMainNotify);
        $Selenium->find_element( "#Submit",        'css' )->VerifiedClick();

        # check if notification exists after adding
        my $Notification = 'System Maintenance was added successfully!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Get test system maintenance start and end time as formated string.
        my $LayoutObject    = Kernel::Output::HTML::Layout->new( UserTimeZone => $UserTimeZone );
        my $StartTimeString = $LayoutObject->{LanguageObject}->FormatTimeString(
            $DTStartObj->ToString(),
            'DateFormat',
            1,
        );

        my $EndTimeString = $LayoutObject->{LanguageObject}->FormatTimeString(
            $DTEndObj->ToString(),
            'DateFormat',
            1,
        );

        # Check for upcoming System Maintenance notification.
        my $UpcomingSysMaintenanceNotif
            = "A system maintenance period will start at: $StartTimeString and is expected to stop at: $EndTimeString";
        $Self->False(
            $Selenium->execute_script(
                "return \$('.MessageBox.Notice p:contains(\"$UpcomingSysMaintenanceNotif\")').length"
            ),
            "$UpcomingSysMaintenanceNotif - notification is not found."
        );

        # Update TimeNotifyUpcomingMaintenance config.
        $Helper->ConfigSettingChange(
            Key   => "SystemMaintenance::TimeNotifyUpcomingMaintenance",
            Value => 61,
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Check for upcoming System Maintenance notification after config update.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.MessageBox.Notice p:contains(\"$UpcomingSysMaintenanceNotif\")').length"
            ),
            "$UpcomingSysMaintenanceNotif - notification is found."
        );

        # check for created test SystemMaintenance
        $Self->True(
            index( $Selenium->get_page_source(), $SysMainComment ) > -1,
            "$SysMainComment found on page",
        );

        # get test SystemMaintenanceID
        my $SysMainCommentQuoted = $DBObject->Quote($SysMainComment);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM system_maintenance WHERE comments = ?",
            Bind => [ \$SysMainCommentQuoted ]
        );
        my $SysMainID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SysMainID = $Row[0];
        }

        # go to new test SystemMaintenance and check values
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SysMainID' )]"
        )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            $SysMainComment,
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#LoginMessage', 'css' )->get_value(),
            $SysMainLogin,
            "#LoginMessage stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#NotifyMessage', 'css' )->get_value(),
            $SysMainNotify,
            "#NotifyMessage stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # check breadcrumb on Edit screen
        $CheckBredcrumb->( BreadcrumbText => 'Edit System Maintenance' );

        # Try to edit System Maintenance with Login and Notify message longer then 250 characters.
        #   See bug#13366 (https://bugs.otrs.org/show_bug.cgi?id=13366).
        #   Verify there is no Error class initially.
        $Self->False(
            $Selenium->execute_script("return \$('#LoginMessage').hasClass('Error')"),
            "There is no error class in Login Message text area"
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NotifyMessage').hasClass('Error')"),
            "There is no error class in Notify Message text area"
        );

        # Add 251 characters in the fields and verify Error class.
        $LongLoginMessage  = "a" x 251;
        $LongNotifyMessage = "b" x 251;

        $Selenium->find_element( "#LoginMessage",  'css' )->clear();
        $Selenium->find_element( "#NotifyMessage", 'css' )->clear();
        $Selenium->find_element( "#LoginMessage",  'css' )->send_keys($LongLoginMessage);
        $Selenium->find_element( "#NotifyMessage", 'css' )->send_keys($LongNotifyMessage);

        $Selenium->execute_script("\$('#Submit').trigger('click')");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#LoginMessage.Error').length && \$('#NotifyMessage.Error').length"
        );

        $Self->True(
            $Selenium->execute_script("return \$('#LoginMessage').hasClass('Error')"),
            "There is error class in Login Message text area"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NotifyMessage').hasClass('Error')"),
            "There is error class in Notify Message text area"
        );
        $Selenium->find_element( "#LoginMessage",  'css' )->clear();
        $Selenium->find_element( "#NotifyMessage", 'css' )->clear();

        # edit test SystemMaintenance and set it to invalid
        $Selenium->find_element( "#LoginMessage",  'css' )->send_keys( $SysMainLogin,  "-update" );
        $Selenium->find_element( "#NotifyMessage", 'css' )->send_keys( $SysMainNotify, "-update" );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check if notification exists after updating
        $Notification = 'System Maintenance was updated successfully!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # check class of invalid SystemMaintenance in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($SysMainComment)').length"
            ),
            "There is a class 'Invalid' for test SystemMaintenance",
        );

        # check updated test SystemMaintenance values
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=SystemMaintenanceEdit;SystemMaintenanceID=$SysMainID' )]"
        )->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( '#LoginMessage', 'css' )->get_value(),
            "$SysMainLogin-update",
            "#LoginMessage updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#NotifyMessage', 'css' )->get_value(),
            "$SysMainNotify-update",
            "#NotifyMessage updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # click 'Go to overview'
        $Selenium->find_element("//a[contains(\@href, 'AdminSystemMaintenance')]")->VerifiedClick();

        # click to delete test SystemMaintenance
        $Selenium->find_element("//a[contains(\@href, 'Subaction=Delete;SystemMaintenanceID=$SysMainID')]")->click();

        $Selenium->WaitFor( AlertPresent => 1 );

        # accept delete confirmation dialog
        $Selenium->accept_alert();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('tbody tr:contains($SysMainComment)').length === 0;"
        );

        $Self->True(
            index( $Selenium->get_page_source(), $SysMainComment ) == -1,
            "Deleted - $SysMainComment"
        );

        my $Epoch = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # define test SystemMaintenance scenarios
        my @Tests = (
            {
                # now, duration 2 hours
                StartDate => $Epoch,
                StopDate  => $Epoch + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #1',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 1 day later, duration 2 hours
                StartDate => $Epoch + 24 * 60 * 60,
                StopDate  => $Epoch + 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #2',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 2 days later, duration 2 hours
                StartDate => $Epoch + 2 * 24 * 60 * 60,
                StopDate  => $Epoch + 2 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #3',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 3 days later, duration 2 hours
                StartDate => $Epoch + 3 * 24 * 60 * 60,
                StopDate  => $Epoch + 3 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #4',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 4 days later, duration 2 hours
                StartDate => $Epoch + 4 * 24 * 60 * 60,
                StopDate  => $Epoch + 4 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #5',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 5 days later, duration 2 hours
                StartDate => $Epoch + 5 * 24 * 60 * 60,
                StopDate  => $Epoch + 5 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #6',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 6 days later, duration 2 hours
                StartDate => $Epoch + 6 * 24 * 60 * 60,
                StopDate  => $Epoch + 6 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #7',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 7 days later, duration 2 hours
                StartDate => $Epoch + 7 * 24 * 60 * 60,
                StopDate  => $Epoch + 7 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #8',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # 8 days later, duration 2 hours
                StartDate => $Epoch + 8 * 24 * 60 * 60,
                StopDate  => $Epoch + 8 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #9',
                ValidID   => 1,
                UserID    => 1,
            },
            {
                # one week earlier, duration 2 hours
                StartDate => $Epoch - 7 * 24 * 60 * 60,
                StopDate  => $Epoch - 7 * 24 * 60 * 60 + 2 * 60 * 60,
                Comment   => $SysMainComment . ' maintenance period #10',
                ValidID   => 1,
                UserID    => 1,
            },
        );

        # create test SystemMaintenances
        my @SystemMaintenanceIDs;
        for my $Test (@Tests) {
            my $SystemMaintenanceID = $SystemMaintenanceObject->SystemMaintenanceAdd(
                StartDate => $Test->{StartDate},
                StopDate  => $Test->{StopDate},
                Comment   => $Test->{Comment},
                ValidID   => $Test->{ValidID},
                UserID    => $Test->{UserID},
            );

            push @SystemMaintenanceIDs, $SystemMaintenanceID;
        }

        # navigate to AdminSystemMaintenance screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemMaintenance");

        # filter by test unique ID
        $Selenium->find_element( "#FilterSystemMaintenances", 'css' )->send_keys( $SysMainComment . ' maintenance' );
        sleep 1;

        # check created SystemMaintenances
        for my $Test (@Tests) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test->{Comment} ) > -1,
                "Created system maintenance with comment '$Test->{Comment}' is found on page.",
            );
        }

        # check order of displayed SystemMaintenances by comments and lines
        for my $i ( 1 .. 10 ) {

            # set the correct index for the @Tests array (line 1 contains last test comment)
            my $Index = $i;
            $Index = ( $Index eq 1 ) ? $Index = 9 : $Index = $Index - 2;

            my $TrIndex = $i - 1;

            $Self->Is(
                $Selenium->execute_script("return \$('tbody tr:visible:eq($TrIndex) td:eq(2)').text()"),
                $Tests[$Index]->{Comment},
                "Found system maintenance with comment '$Tests[$Index]->{Comment}' in line $i."
            );
        }

        # delete created SystemMaintenances
        for my $SystemMaintenanceID (@SystemMaintenanceIDs) {
            my $Success = $SystemMaintenanceObject->SystemMaintenanceDelete(
                ID     => $SystemMaintenanceID,
                UserID => 1,
            );
        }
    }

);

1;
