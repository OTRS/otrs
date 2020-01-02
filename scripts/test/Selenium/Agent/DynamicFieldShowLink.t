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

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

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
            CustomerUser => 'Test Customer',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Check if test dynamic field exists in the system, remove it if it does.
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => 'LinkPreview',
        );
        my $Success;
        if ( $DynamicField->{ID} ) {
            my $ValuesDeleteSuccess = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->AllValuesDelete(
                FieldID => $DynamicField->{ID},
                UserID  => 1,
            );
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => 1,
            );
            $Self->True(
                $Success,
                "DynamicFieldID $DynamicField->{ID} is deleted",
            );
        }

        # Create test dynamic field.
        my $RandomNumber     = $Helper->GetRandomNumber();
        my $DynamicFieldName = 'LinkPreview';
        my $DynamicFieldLink = "http://bugs.otrs.org/show_bug.cgi?id=[% Data.TicketID | uri %]";
        my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                Link        => $DynamicFieldLink,
                LinkPreview => $DynamicFieldLink,
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
        $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
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
            Key   => 'Ticket::Frontend::AgentTicketZoom###DynamicField',
            Value => {
                $DynamicFieldName => 1,
            },
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check existence of test dynamic field in 'Ticket Information' widget.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn a.DynamicFieldLink').parent('span').attr('title').trim();"
            ),
            $ValueText,
            "DynamicFieldID $DynamicFieldID is found in 'Ticket Information' widget",
        );

        # Check dynamic field text.
        my $ValueTextShortened = substr $ValueText, 0, 13;
        $ValueTextShortened .= '[...]';
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn a.DynamicFieldLink').text();"
            ),
            $ValueTextShortened,
            "Dynamic field text '$ValueTextShortened' is correct",
        );

        # Check dynamic field link.
        $DynamicFieldLink = "http://bugs.otrs.org/show_bug.cgi?id=$TicketID";
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn a.DynamicFieldLink').attr('href');"
            ),
            $DynamicFieldLink,
            "Dynamic field link '$DynamicFieldLink' is correct",
        );

        # Check dynamic field link preview.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn a.DynamicFieldLink').attr('data-floater-url');"
            ),
            $DynamicFieldLink,
            "Dynamic field link preview '$DynamicFieldLink' is correct",
        );

        # Hover dynamic field link.
        $Selenium->execute_script(
            "\$('.SidebarColumn a.DynamicFieldLink').mouseenter();"
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
