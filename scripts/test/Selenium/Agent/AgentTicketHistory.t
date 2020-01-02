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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Type',
            Value => 1,
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

        # Add TicketType.
        my $TypeName   = "Type$RandomID";
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
        my $TypeID     = $TypeObject->TypeAdd(
            Name    => $TypeName,
            ValidID => 1,
            UserID  => 1,
        );

        # Create test ticket.
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
            TypeID       => $TypeID,
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
            my $Value     = $DynamicFieldValues{$DynamicFieldType} || $DynamicFieldDateValues{$DynamicFieldType};

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

        # Create two test email articles.
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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Get current initial URL.
        my $InitialURL = $Selenium->get_current_url();

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('height', 'auto');");
        $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('opacity', '1');");
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#nav-Miscellaneous ul').css('height') !== '0px' && \$('#nav-Miscellaneous ul').css('opacity') == '1';"
        );

        # Click on 'History' and switch window.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Check the history entry for the dynamic field.
        my $PageSource = $Selenium->get_page_source();
        for my $DynamicFieldType ( sort keys %DynamicFieldsExpectedResults ) {

            $Self->True(
                index( $PageSource, $DynamicFieldsExpectedResults{$DynamicFieldType}->{Result} ) > -1,
                "Human readable history entry for DynamicField_$DynamicFields{$DynamicFieldType}->{Name} is found on page.",
            );
        }

        # Check if Type is shown correctly. See bug#14826.
        my $TypeExpectedResults = "Changed type from \"\" () to \"$TypeName\" ($TypeID). (TypeUpdate)";
        $Self->True(
            index( $PageSource, $TypeExpectedResults ) > -1,
            "Human readable history entry for Type is found on page.",
        );

        # Click on 'Zoom view' for created second article.
        $Selenium->find_element("//a[contains(\@href, 'AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleIDs[1]')]")
            ->VerifiedClick();

        # Verify new URL.
        my $ChangedURL = $Selenium->get_current_url();
        $Self->IsNot(
            $ChangedURL,
            $InitialURL,
            'AgentTicketHistory correctly changed parent window URL - JS is successful'
        );

        # Delete created test ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Deleted test ticket - $TicketID",
        );

        # Delete created test dynamic fields.
        for my $DynamicFieldID (@DynamicFieldIDs) {
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete Type.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM ticket_type WHERE id = $TypeID",
        );
        $Self->True(
            $Success,
            "Type with ID $TypeID is deleted!"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
