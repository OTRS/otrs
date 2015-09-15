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

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # enable CustomerUserGenericTicket sysconfig
        my @CustomerSysConfig = ( '1-GoogleMaps', '2-Google', '2-LinkedIn', '3-XING' );
        my @CustomerUserGenericText;
        for my $SysConfigChange (@CustomerSysConfig) {

            # get default sysconfig
            my $SysConfigName  = 'Frontend::CustomerUser::Item###' . $SysConfigChange;
            my %CustomerConfig = $SysConfigObject->ConfigItemGet(
                Name    => $SysConfigName,
                Default => 1,
            );

            # get default link text for each CustomerUserGenericTicket module
            for my $DefaultText ( $CustomerConfig{Setting}->[1]->{Hash}->[1]->{Item}->[7]->{Content} ) {
                push @CustomerUserGenericText, $DefaultText;
            }

            # set CustomerUserGenericTicket modules to valid
            %CustomerConfig = map { $_->{Key} => $_->{Content} }
                grep { defined $_->{Key} } @{ $CustomerConfig{Setting}->[1]->{Hash}->[1]->{Item} };

            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $SysConfigName,
                Value => \%CustomerConfig,
            );
        }

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test customer user
        my $TestCustomerName = "Customer" . $Helper->GetRandomID();
        my $TestCustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomerName,
            UserLastname   => $TestCustomerName,
            UserCustomerID => 'A124',
            UserLogin      => $TestCustomerName,
            UserEmail      => $TestCustomerName . '@localhost.com',
            UserStreet     => 'Test Street',
            UserCity       => 'Test City',
            UserCountry    => 'Test Country',
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => $TestCustomerUser,
            CustomerUser => $TestCustomerName,
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Created ticket - $TicketID",
        );

        # go to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # check for CustomerUserGeneric link text
        for my $TestText (@CustomerUserGenericText) {
            $Self->True(
                index( $Selenium->get_page_source(), $TestText ) > -1,
                "Link text $TestText - found on screen"
            );
        }

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Deleted ticket - $TicketID"
        );

        # delete created test customer user
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
            Bind => [ \$TestCustomerUser ],
        );
        $Self->True(
            $Success,
            "Deleted CustomerUser - $TestCustomerUser",
        );
    }
);

1;
