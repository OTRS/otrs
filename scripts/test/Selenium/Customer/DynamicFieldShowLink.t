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

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'Test Company',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create dynamic field.
        my $RandomNumber     = $Helper->GetRandomNumber();
        my $DynamicFieldName = 'DF' . $RandomNumber;
        my $DynamicFieldLink = "https://www.example.com";
        my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                Link        => $DynamicFieldLink,
                LinkPreview => 'https://www.otrs.com',
            },
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is created",
        );

        # Set dynamic field value.
        my $ValueText = 'Click on Link' . $RandomNumber;
        my $Success   = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
            FieldID    => $DynamicFieldID,
            ObjectType => 'Ticket',
            ObjectID   => $TicketID,
            Value      => [
                {
                    ValueText => $ValueText,
                },
            ],
            UserID => 1,
        );
        $Self->True(
            $Success,
            "DynamicFieldID $DynamicFieldID is set to '$ValueText' successfully",
        );

        # Set SysConfig to show dynamic field in CustomerTicketZoom screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DynamicField',
            Value => {
                $DynamicFieldName => 1,
            },
        );

        # Login as test created customer.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        # Check existence of test dynamic field in 'Information' sidebar.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ZoomSidebar li span.Key:contains($DynamicFieldName)').siblings('span').find('a.DynamicFieldLink').length;"
            ),
            1,
            "DynamicFieldID $DynamicFieldID is found in 'Information' sidebar",
        );

        # Check dynamic field text.
        my $ValueTextShortened = substr $ValueText, 0, 20;
        $ValueTextShortened .= '[...]';
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ZoomSidebar li span.Key:contains($DynamicFieldName)').siblings('span').find('a.DynamicFieldLink').text();"
            ),
            $ValueTextShortened,
            "Dynamic field text '$ValueTextShortened' is correct",
        );

        # Check dynamic field link.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#ZoomSidebar li span.Key:contains($DynamicFieldName)').siblings('span').find('a.DynamicFieldLink').attr('href');"
            ),
            $DynamicFieldLink,
            "Dynamic field link '$DynamicFieldLink' is correct",
        );

        # Hover dynamic field link.
        $Selenium->execute_script(
            "\$('#ZoomSidebar li span.Key:contains($DynamicFieldName)').siblings('span').find('a.DynamicFieldLink').mouseenter();"
        );

        # Wait for the floater to be fully visible.
        $Selenium->WaitFor(
            JavaScript => "return parseInt(\$('div.MetaFloater:visible').css('opacity'), 10) === 1;"
        );

        # Check if a floater is visible now.
        $Self->Is(
            $Selenium->execute_script("return \$('div.MetaFloater:visible').length"),
            1,
            'Floater is visible',
        );

        # Delete test created ticket.
        $Success = $TicketObject->TicketDelete(
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
            "TicketID $TicketID is deleted"
        );

        # Delete test created dynamic field.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "DynamicFieldID $DynamicFieldID is deleted",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

1;
