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
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject             = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        my $RandomID      = $Helper->GetRandomID();
        my %DynamicFields = (
            Text => {
                Name       => 'TestText' . $RandomID,
                Label      => 'TestText' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Text',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue => '',
                    Link         => '',
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Dropdown => {
                Name       => 'TestDropdown' . $RandomID,
                Label      => 'TestDropdown' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Dropdown',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        0 => 'No',
                        1 => 'Yes',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Multiselect => {
                Name       => 'TestMultiselect' . $RandomID,
                Label      => 'TestMultiselect' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Multiselect',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        year  => 'year',
                        month => 'month',
                        week  => 'week',
                    },
                    TranslatableValues => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            Date => {
                Name       => 'TestDate' . $RandomID,
                Label      => 'TestDate' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Date',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            DateTime => {
                Name       => 'TestDateTime' . $RandomID,
                Label      => 'TestDateTime' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'DateTime',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @DynamicFieldIDs;

        # Create test dynamic field.
        for my $DynamicFieldType ( sort keys %DynamicFields ) {

            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{ $DynamicFields{$DynamicFieldType} },
            );

            $Self->True(
                $DynamicFieldID,
                "Dynamic field $DynamicFields{$DynamicFieldType}->{Name} - ID $DynamicFieldID - created",
            );

            push @DynamicFieldIDs, $DynamicFieldID;
        }

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketCreate - ID $TicketID",
        );

        my %DynamicFieldValues = (
            Text        => "Test Text $RandomID",
            Dropdown    => '1',
            Multiselect => [
                'month',
                'year',
            ],
        );

        my %DynamicFieldDateValues = (
            Date     => '2016-04-13 00:00:00',
            DateTime => '2016-04-13 14:20:00',
        );

        my %DynamicFieldsExpectedResults;
        for my $DynamicFieldType ( sort keys %DynamicFieldValues, sort keys %DynamicFieldDateValues ) {

            my $FieldName = $DynamicFields{$DynamicFieldType}->{Name};
            my $Value = $DynamicFieldValues{$DynamicFieldType} || $DynamicFieldDateValues{$DynamicFieldType};

            # Set the value from the dynamic field.
            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFields{$DynamicFieldType}->{Name},
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $Value,
                UserID             => 1,
            );

            # Prepare hash with result for checking display in AgentTicketHistory popup.
            if ( $DynamicFieldType eq 'Multiselect' ) {

                $Value = join( ', ', @{ $DynamicFieldValues{$DynamicFieldType} } );
            }
            elsif ( $DynamicFieldType eq 'Date' ) {

                # Remove the time value.
                $Value =~ s{ [ ] \d\d:\d\d:\d\d \z }{}xms;
            }

            $DynamicFieldsExpectedResults{$DynamicFieldType}->{Result}
                = 'Changed dynamic field ' . $FieldName . ' from "" to "' . $Value . '".';
        }

        my $ArticleBackendObject
            = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Phone' );

        # create two test email articles
        my @ArticleIDs;
        for my $ArticleCreate ( 1 .. 2 ) {
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => 'some short description',
                Body                 => 'the message text',
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'EmailCustomer',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );
            push @ArticleIDs, $ArticleID;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to ticket zoom page of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # get current initial URL
        my $InitialURL = $Selenium->get_current_url();

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'History' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Check the history entry for the dynamic field.
        my $PageSource = $Selenium->get_page_source();
        for my $DynamicFieldType ( sort keys %DynamicFieldsExpectedResults ) {

            $Self->True(
                index( $PageSource, $DynamicFieldsExpectedResults{$DynamicFieldType}->{Result} ) > -1,
                "Human readable history entry for DynamicField_$DynamicFields{$DynamicFieldType}->{Name} is found on page.",
            );
        }

        # click on 'Zoom view' for created second article
        $Selenium->find_element("//a[contains(\@href, 'AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleIDs[1]')]")
            ->click();

        # switch window back
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # verify new URL
        my $ChangedURL = $Selenium->get_current_url();
        $Self->IsNot(
            $ChangedURL,
            $InitialURL,
            'AgentTicketHistory correctly changed parent window URL - JS is successful'
        );

        # Wait until all current AJAX requests have completed, before cleaning up test entities. Otherwise, it could
        #   happen some asynchronous calls prevent entries from being deleted by running into race conditions.
        #   jQuery property $.active contains number of active AJAX calls on the page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active === 0' );

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketDelete - ID $TicketID"
        );

        for my $DynamicFieldID (@DynamicFieldIDs) {

            # delete created test dynamic field
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
